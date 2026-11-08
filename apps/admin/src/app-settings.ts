import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import type { components } from '@fox-drop/api-schema';
import { api } from './api.js';
import { citiesQuery } from './cities.js';

// OWN's row of the AP §6.2 matrix; the server checks the Appendix A edit
// roles of each key (OWN for app.<app>.*).
export const SETTINGS_READ = 'settings.read';

export const platformApps = ['customer', 'merchant', 'captain'] as const;
export type PlatformApp = (typeof platformApps)[number];

type SettingEntry = components['schemas']['SettingListDto_Output']['settings'][number];

// AP §9.14 «التطبيقات»: an app's versions, update message and maintenance
// (Appendix A app.<app>.*). Empty means unset.
export interface AppValues {
  minVersion: string | null;
  latestVersion: string | null;
  updateMessage: string | null;
  maintenance: { enabled: boolean; message: string | null };
}

const fields = {
  minVersion: 'min_version',
  latestVersion: 'latest_version',
  updateMessage: 'update_message',
  maintenance: 'maintenance',
} as const satisfies Record<keyof AppValues, string>;

const keyOf = (app: PlatformApp, field: keyof AppValues) => `app.${app}.${fields[field]}`;

const text = (value: unknown): string | null =>
  typeof value === 'string' && value !== '' ? value : null;

// The app's values in the settings list.
export function appValues(settings: SettingEntry[], app: PlatformApp): AppValues {
  const value = (field: keyof AppValues) =>
    settings.find((entry) => entry.key === keyOf(app, field))?.value;
  const maintenance = value('maintenance') as { enabled?: unknown; message?: unknown } | undefined;
  return {
    minVersion: text(value('minVersion')),
    latestVersion: text(value('latestVersion')),
    updateMessage: text(value('updateMessage')),
    maintenance: {
      enabled: maintenance?.enabled === true,
      message: text(maintenance?.message),
    },
  };
}

const trimmed = (value: FormDataEntryValue | null): string | null =>
  text(typeof value === 'string' ? value.trim() : null);

// The form's values: trimmed, empty as unset.
export function formValues(form: FormData): AppValues {
  return {
    minVersion: trimmed(form.get('minVersion')),
    latestVersion: trimmed(form.get('latestVersion')),
    updateMessage: trimmed(form.get('updateMessage')),
    maintenance: {
      enabled: form.get('maintenance') === 'on',
      message: trimmed(form.get('maintenanceMessage')),
    },
  };
}

// The settings a save changes, each by its concrete key.
export function changes(
  app: PlatformApp,
  before: AppValues,
  after: AppValues,
): { key: string; value: unknown }[] {
  return (Object.keys(fields) as (keyof AppValues)[])
    .filter((field) => JSON.stringify(before[field]) !== JSON.stringify(after[field]))
    .map((field) => ({ key: keyOf(app, field), value: after[field] }));
}

const settingsKey = ['settings'] as const;

// Every setting OWN sees; the app settings are global, but the list is read
// for a city (the first one).
export function useAppSettings() {
  const queryClient = useQueryClient();
  return useQuery({
    queryKey: settingsKey,
    queryFn: async () => {
      const [city] = await queryClient.fetchQuery(citiesQuery);
      if (!city) throw new Error('no city');
      const { data } = await api.GET('/v1/admin/settings', {
        params: { query: { cityId: city.id } },
      });
      if (!data) throw new Error('settings unavailable');
      return data.settings;
    },
  });
}

export type SaveResult = { status: 'saved' } | { status: 'refused'; key: string };

// Saves each changed setting in turn; a value the server refuses (a version
// not in the form 1.4.0) stops there.
export function useSaveAppSettings() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async ({
      app,
      before,
      after,
    }: {
      app: PlatformApp;
      before: AppValues;
      after: AppValues;
    }): Promise<SaveResult> => {
      try {
        for (const { key, value } of changes(app, before, after)) {
          const { error, response } = await api.PUT('/v1/admin/settings/{key}', {
            params: { path: { key } },
            body: { value, reason: null },
          });
          const status: number = response.status;
          if (status === 400) return { status: 'refused', key };
          if (error !== undefined) throw new Error(`setting ${key} failed with ${status}`);
        }
        return { status: 'saved' };
      } finally {
        await queryClient.invalidateQueries({ queryKey: settingsKey });
      }
    },
  });
}
