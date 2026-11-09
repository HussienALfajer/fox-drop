import { GetObjectCommand, PutObjectCommand, S3Client } from '@aws-sdk/client-s3';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { PUBLIC_MEDIA_BUCKET, setUpStorage, type StorageKey } from './storage-setup.js';
import { startTestStorage, type TestStorage } from './test-storage.js';

// The storage setup (architecture §5.8) on a real Garage: the layout, the two
// keys and their rights on public-media, and running it again.
let storage: TestStorage;

beforeAll(async () => {
  storage = await startTestStorage();
}, 300_000);

afterAll(async () => {
  await storage?.stop();
});

function client(key: StorageKey) {
  return new S3Client({
    endpoint: storage.url,
    region: 'garage',
    forcePathStyle: true,
    credentials: { accessKeyId: key.id, secretAccessKey: key.secret },
  });
}

const put = (key: StorageKey, name: string) =>
  client(key).send(new PutObjectCommand({ Bucket: PUBLIC_MEDIA_BUCKET, Key: name, Body: 'image' }));

describe('setUpStorage', () => {
  it('lets the server write and the reader only read', async () => {
    await put(storage.key, 'test/one.txt');
    const read = await client(storage.reader).send(
      new GetObjectCommand({ Bucket: PUBLIC_MEDIA_BUCKET, Key: 'test/one.txt' }),
    );
    expect(await read.Body?.transformToString()).toBe('image');
    await expect(put(storage.reader, 'test/two.txt')).rejects.toThrow();
  });

  it('runs again without changing anything', async () => {
    const options = {
      adminUrl: storage.adminUrl,
      adminToken: storage.adminToken,
      keys: [storage.key, storage.reader],
    };
    await setUpStorage(options);
    await put(storage.key, 'test/three.txt');
    await expect(put(storage.reader, 'test/four.txt')).rejects.toThrow();
  });

  it('refuses a key whose secret changed', async () => {
    await expect(
      setUpStorage({
        adminUrl: storage.adminUrl,
        adminToken: storage.adminToken,
        keys: [{ ...storage.key, secret: '0'.repeat(64) }],
      }),
    ).rejects.toThrow('exists with another secret');
  });

  it('fails at once on a wrong admin token', async () => {
    await expect(
      setUpStorage({ adminUrl: storage.adminUrl, adminToken: 'wrong', keys: [] }),
    ).rejects.toThrow('403');
  });
});
