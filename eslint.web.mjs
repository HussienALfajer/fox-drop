import reactHooks from 'eslint-plugin-react-hooks';
import globals from 'globals';

// The rules every web app adds to eslint.config.mjs (apps/admin/CLAUDE.md).
const translated = 'User-facing text is a key in src/locales/ar.json, read with t() (AP §4.7).';
const westernDigits = "Plain 'ar' formats with Arabic-Indic digits; use 'ar-u-nu-latn' (AP §4.7).";
const labels =
  'alt|title|label|placeholder|aria-label|aria-description|aria-placeholder|aria-roledescription|aria-valuetext';
const plainArabic = '/^ar(?!.*-u-nu-latn)/';

export const webAppConfig = [
  {
    files: ['src/**/*.{ts,tsx}'],
    languageOptions: { globals: globals.browser },
  },
  reactHooks.configs.flat.recommended,
  {
    files: ['src/**/*.{ts,tsx}'],
    rules: {
      'no-restricted-syntax': [
        'error',
        { selector: 'JSXText[value=/[^ \\t\\r\\n]/]', message: translated },
        {
          selector: 'JSXExpressionContainer > Literal[value=/[^ \\t\\r\\n]/]',
          message: translated,
        },
        { selector: 'JSXExpressionContainer > TemplateLiteral', message: translated },
        { selector: `JSXAttribute[name.name=/^(${labels})$/] > Literal`, message: translated },
        {
          selector: `NewExpression[callee.object.name="Intl"][arguments.0.value=${plainArabic}]`,
          message: westernDigits,
        },
        {
          selector: `CallExpression[callee.property.name=/^toLocale/][arguments.0.value=${plainArabic}]`,
          message: westernDigits,
        },
      ],
    },
  },
];
