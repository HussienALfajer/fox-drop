import { z } from 'zod';

// The public bucket (architecture §5.8): menu photos, logos and covers,
// served through imgproxy. private-docs joins with its first use (2.34).
export const PUBLIC_MEDIA_BUCKET = 'public-media';

export interface StorageKey {
  id: string;
  secret: string;
  name: string;
  // What the key may do on public-media.
  write: boolean;
}

export interface StorageSetupOptions {
  adminUrl: string;
  adminToken: string;
  keys: StorageKey[];
  // How long to wait for Garage's admin API to answer, in milliseconds.
  waitMs?: number;
}

// Garage's partition weight for its only node. With one node and one copy it
// only has to be above zero; it limits nothing.
const NODE_CAPACITY_BYTES = 100 * 1024 ** 3;

const clusterStatus = z.object({
  layoutVersion: z.number(),
  nodes: z.array(z.object({ id: z.string() })).min(1),
});
const keyInfo = z.object({ secretAccessKey: z.string().nullable().optional() });
const bucketInfo = z.object({ id: z.string() });

class AdminApiError extends Error {
  constructor(
    readonly status: number,
    readonly code: string,
    path: string,
  ) {
    super(`Garage's admin API answered ${status} ${code} to ${path}`);
  }
}

// Sets up Garage for FOX DROP through its admin API (v2), safe to run again:
// the one-node layout, each key imported with its fixed ID and secret (from
// the environment, so nothing is printed or stored here), the public-media
// bucket and each key's rights on it. Run by `storage:setup` in development
// and by the deploy on the server (infra/server/deploy.sh).
export async function setUpStorage(options: StorageSetupOptions): Promise<void> {
  const admin = adminApi(options.adminUrl, options.adminToken);
  const status = clusterStatus.parse(await waitForAdmin(admin, options.waitMs ?? 60_000));

  if (status.layoutVersion === 0) {
    await admin.post('UpdateClusterLayout', {
      roles: status.nodes.map((node) => ({
        id: node.id,
        zone: 'local',
        capacity: NODE_CAPACITY_BYTES,
        tags: [],
      })),
    });
    await admin.post('ApplyClusterLayout', { version: 1 });
  }

  for (const key of options.keys) {
    const existing = await admin.getOrNull(
      `GetKeyInfo?id=${encodeURIComponent(key.id)}&showSecretKey=true`,
    );
    if (existing === null) {
      await admin.post('ImportKey', {
        accessKeyId: key.id,
        secretAccessKey: key.secret,
        name: key.name,
      });
    } else if (keyInfo.parse(existing).secretAccessKey !== key.secret) {
      // Garage never changes a key's secret, nor reuses a deleted key's ID.
      throw new Error(`the storage key ${key.name} exists with another secret: give it a new ID`);
    }
  }

  let bucket = await admin.getOrNull(`GetBucketInfo?globalAlias=${PUBLIC_MEDIA_BUCKET}`);
  bucket ??= await admin.post('CreateBucket', { globalAlias: PUBLIC_MEDIA_BUCKET });
  const bucketId = bucketInfo.parse(bucket).id;

  for (const key of options.keys) {
    const rights = { bucketId, accessKeyId: key.id };
    await admin.post('AllowBucketKey', {
      ...rights,
      permissions: { read: true, write: key.write, owner: false },
    });
    // Takes back what an earlier setup may have given.
    await admin.post('DenyBucketKey', {
      ...rights,
      permissions: { read: false, write: !key.write, owner: true },
    });
  }
}

function adminApi(url: string, token: string) {
  const base = `${url.replace(/\/+$/, '')}/v2/`;
  const call = async (path: string, init: RequestInit = {}) => {
    const response = await fetch(base + path, {
      ...init,
      headers: { authorization: `Bearer ${token}`, 'content-type': 'application/json' },
      signal: AbortSignal.timeout(10_000),
    });
    const body: unknown = await response.json().catch(() => null);
    if (!response.ok) {
      const code = z.object({ code: z.string() }).safeParse(body);
      throw new AdminApiError(response.status, code.success ? code.data.code : 'unknown', path);
    }
    return body;
  };
  return {
    get: (path: string) => call(path),
    // A missing key or bucket answers 404.
    getOrNull: async (path: string) => {
      try {
        return await call(path);
      } catch (error) {
        if (error instanceof AdminApiError && error.status === 404) return null;
        throw error;
      }
    },
    post: (path: string, body: object) =>
      call(path, { method: 'POST', body: JSON.stringify(body) }),
  };
}

// Garage starts in a second or two; a wrong token fails at once.
async function waitForAdmin(admin: ReturnType<typeof adminApi>, waitMs: number) {
  const until = Date.now() + waitMs;
  for (;;) {
    try {
      return await admin.get('GetClusterStatus');
    } catch (error) {
      if (error instanceof AdminApiError || Date.now() > until) throw error;
      await new Promise((resolve) => setTimeout(resolve, 500));
    }
  }
}

// The setup's options from the environment: STORAGE_ADMIN_URL,
// GARAGE_ADMIN_TOKEN, the server's key (STORAGE_KEY_ID, STORAGE_SECRET) and
// imgproxy's and the backups' reader key (STORAGE_READER_KEY_ID,
// STORAGE_READER_SECRET).
export function storageSetupFromEnvironment(
  env: NodeJS.ProcessEnv = process.env,
): StorageSetupOptions {
  const value = (name: string) => {
    const found = env[name];
    if (!found) throw new Error(`${name} is not set`);
    return found;
  };
  return {
    adminUrl: value('STORAGE_ADMIN_URL'),
    adminToken: value('GARAGE_ADMIN_TOKEN'),
    keys: [
      { id: value('STORAGE_KEY_ID'), secret: value('STORAGE_SECRET'), name: 'server', write: true },
      {
        id: value('STORAGE_READER_KEY_ID'),
        secret: value('STORAGE_READER_SECRET'),
        name: 'reader',
        write: false,
      },
    ],
  };
}
