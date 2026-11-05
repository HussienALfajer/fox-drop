import js from '@eslint/js';
import globals from 'globals';
import tseslint from 'typescript-eslint';

export default tseslint.config(
  {
    ignores: [
      '**/node_modules/',
      '**/dist/',
      '**/build/',
      '**/coverage/',
      '**/.turbo/',
      '**/.dart_tool/',
      // Playwright's output, which a parallel test:e2e creates and deletes
      // while lint scans the folder.
      '**/test-results/',
      '**/playwright-report/',
    ],
  },
  js.configs.recommended,
  tseslint.configs.recommended,
  {
    files: ['**/*.{js,mjs,cjs}'],
    languageOptions: { globals: globals.node },
  },
);
