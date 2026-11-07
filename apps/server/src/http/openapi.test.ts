import 'reflect-metadata';
import { readdirSync, readFileSync } from 'node:fs';
import { RequestMethod } from '@nestjs/common';
import { METHOD_METADATA, PATH_METADATA } from '@nestjs/common/constants.js';
import { ModulesContainer } from '@nestjs/core';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import type { OpenAPIObject } from '@nestjs/swagger';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../api.module.js';
import { ROUTE_ACCESS, type RouteAccess } from './access.js';
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
      return operation ? [{ path, method, operation }] : [];
    }),
  );
}

// Every route the app serves, from its controllers' metadata, with its access.
function servedRoutes(): { route: string; access: RouteAccess['kind'] | undefined }[] {
  const controllers = new Set<object>();
  for (const module of app.get(ModulesContainer).values()) {
    for (const wrapper of module.controllers.values()) controllers.add(wrapper.metatype as object);
  }
  return [...controllers].flatMap((controller) => {
    const base = Reflect.getMetadata(PATH_METADATA, controller) as string;
    const prototype = (controller as { prototype: Record<string, unknown> }).prototype;
    return Object.getOwnPropertyNames(prototype).flatMap((name) => {
      const handler = prototype[name] as object;
      const path = Reflect.getMetadata(PATH_METADATA, handler) as string | undefined;
      if (name === 'constructor' || path === undefined) return [];
      const method = RequestMethod[Reflect.getMetadata(METHOD_METADATA, handler) as number];
      const access =
        (Reflect.getMetadata(ROUTE_ACCESS, handler) as RouteAccess | undefined) ??
        (Reflect.getMetadata(ROUTE_ACCESS, controller) as RouteAccess | undefined);
      const full = ['/v1', base, path]
        .join('/')
        .replace(/\/+/g, '/')
        .replace(/\/$/, '')
        .replace(/:(\w+)/g, '{$1}');
      return [{ route: `${method} ${full}`, access: access?.kind }];
    });
  });
}

describe('OpenAPI document', () => {
  // Architecture §15.2, E6: the document lists every route, so the clients
  // and the route table of admin-team.test.ts see them all, except the routes
  // only Centrifugo calls, which must then be @RealtimeProxy().
  it('lists every route the app serves but the ones only Centrifugo calls', () => {
    const documented = new Set(
      operations().map(({ path, method }) => `${method.toUpperCase()} ${path}`),
    );
    const left = servedRoutes().filter(({ route }) => !documented.has(route));
    expect(left.map(({ route }) => route).sort()).toEqual([
      'POST /v1/admin/realtime/subscribe',
      'POST /v1/captain/realtime/subscribe',
      'POST /v1/customer/realtime/subscribe',
      'POST /v1/merchant/realtime/subscribe',
    ]);
    expect(left.every(({ access }) => access === 'realtime_proxy')).toBe(true);
    const proxied = servedRoutes().filter(({ access }) => access === 'realtime_proxy');
    expect(proxied.every(({ route }) => !documented.has(route))).toBe(true);
  });

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

  // restoreNullablePrimitives in openapi.ts: a top-level `z.string().nullable()`
  // of a response DTO is a nullable string, never an array of strings.
  it('keeps a nullable primitive nullable at the top of a DTO', () => {
    const schemas = document.components?.schemas ?? {};
    const page = schemas.CustomerRestaurantPageDto_Output as {
      properties: Record<string, unknown>;
    };
    expect(page.properties.nameEn).toMatchObject({ type: ['string', 'null'] });
    expect(page.properties.rating).toMatchObject({ type: ['number', 'null'] });
    expect(JSON.stringify(document)).not.toContain('x-nestjs_zod');
    const admin = schemas.AdminSessionDto_Output as { properties: Record<string, unknown> };
    expect(admin.properties.roles).toMatchObject({ type: 'array' });
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
