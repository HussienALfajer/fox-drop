import { type LoggerOptions, pino } from 'pino';
import { redactLine } from './redact.js';

interface RequestLike {
  id?: unknown;
  method?: string;
  url?: string;
}

interface ResponseLike {
  statusCode?: number;
}

// Query strings and headers can carry tokens and codes, so a request is
// logged by its id, method and path only. Secrets never go in a path.
export function serializeRequest(request: RequestLike) {
  return {
    id: request.id,
    method: request.method,
    path: request.url?.split('?')[0],
  };
}

export function serializeResponse(response: ResponseLike) {
  return { statusCode: response.statusCode };
}

export function loggerOptions(level = process.env.LOG_LEVEL ?? 'info'): LoggerOptions {
  return {
    level,
    hooks: { streamWrite: redactLine },
    serializers: { req: serializeRequest, res: serializeResponse },
  };
}

// For what happens outside Nest: start-up failures and process-level errors.
export function createLogger() {
  return pino(loggerOptions());
}
