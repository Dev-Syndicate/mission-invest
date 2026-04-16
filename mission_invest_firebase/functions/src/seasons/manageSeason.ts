import { https } from 'firebase-functions/v1';
import * as admin from 'firebase-admin';
import { db, collections } from '../utils/firestore';

/**
 * Season CRUD — admin-only callable (PRD 5.10)
 */
export const manageSeason = https.onCall(async (data, context) => {
  const userId = context.auth?.uid;
  if (!userId) throw new https.HttpsError('unauthenticated', 'Login required');

  const userDoc = await db.collection(collections.users).doc(userId).get();
  if (!userDoc.data()?.isAdmin) {
    throw new https.HttpsError('permission-denied', 'Admin only');
  }

  const { action, seasonId, data: seasonData } = data;

  switch (action) {
    case 'create': {
      const docRef = await db.collection(collections.seasons).add({
        ...seasonData,
        participantCount: 0,
        completionRate: 0,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      return { success: true, seasonId: docRef.id };
    }
    case 'update':
      if (!seasonId) throw new https.HttpsError('invalid-argument', 'seasonId required');
      await db.collection(collections.seasons).doc(seasonId).update(seasonData);
      return { success: true };

    case 'archive':
      if (!seasonId) throw new https.HttpsError('invalid-argument', 'seasonId required');
      await db.collection(collections.seasons).doc(seasonId).update({
        archived: true,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      return { success: true };

    default:
      throw new https.HttpsError('invalid-argument', 'Invalid action');
  }
});
