import 'reflect-metadata';
import { ApiModule } from './api.module.js';
import { createApiApp } from './http/create-api-app.js';

const app = await createApiApp(ApiModule);
await app.listen({ host: '0.0.0.0', port: Number(process.env.PORT ?? 3000) });
