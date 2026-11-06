import { Injectable, type OnModuleInit } from '@nestjs/common';
import { SignJWT } from 'jose';
import type { AppSession } from '../identity/index.js';
import { requireRealtime, tokenSecret } from './realtime-config.js';

// As long as an access token (architecture §15.1): the app asks for a new one
// when Centrifugo says it expired. A session that ends is disconnected at once
// (RealtimeSessions); one the API cannot see end, such as a restaurant
// terminated while its devices are connected, stops receiving within this time.
export const CONNECTION_TOKEN_MINUTES = 15;

// What Centrifugo passes back to the subscription proxy (include_connection_
// meta), never shown to other clients.
export interface ConnectionMeta {
  party: AppSession['party'];
  accountId: string;
}

// Architecture §6.1: the short-lived connection token of an app session,
// signed with the secret Centrifugo checks (CENTRIFUGO_TOKEN_SECRET, which
// never ships in an app, E7). Its subject is the session, so Centrifugo's
// user is one device's session and the API can disconnect exactly it.
@Injectable()
export class RealtimeTokens implements OnModuleInit {
  onModuleInit(): void {
    requireRealtime('tokens');
  }

  // Null while real time is off.
  async connectionToken(
    session: AppSession,
    now: Date,
  ): Promise<{ token: string; expiresAt: Date } | null> {
    const secret = tokenSecret();
    if (!secret) return null;
    const expiresAt = new Date(now.getTime() + CONNECTION_TOKEN_MINUTES * 60_000);
    const meta: ConnectionMeta = { party: session.party, accountId: session.accountId };
    const token = await new SignJWT({ meta })
      .setProtectedHeader({ alg: 'HS256' })
      .setSubject(session.id)
      .setIssuedAt(Math.floor(now.getTime() / 1000))
      .setExpirationTime(Math.floor(expiresAt.getTime() / 1000))
      .sign(new TextEncoder().encode(secret));
    return { token, expiresAt };
  }
}
