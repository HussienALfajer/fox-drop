import { describe, expect, it } from 'vitest';
import { suggestedStep, suspensionEnd, violationSteps } from './violations.js';

// AP §9.7.6, CA §11.3: the conduct ladder within captain.violation_window_days.
const now = new Date('2026-11-19T12:00:00Z');
const daysAgo = (days: number) => new Date(now.getTime() - days * 86_400_000);
const recorded = (days: number, voided = false) => ({ recordedAt: daysAgo(days), voided });

describe('the conduct ladder', () => {
  it('has the four steps in order', () => {
    expect(violationSteps).toEqual(['warning', 'suspension_1d', 'suspension_7d', 'termination']);
  });

  it('suggests a warning for the first violation', () => {
    expect(suggestedStep([], { severe: false, windowDays: 90, now })).toBe('warning');
  });

  it('suggests the next step for each violation within the window', () => {
    const window = { severe: false, windowDays: 90, now };
    expect(suggestedStep([recorded(10)], window)).toBe('suspension_1d');
    expect(suggestedStep([recorded(10), recorded(20)], window)).toBe('suspension_7d');
    expect(suggestedStep([recorded(1), recorded(2), recorded(3)], window)).toBe('termination');
    expect(suggestedStep([recorded(1), recorded(2), recorded(3), recorded(4)], window)).toBe(
      'termination',
    );
  });

  it('leaves out the violations older than the window', () => {
    const window = { severe: false, windowDays: 90, now };
    expect(suggestedStep([recorded(91), recorded(200)], window)).toBe('warning');
    expect(suggestedStep([recorded(89), recorded(91)], window)).toBe('suspension_1d');
  });

  it('leaves out a violation an accepted appeal voided', () => {
    const window = { severe: false, windowDays: 90, now };
    expect(suggestedStep([recorded(5, true)], window)).toBe('warning');
    expect(suggestedStep([recorded(5, true), recorded(6)], window)).toBe('suspension_1d');
  });

  it('suggests termination at once for a severe type', () => {
    expect(suggestedStep([], { severe: true, windowDays: 90, now })).toBe('termination');
  });
});

describe('the suspension a step sets', () => {
  it('suspends for a day or seven, and the others not at all', () => {
    expect(suspensionEnd('suspension_1d', now)).toEqual(new Date('2026-11-20T12:00:00Z'));
    expect(suspensionEnd('suspension_7d', now)).toEqual(new Date('2026-11-26T12:00:00Z'));
    expect(suspensionEnd('warning', now)).toBeNull();
    expect(suspensionEnd('termination', now)).toBeNull();
  });
});
