// Runs the visual project inside the Playwright image, the only place its
// baselines are valid (they depend on the Linux fonts and rasteriser). The repo
// is mounted; node_modules live in named volumes so the container's Linux
// install never touches the host's. Arguments pass through to Playwright:
// `pnpm test:visual --update-snapshots`. `pnpm baselines` (scripts/baselines.mjs)
// runs it with FD_VISUAL_STORIES (the stories to run) and FD_VISUAL_REPORT (a
// JSON report), which pass into the container.
import { createHash } from 'node:crypto';
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
  'fd-visual-pnpm': '/opt/pnpm',
};

const forwarded = process.argv.slice(2).map((arg) => `'${arg.replaceAll("'", "'\\''")}'`);
// The image ships the pinned Node (.node-version) but not pnpm: install the
// version of `packageManager`, once, into its own volume. The install itself
// (about 2 min: pnpm checks the lock file against the registry) runs only when
// what it installs changed since the volume's last install: the pnpm version,
// the lock file, the workspace and the manifests of the installed packages.
const read = (file) => readFileSync(resolve(repo, file));
const pnpm = JSON.parse(read('package.json')).packageManager;
// A manifest's fields that change an install (a new script does not).
const installFields = (file) => {
  const manifest = JSON.parse(read(file));
  const fields = ['dependencies', 'devDependencies', 'optionalDependencies', 'peerDependencies'];
  return JSON.stringify([...fields, 'pnpm', 'engines'].map((field) => manifest[field] ?? null));
};
const installed = createHash('sha256')
  .update(pnpm)
  .update(read('pnpm-lock.yaml'))
  .update(read('pnpm-workspace.yaml'))
  .update(installFields('package.json'))
  .update(installFields('packages/ui-web/package.json'))
  .update(installFields('packages/design-tokens/package.json'))
  .digest('hex');
const marker = '/work/node_modules/.fd-visual-installed';
const script = [
  'set -e',
  `if [ "$(cat /opt/pnpm/version 2>/dev/null)" != "${pnpm}" ]; then` +
    ` npm install --global --prefix /opt/pnpm --no-fund --no-audit ${pnpm}` +
    ` && echo "${pnpm}" > /opt/pnpm/version; fi`,
  'export PATH=/opt/pnpm/bin:$PATH',
  'cd /work',
  `if [ "$(cat ${marker} 2>/dev/null)" != "${installed}" ]; then` +
    ' pnpm install --frozen-lockfile --filter "@fox-drop/ui-web..."' +
    ` && echo "${installed}" > ${marker}; fi`,
  'cd packages/ui-web',
  `pnpm exec playwright test --project=visual ${forwarded.join(' ')}`,
].join('\n');

const passed = ['FD_VISUAL_STORIES', 'FD_VISUAL_REPORT'].filter((name) => process.env[name]);
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
    // Named only: the value comes from this process's environment (a story
    // list can be longer than a command line).
    ...passed.flatMap((name) => ['-e', name]),
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
