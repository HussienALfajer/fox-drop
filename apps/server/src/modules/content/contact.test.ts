import { describe, expect, it } from 'vitest';
import { supportContact } from './contact.js';

describe('supportContact', () => {
  it('gives the numbers in E.164', () => {
    expect(
      supportContact({
        SUPPORT_PHONE_NUMBER: '+963944000000',
        SUPPORT_WHATSAPP_NUMBER: ' +905321234567 ',
      }),
    ).toEqual({ phone: '+963944000000', whatsapp: '+905321234567' });
  });

  it('leaves out a missing, empty or malformed number', () => {
    expect(
      supportContact({ SUPPORT_PHONE_NUMBER: '', SUPPORT_WHATSAPP_NUMBER: '0944000000' }),
    ).toEqual({});
    expect(supportContact({})).toEqual({});
  });
});
