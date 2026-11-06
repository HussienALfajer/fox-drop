import { Injectable } from '@nestjs/common';
import { type AppParty, type AppSession, AppSessionsService } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { SESSION_ENDED as ENDED } from './realtime-publisher.js';
import type { ConnectionMeta } from './realtime-tokens.js';

// Whether a session may subscribe to the channel of this id.
export type ChannelCheck = (session: AppSession, id: string) => Promise<boolean>;

// The namespaces of architecture §6.2 served so far, and the app whose
// sessions subscribe to each.
const NAMESPACE_PARTY = { merchant: 'merchant', order: 'customer' } as const;
type Namespace = keyof typeof NAMESPACE_PARTY;

// What Centrifugo sends to the subscription proxy: user is the connection
// token's subject, the session.
export interface SubscribeRequest {
  user: string;
  channel: string;
  meta?: unknown;
}

// Centrifugo's answers: let it subscribe, refuse this channel (the client is
// told and does not retry), or end the connection of a session that ended
// (4500 to 4999 tell the client not to reconnect with it).
export type SubscribeAnswer =
  | { result: Record<string, never> }
  | { error: { code: number; message: string } }
  | { disconnect: { code: number; reason: string } };

const ALLOWED: SubscribeAnswer = { result: {} };
const REFUSED: SubscribeAnswer = { error: { code: 403, message: 'permission denied' } };
const SESSION_ENDED: SubscribeAnswer = { disconnect: ENDED };

const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/;

// Architecture §6.1: the API checks every subscription Centrifugo is asked
// for. The connection's session must still be open, as for a request, and the
// channel must be the session's own: a restaurant user's restaurant, a
// customer's order. A module that owns a channel's records registers its
// check (allow), since this module cannot read them (architecture §4.3).
@Injectable()
export class RealtimeAccess {
  private readonly checks = new Map<Namespace, ChannelCheck>([
    [
      'merchant',
      async (session, id) =>
        session.merchant?.restaurantId === id && !(await this.terminated(session)),
    ],
  ]);

  constructor(
    private readonly sessions: AppSessionsService,
    private readonly merchants: MerchantsService,
  ) {}

  // RA §5.5: a terminated restaurant's owners still sign in, to the money
  // section only, so they get no orders.
  async terminated(session: AppSession): Promise<boolean> {
    if (!session.merchant) return false;
    return (await this.merchants.accountStatus(session.merchant.restaurantId)) === 'terminated';
  }

  allow(namespace: 'order', check: ChannelCheck): void {
    this.checks.set(namespace, check);
  }

  async subscribe(
    party: AppParty,
    request: SubscribeRequest,
    now = new Date(),
  ): Promise<SubscribeAnswer> {
    const meta = request.meta as Partial<ConnectionMeta> | null | undefined;
    if (meta?.party !== party || typeof meta.accountId !== 'string') return REFUSED;
    const [namespace = '', id = '', ...rest] = request.channel.split(':');
    if (!Object.hasOwn(NAMESPACE_PARTY, namespace) || rest.length > 0 || !UUID.test(id)) {
      return REFUSED;
    }
    if (NAMESPACE_PARTY[namespace as Namespace] !== party) return REFUSED;
    if (!UUID.test(request.user) || !UUID.test(meta.accountId)) return REFUSED;
    const session = await this.sessions.openSession(party, meta.accountId, request.user, now);
    if (session === null || session === 'other_device') return SESSION_ENDED;
    const check = this.checks.get(namespace as Namespace);
    return check && (await check(session, id)) ? ALLOWED : REFUSED;
  }
}
