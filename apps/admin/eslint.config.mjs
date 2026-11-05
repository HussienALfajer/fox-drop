import reactHooks from 'eslint-plugin-react-hooks';
import globals from 'globals';
import rootConfig from '../../eslint.config.mjs';

const translated = 'User-facing text is a key in src/locales/ar.json, read with t() (AP §4.7).';

export default [
  ...rootConfig,
  {
    files: ['src/**/*.{ts,tsx}'],
    languageOptions: { globals: globals.browser },
  },
  reactHooks.configs.flat.recommended,
  {
    files: ['src/**/*.tsx'],
    rules: {
      'no-restricted-syntax': [
        'error',
        { selector: 'JSXText[value=/[^ \\t\\r\\n]/]', message: translated },
        {
          selector:
            'JSXAttribute[name.name=/^(alt|title|placeholder|aria-label|aria-description)$/] > Literal',
          message: translated,
        },
      ],
    },
  },
];
