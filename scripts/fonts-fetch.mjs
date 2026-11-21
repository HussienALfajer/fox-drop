// `pnpm fonts:fetch`: copies the licensed fonts from their private repository
// into .fonts/ and checks every file against docs/brand/fonts-manifest.json.
// Locally it uses your git credentials (gh auth setup-git); in CI the
// FONTS_REPO_TOKEN secret, a read-only token for that repository only.
import { spawnSync } from 'node:child_process';
import { cpSync, mkdirSync, mkdtempSync, rmSync } from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import { missingOrChanged, readManifest } from './fonts.mjs';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const target = path.join(root, '.fonts');
const manifest = readManifest();

// The token goes to git through its environment, for github.com only: not in the
// URL and not in the arguments, which a process list shows.
function gitEnv(auth) {
  const env = { ...process.env, GIT_TERMINAL_PROMPT: '0' };
  if (auth && process.env.FONTS_REPO_TOKEN) {
    const basic = Buffer.from(`x-access-token:${process.env.FONTS_REPO_TOKEN}`).toString('base64');
    env.GIT_CONFIG_COUNT = '1';
    env.GIT_CONFIG_KEY_0 = 'http.https://github.com/.extraheader';
    env.GIT_CONFIG_VALUE_0 = `AUTHORIZATION: basic ${basic}`;
  }
  return env;
}

function git(args, { auth = false } = {}) {
  const result = spawnSync('git', args, { encoding: 'utf8', env: gitEnv(auth) });
  if (result.status !== 0) {
    throw new Error(
      `git ${args[0]} failed.\n${result.stderr.replace(/AUTHORIZATION: basic \S+/g, '***')}`,
    );
  }
}

function fetchFonts() {
  const scratch = mkdtempSync(path.join(os.tmpdir(), 'fox-drop-fonts-'));
  try {
    const checkout = path.join(scratch, 'repo');
    git(
      [
        'clone',
        '--quiet',
        '--no-checkout',
        `https://github.com/${manifest.repository}.git`,
        checkout,
      ],
      {
        auth: true,
      },
    );
    git(['-C', checkout, 'checkout', '--quiet', manifest.ref]);
    for (const file of manifest.files) {
      const to = path.join(target, file.path);
      mkdirSync(path.dirname(to), { recursive: true });
      cpSync(path.join(checkout, file.path), to);
    }
  } finally {
    rmSync(scratch, { recursive: true, force: true });
  }
}

if (missingOrChanged(target, manifest.files).length === 0) {
  console.log(`fonts: ${manifest.files.length} files already in .fonts/, nothing to fetch.`);
} else {
  try {
    fetchFonts();
  } catch (error) {
    console.error(`fonts: ${error.message}`);
    process.exit(1);
  }
  const bad = missingOrChanged(target, manifest.files);
  if (bad.length > 0) {
    console.error(`fonts: these files do not match the manifest: ${bad.join(', ')}`);
    process.exit(1);
  }
  console.log(`fonts: ${manifest.files.length} files in .fonts/, checked against the manifest.`);
}
