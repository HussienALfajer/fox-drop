import { createLogger } from '../logging/logger-options.js';
import { setUpStorage, storageSetupFromEnvironment } from './storage-setup.js';

// `pnpm --filter @fox-drop/server storage:setup` in development, and
// `run --rm storage-setup` in the deploy (infra/compose.yaml).
const logger = createLogger();
try {
  await setUpStorage(storageSetupFromEnvironment());
  logger.info('storage set up: the layout, the keys and the public-media bucket');
} catch (error) {
  logger.fatal({ err: error }, 'storage setup failed');
  process.exit(1);
}
