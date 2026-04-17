import { https } from 'firebase-functions/v1';
import { logger } from '../utils/logger';

export const seedMarketplace = https.onCall(async (_data, _context) => {
  logger.info('seedMarketplace called — placeholder');
  return { success: true, message: 'Marketplace seeding not yet implemented' };
});
