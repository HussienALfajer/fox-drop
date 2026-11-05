import { createServer, type IncomingMessage, type Server, type ServerResponse } from 'node:http';
import type { AddressInfo } from 'node:net';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { OsrmRoadDistances } from './osrm-road-distances.js';

// The OSRM adapter against a local HTTP server that answers as osrm-routed
// does (architecture §7.1).
const from = { latitude: 36.5866, longitude: 37.0463 };
const to = { latitude: 36.5901, longitude: 37.0518 };

let server: Server;
let baseUrl: string;
let handler: (request: IncomingMessage, response: ServerResponse) => void;
const paths: string[] = [];

beforeAll(async () => {
  server = createServer((request, response) => {
    paths.push(request.url ?? '');
    handler(request, response);
  });
  await new Promise<void>((resolve) => server.listen(0, '127.0.0.1', resolve));
  baseUrl = `http://127.0.0.1:${(server.address() as AddressInfo).port}`;
});

afterAll(async () => {
  server.closeAllConnections();
  await new Promise((resolve) => server.close(resolve));
});

function answer(status: number, body: unknown) {
  handler = (_request, response) => {
    response.writeHead(status, { 'content-type': 'application/json' });
    response.end(JSON.stringify(body));
  };
}

describe('OsrmRoadDistances', () => {
  it('reads the distance of the route OSRM answers, asking with longitude first', async () => {
    answer(200, { code: 'Ok', routes: [{ distance: 1834.7, duration: 201.3 }], waypoints: [] });
    const osrm = new OsrmRoadDistances({ car: baseUrl }, 1000);
    await expect(osrm.metres(from, to, 'car')).resolves.toBe(1834.7);
    expect(paths.at(-1)).toBe(
      '/route/v1/driving/37.0463,36.5866;37.0518,36.5901?overview=false&alternatives=false&steps=false',
    );
  });

  it('asks the server of the vehicle', async () => {
    answer(200, { code: 'Ok', routes: [{ distance: 1900, duration: 1400 }] });
    const osrm = new OsrmRoadDistances({ car: 'http://127.0.0.1:1', walking: baseUrl }, 1000);
    await expect(osrm.metres(from, to, 'walking')).resolves.toBe(1900);
  });

  it('fails when OSRM finds no route', async () => {
    answer(400, { code: 'NoRoute', message: 'Impossible route between points' });
    const osrm = new OsrmRoadDistances({ car: baseUrl }, 1000);
    await expect(osrm.metres(from, to, 'car')).rejects.toThrow('NoRoute');
  });

  it('fails when the answer is not a route', async () => {
    answer(200, { code: 'Ok', routes: [] });
    const osrm = new OsrmRoadDistances({ car: baseUrl }, 1000);
    await expect(osrm.metres(from, to, 'car')).rejects.toThrow();
  });

  it('gives up after its timeout', async () => {
    handler = () => {
      // Never answers.
    };
    const osrm = new OsrmRoadDistances({ car: baseUrl }, 100);
    const started = Date.now();
    await expect(osrm.metres(from, to, 'car')).rejects.toThrow();
    expect(Date.now() - started).toBeLessThan(1000);
  });

  it('fails at once for a vehicle without a server', async () => {
    const osrm = new OsrmRoadDistances({ car: baseUrl }, 1000);
    await expect(osrm.metres(from, to, 'bicycle')).rejects.toThrow('no OSRM server for bicycle');
  });
});
