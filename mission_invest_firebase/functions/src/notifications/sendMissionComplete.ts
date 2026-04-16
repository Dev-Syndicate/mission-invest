import { sendPushNotification } from '../utils/fcm';

export async function sendMissionCompleteNotification(
  userId: string,
  missionId: string,
  missionTitle: string
): Promise<void> {
  await sendPushNotification({
    userId,
    title: 'Mission Complete!',
    body: `"${missionTitle}" is 100% funded! Your certificate is ready to share.`,
    type: 'mission_complete',
    missionId,
  });
}
