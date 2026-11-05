import {
  createPrivateKey,
  createPublicKey,
  generateKeyPairSync,
  type KeyObject,
} from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { desc, eq, sql } from 'drizzle-orm';
import { errors, jwtVerify, SignJWT } from 'jose';
import { z } from 'zod';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { appSigningKeys } from './schema.js';
import { IDENTITY_SECRETS, IdentitySecrets } from './secrets.js';

// Architecture §15.1: app access tokens live 15 minutes. A new signing key
// every 30 days (owner decision 2026-11-05).
export const ACCESS_TOKEN_MINUTES = 15;
export const KEY_ROTATION_DAYS = 30;

const DAY_MS = 86_400_000;
const ISSUER = 'fox-drop';
const ALGORITHM = 'EdDSA';
const kid = z.uuid();

export interface AccessClaims {
  // The party's account, the session and the party (the token's audience).
  accountId: string;
  sessionId: string;
  party: string;
}

interface SigningKey {
  id: string;
  privateKey: KeyObject;
  createdAt: Date;
}

// Signs and verifies the apps' access tokens. Keys are rows, the private key
// encrypted with IdentitySecrets, so every API process signs with the same
// current key; each process keeps the keys it has read in memory.
@Injectable()
export class AppSigningKeys {
  private current: SigningKey | undefined;
  private readonly publicKeys = new Map<string, { key: KeyObject; createdAt: Date }>();

  constructor(
    @Inject(DATABASE) private readonly database: Database,
    @Inject(IDENTITY_SECRETS) private readonly secrets: IdentitySecrets,
  ) {}

  async sign(claims: AccessClaims, now: Date): Promise<{ token: string; expiresAt: Date }> {
    const key = await this.signingKey(now);
    const issuedAt = Math.floor(now.getTime() / 1000);
    const expiresAt = issuedAt + ACCESS_TOKEN_MINUTES * 60;
    const token = await new SignJWT({ sid: claims.sessionId })
      .setProtectedHeader({ alg: ALGORITHM, kid: key.id })
      .setIssuer(ISSUER)
      .setAudience(claims.party)
      .setSubject(claims.accountId)
      .setIssuedAt(issuedAt)
      .setExpirationTime(expiresAt)
      .sign(key.privateKey);
    return { token, expiresAt: new Date(expiresAt * 1000) };
  }

  // The claims of a token this party's app may use now, or null.
  async verify(token: string, party: string, now: Date): Promise<AccessClaims | null> {
    try {
      const { payload } = await jwtVerify(
        token,
        async (header) => {
          const key = await this.verificationKey(header.kid, now);
          if (!key) throw new errors.JWKSNoMatchingKey();
          return key;
        },
        { algorithms: [ALGORITHM], issuer: ISSUER, audience: party, currentDate: now },
      );
      if (typeof payload.sub !== 'string' || typeof payload.sid !== 'string') return null;
      return { accountId: payload.sub, sessionId: payload.sid, party };
    } catch (error) {
      if (error instanceof errors.JOSEError) return null;
      throw error;
    }
  }

  private isCurrent(createdAt: Date, now: Date): boolean {
    return now.getTime() < createdAt.getTime() + KEY_ROTATION_DAYS * DAY_MS;
  }

  // The newest key while it is younger than the rotation period; otherwise a
  // new one, created by one process at a time.
  private async signingKey(now: Date): Promise<SigningKey> {
    if (this.current && this.isCurrent(this.current.createdAt, now)) return this.current;
    this.current = await this.database.db.transaction(async (tx) => {
      await tx.execute(sql`SELECT pg_advisory_xact_lock(hashtext('identity.app_signing_keys'))`);
      const [newest] = await tx
        .select()
        .from(appSigningKeys)
        .orderBy(desc(appSigningKeys.createdAt))
        .limit(1);
      if (newest && this.isCurrent(newest.createdAt, now)) {
        return {
          id: newest.id,
          privateKey: createPrivateKey(this.secrets.decrypt(newest.privateKeyEncrypted)),
          createdAt: newest.createdAt,
        };
      }
      const pair = generateKeyPairSync('ed25519');
      const privatePem = pair.privateKey.export({ type: 'pkcs8', format: 'pem' }).toString();
      const publicPem = pair.publicKey.export({ type: 'spki', format: 'pem' }).toString();
      const [row] = await tx
        .insert(appSigningKeys)
        .values({
          privateKeyEncrypted: this.secrets.encrypt(privatePem),
          publicKey: publicPem,
          createdAt: now,
        })
        .returning({ id: appSigningKeys.id });
      if (!row) throw new Error('the signing key was not created');
      return { id: row.id, privateKey: pair.privateKey, createdAt: now };
    });
    return this.current;
  }

  // A key verifies until the last token it could have signed has expired.
  private async verificationKey(id: string | undefined, now: Date): Promise<KeyObject | null> {
    if (!kid.safeParse(id).success) return null;
    let known = this.publicKeys.get(id!);
    if (!known) {
      const [row] = await this.database.db
        .select({ publicKey: appSigningKeys.publicKey, createdAt: appSigningKeys.createdAt })
        .from(appSigningKeys)
        .where(eq(appSigningKeys.id, id!));
      if (!row) return null;
      known = { key: createPublicKey(row.publicKey), createdAt: row.createdAt };
      this.publicKeys.set(id!, known);
    }
    const retiredAt =
      known.createdAt.getTime() + KEY_ROTATION_DAYS * DAY_MS + ACCESS_TOKEN_MINUTES * 60_000;
    return now.getTime() <= retiredAt ? known.key : null;
  }
}
