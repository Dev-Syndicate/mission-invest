import { pubsub } from 'firebase-functions/v1';
import { db, collections } from '../utils/firestore';
import { logger } from '../utils/logger';

/**
 * Financial Confidence Score (PRD 5.12)
 * Runs daily at 1:00 AM IST, recalculates for all active users.
 *
 * score = (streak_ratio * 300)
 *       + (checkpoint_completion_rate * 250)
 *       + (mission_completion_rate * 250)
 *       + (recovery_success_rate * 100)
 *       + (consistency_bonus * 100)   ← no missed days in last 7
 *
 * Tiers: 0-199 Beginner, 200-399 Building Habits, 400-599 Consistent,
 *        600-799 Mission Pro, 800-1000 Financial Athlete
 */

function getTier(score: number): { tier: number; label: string } {
  if (score >= 800) return { tier: 5, label: 'Financial Athlete' };
  if (score >= 600) return { tier: 4, label: 'Mission Pro' };
  if (score >= 400) return { tier: 3, label: 'Consistent Saver' };
  if (score >= 200) return { tier: 2, label: 'Building Habits' };
  return { tier: 1, label: 'Beginner Saver' };
}

export const calculateConfidenceScores = pubsub
  .schedule('0 1 * * *')
  .timeZone('Asia/Kolkata')
  .onRun(async () => {
    try {
      const usersSnap = await db.collection(collections.users).get();
      let updated = 0;

      for (const userDoc of usersSnap.docs) {
        const userId = userDoc.id;

        // Get all missions for this user
        const missionsSnap = await db
          .collection(collections.missions)
          .where('userId', '==', userId)
          .get();

        if (missionsSnap.empty) continue;

        let totalStreakRatio = 0;
        let totalCheckpointRate = 0;
        let totalMissions = missionsSnap.size;
        let completedMissions = 0;
        let activeMissionsWithNoMiss = 0;
        let activeMissionsCount = 0;

        for (const mDoc of missionsSnap.docs) {
          const m = mDoc.data();

          // Streak ratio: currentStreak / durationDays
          const streakRatio = m.durationDays > 0
            ? Math.min((m.currentStreak || 0) / m.durationDays, 1)
            : 0;
          totalStreakRatio += streakRatio;

          // Checkpoint completion: how many of [25,50,75] were unlocked
          const checkpoints = m.checkpointsUnlocked || [];
          totalCheckpointRate += checkpoints.length / 3;

          if (m.status === 'completed') completedMissions++;

          if (m.status === 'active') {
            activeMissionsCount++;
            if ((m.missedDays || 0) === 0) {
              activeMissionsWithNoMiss++;
            }
          }
        }

        const avgStreakRatio = totalStreakRatio / totalMissions;
        const avgCheckpointRate = totalCheckpointRate / totalMissions;
        const missionCompletionRate = totalMissions > 0 ? completedMissions / totalMissions : 0;

        // Recovery success rate
        const recoveriesSnap = await db
          .collection(collections.users)
          .doc(userId)
          .collection('streakRecoveries')
          .get();
        const recoverySuccessRate = recoveriesSnap.size > 0 ? 1 : 0; // simplified: if they've used recovery, they succeeded

        // Consistency bonus: all active missions have 0 missed days in recent window
        const consistencyBonus = activeMissionsCount > 0 && activeMissionsWithNoMiss === activeMissionsCount ? 1 : 0;

        const score = Math.round(
          avgStreakRatio * 300 +
          avgCheckpointRate * 250 +
          missionCompletionRate * 250 +
          recoverySuccessRate * 100 +
          consistencyBonus * 100
        );

        const clampedScore = Math.min(Math.max(score, 0), 1000);
        const { tier, label } = getTier(clampedScore);

        await userDoc.ref.update({
          confidenceScore: clampedScore,
          confidenceTier: tier,
          confidenceLabel: label,
          updatedAt: new Date(),
        });

        updated++;
      }

      logger.info(`Confidence scores recalculated for ${updated} users`);
    } catch (error) {
      logger.error('calculateConfidenceScores failed:', error);
    }
  });
