// Writes GitHub's SSH host keys to ~/.ssh/known_hosts, so `pnpm fonts:fetch` can
// clone over SSH with strict host key checking (never `no` or `accept-new`).
// The keys come from GitHub's API over TLS (https://api.github.com/meta,
// `ssh_keys`), the published source of GitHub's host keys.
import { appendFileSync, mkdirSync } from 'node:fs';
import os from 'node:os';
import path from 'node:path';

// With the job's GITHUB_TOKEN when CI passes it: an anonymous call shares the
// runner IP's rate limit and got 403 on a busy runner.
const token = process.env.GITHUB_TOKEN;
const response = await fetch('https://api.github.com/meta', {
  headers: {
    'User-Agent': 'ci',
    Accept: 'application/vnd.github+json',
    ...(token ? { Authorization: `Bearer ${token}` } : {}),
  },
});
if (!response.ok) throw new Error(`api.github.com/meta answered ${response.status}`);
const { ssh_keys: keys } = await response.json();
if (!Array.isArray(keys) || keys.length === 0)
  throw new Error('api.github.com/meta has no ssh_keys');

// An optional path argument: a container job passes /etc/ssh/ssh_known_hosts,
// since ssh reads the passwd home (/root), not the $HOME that os.homedir() sees.
const file = process.argv[2] ?? path.join(os.homedir(), '.ssh', 'known_hosts');
mkdirSync(path.dirname(file), { recursive: true, mode: 0o700 });
appendFileSync(file, keys.map((key) => `github.com ${key}\n`).join(''), { mode: 0o644 });
console.log(`${file}: ${keys.length} GitHub host keys.`);
