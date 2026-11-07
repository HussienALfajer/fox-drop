import { createApiClient } from '@fox-drop/api-schema';
import { recordServerTime } from './clock.js';

// The API is served on the panel's own origin under /v1 (vite.config.ts).
export const api = createApiClient({ baseUrl: window.location.origin });

// The sign-in routes answer 401 for a refused sign-in or no session; any other
// route answers 401 when the session has ended (AP §5.2).
const authRoutes = '/v1/admin/auth/';

let onSessionEnded: () => void = () => {};

// main.tsx sets this to clear the session and return to the sign-in page.
export function whenSessionEnds(handler: () => void) {
  onSessionEnded = handler;
}

api.use({
  onResponse({ request, response }) {
    recordServerTime(response.headers.get('Server-Time'));
    if (response.status === 401 && !new URL(request.url).pathname.startsWith(authRoutes)) {
      onSessionEnded();
    }
  },
});
