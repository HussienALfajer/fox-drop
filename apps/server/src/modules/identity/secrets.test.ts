import { randomBytes } from 'node:crypto';
import { describe, expect, it } from 'vitest';
import {
  hashPassword,
  IdentitySecrets,
  newBackupCode,
  normalizeBackupCode,
  tokenHash,
  verifyNoPassword,
  verifyPassword,
} from './secrets.js';
import { normalizePhone, parseSignInName } from './sign-in-name.js';

const secrets = new IdentitySecrets(randomBytes(32));

describe('encryption (architecture §15.3)', () => {
  it('reads back what it encrypted, never in clear', () => {
    const encrypted = secrets.encrypt('+963944123456');
    expect(encrypted).not.toContain('944123456');
    expect(secrets.decrypt(encrypted)).toBe('+963944123456');
  });

  it('encrypts one value differently each time', () => {
    expect(secrets.encrypt('JBSWY3DPEHPK3PXP')).not.toBe(secrets.encrypt('JBSWY3DPEHPK3PXP'));
  });

  it('refuses a changed ciphertext', () => {
    const [prefix, iv, tag, ciphertext] = secrets.encrypt('secret').split('.');
    const changed = Buffer.from(ciphertext ?? '', 'base64url');
    changed[0] = (changed[0] ?? 0) ^ 1;
    expect(() =>
      secrets.decrypt([prefix, iv, tag, changed.toString('base64url')].join('.')),
    ).toThrow();
  });

  it('refuses another key', () => {
    const other = new IdentitySecrets(randomBytes(32));
    expect(() => other.decrypt(secrets.encrypt('secret'))).toThrow();
  });

  it('refuses a key that is not 32 bytes', () => {
    expect(() => new IdentitySecrets(randomBytes(16))).toThrow(/32 bytes/);
  });

  it('hashes one phone the same way each time, with a key', () => {
    expect(secrets.phoneHash('+963944123456')).toBe(secrets.phoneHash('+963944123456'));
    expect(new IdentitySecrets(randomBytes(32)).phoneHash('+963944123456')).not.toBe(
      secrets.phoneHash('+963944123456'),
    );
  });
});

describe('passwords (architecture §10.3)', () => {
  it('hashes with Argon2id and checks the password', async () => {
    const hash = await hashPassword('correct horse battery');
    expect(hash).toMatch(/^\$argon2id\$/);
    expect(await verifyPassword(hash, 'correct horse battery')).toBe(true);
    expect(await verifyPassword(hash, 'correct horse battery!')).toBe(false);
  });

  it('refuses any password for an unknown account', async () => {
    expect(await verifyNoPassword('anything')).toBe(false);
  });
});

describe('tokens and backup codes', () => {
  it('stores a token as its SHA-256', () => {
    expect(tokenHash('abc')).toBe(
      'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad',
    );
  });

  it('makes backup codes of ten characters without look-alikes', () => {
    const codes = Array.from({ length: 50 }, newBackupCode);
    for (const code of codes) expect(code).toMatch(/^[A-HJ-NP-Z2-9]{5}-[A-HJ-NP-Z2-9]{5}$/);
    expect(new Set(codes).size).toBe(codes.length);
  });

  it('reads a backup code typed without the dash or in lower case', () => {
    expect(normalizeBackupCode('abcde fghjk')).toBe('ABCDEFGHJK');
    expect(normalizeBackupCode('ABCDE-FGHJK')).toBe('ABCDEFGHJK');
  });
});

describe('sign-in names (AP §5.1 item 1)', () => {
  it('takes an email in any case', () => {
    expect(parseSignInName(' Owner@Example.COM ')).toEqual({ email: 'owner@example.com' });
  });

  it.each([
    ['+963 944 123 456', '+963944123456'],
    ['00963-944-123456', '+963944123456'],
    ['+90 (532) 123 45 67', '+905321234567'],
  ])('takes the international phone %s', (input, phone) => {
    expect(parseSignInName(input)).toEqual({ phone });
  });

  it.each(['0944123456', '+0123456789', '12', 'not an email@'])('refuses %s', (input) => {
    expect(parseSignInName(input)).toBeNull();
  });

  it('never guesses a country', () => {
    expect(normalizePhone('0944123456')).toBeNull();
  });
});
