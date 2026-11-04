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
  return { logger: pino(loggerOptions('info'), stream), lines };
}

describe('structured logs', () => {
  it('are JSON lines', () => {
    const { logger, lines } = capture();

    logger.info({ orderId: 'abc' }, 'order placed');

    expect(JSON.parse(lines[0] ?? '')).toMatchObject({ orderId: 'abc', msg: 'order placed' });
  });

  it('never contain codes or tokens, at any depth', () => {
    const { logger, lines } = capture();

    logger.info({
      code: '482913',
      body: { otp: '482913', refresh_token: 'r-secret', nested: [{ accessToken: 'a-secret' }] },
      headers: { authorization: 'Bearer a-secret', cookie: 'sid=s-secret' },
    });

    const line = lines[0] ?? '';
    expect(line).not.toMatch(/482913|r-secret|a-secret|s-secret/);
    expect(JSON.parse(line)).toMatchObject({ code: REDACTED, body: { otp: REDACTED } });
  });

  it('never contain full phone numbers, in fields or in messages', () => {
    const { logger, lines } = capture();

    logger.info({ phone: '+963912345678' }, 'code sent to +963912345678 and 0912345678');

    const line = lines[0] ?? '';
    expect(line).not.toMatch(/963912345678|0912345678/);
    expect(JSON.parse(line)).toMatchObject({
      phone: '***78',
      msg: 'code sent to ***78 and ***78',
    });
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
