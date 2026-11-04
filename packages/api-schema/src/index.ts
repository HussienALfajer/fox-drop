import createClient, { type ClientOptions } from 'openapi-fetch';
import type { paths } from './schema.js';

// Architecture §5.3, E6: the web apps call the server only through this
// client, typed by the generated src/schema.ts.
export type { components, paths } from './schema.js';

export function createApiClient(options: ClientOptions) {
  return createClient<paths>(options);
}
