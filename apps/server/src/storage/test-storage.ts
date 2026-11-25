import { randomBytes } from 'node:crypto';
import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { GenericContainer, Wait } from 'testcontainers';
import { inject } from 'vitest';
import { setUpStorage, type StorageKey } from './storage-setup.js';

export interface TestStorage {
  // The S3 API, such as http://127.0.0.1:49153.
  url: string;
  adminUrl: string;
  // The website endpoint, which serves public-maps to a request whose Host
  // is the bucket's name.
  webUrl: string;
  adminToken: string;
  // The server's key (read and write) and the reader key (read only).
  key: StorageKey;
  reader: StorageKey;
  // The nightly copy's: reads both buckets, writes none.
  backup: StorageKey;
  stop(): Promise<void>;
}

// A fresh Garage for a test, the image and configuration compose.yaml runs,
// set up as `storage:setup` sets up the local one. Needs Docker.
const root = new URL('../../../../', import.meta.url);
const composeFile = readFileSync(new URL('compose.yaml', root), 'utf8');
const image = /image: (dxflrs\/garage:\S+)/.exec(composeFile)?.[1];
if (!image) throw new Error('compose.yaml has no garage image');
const garageImage: string = image;

const hex = (bytes: number) => randomBytes(bytes).toString('hex');

export async function startTestStorage(): Promise<TestStorage> {
  const adminToken = hex(16);
  const container = await new GenericContainer(garageImage)
    .withLabels(inject('testRun'))
    .withEnvironment({ GARAGE_RPC_SECRET: hex(32), GARAGE_ADMIN_TOKEN: adminToken })
    .withCopyFilesToContainer([
      {
        source: fileURLToPath(new URL('infra/storage/garage.toml', root)),
        target: '/etc/garage.toml',
      },
    ])
    .withExposedPorts(3900, 3902, 3903)
    .withWaitStrategy(Wait.forLogMessage(/Admin API server listening/))
    .start();
  const address = (port: number) =>
    `http://${container.getHost()}:${container.getMappedPort(port)}`;
  const key = { id: `GK${hex(12)}`, secret: hex(32), name: 'server', write: true };
  const reader = { id: `GK${hex(12)}`, secret: hex(32), name: 'reader', write: false };
  const backup = {
    id: `GK${hex(12)}`,
    secret: hex(32),
    name: 'backup',
    write: false,
    readsPrivate: true,
  };
  const storage = {
    url: address(3900),
    adminUrl: address(3903),
    webUrl: address(3902),
    adminToken,
    key,
    reader,
    backup,
    stop: async () => {
      await container.stop();
    },
  };
  await setUpStorage({ adminUrl: storage.adminUrl, adminToken, keys: [key, reader, backup] });
  return storage;
}
