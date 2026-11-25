import { readFileSync } from 'node:fs';
import { createServer } from 'node:http';
import type { AddressInfo } from 'node:net';
import { ValkeyContainer, type StartedValkeyContainer } from '@testcontainers/valkey';
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
// maxWorkers) instead of one for every file. The image is compose.yaml's.
// Needs Docker.
const composeFile = readFileSync(new URL('../../../../compose.yaml', import.meta.url), 'utf8');
const image = /image: (valkey\/valkey:\S+)/.exec(composeFile)?.[1];
if (!image) throw new Error('compose.yaml has no valkey image');
const valkeyImage: string = image;
const PASSWORD = 'test-valkey-password';

// The global setup's half (src/database/test-postgres.global-setup.ts): a
// local HTTP endpoint that starts a slot's Valkey on its first request and
// answers its URL; stop() stops them all at the end of the run.
export async function serveTestValkeys(
  labels: Record<string, string>,
): Promise<{ url: string; stop(): Promise<void> }> {
  const slots = new Map<string, Promise<StartedValkeyContainer>>();
  const start = (slot: string) => {
    let started = slots.get(slot);
    if (!started) {
      started = new ValkeyContainer(valkeyImage).withPassword(PASSWORD).withLabels(labels).start();
      // A failed start is tried again by the slot's next file.
      started.catch(() => slots.delete(slot));
      slots.set(slot, started);
    }
    return started;
  };
  const server = createServer((request, response) => {
    const slot = /^\/slots\/(\d+)$/.exec(request.url ?? '')?.[1];
    if (!slot) {
      response.writeHead(404).end();
      return;
    }
    start(slot).then(
      (container) => response.end(container.getConnectionUrl()),
      (error: unknown) => response.writeHead(500).end(String(error)),
    );
  });
  await new Promise<void>((resolve) => server.listen(0, '127.0.0.1', resolve));
  const { port } = server.address() as AddressInfo;
  return {
    url: `http://127.0.0.1:${port}`,
    stop: async () => {
      await new Promise((resolve) => server.close(resolve));
      const started = await Promise.allSettled(slots.values());
      await Promise.all(
        started.map((each) => (each.status === 'fulfilled' ? each.value.stop() : undefined)),
      );
    },
  };
}

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
