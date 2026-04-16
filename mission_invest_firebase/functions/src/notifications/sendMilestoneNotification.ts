import { sendPushNotification } from '../utils/fcm';

export async function sendMilestoneNotification(
  userId: string,
  missionId: string,
  missionTitle: string,
  milestone: number
): Promise<void> {
  await sendPushNotification({
    userId,
    title: `${milestone}% Milestone!`,
    body: `You've reached ${milestone}% of "${missionTitle}". Amazing progress!`,
    type: 'milestone',
    missionId,
  });
}
