import { https } from 'firebase-functions/v1';
import { db, collections } from '../utils/firestore';
import { sendPushNotification } from '../utils/fcm';
import { logger } from '../utils/logger';

export const sendBroadcast = https.onCall(async (data, context) => {
  const userId = context.auth?.uid;
  if (!userId) {
    throw new https.HttpsError('unauthenticated', 'Must be logged in');
  }

  // Check admin
  const userDoc = await db.collection(collections.users).doc(userId).get();
  if (!userDoc.data()?.isAdmin) {
    throw new https.HttpsError('permission-denied', 'Admin only');
  }

  const { title, body } = data;
  if (!title || !body) {
    throw new https.HttpsError('invalid-argument', 'title and body required');
  }

  try {
    const users = await db.collection(collections.users).where('notificationsEnabled', '==', true).get();

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
    throw new https.HttpsError('internal', 'Broadcast failed');
  }
});
