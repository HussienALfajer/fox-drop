// Runs the core_ui golden tests (R9) on Linux in Docker, the only place their
// baselines are valid: the same image locally and in the CI `golden` job.
// No Flutter image exists for the pinned version, so the image is the pinned
// Ubuntu with the .fvmrc Flutter cloned into it (built once, then cached).
// The repository is mounted read-only and copied into the container (its
// tracked and untracked files, not ignored ones, plus .fonts/), so a Linux
// `pub get` never rewrites the host's .dart_tool; only the goldens and the
// failure images come back. Arguments pass to `flutter test`:
// `node scripts/golden-docker.mjs --update-goldens`.
import { spawnSync } from 'node:child_process';
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

run(['build', '--tag', image, '-'], { input: dockerfile, stdio: ['pipe', 'inherit', 'inherit'] });

const forwarded = process.argv.slice(2).map((arg) => `'${arg.replaceAll("'", "'\\''")}'`);
const golden = 'packages/core_ui/test/golden';
const script = [
  'set -e',
  'mkdir /work',
  'cd /repo',
  'git ls-files -z --cached --others --exclude-standard | tar --null --files-from - --create --file - | tar --extract --file - --directory /work',
  'cp -r /repo/.fonts /work/.fonts',
  'cd /work',
  'flutter pub get --enforce-lockfile >/dev/null',
  'cd packages/core_ui',
  'status=0',
  `flutter test --tags golden --run-skipped ${forwarded.join(' ')} || status=$?`,
  `rm -rf /out/goldens /out/failures`,
  `cp -r /work/${golden}/goldens /out/goldens`,
  `if [ -d /work/${golden}/failures ]; then cp -r /work/${golden}/failures /out/failures; fi`,
  'exit $status',
].join('\n');

run([
  'run',
  '--rm',
  '-v',
  `${repo}:/repo:ro`,
  '-v',
  `${resolve(repo, golden)}:/out`,
  '-v',
  'fd-golden-pub-cache:/root/.pub-cache',
  image,
  'sh',
  '-c',
  script,
]);
