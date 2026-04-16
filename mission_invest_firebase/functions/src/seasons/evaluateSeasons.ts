import { pubsub } from 'firebase-functions/v1';
import * as admin from 'firebase-admin';
import { db, collections } from '../utils/firestore';
import { awardBadge } from '../badges/awardBadge';
import { awardXp } from '../xp/awardXp';
import { logger } from '../utils/logger';

/**
 * End-of-season evaluator (PRD 5.10)
 * Runs daily at 0:30 AM IST.
 * Checks for seasons that have ended, awards badges to completers,
 * and updates the season's completionRate.
 */
export const evaluateSeasons = pubsub
  .schedule('30 0 * * *')
  .timeZone('Asia/Kolkata')
  .onRun(async () => {
    try {
      const now = admin.firestore.Timestamp.now();

      // Find seasons that ended but haven't been processed
      const endedSeasons = await db
        .collection(collections.seasons)
        .where('archived', '!=', true)
        .get();

      let processed = 0;

      for (const seasonDoc of endedSeasons.docs) {
        const season = seasonDoc.data();
        const endDate = season.endDate?.toDate?.();
        if (!endDate || new Date() <= endDate) continue;
        if (season.evaluated) continue;

        // Get all missions in this season
        const seasonMissions = await db
          .collection(collections.missions)
          .where('seasonId', '==', seasonDoc.id)
          .get();

        let completedCount = 0;
        const totalCount = seasonMissions.size;

        for (const mDoc of seasonMissions.docs) {
          const m = mDoc.data();
          if (m.status === 'completed') {
            completedCount++;

            // Award season badge and XP
            await awardBadge(m.userId, mDoc.id, m.title, `season_${seasonDoc.id}`);
            await awardXp(m.userId, 'season_completion', {
              missionId: mDoc.id,
              detail: `Season: ${season.title}`,
            });
          }
        }

        const completionRate = totalCount > 0 ? completedCount / totalCount : 0;

        await seasonDoc.ref.update({
          completionRate,
          evaluated: true,
          evaluatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        processed++;
        logger.info(`Season ${seasonDoc.id} evaluated: ${completedCount}/${totalCount} completed (${(completionRate * 100).toFixed(1)}%)`);
      }

      logger.info(`Season evaluation done: ${processed} seasons processed`);
    } catch (error) {
      logger.error('evaluateSeasons failed:', error);
    }
  });
