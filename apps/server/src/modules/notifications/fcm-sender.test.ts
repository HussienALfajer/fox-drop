import { generateKeyPairSync } from 'node:crypto';
import { decodeJwt } from 'jose';
import { describe, expect, it } from 'vitest';
import {
  criticalAlertsOn,
  FcmSender,
  fcmMessage,
  type PushMessage,
  serviceAccountFromEnvironment,
} from './fcm-sender.js';

// Architecture §8.1: FCM's HTTP v1 API with a service account's token, and
// what each of its answers means for the token and the message.
const { privateKey } = generateKeyPairSync('rsa', { modulusLength: 2048 });
const account = {
  project_id: 'foxdrop-test',
  client_email: 'push@foxdrop-test.iam.gserviceaccount.com',
  private_key: privateKey.export({ type: 'pkcs8', format: 'pem' }).toString(),
};

const message: PushMessage = {
  token: 'device-token',
  title: 'FOX DROP',
  body: 'المطعم يحضّر طلبك. يصل حوالي 9:45',
  channel: 'default',
  priority: 'high',
  data: { type: 'order', orderId: 'order-1' },
  ttlSeconds: 600,
  interruption: 'active',
};

interface Call {
  url: string;
  body: string;
  authorization: string | null;
}

function fakeFetch(answers: (call: Call) => Response) {
  const calls: Call[] = [];
  const fetcher = (async (url: string | URL, init?: RequestInit) => {
    const call = {
      url: String(url),
      body: String(init?.body),
      authorization: new Headers(init?.headers).get('authorization'),
    };
    calls.push(call);
    return answers(call);
  }) as typeof fetch;
  return { fetcher, calls };
}

const tokenAnswer = () =>
  Response.json({ access_token: 'access-1', expires_in: 3600, token_type: 'Bearer' });

const error = (status: number, code: string) =>
  Response.json(
    {
      error: {
        status: code,
        details: [
          { '@type': 'type.googleapis.com/google.firebase.fcm.v1.FcmError', errorCode: code },
        ],
      },
    },
    { status },
  );

describe('FCM (architecture §8.1)', () => {
  it("signs in with the service account once and sends the app's channel and priority", async () => {
    const { fetcher, calls } = fakeFetch((call) =>
      call.url.includes('oauth2')
        ? tokenAnswer()
        : Response.json({ name: 'projects/x/messages/1' }),
    );
    const sender = new FcmSender(account, fetcher);
    expect(await sender.send(message)).toBe('sent');
    expect(await sender.send(message)).toBe('sent');
    expect(calls.map((call) => call.url)).toEqual([
      'https://oauth2.googleapis.com/token',
      'https://fcm.googleapis.com/v1/projects/foxdrop-test/messages:send',
      'https://fcm.googleapis.com/v1/projects/foxdrop-test/messages:send',
    ]);
    const assertion = decodeJwt(new URLSearchParams(calls[0]!.body).get('assertion')!);
    expect(assertion).toMatchObject({
      iss: account.client_email,
      aud: 'https://oauth2.googleapis.com/token',
      scope: 'https://www.googleapis.com/auth/firebase.messaging',
    });
    expect(calls[1]!.authorization).toBe('Bearer access-1');
    expect(JSON.parse(calls[1]!.body)).toEqual({
      message: {
        fid: 'device-token',
        notification: { title: 'FOX DROP', body: message.body },
        data: { type: 'order', orderId: 'order-1' },
        android: { priority: 'HIGH', ttl: '600s', notification: { channel_id: 'default' } },
        apns: {
          headers: {
            'apns-priority': '10',
            'apns-push-type': 'alert',
            'apns-expiration': expect.stringMatching(/^\d+$/),
          },
          payload: { aps: { sound: 'default', 'interruption-level': 'active' } },
        },
      },
    });
  });

  it('tells an unregistered token from a passing failure and a refused message', async () => {
    const answers = [
      error(404, 'UNREGISTERED'),
      error(503, 'UNAVAILABLE'),
      Response.json(
        {
          error: {
            status: 'INVALID_ARGUMENT',
            details: [
              {
                '@type': 'type.googleapis.com/google.rpc.BadRequest',
                fieldViolations: [{ field: 'message.fid', description: 'Invalid FID' }],
              },
            ],
          },
        },
        { status: 400 },
      ),
      error(400, 'INVALID_ARGUMENT'),
    ];
    const { fetcher } = fakeFetch((call) =>
      call.url.includes('oauth2') ? tokenAnswer() : answers.shift()!,
    );
    const sender = new FcmSender(account, fetcher);
    expect(await sender.send(message)).toBe('invalid');
    expect(await sender.send(message)).toBe('retry');
    // A malformed FID (FCM's INVALID_ARGUMENT on the target) is forgotten too.
    expect(await sender.send(message)).toBe('invalid');
    // Any other INVALID_ARGUMENT refuses the message, not the device.
    expect(await sender.send(message)).toBe('failed');
  });

  it('retries when Google cannot be reached', async () => {
    const fetcher = (async () => {
      throw new TypeError('fetch failed');
    }) as typeof fetch;
    expect(await new FcmSender(account, fetcher).send(message)).toBe('retry');
  });

  // Architecture §8.1, §14.2, CA §4.4 (K15), CU §4.4 (slice 2.46): FCM
  // hands the apns part to APNs for an iPhone.
  it('gives APNs the priority, the expiry, the bundled sound and the interruption level', () => {
    const now = Date.UTC(2026, 10, 20, 12, 0, 0);
    const offer = fcmMessage(
      { ...message, channel: 'ring_offer', interruption: 'time-sensitive', ttlSeconds: 45 },
      now,
    );
    expect(offer.apns).toEqual({
      headers: {
        'apns-priority': '10',
        'apns-push-type': 'alert',
        'apns-expiration': String(now / 1000 + 45),
      },
      payload: { aps: { sound: 'fd_offer_30s.wav', 'interruption-level': 'time-sensitive' } },
    });
    const critical = fcmMessage(
      { ...message, channel: 'ring_offer', interruption: 'critical' },
      now,
    );
    expect(critical.apns.payload.aps).toEqual({
      sound: { critical: 1, name: 'fd_offer_30s.wav', volume: 1 },
      'interruption-level': 'critical',
    });
    const sounds = Object.fromEntries(
      ['chime', 'cancellation', 'ring', 'default'].map((channel) => [
        channel,
        fcmMessage({ ...message, channel }, now).apns.payload.aps.sound,
      ]),
    );
    expect(sounds).toEqual({
      chime: 'fd_chime.wav',
      cancellation: 'fd_cancellation.wav',
      ring: 'default',
      default: 'default',
    });
    const silent = fcmMessage(
      { ...message, channel: 'silent', priority: 'normal', interruption: 'passive' },
      now,
    );
    expect(silent.apns.headers['apns-priority']).toBe('5');
    expect(silent.apns.payload.aps).toEqual({ 'interruption-level': 'passive' });
  });

  it('sends critical alerts only once the environment says Apple granted them', () => {
    expect(criticalAlertsOn({})).toBe(false);
    expect(criticalAlertsOn({ APNS_CRITICAL_ALERTS: 'false' })).toBe(false);
    expect(criticalAlertsOn({ APNS_CRITICAL_ALERTS: 'true' })).toBe(true);
  });

  it('reads the service account from the environment, or none', () => {
    expect(serviceAccountFromEnvironment({})).toBeNull();
    const encoded = Buffer.from(JSON.stringify({ ...account, type: 'service_account' })).toString(
      'base64',
    );
    expect(serviceAccountFromEnvironment({ FCM_SERVICE_ACCOUNT: encoded })).toEqual(account);
    expect(() => serviceAccountFromEnvironment({ FCM_SERVICE_ACCOUNT: 'not json' })).toThrow();
  });
});
