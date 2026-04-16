import { https } from 'firebase-functions/v1';
import * as admin from 'firebase-admin';
import { db, collections } from '../utils/firestore';

export const manageTemplate = https.onCall(async (data, context) => {
  const userId = context.auth?.uid;
  if (!userId) throw new https.HttpsError('unauthenticated', 'Login required');

  const userDoc = await db.collection(collections.users).doc(userId).get();
  if (!userDoc.data()?.isAdmin) {
    throw new https.HttpsError('permission-denied', 'Admin only');
  }

  const { action, templateId, data: templateData } = data;

  switch (action) {
    case 'create': {
      const docRef = await db.collection(collections.templates).add({
        ...templateData,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      return { success: true, templateId: docRef.id };
    }
    case 'update':
      if (!templateId) throw new https.HttpsError('invalid-argument', 'templateId required');
      await db.collection(collections.templates).doc(templateId).update(templateData);
      return { success: true };

    case 'delete':
      if (!templateId) throw new https.HttpsError('invalid-argument', 'templateId required');
      await db.collection(collections.templates).doc(templateId).delete();
      return { success: true };

    default:
      throw new https.HttpsError('invalid-argument', 'Invalid action');
  }
});
