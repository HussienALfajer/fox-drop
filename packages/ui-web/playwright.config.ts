import { defineConfig, devices } from '@playwright/test';

// Both projects run over the built static Storybook (`dist/storybook`, from
// `pnpm build`), served by `vite preview`.
// - functional: the RTL, keyboard, axe and 130% text gate; runs on any OS.
// - visual: screenshots of every story. A baseline is valid only from the
//   Playwright image (`pnpm test:visual` runs it in Docker, which sets
//   FD_VISUAL), so the project exists only there.
const visual = process.env['FD_VISUAL'] === '1';
// `pnpm baselines` reads the failed comparisons from a JSON report.
const report = process.env['FD_VISUAL_REPORT'];
const reporter = process.env['CI'] ? 'github' : 'list';
// - parity: the web side of `pnpm parity <Component>` (the repository root),
//   which names the stories in FD_PARITY; it exists only then, so neither
//   `pnpm verify` nor CI runs it.
const parity = !!process.env['FD_PARITY'];

export default defineConfig({
  testDir: 'e2e',
  // Every test opens its own page on one story and shares nothing, so the
  // tests of a file spread over the workers: rtl.spec.ts (axe over every
  // story) alone held one worker for 5.4 of the 5.5 minutes, and the visual
  // project is one file.
  fullyParallel: true,
  // Playwright's default is half the cores: 2 workers on CI's 4-vCPU runner,
  // where the functional (432 tests) and visual (528) suites each took over
  // 3 minutes, the longest jobs of the run. Locally the default stays.
  ...(process.env['CI'] ? { workers: '100%' } : {}),
  forbidOnly: !!process.env['CI'],
  reporter: report ? [[reporter], ['json', { outputFile: report }]] : reporter,
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
            use: {
              ...devices['Desktop Chrome'],
              // Chromium re-rasterizes only the changed part of a tile after
              // an update (partial raster), and an anti-aliased edge crossing
              // that part then differs by a level or two with the frames
              // painted before: a field's rounded outline failed 13 of 2,400
              // repeats, the pressed stepper 20 of 20 without a full repaint.
              // Every tile drawn whole: 0 of 4,160.
              launchOptions: { args: ['--disable-partial-raster'] },
            },
          },
        ]
      : []),
    ...(parity
      ? [
          {
            name: 'parity',
            testMatch: 'parity.spec.ts',
            // The phone width of the Flutter case, at its pixel ratio.
            use: {
              ...devices['Desktop Chrome'],
              viewport: { width: 360, height: 800 },
              deviceScaleFactor: 2,
            },
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
