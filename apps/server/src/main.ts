import 'reflect-metadata';
import { createLogger } from './logging/logger-options.js';
import { parseProcessRole } from './roles/process-role.js';
import { startRole } from './roles/start-role.js';

// Failures outside Nest still go through the redacting logger.
const logger = createLogger();

function exitOnError(error: unknown, msg: string): void {
  logger.fatal({ err: error }, msg);
  process.exit(1);
}

process.on('uncaughtException', (error) => exitOnError(error, 'uncaught exception'));
process.on('unhandledRejection', (reason) => exitOnError(reason, 'unhandled rejection'));

try {
  await startRole(parseProcessRole(process.env.PROCESS_ROLE));
} catch (error) {
  exitOnError(error, 'start-up failed');
}
