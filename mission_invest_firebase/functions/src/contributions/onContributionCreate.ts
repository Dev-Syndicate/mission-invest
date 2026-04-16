import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { db, collections } from '../utils/firestore';
import { sendPushNotification } from '../utils/fcm';
import { checkBadgeEligibility } from '../badges/checkBadgeEligibility';
import { logger } from '../utils/logger';

export const onContributionCreate = functions.firestore
  .document(`${collections.contributions}/{contributionId}`)
  .onCreate(async (snapshot, context) => {
    const contribution = snapshot.data();
    const missionId = contribution.missionId;
    const userId = contribution.userId;

    try {
      const missionRef = db.collection(collections.missions).doc(missionId);

      await db.runTransaction(async (transaction) => {
        const missionDoc = await transaction.get(missionRef);
        if (!missionDoc.exists) return;

        const mission = missionDoc.data()!;
        const newSavedAmount = (mission.savedAmount || 0) + contribution.amount;
        const newStreak = (mission.currentStreak || 0) + 1;
        const longestStreak = Math.max(mission.longestStreak || 0, newStreak);

        const updateData: Record<string, any> = {
          savedAmount: newSavedAmount,
          currentStreak: newStreak,
          longestStreak,
          lastContributionDate: admin.firestore.FieldValue.serverTimestamp(),
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        };

        // Check if mission is complete
        if (newSavedAmount >= mission.targetAmount) {
          updateData.status = 'completed';
          updateData.completedAt = admin.firestore.FieldValue.serverTimestamp();
        }

        transaction.update(missionRef, updateData);
      });

      // Check milestones (25%, 50%, 75%)
      const missionDoc = await missionRef.get();
      const mission = missionDoc.data()!;
      const progress = mission.savedAmount / mission.targetAmount;
      const milestones = [0.25, 0.50, 0.75];

      for (const milestone of milestones) {
        const prevProgress = (mission.savedAmount - contribution.amount) / mission.targetAmount;
        if (prevProgress < milestone && progress >= milestone) {
          await sendPushNotification({
            userId,
            title: `${Math.round(milestone * 100)}% Milestone!`,
            body: `You've reached ${Math.round(milestone * 100)}% of "${mission.title}". Keep going!`,
            type: 'milestone',
            missionId,
          });
        }
      }

      // Check badge eligibility
      await checkBadgeEligibility(userId, missionId);

      logger.info(`Contribution logged: ${contribution.amount} for mission ${missionId}`);
    } catch (error) {
      logger.error('onContributionCreate failed:', error);
    }
  });
