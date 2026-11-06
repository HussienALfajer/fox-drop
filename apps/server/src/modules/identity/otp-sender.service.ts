import {
  Inject,
  Injectable,
  Logger,
  type OnApplicationBootstrap,
  type OnApplicationShutdown,
} from '@nestjs/common';
import { randomInt } from 'node:crypto';
import { and, eq, gt } from 'drizzle-orm';
import type { Valkey } from 'iovalkey';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { reportAlert } from '../../observability/error-tracking.js';
import { VALKEY } from '../../valkey/valkey.module.js';
import { SettingsService } from '../settings/index.js';
import {
  BLOCKING_COMMAND_TIMEOUT_MS,
  decodeSendPayload,
  ready,
  safeJson,
  SEND_DEADLINE_MARGIN_MS,
  SEND_ANSWERS_CHANNEL,
  SEND_REQUESTS_KEY,
  type SendAnswer,
  type SendRequest,
  sendRequestSchema,
} from './code-send-queue.js';
import type { SendResult } from './code-sender.js';
import { codeMessage, replyMessage } from './otp-messages.js';
import { type DayCounts, OtpSenderNumbers, type SenderNumber } from './otp-sender-numbers.js';
import {
  canSend,
  CONNECTED_SECONDS,
  CONNECTED_STATUSES,
  connectedKey,
  dailyCap,
  type SenderStatus,
  senderDay,
  shouldThrottle,
  THROTTLE_WINDOW,
  warmup,
} from './otp-sender-pool.js';
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
// How often the sender looks at the pool again: lost connections, pairings,
// the owner's changes, throttles and warm-ups that end.
export const SUPERVISE_INTERVAL_MS = 10_000;
// §8.3.3 item 9: a chat gets the fixed reply once in this time.
const REPLIED_SECONDS = 30 * 24 * 60 * 60;
// How long the request loop blocks on the list, so a stop is quick.
const POLL_SECONDS = 1;
// The sent messages a connection remembers for their receipts.
const REMEMBERED_MESSAGES = 5_000;

type Receipt = 'sent' | 'delivered' | 'read';

interface Connection {
  number: SenderNumber;
  client: WhatsAppClient;
  open: boolean;
  // Pacing (§8.3.3 item 7): the sends of the last minute and when the next
  // may start, after the jitter.
  sentAt: number[];
  nextFreeAt: number;
  // The last sends' outcomes, for the throttle (item 12).
  outcomes: boolean[];
  messages: Map<string, Receipt>;
}

interface Candidate {
  connection: Connection;
  freeAt: number;
}

// The otp-sender process (architecture §4.4, §8.3.3): the pool of sending
// numbers, one WhatsApp session each, the API's send requests, the
// on-WhatsApp check, the fixed message, the one reply to incoming messages,
// pacing, warm-up, health counts, the throttle and the alerts. Requests are
// taken one at a time; the Valkey list is the short queue that absorbs peaks.
@Injectable()
export class OtpSenderService implements OnApplicationBootstrap, OnApplicationShutdown {
  private readonly logger = new Logger(OtpSenderService.name);
  private readonly numbers: OtpSenderNumbers;
  private readonly connections = new Map<string, Connection>();
  private supervising: Promise<void> | null = null;
  private superviseTimer: NodeJS.Timeout | undefined;
  private requestLoop: Promise<void> | undefined;
  private blocking: Valkey | undefined;
  private stopped = false;
  // Whether a number could send at the last supervision; null before it.
  private couldSend: boolean | null = null;

  constructor(
    @Inject(DATABASE) private readonly database: Database,
    @Inject(VALKEY) private readonly valkey: Valkey,
    @Inject(IDENTITY_SECRETS) private readonly secrets: IdentitySecrets,
    @Inject(WHATSAPP_CONNECT) private readonly connect: WhatsAppConnect,
    private readonly settings: SettingsService,
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
    const connections = [...this.connections.values()];
    this.connections.clear();
    await Promise.all(connections.map((connection) => connection.client.close()));
  }

  // The numbers connected now, for the tests and the logs.
  connectedNumbers(): string[] {
    return [...this.connections.values()]
      .filter((connection) => connection.open)
      .map((connection) => connection.number.id);
  }

  // Brings the connections in line with the pool. One run at a time.
  supervise(now?: Date): Promise<void> {
    this.supervising ??= this.superviseOnce(now ?? new Date())
      .catch((error: unknown) => this.logger.error({ err: error }, 'otp sender supervision failed'))
      .finally(() => {
        this.supervising = null;
      });
    return this.supervising;
  }

  private async superviseOnce(now: Date): Promise<void> {
    if (this.stopped) return;
    await this.numbers.endThrottles(now);
    const [caps, stepDays] = await Promise.all([
      this.settings.get('otp.sender_warmup_caps'),
      this.settings.get('otp.sender_warmup_step_days'),
    ]);
    let pool = await this.numbers.pool();
    const warmed = pool
      .filter(
        (number) =>
          number.status === 'warming' &&
          number.warmupStartedAt &&
          !warmup(number.warmupStartedAt, now, caps, stepDays),
      )
      .map((number) => number.id);
    if (warmed.length > 0) {
      await this.numbers.endWarmup(warmed);
      this.logger.log({ numbers: warmed }, 'otp sender warm-up over');
      pool = await this.numbers.pool();
    }
    const wanted = new Map(
      pool
        .filter((number) => (CONNECTED_STATUSES as readonly SenderStatus[]).includes(number.status))
        .map((number) => [number.id, number]),
    );
    for (const [id, connection] of this.connections) {
      if (wanted.has(id)) continue;
      this.connections.delete(id);
      await this.valkey.del(connectedKey(id)).catch(() => undefined);
      await connection.client.close();
    }
    for (const number of wanted.values()) {
      if (this.stopped) return;
      if (this.connections.has(number.id)) continue;
      // One number that fails to connect never keeps the others from it.
      await this.open(number).catch((error: unknown) =>
        this.logger.error({ err: error, number: number.id }, 'otp sender number not connected'),
      );
    }
    await this.markConnected();
    await this.watchCanSend(now);
  }

  private async open(number: SenderNumber): Promise<void> {
    const connection: Connection = {
      number: { id: number.id, phone: number.phone },
      client: undefined as never,
      open: false,
      sentAt: [],
      nextFreeAt: 0,
      outcomes: [],
      messages: new Map(),
    };
    connection.client = await this.connect(this.numbers.session(number.id), {
      qr: () => {
        // A stored session never asks for a QR code; this one is no longer
        // valid, and only the pairing command can pair the number again.
        this.whenLost(connection, 'logged_out');
      },
      open: () => {
        connection.open = true;
        this.logger.log({ number: number.id }, 'otp sender connected');
        void this.markConnected();
      },
      closed: (reason) => this.whenLost(connection, reason),
      incoming: (chat) => void this.answerIncoming(connection, chat),
      receipt: (messageId, status) => void this.receipt(connection, messageId, status),
    });
    this.connections.set(number.id, connection);
  }

  // The API's read knows which numbers can send.
  private async markConnected(): Promise<void> {
    const open = this.connectedNumbers();
    if (open.length === 0) return;
    const marks = this.valkey.multi();
    for (const id of open) marks.set(connectedKey(id), '1', 'EX', CONNECTED_SECONDS);
    await marks.exec().catch((error: unknown) => {
      this.logger.warn({ err: error }, 'otp sender connections not marked');
    });
  }

  // §8.3.3 item 14: «لا يمكن إرسال رموز الدخول» once no number can send.
  private async watchCanSend(now: Date): Promise<void> {
    const able = (await this.sendable(now)).length > 0;
    if (!able && this.couldSend !== false) {
      this.logger.error('otp sender: no number can send sign-in codes');
      reportAlert('لا يمكن إرسال رموز الدخول: no sending number can send', 'fatal');
    }
    this.couldSend = able;
  }

  private whenLost(connection: Connection, reason: WhatsAppClosedReason): void {
    this.lost(connection, reason).catch((error: unknown) =>
      this.logger.error({ err: error }, 'otp sender number not marked stopped'),
    );
  }

  private async lost(connection: Connection, reason: WhatsAppClosedReason): Promise<void> {
    connection.open = false;
    const id = connection.number.id;
    if (this.connections.get(id) !== connection) return;
    this.connections.delete(id);
    await this.valkey.del(connectedKey(id)).catch(() => undefined);
    if (reason === 'lost') {
      this.logger.warn({ number: id }, 'otp sender connection lost; reconnecting');
      return;
    }
    await connection.client.close();
    const status = reason === 'banned' ? 'banned' : 'disconnected';
    if (await this.numbers.stop(id, status, new Date())) this.alertStopped(id, status);
  }

  // §8.3.3 item 14: «رقم إرسال الرموز متوقف».
  private alertStopped(numberId: string, status: 'disconnected' | 'throttled' | 'banned'): void {
    this.logger.error({ number: numberId, status }, 'otp sender number stopped');
    reportAlert(`رقم إرسال الرموز متوقف: a sending number is ${status}`, 'warning');
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

  // Answers one request. One with less than the margin left is dropped
  // unsent: the API answers unavailable and rolls its code back.
  async answer(request: SendRequest, now = new Date()): Promise<SendResult | null> {
    const latest = request.deadline - SEND_DEADLINE_MARGIN_MS;
    if (latest <= now.getTime()) return null;
    const { phone, code } = decodeSendPayload(this.secrets, request);
    const result = await this.deliver(phone, code, now, latest);
    const answer: SendAnswer = { id: request.id, result };
    await this.valkey.publish(SEND_ANSWERS_CHANNEL, JSON.stringify(answer));
    return result;
  }

  // §8.3.3 items 7, 11: the next number that can send before the deadline,
  // and failover to the next one when a send fails.
  private async deliver(
    phone: string,
    code: string,
    now: Date,
    latest: number,
  ): Promise<SendResult> {
    const tried = new Set<string>();
    for (;;) {
      const candidate = await this.pick(now, latest, tried);
      if (!candidate) return 'unavailable';
      const { connection } = candidate;
      tried.add(connection.number.id);
      const wait = candidate.freeAt - Date.now();
      if (wait > 0) await pause(wait);
      if (!connection.open) continue;
      let onWhatsApp: boolean;
      try {
        onWhatsApp = await this.onWhatsApp(connection.client, phone, now);
      } catch (error) {
        this.logger.warn(
          { err: error, number: connection.number.id },
          'otp on-WhatsApp check failed',
        );
        continue;
      }
      if (!onWhatsApp) return 'not_on_whatsapp';
      // The check may take a while; the code must still be valid on arrival.
      if (Date.now() >= latest) return 'unavailable';
      if (await this.send(connection, phone, code)) return 'sent';
    }
  }

  // Active numbers first, then warming ones (owner decision 2026-11-06);
  // within them the one free soonest, then the one used longest ago, so the
  // numbers take turns.
  private async pick(now: Date, latest: number, tried: Set<string>): Promise<Candidate | null> {
    const [perMinute, sendable] = await Promise.all([
      this.settings.get('otp.sender_per_minute_max'),
      this.sendable(now),
    ]);
    const candidates = sendable
      .filter(({ connection }) => !tried.has(connection.number.id))
      .map(({ connection, status }) => {
        const minuteAgo = Date.now() - 60_000;
        connection.sentAt = connection.sentAt.filter((at) => at > minuteAgo);
        const minuteFree =
          connection.sentAt.length >= perMinute
            ? (connection.sentAt[connection.sentAt.length - perMinute] ?? 0) + 60_000
            : 0;
        return {
          connection,
          tier: status === 'active' ? 0 : 1,
          freeAt: Math.max(connection.nextFreeAt, minuteFree),
          lastSent: connection.sentAt.at(-1) ?? 0,
        };
      })
      .filter((candidate) => candidate.freeAt < latest)
      .sort((a, b) => a.tier - b.tier || a.freeAt - b.freeAt || a.lastSent - b.lastSent);
    return candidates[0] ?? null;
  }

  // The connected numbers in a sending state and under their daily cap.
  private async sendable(
    now: Date,
  ): Promise<{ connection: Connection; status: SenderStatus; counts: DayCounts }[]> {
    const [rows, dailyMax, caps, stepDays] = await Promise.all([
      this.numbers.sending(senderDay(now)),
      this.settings.get('otp.sender_daily_max'),
      this.settings.get('otp.sender_warmup_caps'),
      this.settings.get('otp.sender_warmup_step_days'),
    ]);
    return rows.flatMap((row) => {
      const connection = this.connections.get(row.id);
      if (!connection) return [];
      const warming =
        row.status === 'warming' && row.warmupStartedAt
          ? warmup(row.warmupStartedAt, now, caps, stepDays)
          : null;
      const health = {
        id: row.id,
        status: row.status,
        connected: connection.open,
        attemptedToday: row.counts.sent + row.counts.failed,
        dailyCap: dailyCap(warming, dailyMax),
      };
      return canSend(health) ? [{ connection, status: row.status, counts: row.counts }] : [];
    });
  }

  // One send from one number, counted for the caps and the health signals.
  private async send(connection: Connection, phone: string, code: string): Promise<boolean> {
    const id = connection.number.id;
    const jitter = await this.settings.get('otp.send_jitter_sec');
    const startedAt = Date.now();
    connection.sentAt.push(startedAt);
    connection.nextFreeAt = startedAt + randomInt(jitter.min * 1000, jitter.max * 1000 + 1);
    const day = senderDay(new Date());
    let sent: boolean;
    try {
      const messageId = await connection.client.sendText(phone, codeMessage(code));
      if (messageId) this.remember(connection, messageId);
      sent = true;
    } catch (error) {
      this.logger.error({ err: error, number: id }, 'otp code not sent');
      sent = false;
    }
    await this.numbers
      .count(id, day, sent ? { sent: 1 } : { failed: 1 })
      .catch((error: unknown) => this.logger.error({ err: error }, 'otp send not counted'));
    connection.outcomes = [...connection.outcomes, sent].slice(-THROTTLE_WINDOW);
    if (!sent && shouldThrottle(connection.outcomes)) {
      connection.outcomes = [];
      const throttled = await this.numbers.throttle(id, new Date()).catch((error: unknown) => {
        this.logger.error({ err: error }, 'otp sender number not throttled');
        return false;
      });
      if (throttled) this.alertStopped(id, 'throttled');
    }
    return sent;
  }

  private remember(connection: Connection, messageId: string): void {
    connection.messages.set(messageId, 'sent');
    if (connection.messages.size > REMEMBERED_MESSAGES) {
      const oldest = connection.messages.keys().next().value;
      if (oldest !== undefined) connection.messages.delete(oldest);
    }
  }

  // §8.3.3 item 12: delivered and read, once per message; a read without a
  // delivery receipt counts as both.
  private async receipt(
    connection: Connection,
    messageId: string,
    status: 'delivered' | 'read',
  ): Promise<void> {
    const before = connection.messages.get(messageId);
    if (!before || before === 'read' || (before === 'delivered' && status === 'delivered')) return;
    const counts: Partial<DayCounts> = {};
    if (before === 'sent') counts.delivered = 1;
    if (status === 'read') {
      counts.read = 1;
      connection.messages.delete(messageId);
    } else {
      connection.messages.set(messageId, 'delivered');
    }
    await this.numbers
      .count(connection.number.id, senderDay(new Date()), counts)
      .catch((error: unknown) => this.logger.warn({ err: error }, 'otp receipt not counted'));
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

  // §8.3.3 item 9: one fixed reply per chat. The mark lives in Valkey, by the
  // chat's keyed hash (an address may be a phone number), so losing it costs
  // one more reply at most; a reply that fails leaves no mark.
  private async answerIncoming(connection: Connection, chat: string): Promise<void> {
    if (!connection.open) return;
    const key = `identity:otp:replied:${this.secrets.phoneHash(chat)}`;
    try {
      const first = await this.valkey.set(key, '1', 'EX', REPLIED_SECONDS, 'NX');
      if (first !== 'OK') return;
      try {
        await connection.client.reply(chat, replyMessage(process.env.SUPPORT_WHATSAPP_NUMBER));
      } catch (error) {
        await this.valkey.del(key);
        throw error;
      }
    } catch (error) {
      this.logger.warn({ err: error }, 'otp sender reply not sent');
    }
  }
}

function pause(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
