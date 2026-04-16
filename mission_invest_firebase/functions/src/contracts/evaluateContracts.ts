import { pubsub } from 'firebase-functions/v1';
import * as admin from 'firebase-admin';
import { db, collections } from '../utils/firestore';
import { sendPushNotification } from '../utils/fcm';
import { logger } from '../utils/logger';
import { subDays, startOfDay } from 'date-fns';

/**
 * Commit Contract Evaluator (PRD 5.15)
 * Runs daily at 0:15 AM IST.
 *
 * Contract types:
 *  - half_pledge: save 50% of target in first half of duration
 *  - consistency_pact: no more than 2 misses in any 7-day window
 *  - speed_pact: complete 3 days before deadline (checked at mission complete)
 *
 * On breach: sets contractStatus to 'in_recovery' and gives 48hr recovery deadline.
 * If recovery deadline passes without a bonus contribution: contractStatus -> 'breached'.
 */

export const evaluateContracts = pubsub
  .schedule('15 0 * * *')
  .timeZone('Asia/Kolkata')
  .onRun(async () => {
    try {
      const now = new Date();

      // Get all active missions with an active contract
      const missionsSnap = await db
        .collection(collections.missions)
        .where('status', '==', 'active')
        .get();

      let breaches = 0;
      let recoveryExpired = 0;

      for (const doc of missionsSnap.docs) {
        const mission = doc.data();
        const contractType = mission.contractType;
        const contractStatus = mission.contractStatus;

        if (!contractType || contractType === 'none') continue;

        // Handle expired recovery deadlines
        if (contractStatus === 'in_recovery') {
          const deadline = mission.contractRecoveryDeadline?.toDate?.();
          if (deadline && now > deadline) {
            await doc.ref.update({
              contractStatus: 'breached',
              updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            });
            await sendPushNotification({
              userId: mission.userId,
              title: 'Contract Breached',
              body: `Your ${formatContractName(contractType)} on "${mission.title}" has been breached. Recovery window expired.`,
              type: 'contract_breach',
              missionId: doc.id,
            });
            recoveryExpired++;
            continue;
          }
        }

        // Only evaluate active contracts
        if (contractStatus !== 'active') continue;

        let breached = false;

        if (contractType === 'half_pledge') {
          // Check if we're past the halfway point and haven't saved 50%
          const startDate = mission.startDate?.toDate?.() || now;
          const halfwayDate = new Date(
            startDate.getTime() + (mission.durationDays / 2) * 86400000
          );
          if (now > halfwayDate) {
            const progress = mission.targetAmount > 0
              ? (mission.savedAmount || 0) / mission.targetAmount
              : 0;
            if (progress < 0.5) {
              breached = true;
            }
          }
        }

        if (contractType === 'consistency_pact') {
          // Check recent 7-day window for more than 2 misses
          const sevenDaysAgo = startOfDay(subDays(now, 7));
          const recentContribs = await db
            .collection(collections.contributions)
            .where('missionId', '==', doc.id)
            .where('date', '>=', admin.firestore.Timestamp.fromDate(sevenDaysAgo))
            .get();

          const daysWithContrib = new Set<string>();
          recentContribs.forEach((c) => {
            const d = c.data().date?.toDate?.();
            if (d) daysWithContrib.add(startOfDay(d).toISOString());
          });

          const missedInWindow = 7 - daysWithContrib.size;
          if (missedInWindow > 2) {
            breached = true;
          }
        }

        // speed_pact is evaluated at mission completion, not here

        if (breached) {
          const recoveryDeadline = new Date(now.getTime() + 48 * 3600000);
          await doc.ref.update({
            contractStatus: 'in_recovery',
            contractRecoveryDeadline: admin.firestore.Timestamp.fromDate(recoveryDeadline),
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          });

          await sendPushNotification({
            userId: mission.userId,
            title: 'Contract at Risk!',
            body: `Your ${formatContractName(contractType)} on "${mission.title}" was breached. Log a ₹50 bonus contribution within 48hrs to recover.`,
            type: 'contract_recovery',
            missionId: doc.id,
          });

          breaches++;
        }
      }

      logger.info(`Contract evaluation: ${breaches} new breaches, ${recoveryExpired} expired recoveries`);
    } catch (error) {
      logger.error('evaluateContracts failed:', error);
    }
  });

function formatContractName(type: string): string {
  switch (type) {
    case 'half_pledge': return 'Half-Pledge';
    case 'consistency_pact': return 'Consistency Pact';
    case 'speed_pact': return 'Speed Pact';
    default: return 'contract';
  }
}
