import { randomBytes } from 'node:crypto';
import { Valkey } from 'iovalkey';
import { afterEach, describe, expect, it } from 'vitest';
import { QueuedCodeSender } from './code-send-queue.js';
import { codeSenderFromEnvironment, DevelopmentCodeSender } from './code-sender.js';
import { IdentitySecrets } from './secrets.js';

// Architecture §8.3.1: the development sender never runs outside development;
// everywhere else codes go to the otp-sender process.
describe('the code sender', () => {
  const environment = process.env.FOX_DROP_ENVIRONMENT;
  const secrets = new IdentitySecrets(randomBytes(32));
  const valkey = new Valkey({ lazyConnect: true });
  afterEach(() => {
    process.env.FOX_DROP_ENVIRONMENT = environment;
  });

  it('is the development sender only in development', async () => {
    process.env.FOX_DROP_ENVIRONMENT = 'development';
    const sender = codeSenderFromEnvironment(valkey, secrets);
    expect(sender).toBeInstanceOf(DevelopmentCodeSender);
    expect(await sender.send('+963912345678', '123456')).toBe('sent');
    expect((sender as DevelopmentCodeSender).lastCode('+963912345678')).toBe('123456');
  });

  it('queues codes for the otp-sender anywhere else', () => {
    for (const name of ['production', 'staging', 'Development', '', undefined]) {
      if (name === undefined) delete process.env.FOX_DROP_ENVIRONMENT;
      else process.env.FOX_DROP_ENVIRONMENT = name;
      expect(codeSenderFromEnvironment(valkey, secrets)).toBeInstanceOf(QueuedCodeSender);
      expect(() => new DevelopmentCodeSender()).toThrow(/only in development/);
    }
  });
});
