import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { db, collections } from '../utils/firestore';

export const manageChallenge = functions.https.onCall(async (request) => {
  const userId = request.auth?.uid;
  if (!userId) throw new functions.https.HttpsError('unauthenticated', 'Login required');

  const userDoc = await db.collection(collections.users).doc(userId).get();
  if (!userDoc.data()?.isAdmin) {
    throw new functions.https.HttpsError('permission-denied', 'Admin only');
  }

  const { action, challengeId, data } = request.data;

  switch (action) {
    case 'create':
      const docRef = await db.collection(collections.challenges).add({
        ...data,
        participantCount: 0,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      return { success: true, challengeId: docRef.id };

    case 'update':
      if (!challengeId) throw new functions.https.HttpsError('invalid-argument', 'challengeId required');
      await db.collection(collections.challenges).doc(challengeId).update(data);
      return { success: true };

    case 'delete':
      if (!challengeId) throw new functions.https.HttpsError('invalid-argument', 'challengeId required');
      await db.collection(collections.challenges).doc(challengeId).delete();
      return { success: true };

    default:
      throw new functions.https.HttpsError('invalid-argument', 'Invalid action');
  }
});
