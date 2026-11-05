import { afterEach, describe, expect, it } from 'vitest';
import {
  codeSenderFromEnvironment,
  DevelopmentCodeSender,
  UnavailableCodeSender,
} from './code-sender.js';

// Architecture §8.3.1: the development sender never runs outside development.
describe('the code sender', () => {
  const environment = process.env.FOX_DROP_ENVIRONMENT;
  afterEach(() => {
    process.env.FOX_DROP_ENVIRONMENT = environment;
  });

  it('is the development sender only in development', async () => {
    process.env.FOX_DROP_ENVIRONMENT = 'development';
    const sender = codeSenderFromEnvironment();
    expect(sender).toBeInstanceOf(DevelopmentCodeSender);
    expect(await sender.send('+963912345678', '123456')).toBe('sent');
    expect((sender as DevelopmentCodeSender).lastCode('+963912345678')).toBe('123456');
  });

  it('sends nothing anywhere else', async () => {
    for (const name of ['production', 'staging', 'Development', '', undefined]) {
      if (name === undefined) delete process.env.FOX_DROP_ENVIRONMENT;
      else process.env.FOX_DROP_ENVIRONMENT = name;
      const sender = codeSenderFromEnvironment();
      expect(sender).toBeInstanceOf(UnavailableCodeSender);
      expect(await sender.send('+963912345678', '123456')).toBe('unavailable');
      expect(() => new DevelopmentCodeSender()).toThrow(/only in development/);
    }
  });
});
