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
  killProcesses,
  killTrees,
  processAlive,
  releaseLock,
  windowsProcessTable,
} from './verify-support.mjs';

const [verifyPid, stateFile] = [Number(process.argv[2]), process.argv[3]];
// When verify was last seen alive: no process started after it is the run's,
// unless one of the run's own processes started it.
let lastAlive = Date.now();

function reap() {
  if (!existsSync(stateFile)) return;
  let state;
  try {
    state = JSON.parse(readFileSync(stateFile, 'utf8'));
  } catch {
    return;
  }
  if (state.pid !== verifyPid) return;
  if (process.platform === 'win32') {
    // Each process by itself (no /T: Windows' own tree walk trusts reused ids).
    killProcesses(
      descendants(
        windowsProcessTable(),
        state.steps,
        state.started,
        Math.max(lastAlive, state.alive ?? 0),
      ),
    );
  } else {
    // Each step is a process group of its own.
    killTrees(state.steps);
  }
  rmSync(stateFile, { force: true });
  // The next check would take the stale lock over; release it now.
  if (state.lock) releaseLock(state.lock, verifyPid);
}

const timer = setInterval(() => {
  if (processAlive(verifyPid)) {
    lastAlive = Date.now();
    return;
  }
  clearInterval(timer);
  reap();
}, 250);
