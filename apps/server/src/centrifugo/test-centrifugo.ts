import { randomBytes } from 'node:crypto';
import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { GenericContainer, TestContainers, Wait } from 'testcontainers';

export interface TestCentrifugo {
  // The variables the server reads (realtime-config.ts in notifications).
  env: {
    CENTRIFUGO_API_URL: string;
    CENTRIFUGO_API_KEY: string;
    CENTRIFUGO_TOKEN_SECRET: string;
    CENTRIFUGO_PROXY_SECRET: string;
  };
  websocketUrl: string;
  // The data of the channel's publications, oldest first.
  history(channel: string): Promise<unknown[]>;
  stop(): Promise<void>;
}

// A fresh Centrifugo for a test, the image compose.yaml runs with the
// channels of infra/centrifugo/config.yaml. With apiPort, its subscription
// proxies call the API listening on that port of this machine. Needs Docker.
const composeFile = readFileSync(new URL('../../../../compose.yaml', import.meta.url), 'utf8');
const image = /image: (centrifugo\/centrifugo:\S+)/.exec(composeFile)?.[1];
if (!image) throw new Error('compose.yaml has no centrifugo image');
const centrifugoImage: string = image;
const configFile = fileURLToPath(
  new URL('../../../../infra/centrifugo/config.yaml', import.meta.url),
);

export async function startTestCentrifugo(
  options: { apiPort?: number; proxySecret?: string; tokenSecret?: string } = {},
): Promise<TestCentrifugo> {
  const apiKey = randomBytes(16).toString('hex');
  const tokenSecret = options.tokenSecret ?? randomBytes(32).toString('hex');
  const proxySecret = options.proxySecret ?? randomBytes(32).toString('hex');
  let api = 'http://127.0.0.1:1';
  if (options.apiPort !== undefined) {
    await TestContainers.exposeHostPorts(options.apiPort);
    api = `http://host.testcontainers.internal:${options.apiPort}`;
  }
  const proxy = (name: string, group: string) => ({
    name,
    endpoint: `${api}/v1/${group}/realtime/subscribe`,
    timeout: '3s',
    include_connection_meta: true,
    http: { static_headers: { 'X-Centrifugo-Proxy-Secret': proxySecret } },
  });
  const container = await new GenericContainer(centrifugoImage)
    .withCopyFilesToContainer([{ source: configFile, target: '/centrifugo/config.yaml' }])
    .withCommand(['centrifugo', '--config', '/centrifugo/config.yaml'])
    .withEnvironment({
      CENTRIFUGO_CLIENT_TOKEN_HMAC_SECRET_KEY: tokenSecret,
      CENTRIFUGO_HTTP_API_KEY: apiKey,
      CENTRIFUGO_PROXIES: JSON.stringify([
        proxy('merchant', 'merchant'),
        proxy('customer', 'customer'),
        proxy('captain', 'captain'),
      ]),
    })
    .withExposedPorts(8000)
    .withWaitStrategy(Wait.forLogMessage(/serving websocket/))
    .start();
  const base = `${container.getHost()}:${container.getMappedPort(8000)}`;
  const apiUrl = `http://${base}/api`;
  return {
    env: {
      CENTRIFUGO_API_URL: apiUrl,
      CENTRIFUGO_API_KEY: apiKey,
      CENTRIFUGO_TOKEN_SECRET: tokenSecret,
      CENTRIFUGO_PROXY_SECRET: proxySecret,
    },
    websocketUrl: `ws://${base}/connection/websocket`,
    history: async (channel) => {
      const response = await fetch(`${apiUrl}/history`, {
        method: 'POST',
        headers: { 'content-type': 'application/json', 'x-api-key': apiKey },
        body: JSON.stringify({ channel, limit: 100 }),
      });
      const reply = (await response.json()) as {
        result?: { publications?: { data: unknown }[] };
      };
      return (reply.result?.publications ?? []).map((publication) => publication.data);
    },
    stop: async () => {
      await container.stop();
    },
  };
}
