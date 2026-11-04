import 'reflect-metadata';
import { Logger } from 'nestjs-pino';
import { expect, it } from 'vitest';
import { createBackgroundContext } from './start-role.js';

it('starts a background role with the structured logger', async () => {
  const context = await createBackgroundContext('dispatcher');

  expect(context.get(Logger)).toBeInstanceOf(Logger);

  await context.close();
});
