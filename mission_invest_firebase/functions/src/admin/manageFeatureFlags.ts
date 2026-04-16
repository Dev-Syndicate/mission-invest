import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { db, collections } from '../utils/firestore';

export const manageFeatureFlag = functions.https.onCall(async (request) => {
  const userId = request.auth?.uid;
  if (!userId) throw new functions.https.HttpsError('unauthenticated', 'Login required');

  const userDoc = await db.collection(collections.users).doc(userId).get();
  if (!userDoc.data()?.isAdmin) {
    throw new functions.https.HttpsError('permission-denied', 'Admin only');
  }

  const { flagId, enabled } = request.data;
  if (!flagId || typeof enabled !== 'boolean') {
    throw new functions.https.HttpsError('invalid-argument', 'flagId and enabled required');
  }

  await db.collection(collections.featureFlags).doc(flagId).set({
    key: flagId,
    enabled,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedBy: userId,
  }, { merge: true });

  return { success: true };
});
