// Pairs a WhatsApp number for the sign-in codes (architecture §8.3.3 items 4,
// 10 and 13; the panel screen waits for the design). Prints a QR code to scan
// from the number's WhatsApp («الأجهزة المرتبطة» › «ربط جهاز»), then stores
// the session encrypted. Run with DATABASE_URL and IDENTITY_ENCRYPTION_KEY
// set, in a terminal:
//   node dist/modules/identity/otp-sender-pair-command.js
// The running otp-sender picks the new number up within 10 seconds.
import QRCode from 'qrcode';
import { createDatabase } from '../../database/database.js';
import { maskPhone } from '../../logging/redact.js';
import { memorySession, OtpSenderNumbers } from './otp-sender-numbers.js';
import { identitySecretsFromEnvironment } from './secrets.js';
import { baileysConnect } from './whatsapp-baileys.js';
import type { WhatsAppClient } from './whatsapp-client.js';

// Long enough to find the phone and scan a few codes.
const PAIRING_TIMEOUT_MS = 3 * 60_000;
// After WhatsApp opens the session, the library uploads its keys; wait for
// them before saving.
const SETTLE_MS = 10_000;

function fail(message: string): never {
  process.stderr.write(`${message}\n`);
  process.exit(1);
}

const databaseUrl = process.env.DATABASE_URL ?? fail('DATABASE_URL is not set');
const secrets = identitySecretsFromEnvironment();
const database = createDatabase(databaseUrl);
const session = memorySession();

const paired = await new Promise<string>((resolve, reject) => {
  let client: WhatsAppClient | undefined;
  // Set once the pairing ends, so the close it causes starts nothing.
  let done = false;
  const timer = setTimeout(() => {
    done = true;
    void client?.close();
    reject(new Error('No QR code was scanned in 3 minutes.'));
  }, PAIRING_TIMEOUT_MS);
  const start = async () => {
    client = await baileysConnect(session, {
      qr: (code) => {
        QRCode.toString(code, { type: 'terminal', small: true }).then(
          (picture) =>
            process.stdout.write(
              `\nScan with WhatsApp on the sending number: Linked devices › Link a device.\n${picture}\n`,
            ),
          (error: unknown) =>
            process.stderr.write(`The QR code could not be drawn: ${String(error)}\n`),
        );
      },
      open: (phone) => {
        setTimeout(() => {
          done = true;
          clearTimeout(timer);
          // Closing waits for the session's last write.
          (client?.close() ?? Promise.resolve()).then(() => resolve(phone), reject);
        }, SETTLE_MS);
      },
      closed: (reason) => {
        if (done) return;
        // WhatsApp restarts the connection once the code is scanned.
        if (reason === 'lost') void start().catch(reject);
        else {
          done = true;
          clearTimeout(timer);
          reject(new Error('WhatsApp refused the pairing.'));
        }
      },
      incoming: () => undefined,
    });
  };
  void start().catch(reject);
}).catch((error: unknown) => fail(error instanceof Error ? error.message : String(error)));

try {
  const number = await new OtpSenderNumbers(database, secrets).savePaired(
    paired,
    session.entries,
    new Date(),
  );
  process.stdout.write(`Paired ${maskPhone(paired)} as sending number ${number.id}.\n`);
} finally {
  await database.pool.end();
}
process.exit(0);
