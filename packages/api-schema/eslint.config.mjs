import rootConfig from '../../eslint.config.mjs';

// src/schema.ts is generated from openapi.json (pnpm generate:api).
export default [...rootConfig, { ignores: ['src/schema.ts'] }];
