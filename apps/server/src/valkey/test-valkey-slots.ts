import { readFileSync } from 'node:fs';
import { createServer } from 'node:http';
import type { AddressInfo } from 'node:net';
import { ValkeyContainer, type StartedValkeyContainer } from '@testcontainers/valkey';
import { PASSWORD } from './test-valkey.js';

// The global setup's half of src/valkey/test-valkey.ts (only
// src/database/test-postgres.global-setup.ts imports it, so a test file's
// worker never loads Testcontainers): a local HTTP endpoint that starts a
// slot's Valkey on its first request and answers its URL; stop() stops them
// all at the end of the run. The image is compose.yaml's. Needs Docker.
const composeFile = readFileSync(new URL('../../../../compose.yaml', import.meta.url), 'utf8');
const image = /image: (valkey\/valkey:\S+)/.exec(composeFile)?.[1];
if (!image) throw new Error('compose.yaml has no valkey image');
const valkeyImage: string = image;

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
