import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { db, collections } from '../utils/firestore';
import { logger } from '../utils/logger';

export const evaluateExpiredMissions = functions.pubsub
  .schedule('30 0 * * *')
  .timeZone('Asia/Kolkata')
  .onRun(async () => {
    const now = admin.firestore.Timestamp.now();

    try {
      const expiredMissions = await db
        .collection(collections.missions)
        .where('status', '==', 'active')
        .where('endDate', '<', now)
        .get();

      const batch = db.batch();
      let count = 0;

      expiredMissions.forEach((doc) => {
        const mission = doc.data();
        if (mission.savedAmount < mission.targetAmount) {
          batch.update(doc.ref, {
            status: 'failed',
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          });
          count++;
        }
      });

      if (count > 0) {
        await batch.commit();
      }

      logger.info(`Marked ${count} expired missions as failed`);
    } catch (error) {
      logger.error('evaluateExpiredMissions failed:', error);
    }
  });
