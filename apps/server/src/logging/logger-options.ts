import type { LoggerOptions } from 'pino';
import { redact, redactText } from './redact.js';

interface RequestLike {
  id?: unknown;
  method?: string;
  url?: string;
}

interface ResponseLike {
  statusCode?: number;
}

// Query strings and headers can carry tokens and codes, so a request is
// logged by its id, method and path only.
export function serializeRequest(request: RequestLike) {
  return {
    id: request.id,
    method: request.method,
    path: request.url === undefined ? undefined : redactText(request.url.split('?')[0] ?? ''),
  };
}

export function serializeResponse(response: ResponseLike) {
  return { statusCode: response.statusCode };
}

export function loggerOptions(level = process.env.LOG_LEVEL ?? 'info'): LoggerOptions {
  return {
    level,
    formatters: {
      log: (object) => redact(object) as Record<string, unknown>,
    },
    hooks: {
      logMethod(args, method) {
        method.apply(
          this,
          args.map((arg: unknown) =>
            typeof arg === 'string' ? redactText(arg) : arg,
          ) as Parameters<typeof method>,
        );
      },
    },
    serializers: { req: serializeRequest, res: serializeResponse },
  };
}
