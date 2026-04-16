import { https } from 'firebase-functions/v1';
import * as admin from 'firebase-admin';
import { db, collections } from '../utils/firestore';

export const manageChallenge = https.onCall(async (data, context) => {
  const userId = context.auth?.uid;
  if (!userId) throw new https.HttpsError('unauthenticated', 'Login required');

  const userDoc = await db.collection(collections.users).doc(userId).get();
  if (!userDoc.data()?.isAdmin) {
    throw new https.HttpsError('permission-denied', 'Admin only');
  }

  const { action, challengeId, data: challengeData } = data;

  switch (action) {
    case 'create': {
      const docRef = await db.collection(collections.challenges).add({
        ...challengeData,
        participantCount: 0,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      return { success: true, challengeId: docRef.id };
    }
    case 'update':
      if (!challengeId) throw new https.HttpsError('invalid-argument', 'challengeId required');
      await db.collection(collections.challenges).doc(challengeId).update(challengeData);
      return { success: true };

    case 'delete':
      if (!challengeId) throw new https.HttpsError('invalid-argument', 'challengeId required');
      await db.collection(collections.challenges).doc(challengeId).delete();
      return { success: true };

    default:
      throw new https.HttpsError('invalid-argument', 'Invalid action');
  }
});
