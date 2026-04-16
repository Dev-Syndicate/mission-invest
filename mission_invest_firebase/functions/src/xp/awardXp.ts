import * as admin from 'firebase-admin';
import { db, collections } from '../utils/firestore';
import { logger } from '../utils/logger';

/**
 * XP earn rates (from PRD 5.13):
 * - Daily contribution: +10
 * - Checkpoint reached (25/50/75%): +50
 * - Mission completed: +200
 * - Streak milestone 7d: +75, 30d: +150, 60d: +300
 * - Speed Runner (early finish): +250
 * - Season completion: +500
 */

type XpAction =
  | 'daily_contribution'
  | 'checkpoint_reached'
  | 'mission_completed'
  | 'streak_7'
  | 'streak_30'
  | 'streak_60'
  | 'speed_runner'
  | 'season_completion';

const XP_RATES: Record<XpAction, number> = {
  daily_contribution: 10,
  checkpoint_reached: 50,
  mission_completed: 200,
  streak_7: 75,
  streak_30: 150,
  streak_60: 300,
  speed_runner: 250,
  season_completion: 500,
};

export async function awardXp(
  userId: string,
  action: XpAction,
  metadata?: { missionId?: string; detail?: string }
): Promise<number> {
  const xp = XP_RATES[action];
  if (!xp) return 0;

  await db.collection(collections.users).doc(userId).update({
    xpTotal: admin.firestore.FieldValue.increment(xp),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  // Log the XP event for auditing
  await db
    .collection(collections.users)
    .doc(userId)
    .collection('xpHistory')
    .add({
      action,
      xp,
      missionId: metadata?.missionId || null,
      detail: metadata?.detail || null,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

  logger.info(`XP awarded: +${xp} (${action}) to user ${userId}`);
  return xp;
}
