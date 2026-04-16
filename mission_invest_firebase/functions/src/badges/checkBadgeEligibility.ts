import { db, collections } from '../utils/firestore';
import { awardBadge } from './awardBadge';
import { logger } from '../utils/logger';

export async function checkBadgeEligibility(
  userId: string,
  missionId: string
): Promise<void> {
  try {
    const missionDoc = await db.collection(collections.missions).doc(missionId).get();
    if (!missionDoc.exists) return;

    const mission = missionDoc.data()!;
    const streak = mission.currentStreak || 0;
    const progress = mission.targetAmount > 0
      ? mission.savedAmount / mission.targetAmount
      : 0;

    // 3-day streak
    if (streak >= 3) {
      await awardBadge(userId, missionId, mission.title, '3_day_streak');
    }

    // 7-day warrior
    if (streak >= 7) {
      await awardBadge(userId, missionId, mission.title, '7_day_warrior');
    }

    // 30-day survivor
    if (streak >= 30) {
      await awardBadge(userId, missionId, mission.title, '30_day_survivor');
    }

    // Halfway hero
    if (progress >= 0.5) {
      await awardBadge(userId, missionId, mission.title, 'halfway_hero');
    }
  } catch (error) {
    logger.error('checkBadgeEligibility failed:', error);
  }
}
