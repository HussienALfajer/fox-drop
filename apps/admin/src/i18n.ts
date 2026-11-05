import i18next from 'i18next';
import { initReactI18next } from 'react-i18next';
import ar from './locales/ar.json';

// Arabic is the only V1 language (AP D21). Keys are typed from ar.json, so a
// missing key fails the type check.
declare module 'i18next' {
  interface CustomTypeOptions {
    resources: { translation: typeof ar };
  }
}

export const i18n = i18next.createInstance();

await i18n.use(initReactI18next).init({
  lng: 'ar',
  fallbackLng: 'ar',
  resources: { ar: { translation: ar } },
  interpolation: { escapeValue: false },
});
