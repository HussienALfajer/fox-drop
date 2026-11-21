// `pnpm fonts:fetch`: copies the licensed fonts from their private repository
// into .fonts/ and checks every file against docs/brand/fonts-manifest.json.
// Locally it uses your git credentials (gh auth setup-git). In CI it uses
// FONTS_DEPLOY_KEY, the private half of a read-only deploy key of that
// repository: it never expires, and it opens that one repository only.
import { spawnSync } from 'node:child_process';
import { cpSync, mkdirSync, mkdtempSync, rmSync, writeFileSync } from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import { missingOrChanged, readManifest } from './fonts.mjs';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const target = path.join(root, '.fonts');
const manifest = readManifest();

function git(args, env = {}) {
  const result = spawnSync('git', args, {
    encoding: 'utf8',
    env: { ...process.env, GIT_TERMINAL_PROMPT: '0', ...env },
  });
  if (result.status !== 0) {
    throw new Error(`git ${args[0]} failed.\n${result.stderr}`);
  }
}

function fetchFonts() {
  const scratch = mkdtempSync(path.join(os.tmpdir(), 'fox-drop-fonts-'));
  try {
    const checkout = path.join(scratch, 'repo');
    let url = `https://github.com/${manifest.repository}.git`;
    let env = {};
    if (process.env.FONTS_DEPLOY_KEY) {
      // The key is written to a file only this process can read, inside the
      // scratch folder that is deleted below; ssh uses that key and no other.
      const key = path.join(scratch, 'deploy_key');
      const text = process.env.FONTS_DEPLOY_KEY.replaceAll('\r\n', '\n').trimEnd();
      writeFileSync(key, `${text}\n`, { mode: 0o600 });
      url = `git@github.com:${manifest.repository}.git`;
      env = {
        GIT_SSH_COMMAND: `ssh -i "${key.replaceAll('\\', '/')}" -o IdentitiesOnly=yes`,
      };
    }
    git(['clone', '--quiet', '--no-checkout', url, checkout], env);
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
