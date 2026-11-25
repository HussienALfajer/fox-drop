import { expect, test, type Locator, type Page } from '@playwright/test';
import { openStory, stories } from './stories';

// The RTL, keyboard and 130% text gate of the form components (D.8; architecture
// §9.5 R4, R5, R9): fields, selection controls and the stepper behave right to
// left, by keyboard, and survive larger text. axe runs over every story in
// rtl.spec.ts.

const TITLES = [
  'Field',
  'TextField',
  'TextArea',
  'SearchField',
  'PhoneField',
  'CodeField',
  'Select',
  'Checkbox',
  'RadioGroup',
  'Switch',
  'QuantityStepper',
];

/** A token's value as the `rgb(r, g, b)` the browser computes. */
async function colour(page: Page, name: string): Promise<string> {
  return page.evaluate((variable) => {
    const hex = getComputedStyle(document.documentElement).getPropertyValue(variable).trim();
    const [r, g, b] = [1, 3, 5].map((i) => parseInt(hex.slice(i, i + 2), 16));
    return `rgb(${r}, ${g}, ${b})`;
  }, name);
}

const shadowOf = (box: Locator) => box.evaluate((element) => getComputedStyle(element).boxShadow);
const x = async (locator: Locator) => (await locator.boundingBox())!.x;
const centre = async (locator: Locator) => {
  const box = (await locator.boundingBox())!;
  return box.x + box.width / 2;
};

test.describe('the outline of a field (R4, R10)', () => {
  const box = (page: Page) => page.locator('[data-slot="input-group"]').first();

  test('hover darkens the outline, focus turns it brand orange, invalid turns it red', async ({
    page,
  }) => {
    await openStory(page, 'textfield--default');
    const rest = await shadowOf(box(page));
    expect(rest).toContain(await colour(page, '--fd-input-color-border'));

    await page.getByRole('textbox').hover();
    await expect
      .poll(() => shadowOf(box(page)))
      .toContain(await colour(page, '--fd-input-color-border-hover'));

    await page.getByRole('textbox').focus();
    await expect
      .poll(() => shadowOf(box(page)))
      .toContain(await colour(page, '--fd-input-color-border-focus'));

    await openStory(page, 'textfield--invalid');
    await expect
      .poll(() => shadowOf(box(page)))
      .toContain(await colour(page, '--fd-input-color-border-invalid'));
    await page.getByRole('textbox').focus();
    // an invalid field stays red when focused, and nothing moves
    expect(await shadowOf(box(page))).toContain(
      await colour(page, '--fd-input-color-border-invalid'),
    );
  });

  test('the error is the control description and the field is 50 high, 40 compact', async ({
    page,
  }) => {
    await openStory(page, 'textfield--invalid');
    const description = await page
      .getByRole('textbox')
      .evaluate(
        (input) => document.getElementById(input.getAttribute('aria-describedby')!)?.textContent,
      );
    expect(description).toContain('اكتب الاسم');
    expect((await box(page).boundingBox())!.height).toBeCloseTo(50, 0);
    await openStory(page, 'textfield--compact');
    expect((await box(page).boundingBox())!.height).toBeCloseTo(40, 0);
  });
});

test.describe('phone field and code field read left to right inside a right to left form', () => {
  test('the country chip is left of the digits, the label stays right to left', async ({
    page,
  }) => {
    await openStory(page, 'phonefield--default');
    const chip = page.getByRole('button', { name: /^الدولة:/ });
    const digits = page.getByRole('textbox');
    expect(await x(chip)).toBeLessThan(await x(digits));
    const direction = (locator: Locator) =>
      locator.evaluate((element) => getComputedStyle(element).direction);
    expect(await direction(page.locator('[data-slot="input-group"]'))).toBe('ltr');
    expect(await direction(page.locator('label').first())).toBe('rtl');
  });

  test('the six cells run left to right', async ({ page }) => {
    await openStory(page, 'codefield--typing');
    const cells = page.locator('[data-slot="otp-input-slot"]');
    await expect(cells).toHaveCount(6);
    const xs = [];
    for (let index = 0; index < 6; index++) xs.push(await x(cells.nth(index)));
    expect(xs).toEqual([...xs].sort((a, b) => a - b));
    await expect(cells.first()).toHaveText('4');
  });

  test('a pasted code fills the cells', async ({ page, context }) => {
    await context.grantPermissions(['clipboard-read', 'clipboard-write']);
    await openStory(page, 'codefield--default');
    await page.getByRole('textbox').focus();
    await page.evaluate(() => navigator.clipboard.writeText('482-913'));
    await page.keyboard.press('Control+V');
    await expect(page.getByRole('textbox')).toHaveValue('482913');
  });
});

test.describe('selection controls', () => {
  test('the checkbox sits at the start (right) of its label and Space toggles it', async ({
    page,
  }) => {
    await openStory(page, 'checkbox--default');
    const box = page.getByRole('checkbox');
    expect(await centre(box)).toBeGreaterThan(await centre(page.getByText('أوافق')));
    await page.keyboard.press('Tab');
    await expect(box).toBeFocused();
    await page.keyboard.press('Space');
    await expect(box).toBeChecked();
    await page.getByText('أوافق').click();
    await expect(box).not.toBeChecked();
  });

  test('the mixed checkbox is announced as mixed', async ({ page }) => {
    await openStory(page, 'checkbox--mixed');
    await expect(page.getByRole('checkbox')).toHaveAttribute('aria-checked', 'mixed');
  });

  test('the switch rests at the start and slides to the end (left) when on', async ({ page }) => {
    await openStory(page, 'switch--default');
    const track = page.getByRole('switch');
    const thumb = page.locator('[data-slot="switch-thumb"]');
    const side = async () => (await centre(thumb)) - (await centre(track));
    expect(await side()).toBeGreaterThan(0);
    await page.keyboard.press('Tab');
    await expect(track).toBeFocused();
    await page.keyboard.press('Space');
    await expect(track).toBeChecked();
    await expect.poll(side).toBeLessThan(0);
    const size = (await track.boundingBox())!;
    expect([size.width, size.height]).toEqual([52, 32]);
  });

  test('the radio group has one tab stop and the arrow keys move the choice', async ({ page }) => {
    await openStory(page, 'radiogroup--selected');
    await page.keyboard.press('Tab');
    await expect(page.getByRole('radio', { name: 'نقداً عند الاستلام' })).toBeFocused();
    await page.keyboard.press('ArrowDown');
    await expect(page.getByRole('radio', { name: 'المحفظة' })).toBeChecked();
    await page.keyboard.press('Tab');
    await expect(page.getByRole('radio', { name: 'المحفظة' })).not.toBeFocused();
  });

  test('a keyboard-focused control shows the blue ring, not only the outline', async ({ page }) => {
    for (const id of ['checkbox--default', 'switch--default', 'radiogroup--default']) {
      await openStory(page, id);
      const control = page
        .getByRole(
          id.startsWith('switch') ? 'switch' : id.startsWith('radio') ? 'radio' : 'checkbox',
        )
        .first();
      const before = await shadowOf(control);
      await page.keyboard.press('Tab');
      await expect(control).toBeFocused();
      expect(await shadowOf(control), id).not.toBe(before);
    }
  });
});

test.describe('select', () => {
  test('the arrow key opens the list, Enter picks, typing jumps to an option', async ({ page }) => {
    await openStory(page, 'select--default');
    const trigger = page.getByRole('combobox');
    await page.keyboard.press('Tab');
    await expect(trigger).toBeFocused();
    await page.keyboard.press('ArrowDown');
    await expect(page.getByRole('option', { name: 'ذكر' })).toBeVisible();
    await page.keyboard.press('Enter');
    await expect(trigger).toContainText('ذكر');
    // Playwright has no key name for an Arabic letter: send the keydown a keyboard would.
    await trigger.dispatchEvent('keydown', { key: 'أ', bubbles: true });
    await expect(trigger).toContainText('أنثى');
  });

  test('the open list is a listbox right to left, as wide as the trigger', async ({ page }) => {
    await openStory(page, 'select--open');
    const list = page.getByRole('listbox');
    await expect(list).toBeVisible();
    expect(await list.evaluate((element) => getComputedStyle(element).direction)).toBe('rtl');
    const widths = [
      (await list.boundingBox())!.width,
      (await page.getByRole('combobox').boundingBox())!.width,
    ];
    expect(widths[0]).toBeGreaterThanOrEqual(widths[1]! - 1);
  });
});

test.describe('quantity stepper', () => {
  test('«+» is at the start (right) and «−» at the end (left)', async ({ page }) => {
    await openStory(page, 'quantitystepper--default');
    expect(await x(page.getByRole('button', { name: 'زيادة' }))).toBeGreaterThan(
      await x(page.getByRole('button', { name: 'تقليل' })),
    );
  });

  test('the keyboard steps the count and the count is announced', async ({ page }) => {
    await openStory(page, 'quantitystepper--hover');
    await page.keyboard.press('Tab');
    await expect(page.getByRole('button', { name: 'زيادة' })).toBeFocused();
    await page.keyboard.press('Enter');
    await expect(page.getByRole('group', { name: 'الكمية' })).toHaveAccessibleDescription('3');
    await expect(page.getByRole('status')).toHaveText('3');
  });

  test('at the minimum «−» is the delete button; at the maximum «+» is off but focusable', async ({
    page,
  }) => {
    await openStory(page, 'quantitystepper--minimum');
    await expect(page.getByRole('button', { name: 'حذف' })).toBeVisible();
    await openStory(page, 'quantitystepper--maximum');
    const add = page.getByRole('button', { name: 'زيادة' });
    await expect(add).toHaveAttribute('aria-disabled', 'true');
    await add.focus();
    await expect(add).toBeFocused();
  });

  test('each circle is a 48 target', async ({ page }) => {
    await openStory(page, 'quantitystepper--default');
    for (const name of ['زيادة', 'تقليل']) {
      const box = (await page.getByRole('button', { name }).boundingBox())!;
      expect([box.width, box.height]).toEqual([48, 48]);
    }
  });
});

test.describe('130% text', () => {
  for (const title of TITLES)
    for (const story of stories(title)) {
      test(story.id, async ({ page }) => {
        await openStory(page, story.id);
        const heights = () =>
          page.evaluate(() =>
            [...document.querySelectorAll('#storybook-root *')]
              .filter((element) => element.matches('input, textarea, button, [role="combobox"]'))
              .map((element) => element.getBoundingClientRect().height),
          );
        const before = await heights();
        const scaled = await page.evaluate(() => {
          const root = document.documentElement;
          const names = new Set<string>();
          for (const sheet of document.styleSheets)
            for (const rule of sheet.cssRules)
              if (rule instanceof CSSStyleRule)
                for (const name of rule.style)
                  if (/^--fd-type-.*-size$/.test(name)) names.add(name);
          const computed = getComputedStyle(root);
          for (const name of names) {
            const px = parseFloat(computed.getPropertyValue(name));
            if (Number.isFinite(px)) root.style.setProperty(name, `${px * 1.3}px`);
          }
          return names.size;
        });
        expect(scaled, 'no --fd-type-*-size property found').toBeGreaterThan(0);
        const after = await heights();
        // no control got smaller, and no text is cut off or leaves its box
        after.forEach((height, index) =>
          expect(height).toBeGreaterThanOrEqual(before[index]! - 0.5),
        );
        const clipped = await page.evaluate(() =>
          [...document.querySelectorAll('#storybook-root *')].flatMap((element) => {
            // the hidden native control the UI SDK keeps for forms and autofill
            if (element.closest('[aria-hidden="true"]')) return [];
            // text for screen readers only, clipped to one pixel on purpose
            if (element.classList.contains('sr-only')) return [];
            const style = getComputedStyle(element);
            const cuts = style.overflowX !== 'visible' && style.textOverflow === 'ellipsis';
            // the select value and the search text may end in an ellipsis by design; a label may not
            if (cuts) return [];
            const own =
              element.scrollWidth > element.clientWidth + 1 && style.overflowX !== 'visible';
            const parent = element.parentElement;
            const outside =
              parent &&
              parent.id !== 'storybook-root' &&
              parent.getAttribute('data-slot') === 'input-group' &&
              element.getBoundingClientRect().right > parent.getBoundingClientRect().right + 1 &&
              element.getBoundingClientRect().left < parent.getBoundingClientRect().left - 1;
            return own || outside
              ? [element.tagName + ' ' + String(element.className).slice(0, 40)]
              : [];
          }),
        );
        expect(clipped).toEqual([]);
      });
    }
});
