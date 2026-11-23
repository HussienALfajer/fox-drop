import reactHooks from 'eslint-plugin-react-hooks';
import globals from 'globals';

// The rules every web app and packages/ui-web add to eslint.config.mjs
// (apps/admin/CLAUDE.md, packages/ui-web/CLAUDE.md).
const translated = 'User-facing text is a key in src/locales/ar.json, read with t() (AP §4.7).';
const westernDigits = "Plain 'ar' formats with Arabic-Indic digits; use 'ar-u-nu-latn' (AP §4.7).";
const labels =
  'alt|title|label|placeholder|aria-label|aria-description|aria-placeholder|aria-roledescription|aria-valuetext';
const plainArabic = '/^ar(?!.*-u-nu-latn)/';

// The design rules (architecture §9.5 R1, R3, R5) over every string and
// template of the source: a class name is a string, so a lint rule on the text
// is what keeps raw values and physical directions out.
const hex = /(^|[^\w&])#(?:[0-9a-f]{3,4}|[0-9a-f]{6}|[0-9a-f]{8})(?![\w-])/i;
const arbitrary = /-\[|(^|[\s:])\[[^\]\s]*[:&]/;
// A Tailwind class's utility, without its variants (`hover:`) or `!` and `-`.
const physical =
  /^(?:-?(?:ml|mr|pl|pr|left|right|scroll-ml|scroll-mr|scroll-pl|scroll-pr)-|text-(?:left|right)$|rounded-(?:l|r|tl|tr|bl|br)(?:-|$)|border-(?:l|r)(?:-|$)|float-(?:left|right)$|clear-(?:left|right)$)/;

const messages = {
  arbitrary:
    'No arbitrary Tailwind value (R1): use a semantic class or a component token, bg-(--fd-button-background).',
  hex: 'No hex colour in code (R1): a colour is a design token.',
  physical:
    'No physical direction (R5): use ms-, me-, ps-, pe-, start-, end-, text-start, text-end, rounded-s, rounded-e, border-s, border-e, float-start, float-end.',
  style: 'No style prop (R1): style with classes over design tokens.',
};

function textChecks(context, node, text) {
  if (hex.test(text)) context.report({ node, messageId: 'hex' });
  for (const word of text.split(/\s+/)) {
    const utility = word.split(':').at(-1).replace(/^!/, '');
    if (physical.test(utility)) context.report({ node, messageId: 'physical' });
  }
  if (arbitrary.test(text)) context.report({ node, messageId: 'arbitrary' });
}

const designRules = {
  meta: { type: 'problem', messages, schema: [] },
  create: (context) => ({
    Literal(node) {
      if (typeof node.value === 'string') textChecks(context, node, node.value);
    },
    TemplateElement(node) {
      textChecks(context, node, node.value.cooked ?? node.value.raw);
    },
    JSXAttribute(node) {
      if (node.name.type === 'JSXIdentifier' && node.name.name === 'style') {
        context.report({ node, messageId: 'style' });
      }
    },
  }),
};

const plugin = { rules: { design: designRules } };

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

const noAgent = {
  group: ['@ui-sdk/react/agent', '@ui-sdk/react/agent/*'],
  message: 'The agent entry of the UI SDK is not used (T11).',
};

const common = [
  {
    files: ['src/**/*.{ts,tsx}'],
    languageOptions: { globals: globals.browser },
  },
  reactHooks.configs.flat.recommended,
  {
    files: ['src/**/*.{ts,tsx}'],
    plugins: { fd: plugin },
    rules: {
      'fd/design': 'error',
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
  {
    // Stories show Arabic sample text and tests use plain strings.
    files: ['src/**/*.stories.tsx', 'src/**/*.test.tsx'],
    rules: { 'no-restricted-syntax': ['error', ...intlSelectors] },
  },
];

// The apps style only through @fox-drop/ui-web, the one importer of the UI SDK
// and Base UI (T11).
export const webAppConfig = [
  ...common,
  {
    files: ['src/**/*.{ts,tsx}'],
    rules: {
      'no-restricted-imports': [
        'error',
        {
          patterns: [
            {
              group: ['@ui-sdk/*', '@base-ui/*', '@base-ui-components/*'],
              message: 'Only @fox-drop/ui-web imports the UI SDK and Base UI (T11).',
            },
          ],
        },
      ],
    },
  },
];

export const uiWebConfig = [
  ...common,
  {
    files: ['src/**/*.{ts,tsx}'],
    rules: { 'no-restricted-imports': ['error', { patterns: [noAgent] }] },
  },
];
