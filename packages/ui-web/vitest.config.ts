import { defineConfig } from 'vitest/config';

// Component tests (later steps) render in jsdom; test/lint.test.ts runs ESLint
// and needs no DOM.
export default defineConfig({
  test: { environment: 'jsdom', include: ['src/**/*.test.{ts,tsx}', 'test/**/*.test.ts'] },
});
