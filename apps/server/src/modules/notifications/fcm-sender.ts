import { Logger } from '@nestjs/common';
import { importPKCS8, SignJWT } from 'jose';
import { reportError } from '../../observability/error-tracking.js';
import { z } from 'zod';

// Architecture §8.1: Firebase Cloud Messaging's HTTP v1 API, authorised by a
// service account of the environment's Firebase project. The account comes
// from FCM_SERVICE_ACCOUNT (its JSON key, in base64), a secret of the server
// only (E7): never in the repository or an app.

const TOKEN_URL = 'https://oauth2.googleapis.com/token';
const SCOPE = 'https://www.googleapis.com/auth/firebase.messaging';
const CALL_TIMEOUT_MS = 5_000;
// An access token lasts an hour; a new one is asked this long before.
const RENEW_BEFORE_MS = 5 * 60_000;

const serviceAccountSchema = z.object({
  project_id: z.string().min(1),
  client_email: z.string().min(1),
  private_key: z.string().min(1),
});

export type ServiceAccount = z.infer<typeof serviceAccountSchema>;

// The service account, or null while push is off. A value that does not
// parse throws, so a broken secret fails loudly at start.
export function serviceAccountFromEnvironment(
  environment: NodeJS.ProcessEnv = process.env,
): ServiceAccount | null {
  const encoded = environment.FCM_SERVICE_ACCOUNT?.trim();
  if (!encoded) return null;
  let json: unknown;
  try {
    json = JSON.parse(Buffer.from(encoded, 'base64').toString('utf8'));
  } catch {
    throw new Error('FCM_SERVICE_ACCOUNT is not a base64 JSON key');
  }
  const parsed = serviceAccountSchema.safeParse(json);
  if (!parsed.success)
    throw new Error('FCM_SERVICE_ACCOUNT lacks project_id, client_email or private_key');
  return parsed.data;
}

// One push to one device.
export interface PushMessage {
  token: string;
  title: string;
  body: string;
  // The Android channel the app created for the sound level (architecture §8.2).
  channel: string;
  priority: 'high' | 'normal';
  // What the app opens on a tap, as strings (FCM's data values are strings).
  data: Record<string, string>;
  // How long FCM keeps it for a phone that is off.
  ttlSeconds: number;
}

// sent; invalid: the token is no longer registered (the device forgets it);
// failed: this message will not go through, try nothing again; retry: a
// passing failure (FCM busy, out of reach).
export type PushResult = 'sent' | 'invalid' | 'failed' | 'retry';

export interface PushSender {
  send(message: PushMessage): Promise<PushResult>;
}

export const PUSH_SENDER = Symbol('PUSH_SENDER');

const errorSchema = z.object({
  error: z.object({
    status: z.string().optional(),
    details: z.array(z.looseObject({ errorCode: z.string().optional() })).optional(),
  }),
});

export class FcmSender implements PushSender {
  private readonly logger = new Logger('FcmSender');
  private accessToken: { value: string; renewAt: number } | undefined;
  // Whether the failure to sign in was reported: once per outage (a revoked
  // key, the API turned off), not at every push.
  private signInFailing = false;

  constructor(
    private readonly account: ServiceAccount,
    private readonly fetcher: typeof fetch = fetch,
  ) {}

  async send(message: PushMessage): Promise<PushResult> {
    let token: string;
    try {
      token = await this.token();
      this.signInFailing = false;
    } catch (error) {
      if (!this.signInFailing) {
        this.signInFailing = true;
        this.logger.error({ err: error }, 'Google refused the push service account');
        reportError(error);
      }
      return 'retry';
    }
    let answer: Response;
    try {
      answer = await this.fetcher(
        `https://fcm.googleapis.com/v1/projects/${this.account.project_id}/messages:send`,
        {
          method: 'POST',
          headers: { authorization: `Bearer ${token}`, 'content-type': 'application/json' },
          body: JSON.stringify({ message: fcmMessage(message) }),
          signal: AbortSignal.timeout(CALL_TIMEOUT_MS),
        },
      );
    } catch {
      return 'retry';
    }
    if (answer.ok) return 'sent';
    if (answer.status === 401) this.accessToken = undefined;
    const parsed = errorSchema.safeParse(await answer.json().catch(() => null));
    const codes = new Set(
      parsed.success
        ? [
            parsed.data.error.status,
            ...(parsed.data.error.details ?? []).map((detail) => detail.errorCode),
          ]
        : [],
    );
    // INVALID_ARGUMENT: the message is fixed and tested, so it is the token
    // that is malformed.
    if (
      codes.has('UNREGISTERED') ||
      codes.has('SENDER_ID_MISMATCH') ||
      codes.has('INVALID_ARGUMENT')
    ) {
      return 'invalid';
    }
    if (answer.status === 401 || answer.status === 429 || answer.status >= 500) return 'retry';
    return 'failed';
  }

  private async token(): Promise<string> {
    if (this.accessToken && Date.now() < this.accessToken.renewAt) return this.accessToken.value;
    const now = Math.floor(Date.now() / 1000);
    const assertion = await new SignJWT({ scope: SCOPE })
      .setProtectedHeader({ alg: 'RS256', typ: 'JWT' })
      .setIssuer(this.account.client_email)
      .setSubject(this.account.client_email)
      .setAudience(TOKEN_URL)
      .setIssuedAt(now)
      .setExpirationTime(now + 3600)
      .sign(await importPKCS8(this.account.private_key, 'RS256'));
    const answer = await this.fetcher(TOKEN_URL, {
      method: 'POST',
      headers: { 'content-type': 'application/x-www-form-urlencoded' },
      body: new URLSearchParams({
        grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
        assertion,
      }).toString(),
      signal: AbortSignal.timeout(CALL_TIMEOUT_MS),
    });
    if (!answer.ok) throw new Error(`Google refused the service account (${answer.status})`);
    const { access_token: value, expires_in: seconds } = z
      .object({ access_token: z.string(), expires_in: z.number() })
      .parse(await answer.json());
    this.accessToken = { value, renewAt: Date.now() + seconds * 1000 - RENEW_BEFORE_MS };
    return value;
  }
}

// FCM's message: a notification Android shows on the app's channel while the
// app cannot (architecture §8.2), and the data the app reads on a tap.
export function fcmMessage(message: PushMessage) {
  return {
    token: message.token,
    notification: { title: message.title, body: message.body },
    data: message.data,
    android: {
      priority: message.priority === 'high' ? 'HIGH' : 'NORMAL',
      ttl: `${message.ttlSeconds}s`,
      notification: { channel_id: message.channel },
    },
  };
}

// The worker's sender, or null while push is off. Production never runs
// without it: customers, restaurants and captains rely on push when their
// app cannot run (architecture §8.1).
export function pushSenderFromEnvironment(environment = process.env): PushSender | null {
  const account = serviceAccountFromEnvironment(environment);
  if (account) return new FcmSender(account);
  if (environment.FOX_DROP_ENVIRONMENT === 'production') {
    throw new Error('push needs FCM_SERVICE_ACCOUNT in production');
  }
  return null;
}
