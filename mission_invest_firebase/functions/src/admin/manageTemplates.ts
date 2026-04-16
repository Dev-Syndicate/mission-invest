import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { db, collections } from '../utils/firestore';

export const manageTemplate = functions.https.onCall(async (request) => {
  const userId = request.auth?.uid;
  if (!userId) throw new functions.https.HttpsError('unauthenticated', 'Login required');

  const userDoc = await db.collection(collections.users).doc(userId).get();
  if (!userDoc.data()?.isAdmin) {
    throw new functions.https.HttpsError('permission-denied', 'Admin only');
  }

  const { action, templateId, data } = request.data;

  switch (action) {
    case 'create':
      const docRef = await db.collection(collections.templates).add({
        ...data,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      return { success: true, templateId: docRef.id };

    case 'update':
      if (!templateId) throw new functions.https.HttpsError('invalid-argument', 'templateId required');
      await db.collection(collections.templates).doc(templateId).update(data);
      return { success: true };

    case 'delete':
      if (!templateId) throw new functions.https.HttpsError('invalid-argument', 'templateId required');
      await db.collection(collections.templates).doc(templateId).delete();
      return { success: true };

    default:
      throw new functions.https.HttpsError('invalid-argument', 'Invalid action');
  }
});
