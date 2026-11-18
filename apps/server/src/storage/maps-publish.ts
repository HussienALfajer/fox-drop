import { createReadStream } from 'node:fs';
import { readdir, readFile, stat } from 'node:fs/promises';
import { extname, join, relative, sep } from 'node:path';
import { PutObjectCommand, S3Client } from '@aws-sdk/client-s3';
import { PUBLIC_MAPS_BUCKET } from './storage-setup.js';

// The style names the map's public address as {{MAPS_URL}} (infra/maps/
// style.json); publishing writes the environment's in its place.
const MAPS_URL_PLACEHOLDER = '{{MAPS_URL}}';
const STYLE = 'style.json';

const CONTENT_TYPES: Record<string, string> = {
  '.json': 'application/json',
  '.pbf': 'application/x-protobuf',
  '.png': 'image/png',
  '.pmtiles': 'application/vnd.pmtiles',
};

// Everything but the style sits under its build's folder and never changes,
// so the phones keep it a year; the style names the newest build and changes
// with each one.
const IMMUTABLE = 'public, max-age=31536000, immutable';
const STYLE_CACHE = 'public, max-age=300';

export interface MapsPublishOptions {
  // The folder infra/maps/build.sh filled: style.json and the build's folder.
  dir: string;
  // The map's public address, such as https://<api host>/maps.
  mapsUrl: string;
  storageUrl: string;
  keyId: string;
  secret: string;
}

// Uploads a map build to public-maps (architecture §7.2): each file of the
// build's folder, then the style with the environment's address, last, so it
// never names a file that is not there yet. Older builds stay; they are a few
// megabytes. Run by `run --rm maps-publish` (infra/server/maps-build.sh).
export async function publishMaps(options: MapsPublishOptions): Promise<number> {
  const mapsUrl = new URL(options.mapsUrl).href.replace(/\/+$/, '');
  const style = (await readFile(join(options.dir, STYLE), 'utf8')).replaceAll(
    MAPS_URL_PLACEHOLDER,
    mapsUrl,
  );
  if (style.includes('{{')) throw new Error(`${STYLE} has a placeholder left`);
  const files = (await filesUnder(options.dir)).filter((file) => file !== STYLE);
  if (files.length === 0) throw new Error(`no map build in ${options.dir}`);

  const s3 = new S3Client({
    endpoint: options.storageUrl,
    region: 'garage',
    forcePathStyle: true,
    credentials: { accessKeyId: options.keyId, secretAccessKey: options.secret },
  });
  try {
    for (const file of files) {
      const contentType = CONTENT_TYPES[extname(file)];
      if (!contentType) throw new Error(`unexpected file in the map build: ${file}`);
      const path = join(options.dir, file);
      await s3.send(
        new PutObjectCommand({
          Bucket: PUBLIC_MAPS_BUCKET,
          Key: file,
          Body: createReadStream(path),
          ContentLength: (await stat(path)).size,
          ContentType: contentType,
          CacheControl: IMMUTABLE,
        }),
      );
    }
    await s3.send(
      new PutObjectCommand({
        Bucket: PUBLIC_MAPS_BUCKET,
        Key: STYLE,
        Body: style,
        ContentType: CONTENT_TYPES['.json'],
        CacheControl: STYLE_CACHE,
      }),
    );
  } finally {
    s3.destroy();
  }
  return files.length + 1;
}

// The files under [dir] as keys: relative, with forward slashes.
async function filesUnder(dir: string): Promise<string[]> {
  const entries = await readdir(dir, { recursive: true, withFileTypes: true });
  return entries
    .filter((entry) => entry.isFile())
    .map((entry) => relative(dir, join(entry.parentPath, entry.name)).split(sep).join('/'))
    .sort();
}

// The options from the environment: MAPS_DIR, MAPS_URL, STORAGE_URL and the
// server's key (STORAGE_KEY_ID, STORAGE_SECRET).
export function mapsPublishFromEnvironment(env: NodeJS.ProcessEnv = process.env) {
  const value = (name: string) => {
    const found = env[name];
    if (!found) throw new Error(`${name} is not set`);
    return found;
  };
  return {
    dir: value('MAPS_DIR'),
    mapsUrl: value('MAPS_URL'),
    storageUrl: value('STORAGE_URL'),
    keyId: value('STORAGE_KEY_ID'),
    secret: value('STORAGE_SECRET'),
  } satisfies MapsPublishOptions;
}
