import { pubsub } from 'firebase-functions/v1';
import { db, collections } from '../utils/firestore';
import { sendPushNotification } from '../utils/fcm';
import { logger } from '../utils/logger';

export const sendWeeklyReport = pubsub
  .schedule('0 10 * * 0')
  .timeZone('Asia/Kolkata')
  .onRun(async () => {
    try {
      const users = await db
        .collection(collections.users)
        .where('notificationsEnabled', '==', true)
        .get();

      let sent = 0;
      for (const userDoc of users.docs) {
        const userId = userDoc.id;

        const activeMissions = await db
          .collection(collections.missions)
          .where('userId', '==', userId)
          .where('status', '==', 'active')
          .get();

        if (activeMissions.empty) continue;

        let totalSavedThisWeek = 0;
        let activeMissionCount = activeMissions.size;

        // Summarize
        for (const missionDoc of activeMissions.docs) {
          const mission = missionDoc.data();
          totalSavedThisWeek += mission.savedAmount || 0;
        }

        await sendPushNotification({
          userId,
          title: 'Weekly Summary',
          body: `${activeMissionCount} active mission(s). Total saved: \u20B9${Math.round(totalSavedThisWeek)}. Keep the momentum!`,
          type: 'weekly_report',
        });
        sent++;
      }

      logger.info(`Sent ${sent} weekly reports`);
    } catch (error) {
      logger.error('sendWeeklyReport failed:', error);
    }
  });
