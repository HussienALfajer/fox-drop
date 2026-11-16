import type { TestProject } from 'vitest/node';
import { startTestPostgres } from './test-database.js';

// Vitest's global setup (vitest.config.ts): one PostGIS for the run, its
// template migrated once; each database test file copies the template.
export default async function setup(project: TestProject): Promise<() => Promise<void>> {
  const postgres = await startTestPostgres();
  project.provide('testPostgres', { host: postgres.host, port: postgres.port });
  return () => postgres.stop();
}
