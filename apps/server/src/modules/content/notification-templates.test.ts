import { describe, expect, it } from 'vitest';
import {
  NOTIFICATION_TEMPLATES,
  NOTIFICATION_TEXT_MAX,
  renderNotification,
  variablesOf,
} from './notification-templates.js';

// AP §9.13: one template per push of CU §14, RA §16 and CA §14 that has a
// text, each key once, with Western digits (AP §4.7).
describe('the notification templates', () => {
  it('names each template once, with a text the panel could save', () => {
    const keys = NOTIFICATION_TEMPLATES.map((template) => template.key);
    expect(new Set(keys).size).toBe(keys.length);
    for (const template of NOTIFICATION_TEMPLATES) {
      expect(template.key.startsWith(`${template.audience}.`)).toBe(true);
      expect(template.text.length).toBeLessThanOrEqual(NOTIFICATION_TEXT_MAX);
      expect(template.text).not.toMatch(/[٠-٩]/);
    }
  });

  it('fills the variables it has values for and leaves the others as written', () => {
    expect(variablesOf('الكابتن {الاسم} يؤكد أنه دفع لك {المبلغ} واستلم الطلب #{رقم}')).toEqual([
      'الاسم',
      'المبلغ',
      'رقم',
    ]);
    expect(renderNotification('طلب جديد #{رقم} من {المطعم}', { رقم: '10002' })).toBe(
      'طلب جديد #10002 من {المطعم}',
    );
  });
});
