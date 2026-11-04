import type { INestApplication } from '@nestjs/common';
import { DocumentBuilder, type OpenAPIObject, SwaggerModule } from '@nestjs/swagger';
import { cleanupOpenApiDoc } from 'nestjs-zod';

const SERVER_TIME = 'Server-Time';

// Architecture §5.3, E6: the OpenAPI 3.1 document is generated from the
// controllers, and the TypeScript and Dart clients are generated from it.
export function createOpenApiDocument(app: INestApplication): OpenAPIObject {
  const config = new DocumentBuilder()
    .setTitle('FOX DROP API')
    .setVersion('1')
    .setOpenAPIVersion('3.1.0')
    .build();
  const document = cleanupOpenApiDoc(
    SwaggerModule.createDocument(app, config, {
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
    }),
    { version: '3.1' },
  );
  addServerTimeHeader(document);
  return document;
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
