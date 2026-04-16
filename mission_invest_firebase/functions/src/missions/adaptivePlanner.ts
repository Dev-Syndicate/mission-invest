import { firestore } from 'firebase-functions/v1';
import axios from 'axios';
import { db, collections } from '../utils/firestore';
import { config } from '../config';
import { logger } from '../utils/logger';
import * as admin from 'firebase-admin';

/**
 * Adaptive Mission Planner (PRD 5.9)
 * Triggers when a mission is updated. Checks if the user is behind or ahead
 * and calls /ai/adapt to get recalculated plan suggestions.
 *
 * Trigger conditions:
 *  - User is 2+ days behind schedule
 *  - User has deposited 15%+ more than expected (running ahead)
 */

export const onMissionAdapt = firestore
  .document(`${collections.missions}/{missionId}`)
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();
    const missionId = context.params.missionId;

    // Only run for active missions
    if (after.status !== 'active') return;

    // Don't re-trigger if this update was from the planner itself
    if (after._adaptationInProgress) return;

    const now = new Date();
    const startDate = after.startDate?.toDate?.() || now;
    const endDate = after.endDate?.toDate?.() || now;
    const totalDays = after.durationDays || 1;
    const elapsed = Math.max(1, Math.ceil((now.getTime() - startDate.getTime()) / 86400000));
    const daysLeft = Math.max(0, Math.ceil((endDate.getTime() - now.getTime()) / 86400000));

    const expectedProgress = elapsed / totalDays;
    const actualProgress = after.targetAmount > 0
      ? (after.savedAmount || 0) / after.targetAmount
      : 0;

    const daysBehind = Math.floor((expectedProgress - actualProgress) * totalDays);
    const aheadRatio = actualProgress - expectedProgress;

    // Check trigger conditions
    const isBehind = daysBehind >= 2;
    const isAhead = aheadRatio >= 0.15;

    if (!isBehind && !isAhead) return;

    try {
      const response = await axios.post(`${config.fastApiBaseUrl}/ai/adapt`, {
        mission_id: missionId,
        current_saved: after.savedAmount || 0,
        days_left: daysLeft,
        target: after.targetAmount,
        ahead_flag: isAhead,
      }, {
        headers: config.fastApiKey ? { 'X-API-Key': config.fastApiKey } : {},
        timeout: 10000,
      });

      const suggestion = response.data;

      // Write adaptation to history
      await change.after.ref.update({
        adaptationHistory: admin.firestore.FieldValue.arrayUnion({
          date: new Date().toISOString(),
          type: suggestion.suggestion || (isAhead ? 'ahead' : 'behind'),
          newDailyAmount: suggestion.newDailyAmount || null,
          newEndDate: suggestion.newEndDate || null,
          reason: isBehind ? `${daysBehind}_days_behind` : 'ahead_of_schedule',
        }),
        lastAdaptationCheck: admin.firestore.FieldValue.serverTimestamp(),
      });

      logger.info(`Adaptive planner triggered for mission ${missionId}: ${isBehind ? 'behind' : 'ahead'}`);
    } catch (error) {
      logger.warn(`Adaptive planner API call failed for mission ${missionId}:`, error);
    }
  });
