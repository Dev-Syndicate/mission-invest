import { pubsub } from 'firebase-functions/v1';
import axios from 'axios';
import { db, collections } from '../utils/firestore';
import { sendPushNotification } from '../utils/fcm';
import { config } from '../config';
import { logger } from '../utils/logger';

export const triggerAiNudges = pubsub
  .schedule('0 12 * * *')
  .timeZone('Asia/Kolkata')
  .onRun(async () => {
    try {
      // Find missions needing nudge: 2+ missed days or low probability
      const missions = await db
        .collection(collections.missions)
        .where('status', '==', 'active')
        .get();

      let nudgesSent = 0;
      for (const doc of missions.docs) {
        const mission = doc.data();

        const needsNudge =
          mission.missedDays >= 2 || (mission.completionProbability || 1) < 0.6;

        if (!needsNudge) continue;

        try {
          const response = await axios.post(`${config.fastApiBaseUrl}/ai/nudge`, {
            user_id: mission.userId,
            mission_id: doc.id,
            mission_title: mission.title,
            trigger: mission.missedDays >= 2 ? 'missed_day' : 'low_probability',
            current_streak: mission.currentStreak || 0,
            missed_days: mission.missedDays || 0,
            days_left: mission.durationDays - ((mission.missedDays || 0) + (mission.currentStreak || 0)),
            amount_left: mission.targetAmount - mission.savedAmount,
            target_amount: mission.targetAmount,
            completion_probability: mission.completionProbability || 0.5,
          }, {
            headers: config.fastApiKey
              ? { 'X-API-Key': config.fastApiKey }
              : {},
          });

          const nudge = response.data;

          await sendPushNotification({
            userId: mission.userId,
            title: 'A nudge for you',
            body: nudge.message,
            type: 'daily_reminder',
            missionId: doc.id,
          });

          nudgesSent++;
        } catch (apiError) {
          logger.warn(`AI nudge API failed for mission ${doc.id}:`, apiError);
        }
      }

      logger.info(`AI nudges sent: ${nudgesSent}`);
    } catch (error) {
      logger.error('triggerAiNudges failed:', error);
    }
  });
