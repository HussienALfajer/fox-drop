import { defineConfig } from 'vitest/config';

// Component tests render in jsdom; test/lint.test.ts runs ESLint and
// test/stories.test.ts reads the sources, and neither needs a DOM.
export default defineConfig({
  test: {
    environment: 'jsdom',
    include: ['src/**/*.test.{ts,tsx}', 'test/**/*.test.ts'],
    setupFiles: ['test/setup.ts'],
  },
});
