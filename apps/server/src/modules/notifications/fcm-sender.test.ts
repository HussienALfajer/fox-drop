import { generateKeyPairSync } from 'node:crypto';
import { decodeJwt } from 'jose';
import { describe, expect, it } from 'vitest';
import { FcmSender, type PushMessage, serviceAccountFromEnvironment } from './fcm-sender.js';

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
        token: 'device-token',
        notification: { title: 'FOX DROP', body: message.body },
        data: { type: 'order', orderId: 'order-1' },
        android: { priority: 'HIGH', ttl: '600s', notification: { channel_id: 'default' } },
      },
    });
  });

  it('tells an unregistered token from a passing failure and a refused message', async () => {
    const answers = [
      error(404, 'UNREGISTERED'),
      error(503, 'UNAVAILABLE'),
      error(400, 'INVALID_ARGUMENT'),
    ];
    const { fetcher } = fakeFetch((call) =>
      call.url.includes('oauth2') ? tokenAnswer() : answers.shift()!,
    );
    const sender = new FcmSender(account, fetcher);
    expect(await sender.send(message)).toBe('invalid');
    expect(await sender.send(message)).toBe('retry');
    expect(await sender.send(message)).toBe('failed');
  });

  it('retries when Google cannot be reached', async () => {
    const fetcher = (async () => {
      throw new TypeError('fetch failed');
    }) as typeof fetch;
    expect(await new FcmSender(account, fetcher).send(message)).toBe('retry');
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
