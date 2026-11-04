import 'reflect-metadata';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import { ApiModule } from './api.module.js';
import { createApiApp } from './create-api-app.js';

describe('createApiApp', () => {
  let app: NestFastifyApplication;

  beforeAll(async () => {
    app = await createApiApp(ApiModule);
    await app.init();
    await app.getHttpAdapter().getInstance().ready();
  });

  afterAll(() => app.close());

  it('answers HTTP requests', async () => {
    const response = await app.inject({ method: 'GET', url: '/v1/unknown' });
    expect(response.statusCode).toBe(404);
  });
});
