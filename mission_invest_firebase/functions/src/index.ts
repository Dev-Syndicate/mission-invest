// ── Firestore Triggers ──
export { onMissionCreate } from './missions/onMissionCreate';
export { onMissionComplete } from './missions/onMissionComplete';
export { onContributionCreate } from './contributions/onContributionCreate';

// ── Scheduled Functions ──
export { evaluateDailyStreaks } from './streaks/evaluateStreaks';
export { evaluateExpiredMissions } from './missions/evaluateExpiredMissions';
export { sendDailyReminders } from './notifications/sendDailyReminder';
export { sendStreakAlerts } from './notifications/sendStreakAlert';
export { sendWeeklyReport } from './notifications/sendWeeklyReport';
export { triggerAiNudges } from './ai/triggerAiNudge';

// ── Callable Functions ──
export { recoverStreak } from './streaks/recoverStreak';
export { sendBroadcast } from './notifications/sendBroadcast';
export { getAdminAnalytics } from './admin/getAnalytics';
export { manageTemplate } from './admin/manageTemplates';
export { manageFeatureFlag } from './admin/manageFeatureFlags';
export { manageChallenge } from './admin/manageChallenges';
