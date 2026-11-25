import { Valkey } from 'iovalkey';
import { inject } from 'vitest';

export interface TestValkey {
  url: string;
  stop(): Promise<void>;
}

declare module 'vitest' {
  export interface ProvidedContext {
    // Where the run's global setup hands out the workers' Valkeys.
    testValkeys: string;
  }
}

// One Valkey per Vitest worker slot, not per test file: a slot runs one file
// at a time, so a file still has an instance to itself while it runs, and the
// run starts as many containers as slots that asked for one (at most
// maxWorkers) instead of one for every file. The global setup starts them
// (src/valkey/test-valkey-slots.ts).
export const PASSWORD = 'test-valkey-password';

// The Valkey of this file's worker slot, emptied: the slot's earlier file
// has ended, and so are its connections (its process may still be exiting,
// so they are closed here) and its keys and scripts.
export async function startTestValkey(): Promise<TestValkey> {
  const slot = process.env.VITEST_POOL_ID ?? '1';
  const response = await fetch(`${inject('testValkeys')}/slots/${slot}`);
  const url = await response.text();
  if (!response.ok) throw new Error(`no Valkey for worker slot ${slot}: ${url}`);
  const valkey = new Valkey(url);
  try {
    await valkey.call('CLIENT', 'KILL', 'TYPE', 'normal');
    await valkey.call('CLIENT', 'KILL', 'TYPE', 'pubsub');
    await valkey.flushall();
    await valkey.script('FLUSH');
  } finally {
    valkey.disconnect();
  }
  return {
    url,
    // The global setup stops it after the run; the slot's next file empties it.
    stop: () => Promise.resolve(),
  };
}
