// The WhatsApp library behind the otp-sender process (architecture §8.3.1):
// nothing outside whatsapp-baileys.ts knows which library it is, so another
// library or the official Cloud API can replace it without touching the
// sender. Phones are E.164 (`+9639…`).

// A number's session, kept by the caller (encrypted in PostgreSQL,
// §8.3.3 item 10). Values are the library's own JSON; null removes a key.
export interface WhatsAppSessionStore {
  read(key: string): Promise<string | null>;
  write(entries: Record<string, string | null>): Promise<void>;
}

export type WhatsAppClosedReason =
  // WhatsApp ended the session (the phone unlinked the device): only a new
  // pairing brings the number back.
  | 'logged_out'
  // WhatsApp refused the number (403): a ban.
  | 'banned'
  // Anything else: the client reconnects on its own.
  | 'lost';

export interface WhatsAppEvents {
  // A QR code to scan while the number is not paired yet.
  qr(code: string): void;
  // Connected as this number.
  open(phone: string): void;
  closed(reason: WhatsAppClosedReason): void;
  // Someone wrote to the number. The chat is the library's opaque address,
  // for reply().
  incoming(chat: string): void;
  // WhatsApp's receipt for a message sendText sent, by its id
  // (architecture §8.3.3 item 12).
  receipt(messageId: string, status: 'delivered' | 'read'): void;
}

export interface WhatsAppClient {
  isOnWhatsApp(phone: string): Promise<boolean>;
  // The sent message's id, for its receipts.
  sendText(phone: string, text: string): Promise<string | null>;
  reply(chat: string, text: string): Promise<void>;
  close(): Promise<void>;
}

export type WhatsAppConnect = (
  session: WhatsAppSessionStore,
  events: WhatsAppEvents,
) => Promise<WhatsAppClient>;

// The injection token of the process's WhatsAppConnect.
export const WHATSAPP_CONNECT = Symbol('WHATSAPP_CONNECT');
