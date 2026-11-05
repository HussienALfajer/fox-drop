// The injection token of the module's CodeSender.
export const CODE_SENDER = Symbol('CODE_SENDER');

// Architecture §8.3.1: the identity module asks this port to deliver a sign-in
// code. V1's adapter is the WhatsApp library sender in the otp-sender process;
// until it exists the API calls the development sender directly (owner
// decision 2026-11-05). not_on_whatsapp: the number has no WhatsApp account,
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

  send(phone: string, code: string): Promise<'sent'> {
    this.lastCodes.set(phone, code);
    process.stdout.write(`[development code sender] ${phone}: ${code}\n`);
    return Promise.resolve('sent');
  }

  lastCode(phone: string): string | undefined {
    return this.lastCodes.get(phone);
  }
}

// Outside development until the WhatsApp sender arrives (roadmap, before the
// Phase 1 staging trials): every code request is refused, and nothing is sent.
export class UnavailableCodeSender implements CodeSender {
  send(): Promise<'unavailable'> {
    return Promise.resolve('unavailable');
  }
}

export function codeSenderFromEnvironment(): CodeSender {
  return isDevelopment() ? new DevelopmentCodeSender() : new UnavailableCodeSender();
}
