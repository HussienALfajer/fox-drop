import swc from 'unplugin-swc';
import { defineConfig } from 'vitest/config';

// NestJS dependency injection reads decorator metadata, which esbuild does not
// emit, so tests compile through SWC.
export default defineConfig({
  plugins: [swc.vite({ module: { type: 'es6' } })],
  test: {
    include: ['src/**/*.test.ts', 'test/**/*.test.ts'],
  },
});
