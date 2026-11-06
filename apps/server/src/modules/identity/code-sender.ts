import type { Valkey } from 'iovalkey';
import { QueuedCodeSender } from './code-send-queue.js';
import type { IdentitySecrets } from './secrets.js';

// The injection token of the module's CodeSender.
export const CODE_SENDER = Symbol('CODE_SENDER');

// Architecture §8.3.1: the identity module asks this port to deliver a sign-in
// code. Outside development the adapter is QueuedCodeSender, which hands the
// code to the WhatsApp sender of the otp-sender process (code-send-queue.ts).
// not_on_whatsapp: the number has no WhatsApp account,
// so nothing was sent (architecture §8.3.3 item 3); unavailable: no channel
// can send now (§8.3.3 item 14), so nothing was sent either.
export type SendResult = 'sent' | 'not_on_whatsapp' | 'unavailable';

export interface CodeSender {
  send(phone: string, code: string): Promise<SendResult>;
}

// FOX_DROP_ENVIRONMENT names where the server runs: development on a
// developer's machine and in the tests, staging or production when deployed.
export function isDevelopment(): boolean {
  return process.env.FOX_DROP_ENVIRONMENT === 'development';
}

// Prints the code to the server's standard output, never to the logger, so a
// developer can sign in without WhatsApp. It refuses to exist anywhere but in
// development. The last code per number stays readable for the tests.
export class DevelopmentCodeSender implements CodeSender {
  private readonly lastCodes = new Map<string, string>();

  constructor() {
    if (!isDevelopment()) throw new Error('the development code sender runs only in development');
  }

  send(phone: string, code: string): Promise<SendResult> {
    this.lastCodes.set(phone, code);
    process.stdout.write(`[development code sender] ${phone}: ${code}\n`);
    return Promise.resolve('sent');
  }

  lastCode(phone: string): string | undefined {
    return this.lastCodes.get(phone);
  }
}

// Development prints codes; staging and production send them over WhatsApp
// through the otp-sender process.
export function codeSenderFromEnvironment(valkey: Valkey, secrets: IdentitySecrets): CodeSender {
  return isDevelopment() ? new DevelopmentCodeSender() : new QueuedCodeSender(valkey, secrets);
}
