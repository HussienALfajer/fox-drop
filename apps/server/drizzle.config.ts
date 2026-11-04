import { defineConfig } from 'drizzle-kit';

// `pnpm --filter @fox-drop/server db:generate` writes the SQL migration for a
// schema change into migrations/; review it as SQL before committing.
export default defineConfig({
  dialect: 'postgresql',
  schema: './src/modules/*/schema.ts',
  out: './migrations',
});
