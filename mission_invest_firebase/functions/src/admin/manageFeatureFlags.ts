import { https } from 'firebase-functions/v1';
import * as admin from 'firebase-admin';
import { db, collections } from '../utils/firestore';

export const manageFeatureFlag = https.onCall(async (data, context) => {
  const userId = context.auth?.uid;
  if (!userId) throw new https.HttpsError('unauthenticated', 'Login required');

  const userDoc = await db.collection(collections.users).doc(userId).get();
  if (!userDoc.data()?.isAdmin) {
    throw new https.HttpsError('permission-denied', 'Admin only');
  }

  const { flagId, enabled } = data;
  if (!flagId || typeof enabled !== 'boolean') {
    throw new https.HttpsError('invalid-argument', 'flagId and enabled required');
  }

  await db.collection(collections.featureFlags).doc(flagId).set({
    key: flagId,
    enabled,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedBy: userId,
  }, { merge: true });

  return { success: true };
});
