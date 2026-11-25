import { describe, expect, it } from 'vitest';
import { appPhone, isAppMobile, maskedPhone, signsInAbroad } from './app-phone.js';

// CU U3, §5.2 item 1 (owner decision 2026-11-24): the apps take a mobile
// number of any country, in E.164; the server takes nothing else.
describe('an app mobile number', () => {
  it.each([
    ['a Syrian Syriatel mobile', '+963933123456'],
    ['a Syrian MTN mobile', '+963944123456'],
    ['a Syrian mobile on 95', '+963951234567'],
    ['a Syrian mobile on 96', '+963961234567'],
    ['a Syrian mobile on 98', '+963981234567'],
    ['a Syrian mobile on 99', '+963991234567'],
    ['a Turkish mobile', '+905321234567'],
    ['a German mobile', '+4915123456789'],
    ['a British mobile', '+447911123456'],
    ['an Iraqi mobile', '+9647901234567'],
    ['an American number (fixed or mobile)', '+12015550123'],
  ])('takes %s', (_name, phone) => {
    expect(isAppMobile(phone)).toBe(true);
    expect(appPhone.safeParse(phone).success).toBe(true);
  });

  // Today's Syrian and Turkish rule stays: nothing taken before is refused
  // (plan critique, 2026-11-24).
  it.each([
    ['a Syrian number on 91', '+963912345678'],
    ['a Syrian number on 92', '+963921234567'],
  ])('still takes %s, as before', (_name, phone) => {
    expect(isAppMobile(phone)).toBe(true);
  });

  it.each([
    ['a Syrian landline', '+963112345678'],
    ['a Turkish landline', '+902121234567'],
    ['a Syrian mobile a digit short', '+96394412345'],
    ['a Syrian mobile a digit long', '+9639441234567'],
    ['a national form', '0944123456'],
    ['the 00 form', '00963944123456'],
    ['a bare calling code', '963944123456'],
    ['a German landline', '+493012345678'],
    ['nothing', ''],
  ])('refuses %s', (_name, phone) => {
    expect(isAppMobile(phone)).toBe(false);
    expect(appPhone.safeParse(phone).success).toBe(false);
  });

  it('takes every number of the placeholder seed and the placeholder-phone command', () => {
    for (const phone of ['+963900000001', '+963900000002', '+963900000003']) {
      expect(isAppMobile(phone)).toBe(true);
    }
  });
});

// Architecture §8.3.3 item 2 (owner decision 2026-11-24): a number outside
// Syria and Turkey has a daily limit of its own.
describe('a number abroad', () => {
  it.each([
    ['+963944123456', false],
    ['+905321234567', false],
    ['+4915123456789', true],
    ['+447911123456', true],
    ['+9647901234567', true],
    ['+12015550123', true],
  ])('%s abroad: %s', (phone, abroad) => {
    expect(signsInAbroad(phone)).toBe(abroad);
  });
});

// The panel's masked display shows the number's own calling code.
describe('the masked number', () => {
  it.each([
    ['+963944123456', '+963 ••• 456'],
    ['+905321234567', '+90 ••• 567'],
    ['+447911123123', '+44 ••• 123'],
    ['+12015550123', '+1 ••• 123'],
    ['+79161234567', '+7 ••• 567'],
  ])('%s is %s', (phone, masked) => {
    expect(maskedPhone(phone)).toBe(masked);
  });
});
