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

/** Opens one story alone, on a surface, and waits until it has rendered. */
export async function openStory(page: Page, id: string, surface: Surface = 'phone') {
  await page.goto(`/iframe.html?id=${id}&viewMode=story&globals=surface:${surface}`);
  await page.locator('#storybook-root > *').first().waitFor();
}
