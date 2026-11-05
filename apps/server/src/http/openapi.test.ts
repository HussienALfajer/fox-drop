import 'reflect-metadata';
import { readdirSync, readFileSync } from 'node:fs';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import type { OpenAPIObject } from '@nestjs/swagger';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../api.module.js';
import { createApiApp } from './create-api-app.js';
import { createOpenApiDocument, setOpenApiPlaceholderEnvironment } from './openapi.js';
import { ROUTE_GROUPS } from './route-groups.js';

let app: NestFastifyApplication;
let document: OpenAPIObject;

beforeAll(async () => {
  setOpenApiPlaceholderEnvironment();
  app = await createApiApp(ApiModule);
  await app.init();
  await app.getHttpAdapter().getInstance().ready();
  document = createOpenApiDocument(app);
});

afterAll(async () => {
  await app.close();
});

function operations() {
  return Object.entries(document.paths).flatMap(([path, item]) =>
    (['get', 'put', 'post', 'delete', 'patch'] as const).flatMap((method) => {
      const operation = item[method];
      return operation ? [{ path, operation }] : [];
    }),
  );
}

describe('OpenAPI document', () => {
  // A DTO class's name is its schema's name in the document, and two classes
  // with one name silently become one schema, the second replacing the first.
  it('has one DTO class per name', () => {
    const source = new URL('..', import.meta.url);
    const names = readdirSync(source, { recursive: true, encoding: 'utf8' })
      .filter((file) => file.endsWith('.ts') && !file.endsWith('.test.ts'))
      .flatMap((file) =>
        [
          ...readFileSync(new URL(file.replaceAll('\\', '/'), source), 'utf8').matchAll(
            /class (\w+) extends createZodDto/g,
          ),
        ].map((match) => match[1]),
      );
    expect(names.length).toBeGreaterThan(10);
    expect(names.filter((name, index) => names.indexOf(name) !== index)).toEqual([]);
  });

  it('is OpenAPI 3.1', () => {
    expect(document.openapi).toMatch(/^3\.1\./);
  });

  it('tags every route with the group of its path', () => {
    for (const { path, operation } of operations()) {
      const group = path.split('/')[2];
      expect(ROUTE_GROUPS).toContain(group);
      expect(operation.tags).toEqual([group]);
    }
  });

  it.each(ROUTE_GROUPS)('has the status route of /v1/%s', (group) => {
    const response = document.paths[`/v1/${group}/status`]?.get?.responses['200'];

    expect(response).toMatchObject({
      content: {
        'application/json': { schema: { $ref: '#/components/schemas/StatusDto_Output' } },
      },
    });
  });

  it('declares Server-Time on every response', () => {
    expect(document.components?.headers?.['Server-Time']).toMatchObject({ required: true });
    for (const { operation } of operations()) {
      for (const response of Object.values(operation.responses)) {
        expect(response).toMatchObject({
          headers: { 'Server-Time': { $ref: '#/components/headers/Server-Time' } },
        });
      }
    }
  });

  it('documents a success response with a schema for every operation', () => {
    for (const { path, operation } of operations()) {
      const success = Object.entries(operation.responses).filter(([status]) =>
        /^2\d\d$/.test(status),
      );
      expect(success, path).not.toHaveLength(0);
      for (const [, response] of success) {
        expect(response, path).toMatchObject({
          content: { 'application/json': { schema: { $ref: expect.any(String) } } },
        });
      }
    }
  });

  it('gives every operation a unique id', () => {
    const ids = operations().map(({ operation }) => operation.operationId);

    expect(new Set(ids).size).toBe(ids.length);
  });
});

describe('status route', () => {
  it.each(ROUTE_GROUPS)('answers on /v1/%s/status with the server clock', async (group) => {
    const before = Date.now();

    const response = await app.inject({ method: 'GET', url: `/v1/${group}/status` });

    expect(response.statusCode).toBe(200);
    const body = response.json<{ status: string; serverTime: number }>();
    expect(body.status).toBe('ok');
    expect(body.serverTime).toBeGreaterThanOrEqual(before);
    expect(body.serverTime).toBeLessThanOrEqual(Number(response.headers['server-time']));
  });
});
