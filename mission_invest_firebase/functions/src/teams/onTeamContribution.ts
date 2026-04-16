import { firestore } from 'firebase-functions/v1';
import * as admin from 'firebase-admin';
import { db, collections } from '../utils/firestore';
import { sendPushNotification } from '../utils/fcm';
import { logger } from '../utils/logger';

/**
 * Team contribution handler (PRD 5.11)
 * Listens for new contributions that have a teamMissionId field.
 * Updates the team's pooled total and notifies members.
 */
export const onTeamContribution = firestore
  .document(`${collections.contributions}/{contributionId}`)
  .onCreate(async (snapshot) => {
    const contribution = snapshot.data();
    const teamMissionId = contribution.teamMissionId;

    // Only process team contributions
    if (!teamMissionId) return;

    const userId = contribution.userId;
    const amount = contribution.amount;

    try {
      const teamRef = db.collection(collections.teamMissions).doc(teamMissionId);

      await db.runTransaction(async (transaction) => {
        const teamDoc = await transaction.get(teamRef);
        if (!teamDoc.exists) return;

        const team = teamDoc.data()!;
        if (team.status !== 'active') return;

        const newTotal = (team.totalSaved || 0) + amount;
        const memberContrib = (team.contributions?.[userId] || 0) + amount;

        const updateData: Record<string, unknown> = {
          totalSaved: newTotal,
          [`contributions.${userId}`]: memberContrib,
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        };

        // Check if team mission is complete
        if (newTotal >= team.targetAmount) {
          updateData.status = 'completed';
          updateData.completedAt = admin.firestore.FieldValue.serverTimestamp();
        }

        transaction.update(teamRef, updateData);
      });

      // Notify other team members
      const teamDoc = await teamRef.get();
      const team = teamDoc.data();
      if (team) {
        const otherMembers = team.memberIds.filter((id: string) => id !== userId);
        for (const memberId of otherMembers) {
          await sendPushNotification({
            userId: memberId,
            title: 'Team Contribution!',
            body: `A teammate added ₹${amount} to "${team.title}". Total: ₹${team.totalSaved || 0}/${team.targetAmount}.`,
            type: 'team_update',
          });
        }
      }

      logger.info(`Team contribution: ₹${amount} to team ${teamMissionId} by user ${userId}`);
    } catch (error) {
      logger.error('onTeamContribution failed:', error);
    }
  });
