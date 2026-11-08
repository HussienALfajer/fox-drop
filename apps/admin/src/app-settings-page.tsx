import { Link } from '@tanstack/react-router';
import type { FormEvent } from 'react';
import { useTranslation } from 'react-i18next';
import {
  appValues,
  type AppValues,
  formValues,
  type PlatformApp,
  platformApps,
  useAppSettings,
  useSaveAppSettings,
} from './app-settings.js';

const appKeys = {
  customer: 'appSettings.app.customer',
  merchant: 'appSettings.app.merchant',
  captain: 'appSettings.app.captain',
} as const satisfies Record<PlatformApp, string>;

// AP §9.14 «التطبيقات»: for each app, the minimum version (older versions are
// forced to update), the latest version (newer is suggested), the update
// message and maintenance with its message. OWN only. Unstyled until the
// design.
export function AppSettingsPage() {
  const { t } = useTranslation();
  const settings = useAppSettings();
  return (
    <main>
      <h1>{t('appSettings.title')}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
      <p>{t('appSettings.explain')}</p>
      {settings.isPending ? (
        <p role="status">{t('status.loading')}</p>
      ) : settings.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : (
        platformApps.map((app) => {
          const values = appValues(settings.data, app);
          // A new key after a save, so the form shows what the server holds.
          const formKey = app + ':' + JSON.stringify(values);
          return <AppForm key={formKey} app={app} values={values} />;
        })
      )}
    </main>
  );
}

function AppForm({ app, values }: { app: PlatformApp; values: AppValues }) {
  const { t } = useTranslation();
  const save = useSaveAppSettings();
  function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    save.mutate({ app, before: values, after: formValues(new FormData(event.currentTarget)) });
  }
  const heading = 'app-settings-' + app;
  return (
    <section aria-labelledby={heading}>
      <h2 id={heading}>{t(appKeys[app])}</h2>
      <form onSubmit={submit}>
        <fieldset disabled={save.isPending}>
          <label>
            {t('appSettings.minVersion')}
            <input name="minVersion" defaultValue={values.minVersion ?? ''} maxLength={20} />
          </label>
          <label>
            {t('appSettings.latestVersion')}
            <input name="latestVersion" defaultValue={values.latestVersion ?? ''} maxLength={20} />
          </label>
          <label>
            {t('appSettings.updateMessage')}
            <textarea
              name="updateMessage"
              defaultValue={values.updateMessage ?? ''}
              maxLength={500}
            />
          </label>
          <label>
            <input type="checkbox" name="maintenance" defaultChecked={values.maintenance.enabled} />
            {t('appSettings.maintenance')}
          </label>
          <label>
            {t('appSettings.maintenanceMessage')}
            <textarea
              name="maintenanceMessage"
              defaultValue={values.maintenance.message ?? ''}
              maxLength={500}
            />
          </label>
          <button type="submit">{t('appSettings.save')}</button>
        </fieldset>
      </form>
      {save.isError && <p role="alert">{t('common.failed')}</p>}
      {save.data?.status === 'saved' && <p role="status">{t('appSettings.saved')}</p>}
      {save.data?.status === 'refused' && <p role="alert">{t('appSettings.refused')}</p>}
    </section>
  );
}
