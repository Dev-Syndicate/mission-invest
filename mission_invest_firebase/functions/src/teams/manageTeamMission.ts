import { https } from 'firebase-functions/v1';
import * as admin from 'firebase-admin';
import { db, collections } from '../utils/firestore';
import { sendPushNotification } from '../utils/fcm';
import { logger } from '../utils/logger';

/**
 * Team Mission management (PRD 5.11)
 * - create: create a team mission (up to 5 members)
 * - join: join an existing team mission
 * - leave: leave a team mission
 */
export const manageTeamMission = https.onCall(async (data, context) => {
  const userId = context.auth?.uid;
  if (!userId) {
    throw new https.HttpsError('unauthenticated', 'Must be logged in');
  }

  const { action } = data;

  switch (action) {
    case 'create':
      return createTeamMission(userId, data);
    case 'join':
      return joinTeamMission(userId, data);
    case 'leave':
      return leaveTeamMission(userId, data);
    default:
      throw new https.HttpsError('invalid-argument', 'Invalid action');
  }
});

async function createTeamMission(
  userId: string,
  data: { title: string; targetAmount: number; category?: string }
) {
  const { title, targetAmount, category } = data;

  if (!title || !targetAmount) {
    throw new https.HttpsError('invalid-argument', 'title and targetAmount required');
  }
  if (targetAmount < 100) {
    throw new https.HttpsError('invalid-argument', 'targetAmount must be at least ₹100');
  }

  const docRef = await db.collection(collections.teamMissions).add({
    title,
    targetAmount,
    category: category || 'general',
    memberIds: [userId],
    contributions: { [userId]: 0 },
    totalSaved: 0,
    status: 'active',
    createdBy: userId,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  logger.info(`Team mission created: ${docRef.id} by user ${userId}`);
  return { success: true, teamMissionId: docRef.id };
}

async function joinTeamMission(userId: string, data: { teamMissionId: string }) {
  const { teamMissionId } = data;
  if (!teamMissionId) {
    throw new https.HttpsError('invalid-argument', 'teamMissionId required');
  }

  const teamRef = db.collection(collections.teamMissions).doc(teamMissionId);

  return db.runTransaction(async (transaction) => {
    const teamDoc = await transaction.get(teamRef);
    if (!teamDoc.exists) {
      throw new https.HttpsError('not-found', 'Team mission not found');
    }

    const team = teamDoc.data()!;
    if (team.status !== 'active') {
      throw new https.HttpsError('failed-precondition', 'Team mission is not active');
    }
    if (team.memberIds.includes(userId)) {
      throw new https.HttpsError('already-exists', 'Already a member');
    }
    if (team.memberIds.length >= 5) {
      throw new https.HttpsError('failed-precondition', 'Team is full (max 5 members)');
    }

    transaction.update(teamRef, {
      memberIds: admin.firestore.FieldValue.arrayUnion(userId),
      [`contributions.${userId}`]: 0,
    });

    return { success: true };
  });
}

async function leaveTeamMission(userId: string, data: { teamMissionId: string }) {
  const { teamMissionId } = data;
  if (!teamMissionId) {
    throw new https.HttpsError('invalid-argument', 'teamMissionId required');
  }

  const teamRef = db.collection(collections.teamMissions).doc(teamMissionId);
  const teamDoc = await teamRef.get();

  if (!teamDoc.exists) {
    throw new https.HttpsError('not-found', 'Team mission not found');
  }

  const team = teamDoc.data()!;
  if (!team.memberIds.includes(userId)) {
    throw new https.HttpsError('failed-precondition', 'Not a member');
  }

  await teamRef.update({
    memberIds: admin.firestore.FieldValue.arrayRemove(userId),
  });

  logger.info(`User ${userId} left team mission ${teamMissionId}`);
  return { success: true };
}
