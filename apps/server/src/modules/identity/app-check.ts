import { Logger } from '@nestjs/common';
import { createRemoteJWKSet, errors, type JWTVerifyGetKey, jwtVerify } from 'jose';

// The injection token of the module's AppCheckVerifier.
export const APP_CHECK_VERIFIER = Symbol('APP_CHECK_VERIFIER');

// Architecture §8.3.3 item 1: a code request carries a Firebase App Check
// token in this header (Firebase's own name), which Play Integrity on Android
// and App Attest on iOS stand behind.
export const APP_CHECK_HEADER = 'X-Firebase-AppCheck';

// Firebase's public keys for App Check tokens. Firebase asks servers to keep
// them no longer than 6 hours.
const FIREBASE_JWKS_URL = 'https://firebaseappcheck.googleapis.com/v1/jwks';
const JWKS_CACHE_MS = 6 * 60 * 60 * 1000;

// The errors of a token itself: refused without a log. Any other error means
// Firebase's keys could not be read (a timeout, a non-200 answer, a bad key
// set or no network).
const TOKEN_ERRORS = [
  errors.JWSInvalid,
  errors.JWTInvalid,
  errors.JWSSignatureVerificationFailed,
  errors.JWTClaimValidationFailed,
  errors.JWTExpired,
  errors.JOSEAlgNotAllowed,
  errors.JOSENotSupported,
  errors.JWKSNoMatchingKey,
  errors.JWKSMultipleMatchingKeys,
];

// Longer than any token Firebase issues; a longer header is refused unread.
export const APP_CHECK_TOKEN_MAX_LENGTH = 4096;

export interface AppCheckVerifier {
  // True only for a token Firebase signed for this project that is still valid.
  verify(token: string | undefined, now: Date): Promise<boolean>;
}

// Verifies a token as Firebase documents it, with no service-account secret
// (owner decision 2026-11-07): RS256, signed by one of Firebase's public keys,
// issued by App Check for this project number, with the project in its
// audience and not expired. Without a project number every token is refused,
// so turning `otp.app_check_required` on before configuring the server stops
// codes instead of letting scripts through.
export class FirebaseAppCheckVerifier implements AppCheckVerifier {
  private readonly logger = new Logger('AppCheck');

  constructor(
    private readonly projectNumber: string | null,
    private readonly keys: JWTVerifyGetKey = createRemoteJWKSet(new URL(FIREBASE_JWKS_URL), {
      cacheMaxAge: JWKS_CACHE_MS,
    }),
  ) {}

  async verify(token: string | undefined, now: Date): Promise<boolean> {
    if (!token || token.length > APP_CHECK_TOKEN_MAX_LENGTH) return false;
    if (!this.projectNumber) {
      this.logger.error('App Check is required but FIREBASE_PROJECT_NUMBER is not set');
      return false;
    }
    try {
      const { payload } = await jwtVerify(token, this.keys, {
        algorithms: ['RS256'],
        typ: 'JWT',
        issuer: `https://firebaseappcheck.googleapis.com/${this.projectNumber}`,
        audience: `projects/${this.projectNumber}`,
        currentDate: now,
      });
      // The subject is the Firebase app the token was issued to.
      return typeof payload.sub === 'string' && payload.sub.length > 0;
    } catch (error) {
      if (TOKEN_ERRORS.some((type) => error instanceof type)) return false;
      // Firebase's keys could not be read, such as Google being unreachable:
      // the request is refused, and OWN can turn the setting off.
      this.logger.warn(`App Check keys unavailable: ${String(error)}`);
      return false;
    }
  }
}

// FIREBASE_PROJECT_NUMBER: the Firebase project's number (not a secret), all
// digits. A project ID such as fox-drop would never match a token, so it
// counts as unset and is logged.
export function appCheckVerifierFromEnvironment(): AppCheckVerifier {
  const value = process.env.FIREBASE_PROJECT_NUMBER;
  if (value && !/^\d+$/.test(value)) {
    new Logger('AppCheck').error('FIREBASE_PROJECT_NUMBER must be the project number, all digits');
  }
  return new FirebaseAppCheckVerifier(value && /^\d+$/.test(value) ? value : null);
}
