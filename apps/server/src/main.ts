import 'reflect-metadata';
import { parseProcessRole } from './roles/process-role.js';
import { startRole } from './roles/start-role.js';

await startRole(parseProcessRole(process.env.PROCESS_ROLE));
