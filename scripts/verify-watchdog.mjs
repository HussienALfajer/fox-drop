// The watchdog of one local verify run (scripts/verify.mjs starts it, detached,
// outside the run's own process tree):
//
//   node scripts/verify-watchdog.mjs <verify pid> <state file>
//
// On Windows, Node starts each child in a job that ends it with its parent,
// so a hard kill of the process that started verify (the Stop hook at its
// time limit, a closed tool call) kills verify at once, before it can end its
// steps; the steps' own children (pnpm, Vitest, a browser, the Dart analyzer)
// are outside that job and live on as orphans. The watchdog notices verify is
// gone and ends what its steps started: verify keeps the ids of its running
// steps in the state file. A verify that ends normally ends its steps itself
// and removes the file; the watchdog then has nothing to do.
import { existsSync, readFileSync, rmSync } from 'node:fs';

import {
  descendants,
  killTrees,
  processAlive,
  releaseLock,
  windowsProcessTable,
} from './verify-support.mjs';

const [verifyPid, stateFile] = [Number(process.argv[2]), process.argv[3]];

function reap() {
  if (!existsSync(stateFile)) return;
  let state;
  try {
    state = JSON.parse(readFileSync(stateFile, 'utf8'));
  } catch {
    return;
  }
  if (state.pid !== verifyPid) return;
  // On POSIX each step is a process group of its own.
  killTrees(
    process.platform === 'win32'
      ? descendants(windowsProcessTable(), state.steps, state.started)
      : state.steps,
  );
  rmSync(stateFile, { force: true });
  // The next check would take the stale lock over; release it now.
  if (state.lock) releaseLock(state.lock, verifyPid);
}

const timer = setInterval(() => {
  if (processAlive(verifyPid)) return;
  clearInterval(timer);
  reap();
}, 1000);
