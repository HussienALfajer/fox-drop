import type { INestApplication } from '@nestjs/common';
import { DocumentBuilder, type OpenAPIObject, SwaggerModule } from '@nestjs/swagger';
import { cleanupOpenApiDoc } from 'nestjs-zod';

const SERVER_TIME = 'Server-Time';

// Building the API module to read its routes needs the variables its modules
// read at start. Nothing is queried, so addresses where nothing listens do:
// the pool connects on first use only, and Valkey's failed connection is
// closed with the app.
export function setOpenApiPlaceholderEnvironment(): void {
  process.env.DATABASE_URL ??= 'postgres://openapi:openapi@127.0.0.1:1/openapi';
  process.env.VALKEY_URL ??= 'redis://127.0.0.1:1';
  process.env.IDENTITY_ENCRYPTION_KEY ??= Buffer.alloc(32).toString('base64');
}

// Architecture §5.3, E6: the OpenAPI 3.1 document is generated from the
// controllers, and the TypeScript and Dart clients are generated from it.
export function createOpenApiDocument(app: INestApplication): OpenAPIObject {
  const config = new DocumentBuilder()
    .setTitle('FOX DROP API')
    .setVersion('1')
    .setOpenAPIVersion('3.1.0')
    .build();
  const raw = SwaggerModule.createDocument(app, config, {
    // AdminStatusController.get becomes adminStatusGet.
    operationIdFactory: (controllerKey, methodKey) => {
      const name = controllerKey.replace(/Controller$/, '');
      return (
        name.charAt(0).toLowerCase() +
        name.slice(1) +
        methodKey.charAt(0).toUpperCase() +
        methodKey.slice(1)
      );
    },
  });
  restoreNullablePrimitives(raw);
  const document = cleanupOpenApiDoc(raw, { version: '3.1' });
  addServerTimeHeader(document);
  return document;
}

// nestjs-zod 5.5.0 marks a DTO's top-level property whose JSON schema type is
// not a string. Zod writes a nullable primitive without constraints as
// `type: ['string', 'null']`, and @nestjs/swagger reads a list as "array of
// the first", so `z.string().nullable()` reached the document as an array of
// strings and the Dart client could not read the answer. A real array never
// carries the marker, so a marked `array` is put back as the nullable type.
const EMPTY_TYPE_MARKER = 'x-nestjs_zod-empty-type';

function restoreNullablePrimitives(document: OpenAPIObject): void {
  for (const schema of Object.values(document.components?.schemas ?? {})) {
    if ('$ref' in schema) continue;
    for (const property of Object.values(schema.properties ?? {})) {
      const marked = property as Record<string, unknown>;
      if (marked[EMPTY_TYPE_MARKER] !== true || marked.type !== 'array') continue;
      const items = marked.items as { type?: unknown } | undefined;
      if (!items || typeof items.type !== 'string' || Object.keys(items).length !== 1) {
        throw new Error('openapi: a marked array property has unexpected items');
      }
      marked.type = [items.type, 'null'];
      delete marked.items;
    }
  }
}

// create-api-app.ts sets Server-Time on every response, which no decorator
// can describe, so the document declares it once and every response refers to it.
function addServerTimeHeader(document: OpenAPIObject): void {
  document.components ??= {};
  document.components.headers = {
    ...document.components.headers,
    [SERVER_TIME]: {
      description:
        'The server clock in Unix milliseconds. The apps compute their clock offset from it (RA §4.7).',
      required: true,
      schema: { type: 'string', pattern: '^\\d+$' },
    },
  };
  for (const pathItem of Object.values(document.paths)) {
    for (const method of ['get', 'put', 'post', 'delete', 'patch'] as const) {
      for (const response of Object.values(pathItem[method]?.responses ?? {})) {
        if (!response || '$ref' in response) continue;
        response.headers = {
          ...response.headers,
          [SERVER_TIME]: { $ref: `#/components/headers/${SERVER_TIME}` },
        };
      }
    }
  }
}
