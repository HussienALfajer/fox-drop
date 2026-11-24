import { defineConfig, devices } from '@playwright/test';

// Both projects run over the built static Storybook (`dist/storybook`, from
// `pnpm build`), served by `vite preview`.
// - functional: the RTL, keyboard, axe and 130% text gate; runs on any OS.
// - visual: screenshots of every story. A baseline is valid only from the
//   Playwright image (`pnpm test:visual` runs it in Docker, which sets
//   FD_VISUAL), so the project exists only there.
const visual = process.env['FD_VISUAL'] === '1';

export default defineConfig({
  testDir: 'e2e',
  forbidOnly: !!process.env['CI'],
  reporter: process.env['CI'] ? 'github' : 'list',
  snapshotPathTemplate: '{testDir}/__screenshots__/{arg}{ext}',
  // No trace: a trace archives every response, and Storybook serves the
  // licensed fonts. CI uploads only the PNGs of a failed comparison.
  use: { baseURL: 'http://127.0.0.1:6007', locale: 'ar', trace: 'off' },
  projects: [
    {
      name: 'functional',
      testMatch: ['rtl.spec.ts', 'forms.spec.ts', 'overlays.spec.ts'],
      use: { ...devices['Desktop Chrome'] },
    },
    ...(visual
      ? [
          {
            name: 'visual',
            testMatch: 'visual.spec.ts',
            use: { ...devices['Desktop Chrome'] },
          },
        ]
      : []),
  ],
  webServer: {
    command:
      'pnpm exec vite preview --outDir dist/storybook --host 127.0.0.1 --port 6007 --strictPort',
    url: 'http://127.0.0.1:6007/iframe.html',
    reuseExistingServer: false,
  },
});
