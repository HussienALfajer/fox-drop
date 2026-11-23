import { existsSync } from 'node:fs';
import { expect, test, type Page } from '@playwright/test';
import { openStory, stories, type Surface } from './stories';

// Screenshot comparison (architecture §9.5 R9) of every story on the phone and
// captain surfaces, with the real CoFo. Baselines in e2e/__screenshots__ are
// valid only from the Playwright image: `pnpm test:visual` runs this project in
// Docker (FD_VISUAL=1); update them with `pnpm test:visual --update-snapshots`.
const surfaces: Surface[] = ['phone', 'captain'];

// Two frames with another root background, then two with its own: each change
// invalidates the paint of the whole page, with no new layer (opacity made
// one, which changed the text's anti-aliasing) and no change to hit testing,
// so a hover or a press stays.
async function repaint(page: Page) {
  await page.evaluate(async () => {
    const frames = () =>
      new Promise((done) => requestAnimationFrame(() => requestAnimationFrame(done)));
    document.documentElement.style.backgroundColor = 'rgb(0 0 0)';
    await frames();
    document.documentElement.style.backgroundColor = '';
    await frames();
  });
}
const font = `${import.meta.dirname}/../dist/storybook/fonts/cofo-sans-pro-arabic/CoFoSansProArabic-Regular.ttf`;

test.beforeAll(() => {
  // Never skipped: a snapshot in the system font would be a wrong baseline.
  if (!existsSync(font))
    throw new Error(
      'CoFo Sans Pro Arabic is missing from the built Storybook: run `pnpm fonts:fetch`, then `pnpm --filter @fox-drop/ui-web build`.',
    );
});

for (const surface of surfaces)
  for (const story of stories()) {
    test(`${story.id} on ${surface}`, async ({ page }) => {
      await openStory(page, story.id, surface);
      // Loads the faces even for a story without text, so the check is real.
      const loaded = await page.evaluate(async () => {
        await document.fonts.load('500 16px "CoFo Sans Pro Arabic"');
        await document.fonts.ready;
        return document.fonts.check('500 16px "CoFo Sans Pro Arabic"');
      });
      expect(loaded, 'CoFo did not load: run `pnpm fonts:fetch` and rebuild').toBe(true);
      // A state driven below starts a colour transition that `animations:
      // 'disabled'` does not always catch, so the shot could land mid-way (a
      // pressed baseline once held the hover colour). The end state is what is
      // compared: no transitions.
      await page.addStyleTag({
        content: '*, *::before, *::after { transition: none !important; }',
      });
      // The Hover, Focus and Pressed stories are the plain button: drive it.
      // Tab (not click) so that :focus-visible applies.
      // The first control of the story, whatever it is: a button, a text box, a
      // combobox, a checkbox, a switch or a radio (the form stories).
      const button = page
        .getByRole('button')
        .or(page.getByRole('textbox'))
        .or(page.getByRole('searchbox'))
        .or(page.getByRole('combobox'))
        .or(page.getByRole('checkbox'))
        .or(page.getByRole('switch'))
        .or(page.getByRole('radio'))
        .first();
      if (story.name.endsWith('Hover')) await button.hover();
      if (story.name.endsWith('Focus')) {
        await page.keyboard.press('Tab');
        await expect(button).toBeFocused();
      }
      if (story.name.endsWith('Pressed')) {
        const box = (await button.boundingBox())!;
        await page.mouse.move(box.x + box.width / 2, box.y + box.height / 2);
        await page.mouse.down();
      }
      // A state repaints only its control's rectangle, and an anti-aliased
      // edge inside it (the stepper's strip) then rounded by one level
      // depending on which frames were painted before (CI, PR 265). Repaint the
      // whole page in the final state, so the shot depends on the state alone.
      if (/(Hover|Focus|Pressed)$/.test(story.name)) await repaint(page);
      await expect(page).toHaveScreenshot(`${story.id}-${surface}.png`, {
        animations: 'disabled',
        fullPage: true,
        // Exact colours: Playwright's default tolerance would hide a state change.
        threshold: 0,
      });
    });
  }
