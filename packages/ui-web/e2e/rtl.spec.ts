import AxeBuilder from '@axe-core/playwright';
import { expect, test } from '@playwright/test';
import { openStory, stories } from './stories';

// The RTL gate (architecture §9.5 R4, R5, R9; §9.10 T11): every story passes
// axe, and parts stay inside their scrolling containers. The component tests
// (icons by reading direction, keyboard, state tokens, 130% text) left with
// the components in D.R1 (2026-11-27) and come back with the first approved
// one (git history: this file before D.R1).

test('the built Storybook serves its preview with the tokens and its index', async ({ page }) => {
  await page.goto('/iframe.html');
  await expect
    .poll(() =>
      page.evaluate(() =>
        getComputedStyle(document.documentElement).getPropertyValue('--fd-color-surface').trim(),
      ),
    )
    .not.toBe('');
  expect(stories().every((story) => story.id.length > 0)).toBe(true);
});

test.describe('axe, WCAG 2.2 AA', () => {
  for (const story of stories()) {
    test(story.id, async ({ page }) => {
      await openStory(page, story.id);
      const { violations } = await new AxeBuilder({ page })
        .withTags(['wcag2a', 'wcag2aa', 'wcag21a', 'wcag21aa', 'wcag22aa'])
        // Contrast is gated by the token contrast test (design-tokens
        // src/contrast.ts), which knows the owner's accepted brand-orange
        // exceptions; axe cannot see them and would fail the accepted pairs.
        .disableRules(['color-contrast'])
        .analyze();
      expect(violations, JSON.stringify(violations, null, 2)).toEqual([]);
    });
  }
});

// Inner positions in a scrolling container (PR 300): the UI SDK placed the
// Tabs indicator from the list's physical edges as if it scrolled left to
// right, so on a scrolled RTL list the line sat outside the list, unseen, and
// widened the scroll range by an amount that moved with the fonts' timing.
// The parity gate measures sizes and colours, not where a part lands, so
// every story is checked here: each visible part of an overflowing clipping
// container lies within its scrollable area, and the scroll range stays still
// once the fonts have loaded.

/** The parts outside their clipping container, and each container's scroll range. */
function scrollState() {
  const clips = (value: string) => value === 'auto' || value === 'scroll' || value === 'hidden';
  const isClip = (element: Element) => {
    const style = getComputedStyle(element);
    return clips(style.overflowX) || clips(style.overflowY);
  };
  const nearestClip = (element: Element) => {
    let up = element.parentElement;
    while (up && !isClip(up)) up = up.parentElement;
    return up;
  };
  const name = (element: Element) => {
    const classes = element.getAttribute('class')?.trim().split(/\s+/).join(' ');
    return `${element.tagName.toLowerCase()}${classes ? ` (${classes})` : ''}`;
  };
  const span = (from: number, to: number) => `${Math.round(from)}..${Math.round(to)}`;
  // A part a person cannot see: no box, hidden, or visually hidden (sr-only,
  // a 1 px box). An aria-hidden icon or badge is still seen, so it counts.
  const unseen = (element: Element) => {
    const box = element.getBoundingClientRect();
    if (box.width === 0 || box.height === 0) return true;
    if (box.width <= 1 && box.height <= 1) return true;
    if (element.closest('.sr-only')) return true;
    return getComputedStyle(element).visibility !== 'visible';
  };
  const containers = [...document.body.querySelectorAll('*')].filter(
    (element) =>
      isClip(element) &&
      (element.scrollWidth > element.clientWidth || element.scrollHeight > element.clientHeight),
  );
  const problems: string[] = [];
  for (const container of containers) {
    const style = getComputedStyle(container);
    const box = container.getBoundingClientRect();
    // The scrollable area starts at the padding box, moved by the scroll
    // position. In RTL scrollLeft is 0 or negative and the content extends
    // to the left of the right padding edge.
    const paddingLeft = box.left + container.clientLeft;
    const left =
      style.direction === 'rtl'
        ? paddingLeft + container.clientWidth - container.scrollLeft - container.scrollWidth
        : paddingLeft - container.scrollLeft;
    const top = box.top + container.clientTop - container.scrollTop;
    const right = left + container.scrollWidth;
    const bottom = top + container.scrollHeight;
    // A part inside a nested clipping container answers to that one; a fixed
    // part, or an absolute one placed by a block outside this container, is
    // not clipped by it.
    const parts = [...container.querySelectorAll('*')].flatMap((part) => {
      if (nearestClip(part) !== container || unseen(part)) return [];
      const position = getComputedStyle(part).position;
      if (position === 'fixed') return [];
      const parent = (part as HTMLElement).offsetParent;
      if (position === 'absolute' && parent && !container.contains(parent)) return [];
      return [{ part, absolute: position === 'absolute', at: part.getBoundingClientRect() }];
    });
    const placed = new Set(parts.filter((each) => each.absolute).map((each) => each.part));
    const inFlow = (part: Element) => {
      for (let up: Element | null = part; up && up !== container; up = up.parentElement)
        if (placed.has(up)) return false;
      return true;
    };
    // An absolute part widens the scroll range itself (the old indicator
    // did), so it must also lie over the in-flow content or the visible box.
    const flow = {
      left: paddingLeft,
      right: paddingLeft + container.clientWidth,
      top: box.top + container.clientTop,
      bottom: box.top + container.clientTop + container.clientHeight,
    };
    for (const { at } of parts.filter((each) => inFlow(each.part))) {
      flow.left = Math.min(flow.left, at.left);
      flow.right = Math.max(flow.right, at.right);
      flow.top = Math.min(flow.top, at.top);
      flow.bottom = Math.max(flow.bottom, at.bottom);
    }
    const tolerance = 1;
    const outside = (at: DOMRect, area: typeof flow) =>
      at.left < area.left - tolerance ||
      at.right > area.right + tolerance ||
      at.top < area.top - tolerance ||
      at.bottom > area.bottom + tolerance;
    for (const { part, absolute, at } of parts) {
      const area = absolute ? flow : { left, right, top, bottom };
      if (outside(at, area))
        problems.push(
          `${name(part)} at ${span(at.left, at.right)} × ${span(at.top, at.bottom)} outside ${absolute ? 'the content of ' : ''}${name(container)} ${span(area.left, area.right)} × ${span(area.top, area.bottom)}`,
        );
    }
  }
  return {
    problems,
    ranges: containers.map((container) => ({
      container: name(container),
      width: container.scrollWidth,
      height: container.scrollHeight,
    })),
  };
}

test.describe('parts stay inside their scrolling container', () => {
  for (const story of stories()) {
    test(story.id, async ({ page }) => {
      for (const surface of ['phone', 'captain'] as const) {
        await openStory(page, story.id, surface);
        await page.evaluate(async () => {
          // A face is fetched only once laid-out text needs it: wait a frame.
          await new Promise(requestAnimationFrame);
          await document.fonts.ready;
          // An opening popup grows from its trigger: let finite animations
          // end. A looping one (a loader) is paused, so the two readings
          // below cannot catch it at different points.
          const animations = document.getAnimations();
          const loops = animations.filter(
            (animation) => animation.effect?.getTiming().iterations === Infinity,
          );
          for (const animation of loops) animation.pause();
          await Promise.all(
            animations
              .filter((animation) => !loops.includes(animation))
              .map((animation) => animation.finished.catch(() => undefined)),
          );
        });
        const before = await page.evaluate(scrollState);
        expect(before.problems, `${story.id} on ${surface}`).toEqual([]);
        await page.evaluate(
          () =>
            new Promise<void>((done) => {
              requestAnimationFrame(() => requestAnimationFrame(() => setTimeout(done, 200)));
            }),
        );
        const after = await page.evaluate(scrollState);
        expect(after.ranges, `${story.id} on ${surface}: the scroll range moved`).toEqual(
          before.ranges,
        );
        // A story opens at one scroll position; a part placed from the wrong
        // side may show only at the other end. Scroll every overflowing
        // container to its far end (negative in RTL) and check again.
        await page.evaluate(() => {
          for (const element of document.body.querySelectorAll('*')) {
            const wide = element.scrollWidth - element.clientWidth;
            const tall = element.scrollHeight - element.clientHeight;
            if (wide <= 0 && tall <= 0) continue;
            const rtl = getComputedStyle(element).direction === 'rtl';
            element.scrollLeft = rtl ? -wide : wide;
            element.scrollTop = tall;
          }
        });
        const far = await page.evaluate(scrollState);
        expect(far.problems, `${story.id} on ${surface}, scrolled to the end`).toEqual([]);
      }
    });
  }
});
