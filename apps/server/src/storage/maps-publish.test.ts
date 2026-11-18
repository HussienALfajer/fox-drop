import { request } from 'node:http';
import { mkdir, mkdtemp, rm, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { publishMaps } from './maps-publish.js';
import { PUBLIC_MAPS_BUCKET } from './storage-setup.js';
import { startTestStorage, type TestStorage } from './test-storage.js';

// The map's publishing and serving (architecture §7.2) on a real Garage: the
// build's files and the style reach public-maps, and the website endpoint
// serves them to nginx's /maps/ (Host: public-maps) with range requests,
// which PMTiles reads by.
let storage: TestStorage;
let dir: string;
const tiles = Buffer.from(Array.from({ length: 256 }, (_, index) => index));

beforeAll(async () => {
  storage = await startTestStorage();
  dir = await mkdtemp(join(tmpdir(), 'maps-'));
  await mkdir(join(dir, '20261118', 'fonts', 'Noto Sans Regular'), { recursive: true });
  await writeFile(join(dir, '20261118', 'region.pmtiles'), tiles);
  await writeFile(join(dir, '20261118', 'fonts', 'Noto Sans Regular', '1536-1791.pbf'), 'glyphs');
  await writeFile(
    join(dir, 'style.json'),
    JSON.stringify({ glyphs: '{{MAPS_URL}}/20261118/fonts/{fontstack}/{range}.pbf' }),
  );
}, 300_000);

afterAll(async () => {
  await storage?.stop();
  if (dir) await rm(dir, { recursive: true, force: true });
});

interface Answer {
  status: number;
  headers: Record<string, string | string[] | undefined>;
  body: Buffer;
}

// node:http, since fetch never sends a Host of its own.
function get(path: string, headers: Record<string, string> = {}, host = PUBLIC_MAPS_BUCKET) {
  return new Promise<Answer>((resolve, reject) => {
    const req = request(`${storage.webUrl}${path}`, { headers: { ...headers, host } }, (res) => {
      const chunks: Buffer[] = [];
      res.on('data', (chunk: Buffer) => chunks.push(chunk));
      res.on('end', () =>
        resolve({ status: res.statusCode ?? 0, headers: res.headers, body: Buffer.concat(chunks) }),
      );
    });
    req.on('error', reject);
    req.end();
  });
}

const publish = (mapsUrl = 'https://api.example.test/maps/') =>
  publishMaps({
    dir,
    mapsUrl,
    storageUrl: storage.url,
    keyId: storage.key.id,
    secret: storage.key.secret,
  });

describe('publishMaps', () => {
  it('publishes the style with the environment address, cached for minutes', async () => {
    expect(await publish()).toBe(3);
    const style = await get('/style.json');
    expect(style.status).toBe(200);
    expect(JSON.parse(style.body.toString())).toEqual({
      glyphs: 'https://api.example.test/maps/20261118/fonts/{fontstack}/{range}.pbf',
    });
    expect(style.headers['content-type']).toBe('application/json');
    expect(style.headers['cache-control']).toBe('public, max-age=300');
  });

  it('serves the tiles by range, cached for a year', async () => {
    await publish();
    const part = await get('/20261118/region.pmtiles', { range: 'bytes=16-31' });
    expect(part.status).toBe(206);
    expect(part.body).toEqual(tiles.subarray(16, 32));
    expect(part.headers['cache-control']).toBe('public, max-age=31536000, immutable');
    const glyphs = await get('/20261118/fonts/Noto%20Sans%20Regular/1536-1791.pbf');
    expect(glyphs.status).toBe(200);
    expect(glyphs.headers['content-type']).toBe('application/x-protobuf');
  });

  it('serves no other bucket', async () => {
    expect((await get('/style.json', {}, 'public-media')).status).not.toBe(200);
    expect((await get('/style.json', {}, 'private-docs')).status).not.toBe(200);
  });

  it('refuses a style with a placeholder left', async () => {
    await writeFile(join(dir, 'style.json'), '{"sprite":"{{BUILD}}/sprites/light"}');
    await expect(publish()).rejects.toThrow('placeholder left');
  });
});
