import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { db, collections } from '../utils/firestore';
import { logger } from '../utils/logger';
import { subDays } from 'date-fns';

export const recoverStreak = functions.https.onCall(async (request) => {
  const { missionId } = request.data;
  const userId = request.auth?.uid;

  if (!userId) {
    throw new functions.https.HttpsError('unauthenticated', 'Must be logged in');
  }

  if (!missionId) {
    throw new functions.https.HttpsError('invalid-argument', 'missionId required');
  }

  try {
    const missionDoc = await db.collection(collections.missions).doc(missionId).get();
    if (!missionDoc.exists) {
      throw new functions.https.HttpsError('not-found', 'Mission not found');
    }

    const mission = missionDoc.data()!;
    if (mission.userId !== userId) {
      throw new functions.https.HttpsError('permission-denied', 'Not your mission');
    }

    if (mission.status !== 'active') {
      throw new functions.https.HttpsError('failed-precondition', 'Mission is not active');
    }

    // Check if recovery was used in last 7 days
    const sevenDaysAgo = subDays(new Date(), 7);
    const recentRecoveries = await db
      .collection(collections.users)
      .doc(userId)
      .collection('streakRecoveries')
      .where('missionId', '==', missionId)
      .where('usedAt', '>', admin.firestore.Timestamp.fromDate(sevenDaysAgo))
      .get();

    if (!recentRecoveries.empty) {
      throw new functions.https.HttpsError(
        'failed-precondition',
        'Recovery already used in the last 7 days for this mission'
      );
    }

    // Restore streak
    const previousStreak = mission.longestStreak || 1;
    await missionDoc.ref.update({
      currentStreak: previousStreak,
      recoveryUsedThisWeek: true,
      recoveryWeekStart: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    // Log recovery
    await db
      .collection(collections.users)
      .doc(userId)
      .collection('streakRecoveries')
      .add({
        missionId,
        usedAt: admin.firestore.FieldValue.serverTimestamp(),
        streakAtRecovery: previousStreak,
      });

    logger.info(`Streak recovered for mission ${missionId} by user ${userId}`);

    return { success: true, restoredStreak: previousStreak };
  } catch (error) {
    if (error instanceof functions.https.HttpsError) throw error;
    logger.error('recoverStreak failed:', error);
    throw new functions.https.HttpsError('internal', 'Recovery failed');
  }
});
