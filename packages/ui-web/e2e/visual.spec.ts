import { existsSync } from 'node:fs';
import { expect, test } from '@playwright/test';
import { openStory, stories, type Surface } from './stories';

// Screenshot comparison (architecture §9.5 R9) of every story on the phone and
// captain surfaces, with the real CoFo. Baselines in e2e/__screenshots__ are
// valid only from the Playwright image: `pnpm test:visual` runs this project in
// Docker (FD_VISUAL=1); update them with `pnpm test:visual --update-snapshots`.
const surfaces: Surface[] = ['phone', 'captain'];
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
      await expect(page).toHaveScreenshot(`${story.id}-${surface}.png`, {
        animations: 'disabled',
        fullPage: true,
      });
    });
  }
