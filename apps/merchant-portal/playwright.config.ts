import { defineConfig, devices } from '@playwright/test';

// The smoke test runs the built portal (vite preview) in Chromium and answers
// its API calls itself, so it needs no server or database (owner decision
// 2026-11-05).
export default defineConfig({
  testDir: 'e2e',
  forbidOnly: !!process.env.CI,
  reporter: process.env.CI ? 'github' : 'list',
  use: { baseURL: 'http://localhost:4174', locale: 'ar' },
  projects: [{ name: 'chromium', use: { ...devices['Desktop Chrome'] } }],
  webServer: { command: 'pnpm preview', url: 'http://localhost:4174', reuseExistingServer: false },
});
