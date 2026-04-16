import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { db, collections } from '../utils/firestore';
import { sendPushNotification } from '../utils/fcm';
import { logger } from '../utils/logger';
import { subDays, startOfDay } from 'date-fns';

export const evaluateDailyStreaks = functions.pubsub
  .schedule('5 0 * * *')
  .timeZone('Asia/Kolkata')
  .onRun(async () => {
    const yesterday = startOfDay(subDays(new Date(), 1));

    try {
      const activeMissions = await db
        .collection(collections.missions)
        .where('status', '==', 'active')
        .get();

      const batch = db.batch();
      let brokenStreaks = 0;

      for (const doc of activeMissions.docs) {
        const mission = doc.data();
        const lastContrib = mission.lastContributionDate?.toDate();

        // If no contribution yesterday and streak > 0
        if (mission.currentStreak > 0) {
          const hadContribYesterday =
            lastContrib && startOfDay(lastContrib).getTime() >= yesterday.getTime();

          if (!hadContribYesterday) {
            batch.update(doc.ref, {
              currentStreak: 0,
              missedDays: admin.firestore.FieldValue.increment(1),
              updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            });

            // Send streak break notification
            await sendPushNotification({
              userId: mission.userId,
              title: 'Streak Lost',
              body: `Your streak on "${mission.title}" was broken. Recovery window: 24hrs.`,
              type: 'streak_break',
              missionId: doc.id,
            });

            brokenStreaks++;
          }
        }
      }

      if (brokenStreaks > 0) {
        await batch.commit();
      }

      logger.info(`Daily streak check: ${brokenStreaks} streaks broken`);
    } catch (error) {
      logger.error('evaluateDailyStreaks failed:', error);
    }
  });
