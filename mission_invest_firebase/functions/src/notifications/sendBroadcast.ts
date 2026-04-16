import * as functions from 'firebase-functions';
import { db, collections } from '../utils/firestore';
import { sendPushNotification } from '../utils/fcm';
import { logger } from '../utils/logger';

export const sendBroadcast = functions.https.onCall(async (request) => {
  const userId = request.auth?.uid;
  if (!userId) {
    throw new functions.https.HttpsError('unauthenticated', 'Must be logged in');
  }

  // Check admin
  const userDoc = await db.collection(collections.users).doc(userId).get();
  if (!userDoc.data()?.isAdmin) {
    throw new functions.https.HttpsError('permission-denied', 'Admin only');
  }

  const { title, body, segment } = request.data;
  if (!title || !body) {
    throw new functions.https.HttpsError('invalid-argument', 'title and body required');
  }

  try {
    let usersQuery = db.collection(collections.users).where('notificationsEnabled', '==', true);
    const users = await usersQuery.get();

    let sent = 0;
    for (const doc of users.docs) {
      await sendPushNotification({
        userId: doc.id,
        title,
        body,
        type: 'broadcast',
      });
      sent++;
    }

    logger.info(`Broadcast sent to ${sent} users by admin ${userId}`);
    return { success: true, sentCount: sent };
  } catch (error) {
    logger.error('sendBroadcast failed:', error);
    throw new functions.https.HttpsError('internal', 'Broadcast failed');
  }
});
