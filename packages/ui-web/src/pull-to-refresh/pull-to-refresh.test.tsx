import { createEvent, fireEvent, render, screen } from '@testing-library/react';
import { describe, expect, it } from 'vitest';
import { PullToRefresh } from './pull-to-refresh';

// WebKit has no `touch-action: pan-down`: during a pull, a downward touch
// move is held back by the component itself (D.W4c review).

function setup() {
  render(
    <PullToRefresh onRefresh={() => undefined} refreshLabel="تحديث">
      <p>برجر كبصو</p>
    </PullToRefresh>,
  );
  return screen.getByText('برجر كبصو').closest('[data-pull-scroller]')!;
}

function touchMove(target: Element, clientY: number) {
  const event = createEvent.touchMove(target, { cancelable: true });
  Object.defineProperty(event, 'touches', { value: [{ clientY }] });
  fireEvent(target, event);
  return event;
}

const down = (target: Element) =>
  fireEvent.pointerDown(target, {
    pointerId: 1,
    pointerType: 'touch',
    clientY: 100,
    isPrimary: true,
  });

describe('PullToRefresh on a touch screen', () => {
  it('holds back a downward move during a pull', () => {
    const scroller = setup();
    down(scroller);
    expect(touchMove(scroller, 150).defaultPrevented).toBe(true);
  });

  it('lets an upward move scroll', () => {
    const scroller = setup();
    down(scroller);
    expect(touchMove(scroller, 60).defaultPrevented).toBe(false);
  });

  it('lets a move scroll when no pull started', () => {
    const scroller = setup();
    expect(touchMove(scroller, 150).defaultPrevented).toBe(false);
  });
});
