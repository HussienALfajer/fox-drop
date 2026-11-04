// Writes the OpenAPI document of the built server (architecture §5.3, E6).
// Usage, after `pnpm build`: node scripts/write-openapi.mjs <file>
import 'reflect-metadata';
import { writeFileSync } from 'node:fs';
import { ApiModule } from '../dist/api.module.js';
import { createApiApp } from '../dist/http/create-api-app.js';
import { createOpenApiDocument, setOpenApiPlaceholderEnvironment } from '../dist/http/openapi.js';

// Start-up logs would only be noise here.
process.env.LOG_LEVEL ??= 'silent';

const file = process.argv[2];
if (!file) throw new Error('Usage: write-openapi.mjs <file>');

setOpenApiPlaceholderEnvironment();
const app = await createApiApp(ApiModule);
await app.init();
writeFileSync(file, `${JSON.stringify(createOpenApiDocument(app), null, 2)}\n`);
await app.close();
