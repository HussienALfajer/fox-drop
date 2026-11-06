import { createLocalJWKSet, exportJWK, generateKeyPair, type JWK, SignJWT } from 'jose';
import { beforeAll, describe, expect, it } from 'vitest';
import { FirebaseAppCheckVerifier } from './app-check.js';

// Architecture §8.3.3 item 1: the server verifies a Firebase App Check token
// against Firebase's public keys, here a fake key set of the same shape.
const PROJECT = '123456789012';
const now = new Date('2026-11-07T10:00:00Z');
const seconds = Math.floor(now.getTime() / 1000);

let firebaseKey: CryptoKey;
let otherKey: CryptoKey;
let verifier: FirebaseAppCheckVerifier;

beforeAll(async () => {
  const pair = await generateKeyPair('RS256', { extractable: true });
  firebaseKey = pair.privateKey;
  otherKey = (await generateKeyPair('RS256')).privateKey;
  const jwk: JWK = { ...(await exportJWK(pair.publicKey)), kid: 'firebase-1', alg: 'RS256' };
  verifier = new FirebaseAppCheckVerifier(PROJECT, createLocalJWKSet({ keys: [jwk] }));
});

interface TokenParts {
  key?: CryptoKey;
  kid?: string;
  issuer?: string;
  audience?: string[];
  subject?: string | null;
  expiresAt?: number;
  typ?: string;
}

function token(parts: TokenParts = {}): Promise<string> {
  const jwt = new SignJWT({})
    .setProtectedHeader({ alg: 'RS256', kid: parts.kid ?? 'firebase-1', typ: parts.typ ?? 'JWT' })
    .setIssuer(parts.issuer ?? `https://firebaseappcheck.googleapis.com/${PROJECT}`)
    .setAudience(parts.audience ?? [`projects/${PROJECT}`, 'projects/fox-drop'])
    .setIssuedAt(seconds - 60)
    .setExpirationTime(parts.expiresAt ?? seconds + 3600);
  if (parts.subject !== null) jwt.setSubject(parts.subject ?? '1:123456789012:android:abc');
  return jwt.sign(parts.key ?? firebaseKey);
}

describe('the App Check token (architecture §8.3.3 item 1)', () => {
  it('accepts a token Firebase signed for the project', async () => {
    expect(await verifier.verify(await token(), now)).toBe(true);
  });

  it('refuses a missing, empty or oversized token', async () => {
    expect(await verifier.verify(undefined, now)).toBe(false);
    expect(await verifier.verify('', now)).toBe(false);
    expect(await verifier.verify('a'.repeat(5000), now)).toBe(false);
    expect(await verifier.verify('not a token', now)).toBe(false);
  });

  it('refuses a token signed by another key', async () => {
    expect(await verifier.verify(await token({ key: otherKey }), now)).toBe(false);
    expect(await verifier.verify(await token({ key: otherKey, kid: 'unknown' }), now)).toBe(false);
  });

  it('refuses a token of another project or issuer', async () => {
    const otherIssuer = await token({ issuer: 'https://firebaseappcheck.googleapis.com/999' });
    expect(await verifier.verify(otherIssuer, now)).toBe(false);
    expect(await verifier.verify(await token({ audience: ['projects/999'] }), now)).toBe(false);
  });

  it('refuses an expired token, without a subject or of another type', async () => {
    expect(await verifier.verify(await token({ expiresAt: seconds - 1 }), now)).toBe(false);
    expect(await verifier.verify(await token({ subject: null }), now)).toBe(false);
    expect(await verifier.verify(await token({ typ: 'at+jwt' }), now)).toBe(false);
  });

  it('refuses every token while the project number is not set', async () => {
    const unconfigured = new FirebaseAppCheckVerifier(null, createLocalJWKSet({ keys: [] }));
    expect(await unconfigured.verify(await token(), now)).toBe(false);
  });

  it('refuses when Firebase keys cannot be read', async () => {
    const unreachable = new FirebaseAppCheckVerifier(PROJECT, () =>
      Promise.reject(new TypeError('fetch failed')),
    );
    expect(await unreachable.verify(await token(), now)).toBe(false);
  });
});
