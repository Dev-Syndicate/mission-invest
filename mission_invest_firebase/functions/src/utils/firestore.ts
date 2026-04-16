import * as admin from 'firebase-admin';

if (!admin.apps.length) {
  admin.initializeApp();
}

export const db = admin.firestore();
export const auth = admin.auth();

export const collections = {
  users: 'users',
  missions: 'missions',
  contributions: 'contributions',
  badges: 'badges',
  notifications: 'notifications',
  templates: 'templates',
  challenges: 'challenges',
  featureFlags: 'featureFlags',
  aiLogs: 'aiLogs',
} as const;
