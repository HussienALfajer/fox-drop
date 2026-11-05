import { createApiClient } from '@fox-drop/api-schema';

// The API is served on the portal's own origin under /v1 (vite.config.ts).
export const api = createApiClient({ baseUrl: window.location.origin });
