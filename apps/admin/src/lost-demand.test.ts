import { describe, expect, it, vi } from 'vitest';

vi.mock('./api.js', () => ({ api: {} }));

const { canSeeLostDemand } = await import('./lost-demand.js');

const session = (permissions: string[]) => ({ permissions }) as never;

// AP §9.17, §6.2 (slice 2.28a): «الطلب الضائع», an operations report.
describe('canSeeLostDemand', () => {
  it('needs reports.operations or reports.all', () => {
    expect(canSeeLostDemand(session(['reports.operations']))).toBe(true);
    expect(canSeeLostDemand(session(['reports.all']))).toBe(true);
    expect(canSeeLostDemand(session(['reports.support', 'reports.financial']))).toBe(false);
    expect(canSeeLostDemand(null)).toBe(false);
  });
});
