import { https } from 'firebase-functions/v1';
import { db, collections } from '../utils/firestore';
import { logger } from '../utils/logger';

export const getAdminAnalytics = https.onCall(async (data, context) => {
  const userId = context.auth?.uid;
  if (!userId) {
    throw new https.HttpsError('unauthenticated', 'Must be logged in');
  }

  const userDoc = await db.collection(collections.users).doc(userId).get();
  if (!userDoc.data()?.isAdmin) {
    throw new https.HttpsError('permission-denied', 'Admin only');
  }

  try {
    const [usersSnap, missionsSnap, contributionsSnap, badgesSnap] = await Promise.all([
      db.collection(collections.users).get(),
      db.collection(collections.missions).get(),
      db.collection(collections.contributions).get(),
      db.collection(collections.badges).get(),
    ]);

    const totalUsers = usersSnap.size;
    const totalMissions = missionsSnap.size;
    const totalContributions = contributionsSnap.size;
    const totalBadges = badgesSnap.size;

    let completedMissions = 0;
    let activeMissions = 0;
    let failedMissions = 0;
    const categoryCount: Record<string, number> = {};

    missionsSnap.forEach((doc) => {
      const mission = doc.data();
      if (mission.status === 'completed') completedMissions++;
      if (mission.status === 'active') activeMissions++;
      if (mission.status === 'failed') failedMissions++;
      categoryCount[mission.category] = (categoryCount[mission.category] || 0) + 1;
    });

    const completionRate = totalMissions > 0
      ? (completedMissions / totalMissions * 100).toFixed(1)
      : '0';

    return {
      success: true,
      data: {
        totalUsers,
        totalMissions,
        activeMissions,
        completedMissions,
        failedMissions,
        completionRate: `${completionRate}%`,
        totalContributions,
        totalBadges,
        categoryBreakdown: categoryCount,
      },
    };
  } catch (error) {
    logger.error('getAdminAnalytics failed:', error);
    throw new https.HttpsError('internal', 'Analytics fetch failed');
  }
});
