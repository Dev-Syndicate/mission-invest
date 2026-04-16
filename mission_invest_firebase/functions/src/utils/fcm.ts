import * as admin from 'firebase-admin';
import { db, collections } from './firestore';

interface NotificationPayload {
  userId: string;
  title: string;
  body: string;
  type: string;
  data?: Record<string, string>;
  missionId?: string;
}

export async function sendPushNotification(payload: NotificationPayload): Promise<void> {
  const userDoc = await db.collection(collections.users).doc(payload.userId).get();
  const userData = userDoc.data();

  if (!userData?.fcmToken || !userData?.notificationsEnabled) {
    return;
  }

  const message: admin.messaging.Message = {
    token: userData.fcmToken,
    notification: {
      title: payload.title,
      body: payload.body,
    },
    data: {
      type: payload.type,
      ...(payload.missionId ? { missionId: payload.missionId } : {}),
      ...(payload.data || {}),
    },
    android: {
      priority: 'high',
      notification: {
        channelId: getChannelId(payload.type),
      },
    },
    apns: {
      payload: {
        aps: {
          sound: 'default',
          badge: 1,
        },
      },
    },
  };

  try {
    await admin.messaging().send(message);
  } catch (error) {
    console.error(`Failed to send FCM to user ${payload.userId}:`, error);
  }

  // Write notification doc
  await db.collection(collections.notifications).add({
    userId: payload.userId,
    type: payload.type,
    title: payload.title,
    body: payload.body,
    read: false,
    data: payload.data || {},
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });
}

function getChannelId(type: string): string {
  switch (type) {
    case 'streak_alert':
    case 'streak_break':
      return 'mission_invest_alerts';
    case 'milestone':
    case 'mission_complete':
      return 'mission_invest_milestones';
    case 'daily_reminder':
      return 'mission_invest_reminders';
    default:
      return 'mission_invest_reminders';
  }
}
