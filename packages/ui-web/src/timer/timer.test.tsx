import { render, screen } from '@testing-library/react';
import { describe, expect, it } from 'vitest';
import { formatDuration, Timer, timerTone } from './timer';

// AP §4.7 and the approved sheet: mm:ss under 10 minutes, «12 د» above;
// calm, soon (the last minute of a countdown) and late (counting up).
describe('formatDuration', () => {
  it.each([
    [0, '0:00'],
    [48, '0:48'],
    [272, '4:32'],
    [599, '9:59'],
    [600, '10 د'],
    [725, '12 د'],
    [3600, '60 د'],
  ])('%i seconds is %s', (seconds, text) => {
    expect(formatDuration(seconds, 'د')).toBe(text);
  });

  it('counts whole seconds and never shows a negative', () => {
    expect(formatDuration(4.9, 'د')).toBe('0:04');
    expect(formatDuration(-5, 'د')).toBe('0:00');
  });
});

describe('timerTone', () => {
  it('is soon in the last minute of a countdown', () => {
    expect(timerTone({ seconds: 61, direction: 'down' })).toBe('calm');
    expect(timerTone({ seconds: 60, direction: 'down' })).toBe('soon');
  });

  it('is late when the app says so, and a count-up is calm otherwise', () => {
    expect(timerTone({ seconds: 10, direction: 'up', late: true })).toBe('late');
    expect(timerTone({ seconds: 900, direction: 'up' })).toBe('calm');
  });
});

describe('Timer', () => {
  it('is a timer with its prefix and tabular digits', () => {
    render(<Timer seconds={180} direction="up" late prefix="متأخر" minuteUnit="د" />);
    const timer = screen.getByRole('timer');
    expect(timer).toHaveTextContent('متأخر 3:00');
    expect(timer).toHaveAttribute('data-tone', 'late');
    expect(timer.className).toContain('tabular-nums');
  });

  it('takes a tone from the app, for a captain waiting', () => {
    render(<Timer seconds={240} direction="up" tone="soon" minuteUnit="د" />);
    expect(screen.getByRole('timer')).toHaveAttribute('data-tone', 'soon');
  });
});
