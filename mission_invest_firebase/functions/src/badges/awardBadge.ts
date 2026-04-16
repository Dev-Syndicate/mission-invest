import * as admin from 'firebase-admin';
import { db, collections } from '../utils/firestore';
import { logger } from '../utils/logger';

export async function awardBadge(
  userId: string,
  missionId: string,
  missionTitle: string,
  badgeType: string
): Promise<void> {
  // Check if user already has this badge for this mission
  const existing = await db
    .collection(collections.badges)
    .where('userId', '==', userId)
    .where('missionId', '==', missionId)
    .where('badgeType', '==', badgeType)
    .get();

  if (!existing.empty) {
    return; // Already awarded
  }

  await db.collection(collections.badges).add({
    userId,
    missionId,
    missionTitle,
    badgeType,
    earnedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  logger.info(`Badge awarded: ${badgeType} to user ${userId} for mission ${missionId}`);
}
