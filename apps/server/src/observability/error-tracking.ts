import { type ArgumentsHost, Catch, HttpException } from '@nestjs/common';
import * as Sentry from '@sentry/nestjs';
import { SentryGlobalFilter } from '@sentry/nestjs/setup';
import { redact } from '../logging/redact.js';

// main.ts reports these itself before the process exits.
const OWN_HANDLERS = new Set(['OnUncaughtException', 'OnUnhandledRejection']);

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
    integrations: (defaults) =>
      defaults.filter((integration) => !OWN_HANDLERS.has(integration.name)),
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

// Sentry's filter reports what is not an HttpException and then answers as
// Nest's own filter does. A 500 thrown as an HttpException, such as a
// response that fails its own schema, is a server error too.
@Catch()
export class ErrorTrackingFilter extends SentryGlobalFilter {
  override catch(exception: unknown, host: ArgumentsHost): void {
    if (exception instanceof HttpException && exception.getStatus() >= 500) {
      Sentry.captureException(exception);
    }
    super.catch(exception, host);
  }
}

// For an error a background job catches and logs: the roles without HTTP
// have no exception filter.
export function reportError(error: unknown): void {
  Sentry.captureException(error);
}

// For an alert of AP §9.1.3 raised by a role without the panel's alerts feed,
// so it still reaches someone (architecture §16).
export function reportAlert(message: string, level: 'warning' | 'fatal'): void {
  Sentry.captureMessage(message, level);
}

// For errors outside Nest, before the process exits.
export async function reportFatal(error: unknown): Promise<void> {
  Sentry.captureException(error);
  await Sentry.flush(2000);
}
