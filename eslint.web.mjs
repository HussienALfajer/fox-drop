import reactHooks from 'eslint-plugin-react-hooks';
import globals from 'globals';

// The rules every web app and packages/ui-web add to eslint.config.mjs
// (.claude/rules/web-apps.md, packages/ui-web/CLAUDE.md).
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
// The theme resets Tailwind's numeric spacing scale (only named spacing such as
// p-sm exists), so p-0 or inset-0 silently generates no CSS.
const numericSpacing =
  /^-?(?:p|px|py|ps|pe|pt|pb|m|mx|my|ms|me|mt|mb|inset|inset-x|inset-y|top|bottom|start|end|gap|gap-x|gap-y|space-x|space-y|w|h|size|min-w|min-h|max-w|max-h|translate-x|translate-y)-\d/;

const messages = {
  numericSpacing:
    'No numeric spacing utility: the theme has named spacing only (p-none, p-sm, inset-none), so p-0 generates no CSS.',
  arbitrary:
    'No arbitrary Tailwind value (R1): use a semantic class or a component token, bg-(--fd-button-background).',
  hex: 'No hex colour in code (R1): a colour is a design token.',
  physical:
    'No physical direction (R5): use ms-, me-, ps-, pe-, start-, end-, text-start, text-end, rounded-s, rounded-e, border-s, border-e, float-start, float-end.',
  style: 'No style prop (R1): style with classes over design tokens.',
  cssVariable:
    'No CSS-variable class in an app (R1): a screen uses semantic classes only; a component token belongs in @fox-drop/ui-web.',
};

function textChecks(context, node, text) {
  if (hex.test(text)) context.report({ node, messageId: 'hex' });
  for (const word of text.split(/\s+/)) {
    const utility = word.split(':').at(-1).replace(/^!/, '');
    if (physical.test(utility)) context.report({ node, messageId: 'physical' });
    if (numericSpacing.test(utility)) context.report({ node, messageId: 'numericSpacing' });
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

// An app writes no `bg-(--fd-x)` or `text-(color:--fd-x)`: component tokens
// are read in packages/ui-web only.
const cssVariable = /\((?:[\w-]+:)?--/;
function appTextChecks(context, node, text) {
  if (cssVariable.test(text)) context.report({ node, messageId: 'cssVariable' });
}

const appDesignRules = {
  meta: { type: 'problem', messages, schema: [] },
  create: (context) => ({
    Literal(node) {
      if (typeof node.value === 'string') appTextChecks(context, node, node.value);
    },
    TemplateElement(node) {
      appTextChecks(context, node, node.value.cooked ?? node.value.raw);
    },
  }),
};

const plugin = { rules: { design: designRules, 'app-design': appDesignRules } };

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
];

// The apps style only through @fox-drop/ui-web, the one importer of the UI SDK
// and Base UI (T11).
export const webAppConfig = [
  ...common,
  {
    files: ['src/**/*.{ts,tsx}'],
    rules: {
      'fd/app-design': 'error',
      'no-restricted-imports': [
        'error',
        {
          patterns: [
            {
              group: [
                '@ui-sdk/*',
                '@base-ui/*',
                '@base-ui-components/*',
                '@radix-ui/*',
                '@headlessui/*',
                '@mui/*',
                '@chakra-ui/*',
                '@mantine/*',
                'antd',
                'antd/*',
                'react-aria',
                'react-aria/*',
                'react-aria-components',
                'react-aria-components/*',
                '@ark-ui/*',
              ],
              message: 'Only @fox-drop/ui-web imports the UI SDK, Base UI and other UI kits (T11).',
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
  {
    // Stories show Arabic sample text and tests use plain strings (ui-web only).
    files: ['src/**/*.stories.tsx', 'src/**/*.test.tsx'],
    rules: { 'no-restricted-syntax': ['error', ...intlSelectors] },
  },
];
