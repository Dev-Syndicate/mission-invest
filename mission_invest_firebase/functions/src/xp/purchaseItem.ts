import { https } from 'firebase-functions/v1';
import * as admin from 'firebase-admin';
import { db, collections } from '../utils/firestore';
import { logger } from '../utils/logger';

export const purchaseMarketplaceItem = https.onCall(async (data, context) => {
  const userId = context.auth?.uid;
  if (!userId) {
    throw new https.HttpsError('unauthenticated', 'Must be logged in');
  }

  const { itemId } = data;
  if (!itemId) {
    throw new https.HttpsError('invalid-argument', 'itemId required');
  }

  const userRef = db.collection(collections.users).doc(userId);
  const itemRef = db.collection(collections.marketplace).doc(itemId);

  return db.runTransaction(async (transaction) => {
    const [userDoc, itemDoc] = await Promise.all([
      transaction.get(userRef),
      transaction.get(itemRef),
    ]);

    if (!userDoc.exists) {
      throw new https.HttpsError('not-found', 'User not found');
    }
    if (!itemDoc.exists) {
      throw new https.HttpsError('not-found', 'Item not found');
    }

    const user = userDoc.data()!;
    const item = itemDoc.data()!;

    const availableXp = (user.xpTotal || 0) - (user.xpSpent || 0);
    if (availableXp < item.cost) {
      throw new https.HttpsError(
        'failed-precondition',
        `Not enough XP. Need ${item.cost}, have ${availableXp}`
      );
    }

    // Check if already owned
    const ownedItems: string[] = user.ownedItems || [];
    if (ownedItems.includes(itemId)) {
      throw new https.HttpsError('already-exists', 'Item already owned');
    }

    transaction.update(userRef, {
      xpSpent: admin.firestore.FieldValue.increment(item.cost),
      ownedItems: admin.firestore.FieldValue.arrayUnion(itemId),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    logger.info(`User ${userId} purchased marketplace item ${itemId} for ${item.cost} XP`);
    return { success: true, itemId, cost: item.cost };
  });
});
