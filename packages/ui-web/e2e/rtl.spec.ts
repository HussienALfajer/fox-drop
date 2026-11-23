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

test('hover shows the overlay: it has a size and turns visible', async ({ page }) => {
  await openStory(page, 'button--primary-hover');
  const button = page.getByRole('button');
  const overlay = () =>
    button.evaluate((element) => {
      const style = getComputedStyle(element, '::before');
      return {
        opacity: Number(style.opacity),
        width: parseFloat(style.width),
        height: parseFloat(style.height),
      };
    });
  expect((await overlay()).opacity).toBe(0);
  await button.hover();
  const hovered = await overlay();
  expect(hovered.opacity).toBe(0.5);
  expect(hovered.width).toBeGreaterThan(0);
  expect(hovered.height).toBeGreaterThan(0);
});

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
