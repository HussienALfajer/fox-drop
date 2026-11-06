import { Logger } from '@nestjs/common';
import {
  Browsers,
  BufferJSON,
  DisconnectReason,
  getContentType,
  initAuthCreds,
  isJidBroadcast,
  isJidGroup,
  isJidNewsletter,
  isLidUser,
  isPnUser,
  makeCacheableSignalKeyStore,
  makeWASocket,
  normalizeMessageContent,
  proto,
  type SignalDataSet,
  type SignalDataTypeMap,
  type SignalKeyStore,
  type WAMessage,
} from 'baileys';
import type {
  WhatsAppClosedReason,
  WhatsAppConnect,
  WhatsAppSessionStore,
} from './whatsapp-client.js';

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

export function keyStore(session: WhatsAppSessionStore): SignalKeyStore {
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

// Writes run one after the other, in the library's order, and a read waits
// for the writes before it: two upserts of one key on two pool connections
// could otherwise commit out of order. drained() waits for the last write.
export function orderedSession(
  session: WhatsAppSessionStore,
): WhatsAppSessionStore & { drained(): Promise<void> } {
  let writes: Promise<void> = Promise.resolve();
  return {
    read: async (key) => {
      await writes;
      return session.read(key);
    },
    write: (entries) => {
      const next = writes.then(() => session.write(entries));
      writes = next.catch(() => undefined);
      return next;
    },
    drained: () => writes,
  };
}

// A session WhatsApp ended (401, the device unlinked) or refused (403, a ban)
// only comes back with a new pairing; anything else reconnects.
export function closedReason(statusCode: number | undefined): WhatsAppClosedReason {
  return statusCode === DisconnectReason.loggedOut || statusCode === DisconnectReason.forbidden
    ? 'logged_out'
    : 'lost';
}

// The kinds of message a person writes, as opposed to receipts, reactions,
// edits, deletions and the other protocol messages.
const WRITTEN = new Set([
  'conversation',
  'extendedTextMessage',
  'imageMessage',
  'videoMessage',
  'audioMessage',
  'documentMessage',
  'stickerMessage',
  'contactMessage',
  'contactsArrayMessage',
  'locationMessage',
  'liveLocationMessage',
]);

// The chat to answer when a person wrote to the number in their own chat,
// never a group, list, status, channel or WhatsApp's own account.
export function writtenChat(message: WAMessage): string | null {
  const chat = message.key.remoteJid;
  if (message.key.fromMe || !chat || chat === '0@s.whatsapp.net') return null;
  if (isJidGroup(chat) || isJidBroadcast(chat) || isJidNewsletter(chat)) return null;
  if (!isPnUser(chat) && !isLidUser(chat)) return null;
  const type = getContentType(normalizeMessageContent(message.message));
  return type && WRITTEN.has(type) ? chat : null;
}

export const baileysConnect: WhatsAppConnect = async (stored, events) => {
  const session = orderedSession(stored);
  const saved = await session.read('creds');
  const creds = saved === null ? initAuthCreds() : JSON.parse(saved, BufferJSON.reviver);
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
    session
      .write({ creds: JSON.stringify(creds, BufferJSON.replacer) })
      .catch((error: unknown) => logger.error({ err: error }, 'whatsapp session not saved'));
  });
  socket.ev.on('connection.update', ({ connection, lastDisconnect, qr }) => {
    if (qr) events.qr(qr);
    if (connection === 'open' && socket.user) events.open(phoneOf(socket.user.id));
    if (connection === 'close') {
      const error = lastDisconnect?.error as { output?: { statusCode?: number } } | undefined;
      events.closed(closedReason(error?.output?.statusCode));
    }
  });
  socket.ev.on('messages.upsert', ({ messages, type }) => {
    if (type !== 'notify') return;
    for (const message of messages) {
      const chat = writtenChat(message);
      if (chat) events.incoming(chat);
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
    // Waits for the session's last write, so a stop never loses it.
    close: async () => {
      await socket.end(undefined);
      await session.drained();
    },
  };
};
