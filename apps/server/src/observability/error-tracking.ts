import * as Sentry from '@sentry/nestjs';
import { redact } from '../logging/redact.js';

// Architecture §16: server errors go to Sentry, from the server only. Without
// SENTRY_DSN (development, tests) nothing is sent and capturing does nothing.
export function startErrorTracking(env: NodeJS.ProcessEnv = process.env): boolean {
  const dsn = env.SENTRY_DSN;
  if (!dsn) return false;
  Sentry.init({
    dsn,
    environment: env.FOX_DROP_ENVIRONMENT,
    // The commit the image was built from (Dockerfile), so an error points
    // at its code.
    release: env.FOX_DROP_RELEASE,
    // Collect nothing about the request or the user; scrubEvent drops what
    // still gets through.
    dataCollection: {
      userInfo: false,
      cookies: false,
      httpHeaders: false,
      httpBodies: [],
      urlQueryParams: false,
    },
    beforeSend: scrubEvent,
  });
  return true;
}

// The same rule as the logs: no code, token or full phone number leaves the
// server. Bodies, cookies, headers and query strings are dropped, and the rest
// goes through the log redaction.
export function scrubEvent<T extends Sentry.ErrorEvent>(event: T): T {
  if (event.request) {
    delete event.request.data;
    delete event.request.cookies;
    delete event.request.headers;
    delete event.request.query_string;
    if (event.request.url) event.request.url = event.request.url.split('?')[0] ?? '';
  }
  return redact(JSON.parse(JSON.stringify(event))) as T;
}

// For errors outside Nest's exception filter, before the process exits.
export async function reportFatal(error: unknown): Promise<void> {
  Sentry.captureException(error);
  await Sentry.flush(2000);
}
