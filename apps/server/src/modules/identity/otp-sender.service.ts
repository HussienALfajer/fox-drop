import { createHash } from 'node:crypto';
import {
  Inject,
  Injectable,
  Logger,
  type OnApplicationBootstrap,
  type OnApplicationShutdown,
} from '@nestjs/common';
import { and, eq, gt } from 'drizzle-orm';
import type { Valkey } from 'iovalkey';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { VALKEY } from '../../valkey/valkey.module.js';
import {
  BLOCKING_COMMAND_TIMEOUT_MS,
  decodeSendPayload,
  ready,
  safeJson,
  SEND_ANSWERS_CHANNEL,
  SEND_REQUESTS_KEY,
  type SendAnswer,
  type SendRequest,
  sendRequestSchema,
} from './code-send-queue.js';
import type { SendResult } from './code-sender.js';
import { codeMessage, replyMessage } from './otp-messages.js';
import { OtpSenderNumbers, type SenderNumber } from './otp-sender-numbers.js';
import { otpWhatsAppNumbers } from './schema.js';
import { IDENTITY_SECRETS, type IdentitySecrets } from './secrets.js';
import {
  WHATSAPP_CONNECT,
  type WhatsAppClient,
  type WhatsAppClosedReason,
  type WhatsAppConnect,
} from './whatsapp-client.js';

// §8.3.3 item 3: a number known to be on WhatsApp is checked again after 30
// days.
export const ON_WHATSAPP_CACHE_DAYS = 30;
// How often the sender looks for its number again: after a lost connection,
// a pairing, or no number at all.
export const SUPERVISE_INTERVAL_MS = 10_000;
// §8.3.3 item 9: a chat gets the fixed reply once in this time.
const REPLIED_SECONDS = 30 * 24 * 60 * 60;
// How long the request loop blocks on the list, so a stop is quick.
const POLL_SECONDS = 1;

interface Connection {
  number: SenderNumber;
  client: WhatsAppClient;
  open: boolean;
}

// The otp-sender process (architecture §4.4, §8.3.3): one WhatsApp session
// (W1, one number; the pool is W2), the send requests of the API, the
// on-WhatsApp check, the fixed message and the one reply to incoming
// messages. A session is restored from its stored credentials; a number
// WhatsApp logs out is marked disconnected and waits for a new pairing.
@Injectable()
export class OtpSenderService implements OnApplicationBootstrap, OnApplicationShutdown {
  private readonly logger = new Logger(OtpSenderService.name);
  private readonly numbers: OtpSenderNumbers;
  private connection: Connection | null = null;
  private supervising: Promise<void> | null = null;
  private superviseTimer: NodeJS.Timeout | undefined;
  private requestLoop: Promise<void> | undefined;
  private blocking: Valkey | undefined;
  private stopped = false;

  constructor(
    @Inject(DATABASE) private readonly database: Database,
    @Inject(VALKEY) private readonly valkey: Valkey,
    @Inject(IDENTITY_SECRETS) private readonly secrets: IdentitySecrets,
    @Inject(WHATSAPP_CONNECT) private readonly connect: WhatsAppConnect,
  ) {
    this.numbers = new OtpSenderNumbers(database, secrets);
  }

  onApplicationBootstrap(): void {
    void this.supervise();
    this.superviseTimer = setInterval(() => void this.supervise(), SUPERVISE_INTERVAL_MS);
    this.requestLoop = this.takeRequests();
  }

  async onApplicationShutdown(): Promise<void> {
    this.stopped = true;
    clearInterval(this.superviseTimer);
    await this.supervising;
    await this.requestLoop;
    this.blocking?.disconnect();
    const connection = this.connection;
    this.connection = null;
    await connection?.client.close();
  }

  // Whether a number is connected and can send, for the tests and the logs.
  get connected(): boolean {
    return this.connection?.open === true;
  }

  // Connects the latest active number, or moves to a newer one. One run at a
  // time.
  supervise(): Promise<void> {
    this.supervising ??= this.superviseOnce()
      .catch((error: unknown) => this.logger.error({ err: error }, 'otp sender supervision failed'))
      .finally(() => {
        this.supervising = null;
      });
    return this.supervising;
  }

  private async superviseOnce(): Promise<void> {
    if (this.stopped) return;
    const latest = await this.numbers.latestActive();
    const current = this.connection;
    if (current && current.number.id === latest?.id) return;
    if (current) {
      this.connection = null;
      await current.client.close();
    }
    if (!latest) return;
    const connection: Connection = { number: latest, client: undefined as never, open: false };
    connection.client = await this.connect(this.numbers.session(latest.id), {
      qr: () => {
        // A stored session never asks for a QR code; this one is no longer
        // valid, and only the pairing command can pair the number again.
        void this.lost(connection, 'logged_out');
      },
      open: () => {
        connection.open = true;
        this.logger.log('otp sender connected');
      },
      closed: (reason) => void this.lost(connection, reason),
      incoming: (chat) => void this.answerIncoming(connection, chat),
    });
    this.connection = connection;
  }

  private async lost(connection: Connection, reason: WhatsAppClosedReason): Promise<void> {
    connection.open = false;
    if (this.connection !== connection) return;
    this.connection = null;
    if (reason === 'logged_out') {
      // §8.3.3 item 14 raises the alert with the pool (W2).
      this.logger.error('otp sender number logged out by WhatsApp; pair a number again');
      await connection.client.close();
      await this.numbers.disconnect(connection.number.id, new Date());
    } else {
      this.logger.warn('otp sender connection lost; reconnecting');
    }
  }

  private async takeRequests(): Promise<void> {
    this.blocking = this.valkey.duplicate({ commandTimeout: BLOCKING_COMMAND_TIMEOUT_MS });
    this.blocking.on('error', () => undefined);
    while (!this.stopped) {
      try {
        await ready(this.blocking, 5_000);
        const taken = await this.blocking.brpop(SEND_REQUESTS_KEY, POLL_SECONDS);
        if (!taken) continue;
        const request = sendRequestSchema.safeParse(safeJson(taken[1]));
        if (request.success) await this.answer(request.data);
      } catch (error) {
        if (this.stopped) return;
        this.logger.warn({ err: error }, 'otp send requests unreachable');
        await pause(1_000);
        if (this.blocking.status === 'end') {
          this.blocking = this.valkey.duplicate({ commandTimeout: BLOCKING_COMMAND_TIMEOUT_MS });
          this.blocking.on('error', () => undefined);
        }
      }
    }
  }

  // Answers one request. One past its deadline is dropped unsent: the API has
  // already answered unavailable and rolled its code back.
  async answer(request: SendRequest, now = new Date()): Promise<SendResult | null> {
    if (request.deadline <= now.getTime()) return null;
    const { phone, code } = decodeSendPayload(this.secrets, request);
    const result = await this.deliver(phone, code, now);
    const answer: SendAnswer = { id: request.id, result };
    await this.valkey.publish(SEND_ANSWERS_CHANNEL, JSON.stringify(answer));
    return result;
  }

  private async deliver(phone: string, code: string, now: Date): Promise<SendResult> {
    const connection = this.connection;
    if (!connection?.open) return 'unavailable';
    try {
      if (!(await this.onWhatsApp(connection.client, phone, now))) return 'not_on_whatsapp';
      await connection.client.sendText(phone, codeMessage(code));
      return 'sent';
    } catch (error) {
      this.logger.error({ err: error }, 'otp code not sent');
      return 'unavailable';
    }
  }

  // §8.3.3 item 3, cached 30 days. Only a number on WhatsApp is cached.
  private async onWhatsApp(client: WhatsAppClient, phone: string, now: Date): Promise<boolean> {
    const phoneHash = this.secrets.phoneHash(phone);
    const since = new Date(now.getTime() - ON_WHATSAPP_CACHE_DAYS * 24 * 60 * 60 * 1000);
    const [cached] = await this.database.db
      .select({ phoneHash: otpWhatsAppNumbers.phoneHash })
      .from(otpWhatsAppNumbers)
      .where(
        and(eq(otpWhatsAppNumbers.phoneHash, phoneHash), gt(otpWhatsAppNumbers.checkedAt, since)),
      );
    if (cached) return true;
    if (!(await client.isOnWhatsApp(phone))) return false;
    await this.database.db
      .insert(otpWhatsAppNumbers)
      .values({ phoneHash, checkedAt: now })
      .onConflictDoUpdate({ target: otpWhatsAppNumbers.phoneHash, set: { checkedAt: now } });
    return true;
  }

  // §8.3.3 item 9: one fixed reply per chat. The mark lives in Valkey, so
  // losing it costs one more reply at most.
  private async answerIncoming(connection: Connection, chat: string): Promise<void> {
    try {
      const key = `identity:otp:replied:${createHash('sha256').update(chat).digest('hex')}`;
      const first = await this.valkey.set(key, '1', 'EX', REPLIED_SECONDS, 'NX');
      if (first !== 'OK' || !connection.open) return;
      await connection.client.reply(chat, replyMessage(process.env.SUPPORT_WHATSAPP_NUMBER));
    } catch (error) {
      this.logger.warn({ err: error }, 'otp sender reply not sent');
    }
  }
}

function pause(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
