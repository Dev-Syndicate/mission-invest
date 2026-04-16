import { firestore } from 'firebase-functions/v1';
import * as admin from 'firebase-admin';
import { db, collections } from '../utils/firestore';
import { sendPushNotification } from '../utils/fcm';
import { logger } from '../utils/logger';

export const onMissionCreate = firestore
  .document(`${collections.missions}/{missionId}`)
  .onCreate(async (snapshot, context) => {
    const mission = snapshot.data();
    const missionId = context.params.missionId;

    try {
      // Check max 3 active missions
      const activeMissions = await db
        .collection(collections.missions)
        .where('userId', '==', mission.userId)
        .where('status', '==', 'active')
        .get();

      if (activeMissions.size > 3) {
        logger.warn(`User ${mission.userId} exceeded max active missions`);
        await snapshot.ref.update({ status: 'paused' });
        return;
      }

      // Set initial completion probability
      await snapshot.ref.update({
        completionProbability: 1.0,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      // Increment user's totalMissionsCreated
      await db.collection(collections.users).doc(mission.userId).update({
        totalMissionsCreated: admin.firestore.FieldValue.increment(1),
      });

      // Send welcome notification
      await sendPushNotification({
        userId: mission.userId,
        title: 'Mission Launched!',
        body: `"${mission.title}" is live. Your daily target is \u20B9${Math.ceil(mission.dailyTarget)}. Let's go!`,
        type: 'milestone',
        missionId,
      });

      logger.info(`Mission created: ${missionId} for user ${mission.userId}`);
    } catch (error) {
      logger.error('onMissionCreate failed:', error);
    }
  });
