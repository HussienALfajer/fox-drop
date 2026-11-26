// Drives a rendered board as the owner does in Play (check.ts, after
// renderBoard with `live: true`): real pointer and keyboard events from
// Playwright on the playground's copy and its panel. Each finding names the
// element and what did not happen:
// - every enabled control of the copy takes a press (or typing) without an error;
//   a checkbox, switch or radio changes its checked state; a field takes text;
// - a trigger that opens a popup (aria-expanded) opens it, and Escape closes it;
// - Tab reaches every control of the copy that is in the tab order;
// - arrow keys move between the items of a tab list, radio group or menu;
// - each switch, choice and text of the panel, Reset and every scenario button
//   redraw the copy without an error and leave it drawn.
import type { Locator, Page } from '@playwright/test';

const CONTROLS = [
  'button',
  'a[href]',
  'input:not([type=hidden])',
  'textarea',
  '[role=button]',
  '[role=checkbox]',
  '[role=switch]',
  '[role=radio]',
  '[role=tab]',
  '[role=link]',
  '[role=combobox]',
  '[role=spinbutton]',
  '[role=slider]',
].join(', ');
const POPUP = '[role=dialog], [role=alertdialog], [role=menu], [role=listbox], [role=tooltip]';
const SETTLE = 250;

interface Snapshot {
  checked: string | null;
  expanded: string | null;
  value: string | null;
  popups: number;
}

/** A short name for a finding: its role or tag and its accessible text. */
async function nameOf(el: Locator): Promise<string> {
  return el.evaluate((n) => {
    const role = n.getAttribute('role') ?? n.tagName.toLowerCase();
    const label =
      n.getAttribute('aria-label') ??
      (n as HTMLInputElement).labels?.[0]?.textContent ??
      n.textContent ??
      '';
    return `${role} «${label.trim().slice(0, 24)}»`;
  });
}

async function usable(el: Locator): Promise<boolean> {
  return el.evaluate((n) => {
    const h = n as HTMLElement & { disabled?: boolean; readOnly?: boolean };
    if (h.disabled || h.getAttribute('aria-disabled') === 'true') return false;
    if (h.readOnly || h.getAttribute('aria-readonly') === 'true') return false;
    if (h.closest('[inert], [aria-hidden=true]')) return false;
    const r = h.getBoundingClientRect();
    if (r.width === 0 || r.height === 0) return false;
    const s = getComputedStyle(h);
    return s.visibility !== 'hidden' && s.display !== 'none';
  });
}

async function snapshot(page: Page, el: Locator): Promise<Snapshot> {
  const own = await el.evaluate((n) => ({
    checked:
      n.getAttribute('aria-checked') ??
      (n instanceof HTMLInputElement && (n.type === 'checkbox' || n.type === 'radio')
        ? String(n.checked)
        : null),
    expanded: n.getAttribute('aria-expanded'),
    value: n instanceof HTMLInputElement || n instanceof HTMLTextAreaElement ? n.value : null,
  }));
  return { ...own, popups: await visiblePopups(page) };
}

async function visiblePopups(page: Page): Promise<number> {
  return page.evaluate(
    (sel) =>
      [...document.querySelectorAll(sel)].filter((p) => {
        const r = p.getBoundingClientRect();
        return r.width > 0 && r.height > 0 && getComputedStyle(p).visibility !== 'hidden';
      }).length,
    POPUP,
  );
}

const TEXTY = new Set(['text', 'search', 'tel', 'email', 'url', 'number', 'password', '']);

/** Presses (or types into) every enabled control of the copy, one by one. */
async function pressEach(page: Page, stage: Locator, found: string[]): Promise<void> {
  const count = await stage.locator(CONTROLS).count();
  for (let i = 0; i < Math.min(count, 24); i += 1) {
    const el = stage.locator(CONTROLS).nth(i);
    if (!(await el.isVisible()) || !(await usable(el))) continue;
    const name = await nameOf(el);
    if (process.env.PLAY_DEBUG) process.stdout.write(`  press ${name}\n`);
    const field = await el.evaluate(
      (n, texty) =>
        n instanceof HTMLTextAreaElement ||
        (n instanceof HTMLInputElement && texty.includes(n.type)),
      [...TEXTY],
    );
    const before = await snapshot(page, el);
    if (field) {
      await el.click({ timeout: 2000 }).catch(() => found.push(`${name}: cannot be pressed`));
      await page.keyboard.type('12');
      await page.waitForTimeout(SETTLE);
      const after = await snapshot(page, el);
      if (after.value === before.value) found.push(`${name}: typing changed nothing`);
      await page.keyboard.press('Escape');
      continue;
    }
    const pressed = await el
      .click({ timeout: 2000 })
      .then(() => true)
      .catch(() => false);
    if (!pressed) {
      found.push(`${name}: cannot be pressed`);
      continue;
    }
    await page.waitForTimeout(SETTLE);
    const after = await snapshot(page, el);
    if (before.checked !== null && before.checked !== 'true' && after.checked === before.checked)
      found.push(`${name}: a press did not check it`);
    if (before.expanded === 'false') {
      if (after.expanded !== 'true') found.push(`${name}: a press did not open it`);
      else {
        await page.keyboard.press('Escape');
        await page.waitForTimeout(SETTLE);
        if ((await el.getAttribute('aria-expanded').catch(() => 'false')) === 'true')
          found.push(`${name}: Escape did not close it`);
      }
    } else if (after.popups > before.popups) {
      await page.keyboard.press('Escape');
      await page.waitForTimeout(SETTLE);
      if ((await visiblePopups(page)) > before.popups)
        found.push(`${name}: Escape did not close what it opened`);
    }
  }
}

/** Tab from the page's start reaches every control of the copy in the tab order. */
async function tabThrough(page: Page, stage: Locator, found: string[]): Promise<void> {
  const want = await stage.evaluate(
    (s, sel) =>
      [...s.querySelectorAll<HTMLElement>(sel)].filter((n) => {
        const r = n.getBoundingClientRect();
        return (
          n.tabIndex >= 0 &&
          !(n as HTMLButtonElement).disabled &&
          !n.closest('[inert], [aria-hidden=true]') &&
          r.width > 0 &&
          getComputedStyle(n).visibility !== 'hidden'
        );
      }).length,
    CONTROLS,
  );
  if (want === 0) return;
  await page.evaluate(() => {
    (document.activeElement as HTMLElement | null)?.blur();
    window.scrollTo(0, 0);
  });
  const reached = new Set<string>();
  for (let i = 0; i < 80 && reached.size < want; i += 1) {
    await page.keyboard.press('Tab');
    const at = await page.evaluate(() => {
      const a = document.activeElement;
      if (!a?.closest('[data-stage]')) return null;
      a.setAttribute('data-tabbed', '');
      return [...document.querySelectorAll('[data-tabbed]')].indexOf(a);
    });
    if (at !== null) reached.add(String(at));
  }
  if (reached.size < want)
    found.push(`Tab reached ${String(reached.size)} of ${String(want)} controls`);
}

/** Arrow keys move focus between the items of each tab list, radio group and menu. */
async function arrows(page: Page, stage: Locator, found: string[]): Promise<void> {
  const groups = stage.locator('[role=tablist], [role=radiogroup], [role=menu]');
  for (let i = 0; i < (await groups.count()); i += 1) {
    const group = groups.nth(i);
    const items = group.locator('[role=tab], [role=radio], [role=menuitem]');
    const enabled = await items.evaluateAll(
      (ns) => ns.filter((n) => n.getAttribute('aria-disabled') !== 'true').length,
    );
    if (enabled < 2) continue;
    const start = group.locator('[tabindex="0"]').first();
    if (!(await start.count())) continue;
    await start.focus();
    const before = await page.evaluate(() => document.activeElement?.outerHTML);
    await page.keyboard.press('ArrowLeft');
    await page.waitForTimeout(SETTLE);
    const after = await page.evaluate(() => document.activeElement?.outerHTML);
    if (before === after) {
      const role = (await group.getAttribute('role')) ?? 'group';
      found.push(`${role}: ArrowLeft did not move between its items`);
    }
  }
}

async function drawn(stage: Locator): Promise<boolean> {
  return stage.evaluate((s) =>
    [...s.querySelectorAll('*')].some((n) => {
      const r = n.getBoundingClientRect();
      return r.width > 0 && r.height > 0 && n.tagName !== 'DIV';
    }),
  );
}

/** Each control of the panel and each scenario redraws the copy. */
async function panel(page: Page, stage: Locator, found: string[]): Promise<void> {
  const dock = page.locator('[data-dock]');
  const wasDrawn = await drawn(stage);
  const check = async (what: string) => {
    await page.waitForTimeout(SETTLE * 2);
    if (wasDrawn && !(await drawn(page.locator('[data-stage]'))))
      found.push(`panel ${what}: the copy is gone`);
  };
  const switches = await dock.locator('[role=switch]').count();
  for (let i = 0; i < switches; i += 1) {
    const sw = dock.locator('[role=switch]').nth(i);
    const label = await nameOf(sw);
    const before = await sw.getAttribute('aria-checked');
    await sw.click({ timeout: 2000 }).catch(() => found.push(`panel ${label}: cannot be pressed`));
    await check(label);
    const after = await dock.locator('[role=switch]').nth(i).getAttribute('aria-checked');
    if (after === before) found.push(`panel ${label}: the switch did not change`);
  }
  const choices = await dock.locator('[role=combobox]').count();
  for (let i = 0; i < choices; i += 1) {
    const select = dock.locator('[role=combobox]').nth(i);
    const label = await nameOf(select);
    await select.click({ timeout: 2000 }).catch(() => found.push(`panel ${label}: cannot open`));
    const options = page.locator('[role=listbox]:visible [role=option]');
    if ((await options.count()) === 0) {
      found.push(`panel ${label}: no options opened`);
      await page.keyboard.press('Escape');
      continue;
    }
    await options.last().click({ timeout: 2000 });
    await check(label);
  }
  const fields = await dock.locator('input[type=text], input:not([type]), textarea').count();
  for (let i = 0; i < fields; i += 1) {
    const field = dock.locator('input[type=text], input:not([type]), textarea').nth(i);
    const label = await nameOf(field);
    await field.fill('7');
    await check(label);
  }
  const buttons = await dock.locator('button:not([role])').count();
  for (let i = 0; i < buttons; i += 1) {
    const button = dock.locator('button:not([role])').nth(i);
    const label = await nameOf(button);
    await button
      .click({ timeout: 2000 })
      .catch(() => found.push(`panel ${label}: cannot be pressed`));
    await check(label);
  }
}

/** Plays the board's playground; returns what did not work. */
export async function playBoard(page: Page): Promise<string[]> {
  const found: string[] = [];
  const stage = page.locator('[data-stage]');
  if ((await stage.count()) === 0) return ['no playground'];
  await tabThrough(page, stage, found);
  await arrows(page, stage, found);
  await pressEach(page, stage, found);
  await panel(page, stage, found);
  return found;
}
