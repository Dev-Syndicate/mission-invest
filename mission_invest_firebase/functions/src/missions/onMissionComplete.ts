import { firestore } from 'firebase-functions/v1';
import * as admin from 'firebase-admin';
import { db, collections } from '../utils/firestore';
import { sendPushNotification } from '../utils/fcm';
import { awardBadge } from '../badges/awardBadge';
import { logger } from '../utils/logger';

export const onMissionComplete = firestore
  .document(`${collections.missions}/{missionId}`)
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();
    const missionId = context.params.missionId;

    // Only trigger when status changes to 'completed'
    if (before.status === 'completed' || after.status !== 'completed') {
      return;
    }

    const userId = after.userId;

    try {
      // Update user stats
      await db.collection(collections.users).doc(userId).update({
        totalMissionsCompleted: admin.firestore.FieldValue.increment(1),
        totalSaved: admin.firestore.FieldValue.increment(after.savedAmount),
      });

      // Award 'first_complete' badge if this is their first
      const completedMissions = await db
        .collection(collections.missions)
        .where('userId', '==', userId)
        .where('status', '==', 'completed')
        .get();

      if (completedMissions.size === 1) {
        await awardBadge(userId, missionId, after.title, 'first_complete');
      }

      // Award 'speed_runner' if completed before deadline
      const completedAt = after.completedAt?.toDate() || new Date();
      const endDate = after.endDate.toDate();
      if (completedAt < endDate) {
        await awardBadge(userId, missionId, after.title, 'speed_runner');
      }

      // Send celebration notification
      await sendPushNotification({
        userId,
        title: 'Mission Complete!',
        body: `You did it! "${after.title}" is 100% funded. Your certificate is ready!`,
        type: 'mission_complete',
        missionId,
      });

      logger.info(`Mission completed: ${missionId}`);
    } catch (error) {
      logger.error('onMissionComplete failed:', error);
    }
  });
