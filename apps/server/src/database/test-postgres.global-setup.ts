import type { TestProject } from 'vitest/node';
import { serveTestValkeys } from '../valkey/test-valkey.js';
import { removeLeftoverContainers, testRunLabels } from './test-containers.js';
import { startTestPostgres } from './test-database.js';

// Vitest's global setup (vitest.config.ts): first the containers an earlier,
// killed run left behind (src/database/test-containers.ts); then one PostGIS
// for the run, its template migrated once, each database test file copying
// the template; and the workers' Valkeys, one per worker slot that asks
// (src/valkey/test-valkey.ts). Every container carries the run's label.
export default async function setup(project: TestProject): Promise<() => Promise<void>> {
  await removeLeftoverContainers();
  const labels = testRunLabels(process.pid);
  project.provide('testRun', labels);
  const [postgres, valkeys] = await Promise.all([
    startTestPostgres(labels),
    serveTestValkeys(labels),
  ]);
  project.provide('testPostgres', { host: postgres.host, port: postgres.port });
  project.provide('testValkeys', valkeys.url);
  return async () => {
    await Promise.all([postgres.stop(), valkeys.stop()]);
  };
}
