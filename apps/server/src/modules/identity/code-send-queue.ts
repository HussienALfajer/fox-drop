import { randomUUID } from 'node:crypto';
import type { Valkey } from 'iovalkey';
import { z } from 'zod';
import type { CodeSender, SendResult } from './code-sender.js';
import type { IdentitySecrets } from './secrets.js';

// Architecture §8.3.1: the API never loads the WhatsApp library. It puts a
// send request on a Valkey list and waits for the otp-sender's answer on a
// channel, so the app still hears not_on_whatsapp (400) or unavailable (503).
// No answer within the timeout is unavailable, and the code rolls back. The
// number and the code travel encrypted with IdentitySecrets. Nothing here is
// the only copy (architecture §5.7): a lost request is a timeout.
export const SEND_REQUESTS_KEY = 'identity:otp:send:requests';
export const SEND_ANSWERS_CHANNEL = 'identity:otp:send:answers';
// Long enough for the on-WhatsApp check and the send, short enough for the
// app's spinner. The request's deadline is the same, so the sender drops a
// request whose code has already rolled back.
export const SEND_ANSWER_TIMEOUT_MS = 10_000;

// The shared client gives up on a command after a second; the subscriber and
// the sender's blocking pop wait longer than that by design.
export const BLOCKING_COMMAND_TIMEOUT_MS = 30_000;

export const sendRequestSchema = z.object({
  id: z.uuid(),
  // {phone, code} as JSON, encrypted.
  payload: z.string(),
  // Unix milliseconds after which nobody waits for the answer.
  deadline: z.number().int(),
});
export type SendRequest = z.infer<typeof sendRequestSchema>;

export const sendAnswerSchema = z.object({
  id: z.uuid(),
  result: z.enum(['sent', 'not_on_whatsapp', 'unavailable']),
});
export type SendAnswer = z.infer<typeof sendAnswerSchema>;

const payloadSchema = z.object({ phone: z.string(), code: z.string() });

export function encodeSendRequest(
  secrets: IdentitySecrets,
  phone: string,
  code: string,
  deadline: number,
): SendRequest {
  return {
    id: randomUUID(),
    payload: secrets.encrypt(JSON.stringify({ phone, code })),
    deadline,
  };
}

export function decodeSendPayload(
  secrets: IdentitySecrets,
  request: SendRequest,
): { phone: string; code: string } {
  return payloadSchema.parse(JSON.parse(secrets.decrypt(request.payload)));
}

// The API's CodeSender in staging and production. One subscriber connection
// per process hears every answer and hands it to the request that waits.
export class QueuedCodeSender implements CodeSender {
  private subscriber: Promise<Valkey> | undefined;
  private readonly waiting = new Map<string, (result: SendResult) => void>();

  constructor(
    private readonly valkey: Valkey,
    private readonly secrets: IdentitySecrets,
    private readonly timeoutMs = SEND_ANSWER_TIMEOUT_MS,
  ) {}

  async send(phone: string, code: string): Promise<SendResult> {
    try {
      await this.subscribe();
    } catch {
      return 'unavailable';
    }
    const request = encodeSendRequest(this.secrets, phone, code, Date.now() + this.timeoutMs);
    const answer = new Promise<SendResult>((resolve) => {
      const timer = setTimeout(() => {
        this.waiting.delete(request.id);
        resolve('unavailable');
      }, this.timeoutMs);
      this.waiting.set(request.id, (result) => {
        clearTimeout(timer);
        this.waiting.delete(request.id);
        resolve(result);
      });
    });
    try {
      await this.valkey.lpush(SEND_REQUESTS_KEY, JSON.stringify(request));
    } catch {
      this.waiting.get(request.id)?.('unavailable');
    }
    return answer;
  }

  // Nest calls it on the factory's instance when the API stops.
  async onApplicationShutdown(): Promise<void> {
    const subscriber = await this.subscriber?.catch(() => undefined);
    subscriber?.disconnect();
    for (const resolve of this.waiting.values()) resolve('unavailable');
  }

  private subscribe(): Promise<Valkey> {
    this.subscriber ??= (async () => {
      const subscriber = this.valkey.duplicate({ commandTimeout: BLOCKING_COMMAND_TIMEOUT_MS });
      // The client reconnects and subscribes again on its own; requests made
      // meanwhile time out.
      subscriber.on('error', () => undefined);
      await ready(subscriber, this.timeoutMs);
      subscriber.on('message', (_channel: string, message: string) => {
        const answer = sendAnswerSchema.safeParse(safeJson(message));
        if (answer.success) this.waiting.get(answer.data.id)?.(answer.data.result);
      });
      await subscriber.subscribe(SEND_ANSWERS_CHANNEL);
      return subscriber;
    })();
    // A failed subscription is tried again by the next request.
    this.subscriber.catch(() => {
      this.subscriber = undefined;
    });
    return this.subscriber;
  }
}

// Resolves once the connection is ready, so commands are not refused by a
// client that queues nothing while offline.
export function ready(valkey: Valkey, timeoutMs: number): Promise<void> {
  if (valkey.status === 'ready') return Promise.resolve();
  return new Promise((resolve, reject) => {
    const timer = setTimeout(() => {
      valkey.off('ready', onReady);
      valkey.disconnect();
      reject(new Error('valkey is not ready'));
    }, timeoutMs);
    const onReady = () => {
      clearTimeout(timer);
      resolve();
    };
    valkey.once('ready', onReady);
  });
}

export function safeJson(text: string): unknown {
  try {
    return JSON.parse(text);
  } catch {
    return undefined;
  }
}
