import { existsSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import type { StorybookConfig } from '@storybook/react-vite';
import tailwindcss from '@tailwindcss/vite';

// The licensed fonts are fetched into the repository's .fonts/ (architecture
// §9.3); without them (a fork's pull request) the build still runs and the
// text falls back to the system sans.
const fonts = fileURLToPath(new URL('../../../.fonts', import.meta.url));
// Fox Lira (the ₺) is committed: it is served whether or not CoFo is there.
const lira = fileURLToPath(new URL('../fonts/fox-lira', import.meta.url));

const config: StorybookConfig = {
  framework: '@storybook/react-vite',
  core: { disableTelemetry: true },
  stories: ['../src/**/*.stories.tsx'],
  staticDirs: [
    ...(existsSync(fonts) ? [{ from: fonts, to: '/fonts' }] : []),
    { from: lira, to: '/fonts/fox-lira' },
  ],
  viteFinal: (viteConfig) => ({
    ...viteConfig,
    plugins: [...(viteConfig.plugins ?? []), tailwindcss()],
  }),
};

export default config;
