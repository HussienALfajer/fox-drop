import { describe, expect, it, vi } from 'vitest';
import { appValues, type AppValues, changes, formValues } from './app-settings.js';

vi.mock('./api.js', () => ({ api: {} }));

// AP §9.14 «التطبيقات».
const entry = (key: string, value: unknown) => ({ key, value }) as never;

describe('appValues', () => {
  it("reads one app's settings, an unset one as null", () => {
    const settings = [
      entry('app.captain.min_version', '1.4.0'),
      entry('app.customer.min_version', '2.0.0'),
      entry('app.captain.latest_version', null),
      entry('app.captain.maintenance', { enabled: true, message: 'صيانة' }),
    ];
    expect(appValues(settings, 'captain')).toEqual({
      minVersion: '1.4.0',
      latestVersion: null,
      updateMessage: null,
      maintenance: { enabled: true, message: 'صيانة' },
    });
  });
});

describe('formValues', () => {
  it('trims the fields and sends an empty one as unset', () => {
    const form = new FormData();
    form.set('minVersion', ' 1.4.0 ');
    form.set('latestVersion', '');
    form.set('updateMessage', '  ');
    form.set('maintenance', 'on');
    form.set('maintenanceMessage', 'نعود بعد ساعة');
    expect(formValues(form)).toEqual({
      minVersion: '1.4.0',
      latestVersion: null,
      updateMessage: null,
      maintenance: { enabled: true, message: 'نعود بعد ساعة' },
    });
  });
});

describe('changes', () => {
  const before: AppValues = {
    minVersion: '1.4.0',
    latestVersion: null,
    updateMessage: null,
    maintenance: { enabled: false, message: null },
  };

  it('sends only the settings that changed, by their concrete keys', () => {
    expect(
      changes('merchant', before, {
        ...before,
        latestVersion: '1.6.0',
        maintenance: { enabled: true, message: null },
      }),
    ).toEqual([
      { key: 'app.merchant.latest_version', value: '1.6.0' },
      { key: 'app.merchant.maintenance', value: { enabled: true, message: null } },
    ]);
    expect(changes('merchant', before, before)).toEqual([]);
  });
});
