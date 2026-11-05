import {
  createCipheriv,
  createDecipheriv,
  createHash,
  createHmac,
  hkdfSync,
  randomBytes,
  randomInt,
} from 'node:crypto';
import { hash, verify } from '@node-rs/argon2';

// The injection token of the module's IdentitySecrets.
export const IDENTITY_SECRETS = Symbol('IDENTITY_SECRETS');

const KEY_BYTES = 32;
const ENCRYPTED_PREFIX = 'v1';

// Architecture §15.3: phone numbers and TOTP secrets are encrypted in the
// application, phones with a keyed hash to find them by. Each use has its own
// key, derived from IDENTITY_ENCRYPTION_KEY.
export class IdentitySecrets {
  private readonly encryptionKey: Buffer;
  private readonly phoneKey: Buffer;
  private readonly backupCodeKey: Buffer;
  private readonly signInCodeKey: Buffer;

  constructor(masterKey: Buffer) {
    if (masterKey.length !== KEY_BYTES) {
      throw new Error(`IDENTITY_ENCRYPTION_KEY must be ${KEY_BYTES} bytes in base64`);
    }
    const derive = (info: string) =>
      Buffer.from(hkdfSync('sha256', masterKey, Buffer.alloc(0), info, KEY_BYTES));
    this.encryptionKey = derive('fox-drop identity encryption');
    this.phoneKey = derive('fox-drop identity phone hash');
    this.backupCodeKey = derive('fox-drop identity backup code hash');
    this.signInCodeKey = derive('fox-drop identity sign-in code hash');
  }

  // AES-256-GCM, as v1.<iv>.<tag>.<ciphertext> in base64url.
  encrypt(plain: string): string {
    const iv = randomBytes(12);
    const cipher = createCipheriv('aes-256-gcm', this.encryptionKey, iv);
    const ciphertext = Buffer.concat([cipher.update(plain, 'utf8'), cipher.final()]);
    return [ENCRYPTED_PREFIX, iv, cipher.getAuthTag(), ciphertext]
      .map((part) => (typeof part === 'string' ? part : part.toString('base64url')))
      .join('.');
  }

  decrypt(encrypted: string): string {
    const [prefix, iv, tag, ciphertext] = encrypted.split('.');
    if (prefix !== ENCRYPTED_PREFIX || !iv || !tag || ciphertext === undefined) {
      throw new Error('not an identity ciphertext');
    }
    const decipher = createDecipheriv(
      'aes-256-gcm',
      this.encryptionKey,
      Buffer.from(iv, 'base64url'),
    );
    decipher.setAuthTag(Buffer.from(tag, 'base64url'));
    return Buffer.concat([
      decipher.update(Buffer.from(ciphertext, 'base64url')),
      decipher.final(),
    ]).toString('utf8');
  }

  // Takes an E.164 phone from normalizePhone.
  phoneHash(phone: string): string {
    return createHmac('sha256', this.phoneKey).update(phone).digest('hex');
  }

  // An app sign-in code (architecture §8.3.2), bound to its E.164 number. Keyed,
  // so the stored hashes of a million possible codes cannot be reversed.
  signInCodeHash(phone: string, code: string): string {
    return createHmac('sha256', this.signInCodeKey).update(`${phone}:${code}`).digest('hex');
  }

  // Takes a code from normalizeBackupCode.
  backupCodeHash(code: string): string {
    return createHmac('sha256', this.backupCodeKey).update(code).digest('hex');
  }
}

export function identitySecretsFromEnvironment(): IdentitySecrets {
  const key = process.env.IDENTITY_ENCRYPTION_KEY;
  if (!key) throw new Error('IDENTITY_ENCRYPTION_KEY is not set');
  return new IdentitySecrets(Buffer.from(key, 'base64'));
}

// A setup link or session token: 256 random bits. Only its hash is stored.
export function newToken(): string {
  return randomBytes(32).toString('base64url');
}

export function tokenHash(token: string): string {
  return createHash('sha256').update(token).digest('hex');
}

// Architecture §10.3: Argon2id with the OWASP minimum (19 MiB, two passes).
const ARGON2_OPTIONS = { memoryCost: 19_456, timeCost: 2, parallelism: 1 };

export function hashPassword(password: string): Promise<string> {
  return hash(password, ARGON2_OPTIONS);
}

export function verifyPassword(passwordHash: string, password: string): Promise<boolean> {
  return verify(passwordHash, password);
}

// Checked when no account matches, so an unknown sign-in name takes as long
// as a wrong password.
let unknownAccountHash: Promise<string> | undefined;

export async function verifyNoPassword(password: string): Promise<false> {
  unknownAccountHash ??= hash(randomBytes(16).toString('hex'), ARGON2_OPTIONS);
  await verify(await unknownAccountHash, password);
  return false;
}

// Architecture §8.3.2: 6 digits from a cryptographic random generator.
export function newSignInCode(): string {
  return randomInt(1_000_000).toString().padStart(6, '0');
}

// Backup codes: ten characters without look-alikes (50 bits), shown as
// XXXXX-XXXXX.
const BACKUP_CODE_ALPHABET = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
export const BACKUP_CODE_COUNT = 10;

export function newBackupCode(): string {
  const characters = Array.from(
    { length: 10 },
    () => BACKUP_CODE_ALPHABET[randomInt(BACKUP_CODE_ALPHABET.length)],
  );
  return `${characters.slice(0, 5).join('')}-${characters.slice(5).join('')}`;
}

export function normalizeBackupCode(code: string): string {
  return code.toUpperCase().replace(/[\s-]/g, '');
}
