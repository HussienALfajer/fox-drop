import { expect, test, type Page } from '@playwright/test';
import { openStory } from './stories';

// D.10, in a real browser and right to left: focus is trapped and returned,
// sides follow the reading direction, nothing moves under reduced motion.

const centreX = (page: Page, selector: string) =>
  page
    .locator(selector)
    .first()
    .evaluate((el) => {
      const box = el.getBoundingClientRect();
      return box.x + box.width / 2;
    });
const viewportCentre = (page: Page) => page.evaluate(() => window.innerWidth / 2);

test.describe('dialog', () => {
  test('traps Tab inside and returns focus to its trigger', async ({ page }) => {
    await openStory(page, 'dialog--default');
    const trigger = page.getByRole('button', { name: 'حذف العنوان' });
    await trigger.click();
    const dialog = page.getByRole('alertdialog');
    await expect(dialog).toBeVisible();
    for (let i = 0; i < 6; i++) {
      await page.keyboard.press('Tab');
      expect(await dialog.evaluate((el) => el.contains(document.activeElement))).toBe(true);
    }
    await page.keyboard.press('Escape');
    await expect(dialog).toBeHidden();
    await expect(trigger).toBeFocused();
  });
});

test.describe('side drawer', () => {
  test('the quick view opens at the end side, left in RTL', async ({ page }) => {
    await openStory(page, 'drawer--default', 'panel');
    await page.getByRole('button', { name: 'عرض الطلب' }).click();
    const drawer = page.getByRole('dialog');
    await expect(drawer).toBeVisible();
    expect(await centreX(page, '[role="dialog"]')).toBeLessThan(await viewportCentre(page));
    await page.keyboard.press('Escape');
    await expect(drawer).toBeHidden();
  });

  test('the sidebar drawer opens at the start side, right in RTL', async ({ page }) => {
    await openStory(page, 'drawer--start', 'panel');
    await page.getByRole('button', { name: 'القائمة' }).click();
    await expect(page.getByRole('dialog')).toBeVisible();
    expect(await centreX(page, '[role="dialog"]')).toBeGreaterThan(await viewportCentre(page));
  });
});

test.describe('menu', () => {
  test('opens under its trigger, aligned to its start (right) edge', async ({ page }) => {
    await openStory(page, 'menu--default', 'panel');
    const trigger = page.getByRole('button', { name: 'سارة م.' });
    await trigger.click();
    const menu = page.getByRole('menu');
    await expect(menu).toBeVisible();
    const [t, m] = await Promise.all([trigger.boundingBox(), menu.boundingBox()]);
    expect(m!.y).toBeGreaterThanOrEqual(t!.y + t!.height);
    expect(Math.abs(m!.x + m!.width - (t!.x + t!.width))).toBeLessThanOrEqual(2);
  });
});

test.describe('tabs', () => {
  test('overflow scrolls the selected tab into view', async ({ page }) => {
    await page.setViewportSize({ width: 360, height: 640 });
    await openStory(page, 'tabs--overflow');
    const selected = page.getByRole('tab', { selected: true });
    await expect(selected).toBeInViewport();
  });
});

test.describe('tooltip', () => {
  test('shows on keyboard focus without a delay', async ({ page }) => {
    await openStory(page, 'tooltip--default', 'panel');
    await page.keyboard.press('Tab');
    await expect(page.getByRole('tooltip')).toBeVisible({ timeout: 300 });
  });
});

test.describe('sidebar', () => {
  test('sits on the start side, right in RTL', async ({ page }) => {
    await openStory(page, 'sidebar--default', 'panel');
    expect(await centreX(page, 'nav')).toBeGreaterThan(await viewportCentre(page));
  });
});

test.describe('reduced motion', () => {
  test.use({ reducedMotion: 'reduce' });

  test('a toast appears without moving', async ({ page }) => {
    await openStory(page, 'toaster--default');
    await page.getByRole('button', { name: 'أظهر الإشعار' }).click();
    const toast = page.getByText('حُفظت التغييرات');
    await expect(toast).toBeVisible();
    const moved = await toast.evaluate((el) => {
      const node = el.closest('[data-toast]') ?? el;
      return getComputedStyle(node).translate;
    });
    expect(['none', '0px', '0px 0px']).toContain(moved);
  });
});
