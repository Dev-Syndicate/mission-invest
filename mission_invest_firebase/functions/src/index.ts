// ── Firestore Triggers ──
export { onMissionCreate } from './missions/onMissionCreate';
export { onMissionComplete } from './missions/onMissionComplete';
export { onMissionAdapt } from './missions/adaptivePlanner';
export { onContributionCreate } from './contributions/onContributionCreate';
export { onTeamContribution } from './teams/onTeamContribution';

// ── Scheduled Functions ──
export { evaluateDailyStreaks } from './streaks/evaluateStreaks';
export { evaluateExpiredMissions } from './missions/evaluateExpiredMissions';
export { evaluateContracts } from './contracts/evaluateContracts';
export { evaluateSeasons } from './seasons/evaluateSeasons';
export { calculateConfidenceScores } from './scores/calculateConfidenceScore';
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
export { seedMarketplace } from './admin/seedMarketplace';
export { manageSeason } from './seasons/manageSeason';
export { joinSeason } from './seasons/joinSeason';
export { manageTeamMission } from './teams/manageTeamMission';
export { purchaseMarketplaceItem } from './xp/purchaseItem';
