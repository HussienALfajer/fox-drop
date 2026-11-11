import { describe, expect, it } from 'vitest';
import { canPing, canReport, type NoAnswerFacts, noAnswerState } from './no-answer.js';

// CA §9.9, docs/domain/03 (slice 2.13d; owner decisions 2026-11-11): «تنبيه
// الزبون» up to customer.no_answer_pings times, customer.no_answer_ping_interval_min
// apart; «الزبون لا يستجيب» after all the pings and pings × interval from
// the arrival at the customer, or from operations' latest «انتظر».
const arrived = new Date('2026-11-11T10:00:00Z');
const at = (minutes: number) => new Date(arrived.getTime() + minutes * 60_000);
const rule = { pings: 3, intervalMin: 5 };
const none: NoAnswerFacts = { arrivedAt: arrived, pings: [], reports: [] };
const ping = (minutes: number) => ({ at: at(minutes), answer: null, answeredAt: null });

describe('noAnswerState (CA §9.9)', () => {
  it('allows the first ping at once after the arrival', () => {
    const state = noAnswerState(none, rule);
    expect(state).toEqual({
      pingsLeft: 3,
      nextPingAt: arrived,
      answer: null,
      reportableAt: null,
      report: null,
    });
    expect(canPing(state, arrived)).toBe(true);
    expect(canReport(state, at(60))).toBe(false);
  });

  it('spaces the pings by the interval and counts them down', () => {
    const state = noAnswerState({ ...none, pings: [ping(1)] }, rule);
    expect(state.pingsLeft).toBe(2);
    expect(state.nextPingAt).toEqual(at(6));
    expect(canPing(state, at(5))).toBe(false);
    expect(canPing(state, at(6))).toBe(true);
  });

  it('allows no ping past the limit, and «الزبون لا يستجيب» 15 minutes after the arrival', () => {
    const state = noAnswerState({ ...none, pings: [ping(0), ping(5), ping(10)] }, rule);
    expect(state.pingsLeft).toBe(0);
    expect(state.nextPingAt).toBeNull();
    expect(canPing(state, at(30))).toBe(false);
    expect(state.reportableAt).toEqual(at(15));
    expect(canReport(state, at(14))).toBe(false);
    expect(canReport(state, at(15))).toBe(true);
  });

  it('counts the 15 minutes from the arrival even when the pings came late', () => {
    const state = noAnswerState({ ...none, pings: [ping(2), ping(9), ping(20)] }, rule);
    expect(state.reportableAt).toEqual(at(15));
    expect(canReport(state, at(20))).toBe(true);
  });

  it('needs every ping before «الزبون لا يستجيب»', () => {
    const state = noAnswerState({ ...none, pings: [ping(0), ping(5)] }, rule);
    expect(state.reportableAt).toBeNull();
    expect(canReport(state, at(60))).toBe(false);
  });

  it('keeps the timer running after «أنا قادم», giving the latest answer', () => {
    const answered = { at: at(5), answer: 'coming' as const, answeredAt: at(6) };
    const state = noAnswerState({ ...none, pings: [ping(0), answered, ping(10)] }, rule);
    expect(state.answer).toEqual({ answer: 'coming', at: at(6) });
    expect(state.reportableAt).toEqual(at(15));
  });

  it('allows no second report while one waits for operations', () => {
    const state = noAnswerState(
      {
        ...none,
        pings: [ping(0), ping(5), ping(10)],
        reports: [{ at: at(16), waitedAt: null, waitMessage: null }],
      },
      rule,
    );
    expect(state.report).toEqual({ at: at(16), waitedAt: null, waitMessage: null });
    expect(state.reportableAt).toBeNull();
    expect(canReport(state, at(60))).toBe(false);
  });

  it("allows the report again 15 minutes after operations' «انتظر»", () => {
    const state = noAnswerState(
      {
        ...none,
        pings: [ping(0), ping(5), ping(10)],
        reports: [{ at: at(16), waitedAt: at(20), waitMessage: 'الزبون في الطريق' }],
      },
      rule,
    );
    expect(state.report).toEqual({ at: at(16), waitedAt: at(20), waitMessage: 'الزبون في الطريق' });
    expect(state.reportableAt).toEqual(at(35));
    expect(canReport(state, at(34))).toBe(false);
    expect(canReport(state, at(35))).toBe(true);
  });
});
