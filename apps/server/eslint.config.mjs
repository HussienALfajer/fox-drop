import rootConfig from '../../eslint.config.mjs';

export default [
  ...rootConfig,
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
];
