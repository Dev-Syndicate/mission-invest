import { pubsub } from 'firebase-functions/v1';
import { db, collections } from '../utils/firestore';
import { sendPushNotification } from '../utils/fcm';
import { logger } from '../utils/logger';
import { startOfDay } from 'date-fns';

export const sendStreakAlerts = pubsub
  .schedule('0 20 * * *')
  .timeZone('Asia/Kolkata')
  .onRun(async () => {
    const todayStart = startOfDay(new Date());

    try {
      const activeMissions = await db
        .collection(collections.missions)
        .where('status', '==', 'active')
        .get();

      let sent = 0;
      for (const doc of activeMissions.docs) {
        const mission = doc.data();
        const lastContrib = mission.lastContributionDate?.toDate();
        const contributedToday =
          lastContrib && startOfDay(lastContrib).getTime() >= todayStart.getTime();

        if (!contributedToday && mission.currentStreak > 0) {
          await sendPushNotification({
            userId: mission.userId,
            title: 'Streak at risk!',
            body: `Log \u20B9${Math.ceil(mission.dailyTarget)} before midnight to keep your ${mission.currentStreak}-day streak on "${mission.title}".`,
            type: 'streak_alert',
            missionId: doc.id,
          });
          sent++;
        }
      }

      logger.info(`Sent ${sent} streak alerts`);
    } catch (error) {
      logger.error('sendStreakAlerts failed:', error);
    }
  });
