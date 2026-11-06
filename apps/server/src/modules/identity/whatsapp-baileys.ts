import { Logger } from '@nestjs/common';
import {
  Browsers,
  BufferJSON,
  DisconnectReason,
  initAuthCreds,
  isJidBroadcast,
  isJidGroup,
  isJidNewsletter,
  isLidUser,
  isPnUser,
  makeCacheableSignalKeyStore,
  makeWASocket,
  proto,
  type SignalDataSet,
  type SignalDataTypeMap,
  type SignalKeyStore,
} from 'baileys';
import type { WhatsAppConnect, WhatsAppSessionStore } from './whatsapp-client.js';

// The WhatsApp library of architecture §8.3.1: Baileys (owner decision
// 2026-11-06), the multi-device protocol without a browser. This file is the
// only one that imports it.

function jidOf(phone: string): string {
  return `${phone.replace(/\D/g, '')}@s.whatsapp.net`;
}

// "963912345678:12@s.whatsapp.net" is +963912345678.
function phoneOf(jid: string): string {
  return `+${jid.split('@')[0]?.split(':')[0] ?? ''}`;
}

type ILogger = NonNullable<Parameters<typeof makeWASocket>[0]['logger']>;

// The library's logs reach the process logger at warn and above, through
// its redaction (src/logging/redact.ts).
function libraryLogger(): ILogger {
  const logger = new Logger('WhatsApp');
  const quiet = () => undefined;
  const library: ILogger = {
    level: 'warn',
    child: () => library,
    trace: quiet,
    debug: quiet,
    info: quiet,
    warn: (object: unknown, message?: string) =>
      logger.warn({ library: object }, message ?? 'whatsapp library'),
    error: (object: unknown, message?: string) =>
      logger.error({ library: object }, message ?? 'whatsapp library'),
  };
  return library;
}

function keyStore(session: WhatsAppSessionStore): SignalKeyStore {
  return {
    get: async <T extends keyof SignalDataTypeMap>(type: T, ids: string[]) => {
      const found: Record<string, SignalDataTypeMap[T]> = {};
      for (const id of ids) {
        const stored = await session.read(`${type}:${id}`);
        if (stored === null) continue;
        const value: unknown = JSON.parse(stored, BufferJSON.reviver);
        found[id] = (
          type === 'app-state-sync-key'
            ? proto.Message.AppStateSyncKeyData.fromObject(value as object)
            : value
        ) as SignalDataTypeMap[T];
      }
      return found;
    },
    set: async (data: SignalDataSet) => {
      const entries: Record<string, string | null> = {};
      for (const [type, values] of Object.entries(data)) {
        for (const [id, value] of Object.entries(values ?? {})) {
          entries[`${type}:${id}`] = value ? JSON.stringify(value, BufferJSON.replacer) : null;
        }
      }
      await session.write(entries);
    },
  };
}

export const baileysConnect: WhatsAppConnect = async (session, events) => {
  const stored = await session.read('creds');
  const creds = stored === null ? initAuthCreds() : JSON.parse(stored, BufferJSON.reviver);
  const logger = libraryLogger();
  const socket = makeWASocket({
    auth: { creds, keys: makeCacheableSignalKeyStore(keyStore(session), logger) },
    logger,
    browser: Browsers.ubuntu('FOX DROP'),
    // A sending number never shows as online nor downloads its history.
    markOnlineOnConnect: false,
    syncFullHistory: false,
    shouldSyncHistoryMessage: () => false,
  });

  socket.ev.on('creds.update', () => {
    void session
      .write({ creds: JSON.stringify(creds, BufferJSON.replacer) })
      .catch((error: unknown) => logger.error({ err: error }, 'whatsapp session not saved'));
  });
  socket.ev.on('connection.update', ({ connection, lastDisconnect, qr }) => {
    if (qr) events.qr(qr);
    if (connection === 'open' && socket.user) events.open(phoneOf(socket.user.id));
    if (connection === 'close') {
      const status = (lastDisconnect?.error as { output?: { statusCode?: number } } | undefined)
        ?.output?.statusCode;
      events.closed(status === DisconnectReason.loggedOut ? 'logged_out' : 'lost');
    }
  });
  socket.ev.on('messages.upsert', ({ messages, type }) => {
    if (type !== 'notify') return;
    for (const message of messages) {
      const chat = message.key.remoteJid;
      if (message.key.fromMe || !message.message || !chat) continue;
      // A person's own chat only: never groups, lists, statuses or channels.
      if (isJidGroup(chat) || isJidBroadcast(chat) || isJidNewsletter(chat)) continue;
      if (isPnUser(chat) || isLidUser(chat)) events.incoming(chat);
    }
  });

  return {
    isOnWhatsApp: async (phone) => {
      const [result] = (await socket.onWhatsApp(jidOf(phone))) ?? [];
      return result?.exists === true;
    },
    sendText: async (phone, text) => {
      await socket.sendMessage(jidOf(phone), { text });
    },
    reply: async (chat, text) => {
      await socket.sendMessage(chat, { text });
    },
    close: () => {
      socket.end(undefined);
      return Promise.resolve();
    },
  };
};
