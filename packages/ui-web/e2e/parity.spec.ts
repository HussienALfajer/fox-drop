import { existsSync, mkdirSync } from 'node:fs';
import { expect, test } from '@playwright/test';
import { openStory, stories, type Surface } from './stories';

// The parity sheet's web side (architecture §9.7, `pnpm parity <Component>` at
// the repository root): each story FD_PARITY names, on the phone and captain
// surfaces, shot at 360 CSS pixels and device scale 2 to
// .parity/web/<story id>-<surface>.png, beside the Flutter twin's case
// (packages/core_ui/test/parity/). A review tool, never a baseline: the
// `parity` project exists only when FD_PARITY is set (playwright.config.ts).
const surfaces: Surface[] = ['phone', 'captain'];
const only = (process.env['FD_PARITY'] ?? '').split(',').filter(Boolean);
const out = `${import.meta.dirname}/../../../.parity/web`;

const font = `${import.meta.dirname}/../dist/storybook/fonts/cofo-sans-pro-arabic/CoFoSansProArabic-Regular.ttf`;

test.beforeAll(() => {
  if (!existsSync(font))
    throw new Error(
      'CoFo Sans Pro Arabic is missing from the built Storybook: run `pnpm fonts:fetch`, then `pnpm --filter @fox-drop/ui-web build`.',
    );
  mkdirSync(out, { recursive: true });
});

for (const surface of surfaces)
  for (const story of stories().filter((each) => only.includes(each.id))) {
    test(`${story.id} on ${surface}`, async ({ page }) => {
      await openStory(page, story.id, surface);
      const loaded = await page.evaluate(async () => {
        await document.fonts.load('500 16px "CoFo Sans Pro Arabic"');
        await document.fonts.ready;
        return document.fonts.check('500 16px "CoFo Sans Pro Arabic"');
      });
      expect(loaded, 'CoFo did not load: run `pnpm fonts:fetch` and rebuild').toBe(true);
      // The frame of the Flutter case: 360 wide with the story at its start,
      // 16 pixels around it (so a focus ring is not cut), on the surface's
      // ground (the app's, which Storybook leaves white), no Storybook padding,
      // no transitions (the end state is what is compared).
      await page.addStyleTag({
        content: [
          '*, *::before, *::after { transition: none !important; }',
          'body { padding: 0 !important; margin: 0 !important; }',
          '#storybook-root > * { box-sizing: border-box; padding: 16px; background: var(--fd-color-surface); }',
        ].join('\n'),
      });
      // The states are driven as in visual.spec.ts: the first control of the story.
      const control = page
        .getByRole('button')
        .or(page.getByRole('link'))
        .or(page.getByRole('textbox'))
        .or(page.getByRole('searchbox'))
        .or(page.getByRole('combobox'))
        .or(page.getByRole('checkbox'))
        .or(page.getByRole('switch'))
        .or(page.getByRole('radio'))
        // The time field's boxes.
        .or(page.getByRole('spinbutton'))
        .first();
      if (story.name.endsWith('Hover')) await control.hover();
      if (story.name.endsWith('Focus')) {
        await page.keyboard.press('Tab');
        await expect(control).toBeFocused();
      }
      if (story.name.endsWith('Pressed')) {
        const box = (await control.boundingBox())!;
        await page.mouse.move(box.x + box.width / 2, box.y + box.height / 2);
        await page.mouse.down();
      }
      // An open overlay renders outside the story's root (slice D.W3c): a
      // dialog is shot alone, as its Flutter case draws the panel; the toasts
      // as their list; an open menu with its trigger, as the case opens it.
      const path = `${out}/${story.id}-${surface}.png`;
      const root = page.locator('#storybook-root > *').first();
      const panel = page.locator('[role="dialog"]:visible, [role="alertdialog"]:visible').first();
      const toasts = page.locator('section:has([data-toast])').first();
      const menu = page.locator('[role="menu"]:visible').first();
      if ((await panel.count()) > 0) {
        await panel.screenshot({ path, animations: 'disabled' });
      } else if ((await toasts.count()) > 0) {
        await toasts.screenshot({ path, animations: 'disabled' });
      } else if ((await menu.count()) > 0) {
        const a = (await root.boundingBox())!;
        const b = (await menu.boundingBox())!;
        const x = Math.min(a.x, b.x);
        const y = Math.min(a.y, b.y);
        const clip = {
          x,
          y,
          width: Math.max(a.x + a.width, b.x + b.width) - x,
          height: Math.max(a.y + a.height, b.y + b.height) + 16 - y,
        };
        await page.screenshot({ path, clip, animations: 'disabled' });
      } else await root.screenshot({ path, animations: 'disabled' });
    });
  }
