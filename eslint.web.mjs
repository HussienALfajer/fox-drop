import reactHooks from 'eslint-plugin-react-hooks';
import globals from 'globals';

// The rules every web app adds to eslint.config.mjs (.claude/rules/web-apps.md).
const translated = 'User-facing text is a key in src/locales/ar.json, read with t() (AP §4.7).';
const westernDigits = "Plain 'ar' formats with Arabic-Indic digits; use 'ar-u-nu-latn' (AP §4.7).";
const labels =
  'alt|title|label|placeholder|aria-label|aria-description|aria-placeholder|aria-roledescription|aria-valuetext';
const plainArabic = '/^ar(?!.*-u-nu-latn)/';

// Arabic, right to left (AP §4.7): no physical direction in a class name. A
// class name is a string, so a lint rule on the text keeps them out.
// A utility class, without its variants (`hover:`) or `!` and `-`.
const physical =
  /^(?:-?(?:ml|mr|pl|pr|left|right|scroll-ml|scroll-mr|scroll-pl|scroll-pr)-|text-(?:left|right)$|rounded-(?:l|r|tl|tr|bl|br)(?:-|$)|border-(?:l|r)(?:-|$)|float-(?:left|right)$|clear-(?:left|right)$)/;

const messages = {
  physical:
    'No physical direction (AP §4.7): use ms-, me-, ps-, pe-, start-, end-, text-start, text-end, rounded-s, rounded-e, border-s, border-e, float-start, float-end.',
};

function textChecks(context, node, text) {
  for (const word of text.split(/\s+/)) {
    const utility = word.split(':').at(-1).replace(/^!/, '');
    if (physical.test(utility)) context.report({ node, messageId: 'physical' });
  }
}

const directionRules = {
  meta: { type: 'problem', messages, schema: [] },
  create: (context) => ({
    Literal(node) {
      if (typeof node.value === 'string') textChecks(context, node, node.value);
    },
    TemplateElement(node) {
      textChecks(context, node, node.value.cooked ?? node.value.raw);
    },
  }),
};

const plugin = { rules: { direction: directionRules } };

const intlSelectors = [
  {
    selector: `NewExpression[callee.object.name="Intl"][arguments.0.value=${plainArabic}]`,
    message: westernDigits,
  },
  {
    selector: `CallExpression[callee.property.name=/^toLocale/][arguments.0.value=${plainArabic}]`,
    message: westernDigits,
  },
];

export const webAppConfig = [
  {
    files: ['src/**/*.{ts,tsx}'],
    languageOptions: { globals: globals.browser },
  },
  reactHooks.configs.flat.recommended,
  {
    files: ['src/**/*.{ts,tsx}'],
    plugins: { fd: plugin },
    rules: {
      'fd/direction': 'error',
      'no-restricted-syntax': [
        'error',
        { selector: 'JSXText[value=/[^ \\t\\r\\n]/]', message: translated },
        {
          selector: 'JSXExpressionContainer > Literal[value=/[^ \\t\\r\\n]/]',
          message: translated,
        },
        { selector: 'JSXExpressionContainer > TemplateLiteral', message: translated },
        { selector: `JSXAttribute[name.name=/^(${labels})$/] > Literal`, message: translated },
        ...intlSelectors,
      ],
    },
  },
];
