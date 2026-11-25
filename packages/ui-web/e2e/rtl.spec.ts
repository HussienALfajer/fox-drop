import AxeBuilder from '@axe-core/playwright';
import { expect, test, type Page } from '@playwright/test';
import { openStory, stories } from './stories';

// The RTL gate (architecture §9.5 R4, R5, R9; §9.10 T11): the UI SDK's Button
// and our Icon behave right to left, by keyboard, at 130% text, and pass axe.

/** The x of the centre of the button's label text and of its first and last icon. */
async function positions(page: Page) {
  await page.locator('button svg').first().waitFor({ state: 'attached' });
  return page.evaluate(() => {
    const button = document.querySelector('#storybook-root button')!;
    const text = document.createTreeWalker(button, NodeFilter.SHOW_TEXT).nextNode()!;
    const range = document.createRange();
    range.selectNodeContents(text);
    const centre = (box: DOMRect) => box.x + box.width / 2;
    const icons = [...button.querySelectorAll('svg')].map((svg) =>
      centre(svg.getBoundingClientRect()),
    );
    return { label: centre(range.getBoundingClientRect()), icons };
  });
}

test.describe('icons follow the reading direction', () => {
  test('the start icon is right of the label, the end icon left of it', async ({ page }) => {
    await openStory(page, 'button--with-icon-start');
    const start = await positions(page);
    expect(start.icons).toHaveLength(1);
    expect(start.icons[0]).toBeGreaterThan(start.label);

    await openStory(page, 'button--with-icon-end');
    const end = await positions(page);
    expect(end.icons).toHaveLength(1);
    expect(end.icons[0]).toBeLessThan(end.label);

    await openStory(page, 'button--with-both-icons');
    const both = await positions(page);
    expect(both.icons[0]).toBeGreaterThan(both.label);
    expect(both.icons[1]).toBeLessThan(both.label);
  });

  // Tailwind 4 flips with the `scale` property; an older build would use `transform`.
  const flipped = (page: Page) =>
    page
      .locator('svg')
      .first()
      .evaluate((svg) => {
        const style = getComputedStyle(svg);
        const scale = style.scale === 'none' ? 1 : Number(style.scale.split(' ')[0]);
        const matrix = style.transform === 'none' ? 1 : new DOMMatrix(style.transform).a;
        return scale * matrix < 0;
      });

  test('the back icon is mirrored, a plain icon is not', async ({ page }) => {
    await openStory(page, 'icon--mirrored');
    expect(await flipped(page)).toBe(true);
    await openStory(page, 'button--with-icon-back');
    expect(await flipped(page)).toBe(true);
    await openStory(page, 'icon--default');
    expect(await flipped(page)).toBe(false);
  });
});

test.describe('keyboard', () => {
  const pressed = (page: Page) => page.getByLabel('عدد الضغطات');

  for (const key of ['Enter', 'Space']) {
    test(`${key} activates a focused button`, async ({ page }) => {
      await openStory(page, 'button--presseable');
      await page.keyboard.press('Tab');
      await expect(page.getByRole('button')).toBeFocused();
      await page.keyboard.press(key);
      await expect(pressed(page)).toHaveText('1');
    });
  }

  test('a disabled button is skipped by Tab and does nothing', async ({ page }) => {
    await openStory(page, 'button--presseable-disabled');
    await page.keyboard.press('Tab');
    await expect(page.getByRole('button')).not.toBeFocused();
    await page.getByRole('button').click({ force: true });
    await expect(pressed(page)).toHaveText('0');
  });

  for (const key of ['Enter', 'Space']) {
    test(`${key} on a loading button does nothing`, async ({ page }) => {
      await openStory(page, 'button--presseable-loading');
      await page.keyboard.press('Tab');
      await expect(page.getByRole('button')).toBeFocused();
      await page.keyboard.press(key);
      await page.getByRole('button').click({ force: true });
      await expect(pressed(page)).toHaveText('0');
    });
  }

  test('a keyboard-focused button shows a focus ring, a pointer-pressed one does not need it', async ({
    page,
  }) => {
    await openStory(page, 'button--primary-default');
    const ring = () =>
      page.getByRole('button').evaluate((button) => {
        const style = getComputedStyle(button);
        return { shadow: style.boxShadow, outline: `${style.outlineStyle} ${style.outlineWidth}` };
      });
    const before = await ring();
    await page.keyboard.press('Tab');
    await expect(page.getByRole('button')).toBeFocused();
    const after = await ring();
    expect(after.shadow).not.toBe('none');
    expect(after.shadow).not.toBe(before.shadow);
  });
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

// R10: hover and pressed paint the variant's own state tokens (design-tokens
// measures them visible). The colour fades, so poll until it settles.
for (const variant of ['primary', 'secondary', 'danger', 'ghost']) {
  test(`${variant} hover and pressed paint their state tokens`, async ({ page }) => {
    await openStory(page, `button--${variant}-hover`);
    const button = page.getByRole('button');
    const paint = () =>
      button.evaluate((element, v) => {
        const style = getComputedStyle(element);
        const rgb = (name: string) => {
          const hex = style.getPropertyValue(`--fd-button-${v}-${name}`).trim();
          const [r, g, b] = [1, 3, 5].map((i) => parseInt(hex.slice(i, i + 2), 16));
          return `rgb(${r}, ${g}, ${b})`;
        };
        return {
          now: style.backgroundColor,
          hover: rgb('background-hover'),
          pressed: rgb('background-pressed'),
        };
      }, variant);
    const before = await paint();
    expect(before.now).not.toBe(before.hover);
    await button.hover();
    await expect.poll(async () => (await paint()).now).toBe(before.hover);
    await page.mouse.down();
    await expect.poll(async () => (await paint()).now).toBe(before.pressed);
    await page.mouse.up();
  });
}

test.describe('130% text', () => {
  for (const story of stories('Button')) {
    test(story.id, async ({ page }) => {
      await openStory(page, story.id);
      // The type tokens are px, so a root font size would change nothing:
      // scale every --fd-type-*-size on :root by 1.3 and check the label grew.
      const label = page.locator('#storybook-root button').first();
      const size = () => label.evaluate((button) => parseFloat(getComputedStyle(button).fontSize));
      const before = await size();
      const scaled = await page.evaluate(() => {
        const root = document.documentElement;
        const names = new Set<string>();
        for (const sheet of document.styleSheets)
          for (const rule of sheet.cssRules)
            if (rule instanceof CSSStyleRule)
              for (const name of rule.style) if (/^--fd-type-.*-size$/.test(name)) names.add(name);
        const computed = getComputedStyle(root);
        for (const name of names) {
          const px = parseFloat(computed.getPropertyValue(name));
          if (Number.isFinite(px)) root.style.setProperty(name, `${px * 1.3}px`);
        }
        return names.size;
      });
      expect(scaled, 'no --fd-type-*-size property found').toBeGreaterThan(0);
      expect(await size()).toBeGreaterThan(before);
      const clipped = await page.evaluate(() =>
        [...document.querySelectorAll('#storybook-root button')].flatMap((button) => {
          const box = button.getBoundingClientRect();
          return [...button.children].flatMap((child) => {
            const inner = child.getBoundingClientRect();
            const problems: string[] = [];
            if (child.scrollWidth > child.clientWidth) problems.push('label clips');
            if (inner.left < box.left - 0.5 || inner.right > box.right + 0.5)
              problems.push('content leaves the button');
            if (inner.top < box.top - 0.5 || inner.bottom > box.bottom + 0.5)
              problems.push('content taller than the button');
            return problems;
          });
        }),
      );
      expect(clipped).toEqual([]);
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
  // A part a person cannot see: no box, hidden, aria-hidden or sr-only.
  const unseen = (element: Element) => {
    const box = element.getBoundingClientRect();
    if (box.width === 0 || box.height === 0) return true;
    if (element.closest('[aria-hidden="true"], .sr-only')) return true;
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
          // An opening popup grows from its trigger: let finite animations end.
          await Promise.all(
            document
              .getAnimations()
              .filter((animation) => animation.effect?.getTiming().iterations !== Infinity)
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
      }
    });
  }
});
