import { describe, expect, it } from 'vitest';
import { memorySession } from './otp-sender-numbers.js';
import {
  closedReason,
  keyStore,
  orderedSession,
  receiptOf,
  writtenChat,
} from './whatsapp-baileys.js';
import type { WhatsAppSessionStore } from './whatsapp-client.js';

// The Baileys adapter's own logic (architecture §8.3.1, §8.3.3 items 9–10),
// without a connection to WhatsApp.
describe('the session key store', () => {
  it('keeps binary keys through a round trip, and removes a key set to null', async () => {
    const session = memorySession();
    const store = keyStore(session);
    const keyPair = { public: Buffer.from([1, 2, 3]), private: Buffer.from([4, 5, 6]) };
    await store.set({ 'pre-key': { '1': keyPair, '2': keyPair } });
    expect([...session.entries.keys()]).toEqual(['pre-key:1', 'pre-key:2']);
    expect(session.entries.get('pre-key:1')).not.toContain('[1,2,3]');

    const found = await store.get('pre-key', ['1', '3']);
    expect(Object.keys(found)).toEqual(['1']);
    expect(Buffer.from(found['1']?.public ?? [])).toEqual(keyPair.public);
    expect(Buffer.isBuffer(found['1']?.private)).toBe(true);

    await store.set({ 'pre-key': { '2': null } });
    expect(session.entries.get('pre-key:2')).toBeNull();
    expect(await store.get('pre-key', ['2'])).toEqual({});
  });

  it('revives app state sync keys as the library expects', async () => {
    const store = keyStore(memorySession());
    await store.set({ 'app-state-sync-key': { a: { keyData: Buffer.from([9]) } } });
    const { a } = await store.get('app-state-sync-key', ['a']);
    expect(a?.constructor.name).toBe('AppStateSyncKeyData');
    expect(Buffer.from(a?.keyData ?? [])).toEqual(Buffer.from([9]));
  });
});

describe('the ordered session', () => {
  it('writes one after the other, and reads after the writes before it', async () => {
    const committed: string[] = [];
    let release: () => void = () => undefined;
    const slow: WhatsAppSessionStore = {
      read: (key) => Promise.resolve(committed.includes(key) ? key : null),
      write: async (entries) => {
        const [key] = Object.keys(entries);
        if (key === 'first') await new Promise<void>((resolve) => (release = resolve));
        committed.push(key ?? '');
      },
    };
    const session = orderedSession(slow);
    const first = session.write({ first: '1' });
    const second = session.write({ second: '2' });
    const read = session.read('second');
    await new Promise((resolve) => setTimeout(resolve, 20));
    expect(committed).toEqual([]);
    release();
    await Promise.all([first, second]);
    expect(committed).toEqual(['first', 'second']);
    expect(await read).toBe('second');
    await session.drained();
  });

  it('keeps going after a failed write, which fails for its caller', async () => {
    const written: string[] = [];
    const session = orderedSession({
      read: () => Promise.resolve(null),
      write: (entries) => {
        if ('bad' in entries) return Promise.reject(new Error('database down'));
        written.push(...Object.keys(entries));
        return Promise.resolve();
      },
    });
    await expect(session.write({ bad: '1' })).rejects.toThrow('database down');
    await session.write({ good: '1' });
    expect(written).toEqual(['good']);
  });
});

describe('a closed connection', () => {
  it.each([
    [401, 'logged_out'],
    [403, 'banned'],
    [408, 'lost'],
    [428, 'lost'],
    [440, 'lost'],
    [500, 'lost'],
    [515, 'lost'],
    [undefined, 'lost'],
  ])('with status %s is %s', (status, reason) => {
    expect(closedReason(status)).toBe(reason);
  });
});

describe('a message status update', () => {
  it.each([
    [true, 2, null],
    [true, 3, 'delivered'],
    [true, 4, 'read'],
    [true, 5, 'read'],
    [true, undefined, null],
    [false, 4, null],
  ])('from me %s with status %s is %s', (fromMe, status, receipt) => {
    expect(receiptOf(fromMe, status)).toBe(receipt);
  });
});

describe('a message to the number', () => {
  const message = (remoteJid: string, content: object, fromMe = false) => ({
    key: { remoteJid, fromMe, id: 'm1' },
    message: content,
  });

  it.each([
    ['a text in a person’s chat', message('963912345678@s.whatsapp.net', { conversation: 'hi' })],
    ['a text from a hidden number', message('123456789@lid', { conversation: 'hi' })],
    [
      'a photo that disappears',
      message('123456789@lid', { ephemeralMessage: { message: { imageMessage: {} } } }),
    ],
    ['a voice note', message('963912345678@s.whatsapp.net', { audioMessage: {} })],
  ])('is answered: %s', (_, written) => {
    expect(writtenChat(written)).toBe(written.key.remoteJid);
  });

  it.each([
    ['our own message', message('963912345678@s.whatsapp.net', { conversation: 'x' }, true)],
    ['a group', message('1203630@g.us', { conversation: 'hi' })],
    ['a status', message('status@broadcast', { conversation: 'hi' })],
    ['a channel', message('1203630@newsletter', { conversation: 'hi' })],
    ['WhatsApp itself', message('0@s.whatsapp.net', { conversation: 'hi' })],
    ['a reaction', message('123456789@lid', { reactionMessage: { text: '👍' } })],
    ['a deletion', message('123456789@lid', { protocolMessage: { type: 0 } })],
    ['no content', { key: { remoteJid: '123456789@lid', fromMe: false, id: 'm1' } }],
  ])('is not answered: %s', (_, other) => {
    expect(writtenChat(other)).toBeNull();
  });
});
