import { pubsub } from 'firebase-functions/v1';
import { db, collections } from '../utils/firestore';
import { sendPushNotification } from '../utils/fcm';
import { logger } from '../utils/logger';

export const sendDailyReminders = pubsub
  .schedule('0 9 * * *')
  .timeZone('Asia/Kolkata')
  .onRun(async () => {
    try {
      const users = await db
        .collection(collections.users)
        .where('notificationsEnabled', '==', true)
        .get();

      let sent = 0;
      for (const userDoc of users.docs) {
        const user = userDoc.data();
        const userId = userDoc.id;

        const activeMissions = await db
          .collection(collections.missions)
          .where('userId', '==', userId)
          .where('status', '==', 'active')
          .get();

        for (const missionDoc of activeMissions.docs) {
          const mission = missionDoc.data();
          await sendPushNotification({
            userId,
            title: `\u20B9${Math.ceil(mission.dailyTarget)} today`,
            body: `"${mission.title}" — ${mission.durationDays - (mission.missedDays || 0)} days to go!`,
            type: 'daily_reminder',
            missionId: missionDoc.id,
          });
          sent++;
        }
      }

      logger.info(`Sent ${sent} daily reminders`);
    } catch (error) {
      logger.error('sendDailyReminders failed:', error);
    }
  });
