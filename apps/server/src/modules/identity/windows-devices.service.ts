import { createPublicKey, randomInt, verify } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { and, eq, gt, isNull } from 'drizzle-orm';
import { Valkey } from 'iovalkey';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { VALKEY } from '../../valkey/valkey.module.js';
import { type AuditRequestContext, AuditService } from '../audit/index.js';
import { MerchantsService } from '../merchants/index.js';
import type { MerchantAccount } from './merchant-accounts.service.js';
import { HOUR_MS, RequestLimits } from './request-limits.js';
import { windowsDevices, windowsPairings } from './schema.js';
import { IDENTITY_SECRETS, IdentitySecrets } from './secrets.js';

// How long an owner's pairing code works (fixed, decided by us).
export const PAIRING_CODE_MINUTES = 10;

// The registrations one IP address may try per hour, so the 10^8 codes
// cannot be guessed (fixed, decided by us).
export const PAIRING_ATTEMPTS_PER_HOUR = 10;

// How far a code request's signing time may be from the server's clock.
export const DEVICE_SIGNATURE_WINDOW_MS = 5 * 60 * 1000;

const ED25519_KEY_BYTES = 32;
const ED25519_SIGNATURE_BYTES = 64;

// The pairing codes one restaurant may make per hour (fixed, decided by us):
// each registers a PC that passes the code request's attestation.
export const PAIRING_CODES_PER_HOUR = 10;

// What a registered Windows PC signs for a code request: its installation,
// the number in E.164 and the moment, in ISO 8601 (`signedAt`). The app signs
// the same text (`apps/merchant/lib/src/windows/registration.dart`).
export function codeRequestMessage(deviceId: string, phone: string, signedAt: string): string {
  return `fox-drop/merchant-code-request\n${deviceId}\n${phone}\n${signedAt}`;
}

export interface DeviceSignature {
  signedAt: string;
  // Base64 of the 64-byte Ed25519 signature of codeRequestMessage.
  signature: string;
}

// invalid_code: no open code matches (wrong, expired or used); too_many:
// the IP address's attempts (or the restaurant's codes) of the hour are
// spent (retryAfterSec); other_restaurant: the installation is registered to
// another restaurant, which never moves it.
export class WindowsPairingRefusedError extends Error {
  constructor(
    readonly refusal:
      'invalid_code' | 'too_many' | 'invalid_key' | 'restaurant_terminated' | 'other_restaurant',
    readonly retryAfterSec = 0,
  ) {
    super(`windows pairing refused: ${refusal}`);
  }
}

// RA §4.3, architecture §8.3.3 item 1 (slice 2.44; owner decision
// 2026-11-20): the restaurant app on Windows has no App Check, so an owner
// registers each PC with a one-time code; the PC keeps an Ed25519 key and
// signs its code requests with it, which ends Windows' exemption.
@Injectable()
export class WindowsDevicesService {
  private readonly limits: RequestLimits;

  constructor(
    @Inject(DATABASE) private readonly database: Database,
    @Inject(VALKEY) valkey: Valkey,
    @Inject(IDENTITY_SECRETS) private readonly secrets: IdentitySecrets,
    private readonly merchants: MerchantsService,
    private readonly audit: AuditService,
  ) {
    this.limits = new RequestLimits(valkey);
  }

  // A new 8-digit code for the owner's restaurant, shown once. Earlier codes
  // stay open until they expire.
  async pair(
    owner: MerchantAccount,
    context: AuditRequestContext,
    now = new Date(),
  ): Promise<{ code: string; expiresAt: Date }> {
    const restaurant = await this.merchants.restaurant(owner.restaurantId);
    if (!restaurant) throw new Error('an owner without a restaurant');
    const made = await this.limits.reserve(
      [
        {
          key: `identity:windows-pairing:restaurant:${owner.restaurantId}`,
          windowMs: HOUR_MS,
          max: PAIRING_CODES_PER_HOUR,
        },
      ],
      now,
    );
    if (!made.reserved) throw new WindowsPairingRefusedError('too_many', made.retryAfterSec);
    const expiresAt = new Date(now.getTime() + PAIRING_CODE_MINUTES * 60 * 1000);
    return this.database.db.transaction(async (tx) => {
      // A code another restaurant's open code already has is drawn again.
      for (;;) {
        const code = String(randomInt(0, 100_000_000)).padStart(8, '0');
        const codeHash = this.secrets.pairingCodeHash(code);
        const [open] = await tx
          .select({ id: windowsPairings.id })
          .from(windowsPairings)
          .where(
            and(
              eq(windowsPairings.codeHash, codeHash),
              isNull(windowsPairings.usedAt),
              gt(windowsPairings.expiresAt, now),
            ),
          );
        if (open) continue;
        const [created] = await tx
          .insert(windowsPairings)
          .values({
            cityId: restaurant.cityId,
            restaurantId: owner.restaurantId,
            createdBy: owner.id,
            codeHash,
            createdAt: now,
            expiresAt,
          })
          .returning({ id: windowsPairings.id });
        if (!created) throw new Error('the pairing code was not created');
        await this.audit.recordWrite(
          {
            actor: { type: 'merchant', id: owner.id, role: owner.role },
            context,
            cityId: restaurant.cityId,
            action: 'merchant_device.windows_pairing',
            target: { type: 'restaurant', id: owner.restaurantId },
            before: null,
            after: { expiresAt: expiresAt.toISOString() },
          },
          tx,
        );
        return { code, expiresAt };
      }
    });
  }

  // Uses the code up and keeps the PC's public key; the same installation
  // paired again gets the new key.
  async register(
    input: { code: string; deviceId: string; publicKey: string },
    context: AuditRequestContext,
    now = new Date(),
  ): Promise<{ restaurantId: string }> {
    const attempt = await this.limits.reserve(
      [
        {
          key: `identity:windows-pairing:ip:${context.ipAddress ?? 'unknown'}`,
          windowMs: HOUR_MS,
          max: PAIRING_ATTEMPTS_PER_HOUR,
        },
      ],
      now,
    );
    if (!attempt.reserved) {
      throw new WindowsPairingRefusedError('too_many', attempt.retryAfterSec);
    }
    if (Buffer.from(input.publicKey, 'base64').length !== ED25519_KEY_BYTES) {
      throw new WindowsPairingRefusedError('invalid_key');
    }
    const codeHash = this.secrets.pairingCodeHash(input.code);
    return this.database.db.transaction(async (tx) => {
      const [pairing] = await tx
        .select({
          id: windowsPairings.id,
          cityId: windowsPairings.cityId,
          restaurantId: windowsPairings.restaurantId,
          createdBy: windowsPairings.createdBy,
        })
        .from(windowsPairings)
        .where(
          and(
            eq(windowsPairings.codeHash, codeHash),
            isNull(windowsPairings.usedAt),
            gt(windowsPairings.expiresAt, now),
          ),
        )
        .for('update');
      if (!pairing) throw new WindowsPairingRefusedError('invalid_code');
      if ((await this.merchants.lockedAccountStatus(tx, pairing.restaurantId)) === 'terminated') {
        throw new WindowsPairingRefusedError('restaurant_terminated');
      }
      // A PC is paired again only to its own restaurant: one owner never
      // replaces another restaurant's key.
      const [existing] = await tx
        .select({ restaurantId: windowsDevices.restaurantId })
        .from(windowsDevices)
        .where(eq(windowsDevices.deviceId, input.deviceId))
        .for('update');
      if (existing && existing.restaurantId !== pairing.restaurantId) {
        throw new WindowsPairingRefusedError('other_restaurant');
      }
      await tx
        .update(windowsPairings)
        .set({ usedAt: now })
        .where(eq(windowsPairings.id, pairing.id));
      const registration = {
        cityId: pairing.cityId,
        restaurantId: pairing.restaurantId,
        publicKey: input.publicKey,
        pairingId: pairing.id,
        registeredAt: now,
      };
      if (existing) {
        await tx
          .update(windowsDevices)
          .set(registration)
          .where(eq(windowsDevices.deviceId, input.deviceId));
      } else {
        await tx.insert(windowsDevices).values({ deviceId: input.deviceId, ...registration });
      }
      // AP §4.6: the owner whose code it was is the actor; never the key or
      // the code.
      await this.audit.recordWrite(
        {
          actor: { type: 'merchant', id: pairing.createdBy, role: 'owner' },
          context,
          cityId: pairing.cityId,
          action: 'merchant_device.windows_register',
          target: { type: 'restaurant', id: pairing.restaurantId },
          before: null,
          after: { deviceId: input.deviceId, pairingId: pairing.id, again: Boolean(existing) },
        },
        tx,
      );
      return { restaurantId: pairing.restaurantId };
    });
  }

  // True for a signature of codeRequestMessage by this registered PC's key,
  // signed within DEVICE_SIGNATURE_WINDOW_MS of now. A signature can be
  // replayed within that window, as an App Check token within its hour; the
  // code request's limits still apply.
  async verify(
    deviceId: string,
    phone: string,
    signature: DeviceSignature | undefined,
    now: Date,
  ): Promise<boolean> {
    if (!signature) return false;
    const signedAt = Date.parse(signature.signedAt);
    if (Number.isNaN(signedAt) || Math.abs(now.getTime() - signedAt) > DEVICE_SIGNATURE_WINDOW_MS) {
      return false;
    }
    const bytes = Buffer.from(signature.signature, 'base64');
    if (bytes.length !== ED25519_SIGNATURE_BYTES) return false;
    const [device] = await this.database.db
      .select({ publicKey: windowsDevices.publicKey })
      .from(windowsDevices)
      .where(eq(windowsDevices.deviceId, deviceId));
    if (!device) return false;
    const key = createPublicKey({
      key: {
        kty: 'OKP',
        crv: 'Ed25519',
        x: Buffer.from(device.publicKey, 'base64').toString('base64url'),
      },
      format: 'jwk',
    });
    return verify(
      null,
      Buffer.from(codeRequestMessage(deviceId, phone, signature.signedAt)),
      key,
      bytes,
    );
  }
}
