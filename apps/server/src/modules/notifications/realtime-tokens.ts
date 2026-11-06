import { Injectable } from '@nestjs/common';
import { SignJWT } from 'jose';
import type { AppSession } from '../identity/index.js';
import { realtimeConfigFromEnvironment } from './realtime-config.js';

// As long as an access token (architecture §15.1): the app asks for a new one
// when Centrifugo says it expired, so a session that ended stops receiving
// within this time even before the proxy refuses its next subscription.
export const CONNECTION_TOKEN_MINUTES = 15;

// What Centrifugo passes back to the subscription proxy (include_connection_
// meta), never shown to other clients.
export interface ConnectionMeta {
  party: AppSession['party'];
  sessionId: string;
}

// Architecture §6.1: the short-lived connection token of an app session,
// signed with the secret Centrifugo checks (CENTRIFUGO_TOKEN_SECRET, which
// never ships in an app, E7).
@Injectable()
export class RealtimeTokens {
  // Null while real time is off.
  async connectionToken(
    session: AppSession,
    now: Date,
  ): Promise<{ token: string; expiresAt: Date } | null> {
    const config = realtimeConfigFromEnvironment();
    if (!config) return null;
    const expiresAt = new Date(now.getTime() + CONNECTION_TOKEN_MINUTES * 60_000);
    const meta: ConnectionMeta = { party: session.party, sessionId: session.id };
    const token = await new SignJWT({ meta })
      .setProtectedHeader({ alg: 'HS256' })
      .setSubject(session.accountId)
      .setIssuedAt(Math.floor(now.getTime() / 1000))
      .setExpirationTime(Math.floor(expiresAt.getTime() / 1000))
      .sign(new TextEncoder().encode(config.tokenSecret));
    return { token, expiresAt };
  }
}
