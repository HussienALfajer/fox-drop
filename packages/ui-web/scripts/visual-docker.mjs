// Runs the visual project inside the Playwright image, the only place its
// baselines are valid (they depend on the Linux fonts and rasteriser). The repo
// is mounted; node_modules live in named volumes so the container's Linux
// install never touches the host's. Arguments pass through to Playwright:
// `pnpm test:visual --update-snapshots`.
import { spawnSync } from 'node:child_process';
import { existsSync, readFileSync } from 'node:fs';
import { resolve } from 'node:path';

const IMAGE = 'mcr.microsoft.com/playwright:v1.64.1-noble';
const repo = resolve(import.meta.dirname, '../../..');

if (!existsSync(resolve(repo, 'packages/ui-web/dist/storybook/index.json'))) {
  console.error('Build the Storybook first: pnpm --filter @fox-drop/ui-web build');
  process.exit(1);
}

const volumes = {
  'fd-visual-node-modules': '/work/node_modules',
  'fd-visual-ui-web-modules': '/work/packages/ui-web/node_modules',
  'fd-visual-tokens-modules': '/work/packages/design-tokens/node_modules',
  'fd-visual-pnpm-store': '/root/.local/share/pnpm',
};

const forwarded = process.argv.slice(2).map((arg) => `'${arg.replaceAll("'", "'\\''")}'`);
// The image ships the pinned Node (.node-version) but not pnpm: install the
// version of `packageManager`.
const pnpm = JSON.parse(readFileSync(resolve(repo, 'package.json'), 'utf8')).packageManager;
const script = [
  `npm install --global --no-fund --no-audit ${pnpm}`,
  'cd /work',
  'pnpm install --frozen-lockfile --filter "@fox-drop/ui-web..."',
  'cd packages/ui-web',
  `pnpm exec playwright test --project=visual ${forwarded.join(' ')}`,
].join(' && ');

const result = spawnSync(
  'docker',
  [
    'run',
    '--rm',
    '--ipc=host',
    '-e',
    'FD_VISUAL=1',
    '-e',
    'CI=1',
    '-v',
    `${repo}:/work`,
    ...Object.entries(volumes).flatMap(([name, path]) => ['-v', `${name}:${path}`]),
    IMAGE,
    'sh',
    '-c',
    script,
  ],
  { stdio: 'inherit' },
);
process.exit(result.status ?? 1);
