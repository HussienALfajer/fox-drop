// Runs the core_ui golden tests (R9) on Linux in Docker, the only place their
// baselines are valid: the same image locally and in the CI `golden` job.
// No Flutter image exists for the pinned version, so the image is the pinned
// Ubuntu with the .fvmrc Flutter cloned into it (built once, then cached).
// The repository is mounted read-only and copied into the container (its
// tracked and untracked files, not ignored ones, plus .fonts/), so a Linux
// `pub get` never rewrites the host's .dart_tool; only the goldens and the
// failure images come back. Arguments pass to `flutter test`:
// `node scripts/golden-docker.mjs --update-goldens`; `pnpm baselines` runs it.
import { spawnSync } from 'node:child_process';
import { createHash } from 'node:crypto';
import { existsSync, readFileSync } from 'node:fs';
import { resolve } from 'node:path';

const UBUNTU =
  'ubuntu:24.04@sha256:9c7f200c07e3d4a03e7249d2c16bf66a51120fb876aa2242cf31451412543289';
const repo = resolve(import.meta.dirname, '..');
const flutter = JSON.parse(readFileSync(resolve(repo, '.fvmrc'), 'utf8')).flutter;
const image = `fox-drop-golden:${flutter}`;

if (!existsSync(resolve(repo, '.fonts/cofo-sans-pro-arabic'))) {
  console.error('CoFo is missing: run `pnpm fonts:fetch` first.');
  process.exit(1);
}

const dockerfile = `
FROM ${UBUNTU}
RUN apt-get update && apt-get install --yes --no-install-recommends \\
      ca-certificates curl git unzip xz-utils && rm -rf /var/lib/apt/lists/*
RUN git clone --depth 1 --branch ${flutter} https://github.com/flutter/flutter.git /flutter \\
    && git config --global --add safe.directory '*'
ENV PATH=/flutter/bin:$PATH FLUTTER_SUPPRESS_ANALYTICS=true CI=true
RUN flutter config --no-analytics && flutter precache --no-android --no-ios --linux
`;

const run = (args, options = {}) => {
  const result = spawnSync('docker', args, { stdio: 'inherit', ...options });
  if (result.status !== 0) process.exit(result.status ?? 1);
};

// The tag names the Dockerfile's content too, so an image that exists is the
// one this file builds: no build at all then (Docker's build cache is pruned
// on its own, and a rebuild downloads Flutter again, about 7 minutes).
const tag = `${image}-${createHash('sha256').update(dockerfile).digest('hex').slice(0, 12)}`;
if (spawnSync('docker', ['image', 'inspect', tag], { stdio: 'ignore' }).status !== 0)
  run(['build', '--tag', tag, '-'], { input: dockerfile, stdio: ['pipe', 'inherit', 'inherit'] });

// The file list comes from the host's git: inside the container a worktree's
// `.git` file points at a host path that does not exist there.
const files = spawnSync('git', ['ls-files', '-z', '--cached', '--others', '--exclude-standard'], {
  cwd: repo,
  encoding: 'buffer',
  maxBuffer: 64 * 1024 * 1024,
});
if (files.status !== 0) process.exit(files.status ?? 1);

const forwarded = process.argv.slice(2).map((arg) => `'${arg.replaceAll("'", "'\\''")}'`);
const golden = 'packages/core_ui/test/golden';
// On Linux and macOS the copies go back owned by the host user, not root.
const owner = process.getuid ? `${process.getuid()}:${process.getgid()}` : '';
const script = [
  'set -e',
  'mkdir /work',
  'cd /repo',
  'tar --null --files-from - --create --file - | tar --extract --file - --directory /work',
  'cp -r /repo/.fonts /work/.fonts',
  'cd /work',
  'flutter pub get --enforce-lockfile >/dev/null',
  'cd packages/core_ui',
  'status=0',
  `flutter test --tags golden --run-skipped ${forwarded.join(' ')} || status=$?`,
  // Copy first, then swap, so a failed copy never removes the baselines.
  'rm -rf /out/goldens.new /out/failures',
  `cp -r /work/${golden}/goldens /out/goldens.new`,
  'rm -rf /out/goldens && mv /out/goldens.new /out/goldens',
  `if [ -d /work/${golden}/failures ]; then cp -r /work/${golden}/failures /out/failures; fi`,
  owner ? `chown -R ${owner} /out/goldens /out/failures 2>/dev/null || true` : 'true',
  'exit $status',
].join('\n');

run(
  [
    'run',
    '--rm',
    '--interactive',
    '-v',
    `${repo}:/repo:ro`,
    '-v',
    `${resolve(repo, golden)}:/out`,
    '-v',
    'fd-golden-pub-cache:/root/.pub-cache',
    tag,
    'sh',
    '-c',
    script,
  ],
  { input: files.stdout, stdio: ['pipe', 'inherit', 'inherit'] },
);
