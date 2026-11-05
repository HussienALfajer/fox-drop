import 'reflect-metadata';
import { Body, Get, Module, Post, Req, type Type } from '@nestjs/common';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import type { FastifyRequest } from 'fastify';
import * as Sentry from '@sentry/nestjs';
import { createZodDto } from 'nestjs-zod';
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from 'vitest';
import { z } from 'zod';
import { createApiApp } from './create-api-app.js';
import {
  AdminController,
  CaptainController,
  CustomerController,
  MerchantController,
} from './route-groups.js';

class EchoDto extends createZodDto(z.object({ name: z.string().min(1) })) {}

@AdminController('probe')
class AdminProbe {
  @Get()
  get() {
    return { group: 'admin' };
  }

  @Post()
  echo(@Body() body: EchoDto) {
    return body;
  }

  @Get('ip')
  ip(@Req() request: FastifyRequest) {
    return { ip: request.ip };
  }

  @Get('fail')
  fail() {
    throw new Error('unexpected');
  }
}

@MerchantController('probe')
class MerchantProbe {
  @Get()
  get() {
    return { group: 'merchant' };
  }
}

@CaptainController('probe')
class CaptainProbe {
  @Get()
  get() {
    return { group: 'captain' };
  }
}

@CustomerController('probe')
class CustomerProbe {
  @Get()
  get() {
    return { group: 'customer' };
  }
}

@Module({ controllers: [AdminProbe, MerchantProbe, CaptainProbe, CustomerProbe] })
class ProbeModule {}

let app: NestFastifyApplication | undefined;

async function start(module: Type): Promise<NestFastifyApplication> {
  app = await createApiApp(module);
  await app.init();
  await app.getHttpAdapter().getInstance().ready();
  return app;
}

afterEach(async () => {
  await app?.close();
  app = undefined;
});

describe('route groups', () => {
  it.each(['admin', 'merchant', 'captain', 'customer'])('serves /v1/%s', async (group) => {
    const api = await start(ProbeModule);

    const response = await api.inject({ method: 'GET', url: `/v1/${group}/probe` });

    expect(response.statusCode).toBe(200);
    expect(response.json()).toEqual({ group });
  });

  it('serves nothing outside /v1', async () => {
    const api = await start(ProbeModule);

    const response = await api.inject({ method: 'GET', url: '/admin/probe' });

    expect(response.statusCode).toBe(404);
  });
});

// nginx replaces X-Forwarded-For with the address it sees, and the API trusts
// exactly that one hop (architecture §15.5).
describe('client address', () => {
  it('is the address the proxy forwards', async () => {
    const api = await start(ProbeModule);

    const response = await api.inject({
      method: 'GET',
      url: '/v1/admin/probe/ip',
      headers: { 'x-forwarded-for': '203.0.113.7' },
    });

    expect(response.json()).toEqual({ ip: '203.0.113.7' });
  });

  it('ignores addresses a client adds before the proxy', async () => {
    const api = await start(ProbeModule);

    const response = await api.inject({
      method: 'GET',
      url: '/v1/admin/probe/ip',
      headers: { 'x-forwarded-for': '198.51.100.1, 203.0.113.7' },
    });

    expect(response.json()).toEqual({ ip: '203.0.113.7' });
  });
});

describe('error tracking', () => {
  const events: Sentry.ErrorEvent[] = [];

  beforeAll(() => {
    Sentry.init({
      dsn: 'https://public@sentry.example.test/1',
      beforeSend: (event) => {
        events.push(event);
        return null;
      },
    });
  });

  afterAll(async () => {
    await Sentry.close();
  });

  beforeEach(() => {
    events.length = 0;
  });

  it('reports an unexpected error and answers 500', async () => {
    const api = await start(ProbeModule);

    const response = await api.inject({ method: 'GET', url: '/v1/admin/probe/fail' });
    await Sentry.flush();

    expect(response.statusCode).toBe(500);
    expect(events.map((event) => event.exception?.values?.[0]?.value)).toEqual(['unexpected']);
  });

  it('does not report an HTTP error', async () => {
    const api = await start(ProbeModule);

    const response = await api.inject({ method: 'GET', url: '/v1/admin/probe/missing' });
    await Sentry.flush();

    expect(response.statusCode).toBe(404);
    expect(events).toEqual([]);
  });
});

describe('Server-Time header', () => {
  it('carries the server clock in Unix milliseconds on success', async () => {
    const api = await start(ProbeModule);
    const before = Date.now();

    const response = await api.inject({ method: 'GET', url: '/v1/admin/probe' });

    const serverTime = Number(response.headers['server-time']);
    expect(serverTime).toBeGreaterThanOrEqual(before);
    expect(serverTime).toBeLessThanOrEqual(Date.now());
  });

  it('is on errors too', async () => {
    const api = await start(ProbeModule);

    const response = await api.inject({ method: 'GET', url: '/v1/unknown' });

    expect(response.statusCode).toBe(404);
    expect(response.headers['server-time']).toMatch(/^\d+$/);
  });
});

describe('Zod validation', () => {
  it('accepts a body that matches the schema', async () => {
    const api = await start(ProbeModule);

    const response = await api.inject({
      method: 'POST',
      url: '/v1/admin/probe',
      payload: { name: 'Azaz' },
    });

    expect(response.statusCode).toBe(201);
    expect(response.json()).toEqual({ name: 'Azaz' });
  });

  it('rejects a body that does not match with 400', async () => {
    const api = await start(ProbeModule);

    const response = await api.inject({
      method: 'POST',
      url: '/v1/admin/probe',
      payload: { name: '' },
    });

    expect(response.statusCode).toBe(400);
  });
});
