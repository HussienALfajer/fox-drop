import boundaries from 'eslint-plugin-boundaries';
import rootConfig from '../../eslint.config.mjs';

export default [
  ...rootConfig,
  { ignores: ['test/fixtures/'] },
  {
    // Every route lives in one product's group (architecture §5.3).
    files: ['src/**/*.ts'],
    ignores: ['src/http/route-groups.ts'],
    rules: {
      'no-restricted-imports': [
        'error',
        {
          paths: [
            {
              name: '@nestjs/common',
              importNames: ['Controller'],
              message: 'Use a route group controller from src/http/route-groups.ts.',
            },
          ],
        },
      ],
    },
  },
  {
    // Module boundaries (architecture §4.3): a module reaches another module
    // only through that module's public entry, src/modules/<name>/index.ts.
    files: ['src/**/*.ts', 'test/fixtures/**/*.ts'],
    plugins: { boundaries },
    settings: {
      'import/resolver': { typescript: { project: 'tsconfig.json' } },
      'boundaries/elements': [
        { type: 'module', pattern: 'src/modules/*', capture: ['name'], partialMatch: false },
        // Everything else in src: the HTTP layer, logging, the process roles.
        { type: 'shared', pattern: 'src', partialMatch: false },
      ],
    },
    rules: {
      // Every file belongs to a module or to the shared layer, so none escapes the rule.
      'boundaries/no-unknown-files': 'error',
      'boundaries/dependencies': [
        'error',
        {
          default: 'disallow',
          policies: [
            {
              from: { element: { type: 'module' } },
              allow: {
                to: {
                  element: {
                    type: 'module',
                    captured: { name: '{{ from.element.captured.name }}' },
                  },
                },
              },
            },
            { allow: { to: { element: { type: 'module', fileInternalPath: 'index.ts' } } } },
            { allow: { to: { element: { type: 'shared' } } } },
          ],
          message:
            '{{ to.element.captured.name }} is reached only through src/modules/{{ to.element.captured.name }}/index.ts (architecture §4.3).',
        },
      ],
    },
  },
];
