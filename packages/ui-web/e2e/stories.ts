import { readFileSync } from 'node:fs';
import type { Page } from '@playwright/test';

export type Surface = 'phone' | 'captain' | 'panel';

interface Entry {
  id: string;
  title: string;
  name: string;
  type: string;
}

/** Every story of the built Storybook (`pnpm build` writes the index). */
export function stories(title?: string): Entry[] {
  const index = JSON.parse(
    readFileSync(`${import.meta.dirname}/../dist/storybook/index.json`, 'utf8'),
  ) as { entries: Record<string, Entry> };
  return Object.values(index.entries).filter(
    (entry) => entry.type === 'story' && (title === undefined || entry.title === title),
  );
}

/**
 * Opens one story alone, on a surface, and waits until its play function has
 * finished. Waiting for the first rendered node alone let a screenshot land
 * before a play typed or clicked (CI, PR 273 and 274: «ConfirmDialog Filled»
 * shot with an empty field).
 */
export async function openStory(page: Page, id: string, surface: Surface = 'phone') {
  await page.goto(`/iframe.html?id=${id}&viewMode=story&globals=surface:${surface}`);
  await page.locator('#storybook-root > *').first().waitFor();
  const phase = await page.waitForFunction((storyId) => {
    const preview = (
      window as unknown as {
        __STORYBOOK_PREVIEW__?: { storyRenders: { id: string; phase?: string }[] };
      }
    ).__STORYBOOK_PREVIEW__;
    const render = preview?.storyRenders.find((each) => each.id === storyId);
    return render?.phase === 'finished' || render?.phase === 'errored' ? render.phase : false;
  }, id);
  if ((await phase.jsonValue()) === 'errored') throw new Error(`The play function of ${id} failed`);
}
