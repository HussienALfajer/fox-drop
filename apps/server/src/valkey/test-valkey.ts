import { readFileSync } from 'node:fs';
import { ValkeyContainer } from '@testcontainers/valkey';

export interface TestValkey {
  url: string;
  stop(): Promise<void>;
}

// A fresh Valkey for a test, the image compose.yaml runs. Needs Docker.
const composeFile = readFileSync(new URL('../../../../compose.yaml', import.meta.url), 'utf8');
const image = /image: (valkey\/valkey:\S+)/.exec(composeFile)?.[1];
if (!image) throw new Error('compose.yaml has no valkey image');
const valkeyImage: string = image;

export async function startTestValkey(): Promise<TestValkey> {
  const container = await new ValkeyContainer(valkeyImage)
    .withPassword('test-valkey-password')
    .start();
  return {
    url: container.getConnectionUrl(),
    stop: async () => {
      await container.stop();
    },
  };
}
