import { createLogger } from '../logging/logger-options.js';
import { runMigrations } from './migrate.js';

// node dist/database/migrate-command.js, with MIGRATION_DATABASE_URL set.
const logger = createLogger();
const url = process.env.MIGRATION_DATABASE_URL;
if (!url) {
  logger.fatal('MIGRATION_DATABASE_URL is not set');
  process.exit(1);
}
try {
  await runMigrations(url);
  logger.info('migrations applied');
} catch (error) {
  logger.fatal({ err: error }, 'migrations failed');
  process.exit(1);
}
