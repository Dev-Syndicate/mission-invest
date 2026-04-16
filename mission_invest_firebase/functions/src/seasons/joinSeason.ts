import { https } from 'firebase-functions/v1';
import * as admin from 'firebase-admin';
import { db, collections } from '../utils/firestore';
import { logger } from '../utils/logger';

/**
 * Join Season — user links a mission to an active season (PRD 5.10)
 */
export const joinSeason = https.onCall(async (data, context) => {
  const userId = context.auth?.uid;
  if (!userId) {
    throw new https.HttpsError('unauthenticated', 'Must be logged in');
  }

  const { missionId, seasonId } = data;
  if (!missionId || !seasonId) {
    throw new https.HttpsError('invalid-argument', 'missionId and seasonId required');
  }

  const [missionDoc, seasonDoc] = await Promise.all([
    db.collection(collections.missions).doc(missionId).get(),
    db.collection(collections.seasons).doc(seasonId).get(),
  ]);

  if (!missionDoc.exists) {
    throw new https.HttpsError('not-found', 'Mission not found');
  }
  if (!seasonDoc.exists) {
    throw new https.HttpsError('not-found', 'Season not found');
  }

  const mission = missionDoc.data()!;
  if (mission.userId !== userId) {
    throw new https.HttpsError('permission-denied', 'Not your mission');
  }
  if (mission.seasonId) {
    throw new https.HttpsError('failed-precondition', 'Mission already in a season');
  }

  const season = seasonDoc.data()!;
  if (season.archived) {
    throw new https.HttpsError('failed-precondition', 'Season is archived');
  }

  const now = new Date();
  const endDate = season.endDate?.toDate?.();
  if (endDate && now > endDate) {
    throw new https.HttpsError('failed-precondition', 'Season has ended');
  }

  // Link mission to season and increment participant count
  await Promise.all([
    missionDoc.ref.update({
      seasonId,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    }),
    seasonDoc.ref.update({
      participantCount: admin.firestore.FieldValue.increment(1),
    }),
  ]);

  logger.info(`User ${userId} joined season ${seasonId} with mission ${missionId}`);
  return { success: true };
});
