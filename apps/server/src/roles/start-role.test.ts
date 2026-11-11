import 'reflect-metadata';
import { Logger } from 'nestjs-pino';
import { afterAll, beforeAll, expect, it } from 'vitest';
import { startTestDatabase, type TestDatabase } from '../database/test-database.js';
import { startTestValkey, type TestValkey } from '../valkey/test-valkey.js';
import { createBackgroundContext } from './start-role.js';

// The dispatcher's loop (slice 2.15b) reads the cities and the settings, so
// the role starts against a database and a Valkey.
let database: TestDatabase;
let cache: TestValkey;

beforeAll(async () => {
  [database, cache] = await Promise.all([startTestDatabase(), startTestValkey()]);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
}, 300_000);

afterAll(async () => {
  await Promise.all([database?.stop(), cache?.stop()]);
});

it('starts a background role with the structured logger', async () => {
  const context = await createBackgroundContext('dispatcher');

  expect(context.get(Logger)).toBeInstanceOf(Logger);

  await context.close();
});
