import { Writable } from 'node:stream';
import { pino } from 'pino';
import { describe, expect, it } from 'vitest';
import { loggerOptions, serializeRequest } from './logger-options.js';
import { REDACTED } from './redact.js';

function capture() {
  const lines: string[] = [];
  const stream = new Writable({
    write(chunk: Buffer, _encoding, done) {
      lines.push(chunk.toString());
      done();
    },
  });
  const logger = pino(loggerOptions('info'), stream);
  const line = () => lines.at(-1) ?? '';
  return { logger, line, json: () => JSON.parse(line()) as Record<string, unknown> };
}

const SECRETS =
  /482913|r-secret|a-secret|s-secret|f-secret|k-secret|t-secret|b-secret|963912345678|0912345678/;

describe('structured logs', () => {
  it('are JSON lines', () => {
    const { logger, json } = capture();

    logger.info({ orderId: 'abc' }, 'order placed');

    expect(json()).toMatchObject({ orderId: 'abc', msg: 'order placed' });
  });

  it('never contain codes or tokens, at any depth', () => {
    const { logger, line, json } = capture();

    logger.info({
      code: '482913',
      body: {
        otpCode: '482913',
        refresh_token: 'r-secret',
        nested: [{ fcmToken: 'f-secret' }],
        otpauthUri: 'otpauth://totp/x?secret=t-secret',
        backupCodes: ['b-secret'],
      },
      headers: {
        authorization: 'Bearer a-secret',
        cookie: 'sid=s-secret',
        'x-api-key': 'k-secret',
      },
    });

    expect(line()).not.toMatch(SECRETS);
    expect(json()).toMatchObject({ code: REDACTED, body: { otpCode: REDACTED } });
  });

  it('keep fields that only look like secrets', () => {
    const { logger, json } = capture();

    logger.info({ currencyCode: 'SYP', statusCode: 200 });

    expect(json()).toMatchObject({ currencyCode: 'SYP', statusCode: 200 });
  });

  it('never contain full phone numbers, in fields or in messages', () => {
    const { logger, line, json } = capture();

    logger.info({ phone: '+963912345678', mobile: 963912345678 }, 'code sent to 0912345678');

    expect(line()).not.toMatch(SECRETS);
    expect(json()).toMatchObject({ phone: '***78', mobile: '***78', msg: 'code sent to ***78' });
  });

  it.each([
    '+963912345678',
    '+963 912 345 678',
    '00963912345678',
    '963912345678',
    '0912345678',
    '0912-345-678',
    '963912345678@s.whatsapp.net',
    '+44 7700 900123',
  ])('mask the phone number %s', (phone) => {
    const { logger, json } = capture();

    logger.info(`sending to ${phone}`);

    expect(json().msg).toMatch(/^sending to \*\*\*\d\d$/);
  });

  it('redact errors: message, stack and their own fields', () => {
    const { logger, line, json } = capture();
    const error = Object.assign(new Error('no user for +963912345678'), {
      detail: 'Key (phone)=(+963912345678) already exists',
      params: { code: '482913' },
      code: 'ECONNREFUSED',
    });

    logger.error(error);

    expect(line()).not.toMatch(SECRETS);
    expect(json()).toMatchObject({ err: { code: 'ECONNREFUSED' } });
  });

  it('redact the fields of child loggers', () => {
    const { logger, line } = capture();

    logger.child({ phone: '+963912345678', token: 'a-secret' }).info('signed in');

    expect(line()).not.toMatch(SECRETS);
  });

  it('survive objects that refer to themselves', () => {
    const { logger, json } = capture();
    const order: Record<string, unknown> = { id: 'o-1' };
    order.self = order;

    logger.info({ order });

    expect(json()).toMatchObject({ order: { id: 'o-1' } });
  });

  it('log a request by its path only, without query or headers', () => {
    const request = {
      id: 'req-1',
      method: 'GET',
      url: '/v1/customer/orders?token=t-secret',
      headers: { authorization: 'Bearer a-secret' },
    };

    expect(serializeRequest(request)).toEqual({
      id: 'req-1',
      method: 'GET',
      path: '/v1/customer/orders',
    });
  });
});
