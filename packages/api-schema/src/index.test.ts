import { describe, expect, expectTypeOf, it } from 'vitest';
import { type components, createApiClient } from './index.js';

type Status = components['schemas']['StatusDto_Output'];

describe('generated client', () => {
  it('reads a route as its typed model', async () => {
    const requests: Request[] = [];
    const client = createApiClient({
      baseUrl: 'https://api.example.test',
      fetch: async (request: Request) => {
        requests.push(request);
        return Response.json({ status: 'ok', serverTime: 1 }, { headers: { 'Server-Time': '1' } });
      },
    });

    const { data } = await client.GET('/v1/admin/status');

    expectTypeOf(data).toEqualTypeOf<Status | undefined>();
    expectTypeOf<Status>().toEqualTypeOf<{ status: 'ok'; serverTime: number }>();
    expect(data).toEqual({ status: 'ok', serverTime: 1 });
    expect(requests.map((request) => request.url)).toEqual([
      'https://api.example.test/v1/admin/status',
    ]);
  });
});
