// Writes GitHub's SSH host keys to ~/.ssh/known_hosts, so `pnpm fonts:fetch` can
// clone over SSH with strict host key checking (never `no` or `accept-new`).
// The keys come from GitHub's API over TLS (https://api.github.com/meta,
// `ssh_keys`), the published source of GitHub's host keys.
import { appendFileSync, mkdirSync } from 'node:fs';
import os from 'node:os';
import path from 'node:path';

const response = await fetch('https://api.github.com/meta', {
  headers: { 'User-Agent': 'ci', Accept: 'application/vnd.github+json' },
});
if (!response.ok) throw new Error(`api.github.com/meta answered ${response.status}`);
const { ssh_keys: keys } = await response.json();
if (!Array.isArray(keys) || keys.length === 0)
  throw new Error('api.github.com/meta has no ssh_keys');

const dir = path.join(os.homedir(), '.ssh');
mkdirSync(dir, { recursive: true, mode: 0o700 });
appendFileSync(path.join(dir, 'known_hosts'), keys.map((key) => `github.com ${key}\n`).join(''), {
  mode: 0o600,
});
console.log(`known_hosts: ${keys.length} GitHub host keys.`);
