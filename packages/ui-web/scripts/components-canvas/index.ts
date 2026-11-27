// The index board of the "Fox Drop Components" canvas (D.C2): what the page is,
// how to read a board, and a link to every board by Design System group.
import { COMPONENTS as COPY, GROUPS, INDEX } from './copy-ar.ts';
import { esc, type Fonts, page, WIDTH } from './page.ts';

const MUTED = 'color: var(--fd-color-on-surface-muted);';
const CARD =
  'display: flex; flex-direction: column; gap: var(--fd-space-xs); padding: var(--fd-space-lg); border-radius: var(--fd-radius-lg); background: var(--fd-color-surface); border: 1px solid var(--fd-color-border);';

/** The group order of the page: the Design System's, by first appearance in COMPONENTS. */
export function makeIndex(
  groups: { group: string; names: string[] }[],
  h: number,
  fonts: Fonts,
): string {
  const total = groups.reduce((n, g) => n + g.names.length, 0);
  const cards = INDEX.cards
    .map(
      (c) =>
        `    <div style="${CARD}"><strong style="font-size: 17px;">${esc(c.title)}</strong><span style="font-size: 15px; line-height: 1.7; ${MUTED}">${esc(c.text)}</span></div>`,
    )
    .join('\n');
  const lists = groups
    .map((g) => {
      const links = g.names
        .map(
          (name) =>
            `<li style="display: flex; flex-direction: column; gap: 2px;"><a dir="ltr" href="${esc(name)}.dc.html" style="font-size: 16px; font-weight: 700; text-decoration: none; align-self: flex-start;">${esc(name)}</a><span style="font-size: 13px; line-height: 1.5; ${MUTED}">${esc(COPY[name]?.desc ?? '')}</span></li>`,
        )
        .join('');
      return `    <section style="${CARD}">
      <strong style="font-size: 20px;">${esc(GROUPS[g.group] ?? g.group)} <span style="font-weight: 400; ${MUTED}">· ${String(g.names.length)}</span></strong>
      <ul style="margin: 0; padding: 0; list-style: none; display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: var(--fd-space-md) var(--fd-space-lg);">${links}</ul>
    </section>`;
    })
    .join('\n');
  const content =
    total > 0
      ? lists
      : `    <p style="margin: 0; font-size: 18px; line-height: 1.8; ${MUTED}">${esc(INDEX.empty)}</p>`;
  return page({
    title: 'Fox Drop Components',
    w: WIDTH,
    h,
    fonts,
    vals: {},
    logic: '    return { v };',
    body: `<div dir="rtl" lang="ar" style="width: ${String(WIDTH)}px; height: ${String(h)}px; box-sizing: border-box; padding: var(--fd-space-3xl) 80px; display: flex; flex-direction: column; gap: var(--fd-space-xl); background: var(--fd-color-surface-raised); color: var(--fd-color-on-surface); font-family: var(--fd-font-family-sans);">
  <header style="display: flex; flex-direction: column; gap: var(--fd-space-sm); max-width: 1000px;">
    <p style="margin: 0; font-size: 15px; ${MUTED}">${esc(INDEX.kicker)} · ${String(total)}</p>
    <h1 dir="ltr" style="margin: 0; font-size: 48px; line-height: 1.2; font-weight: 700; color: var(--fd-color-heading); align-self: flex-start;">Fox Drop Components</h1>
    <p style="margin: 0; font-size: 18px; line-height: 1.8;">${esc(INDEX.lead)}</p>
  </header>
  <div style="display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: var(--fd-space-lg);">
${cards}
  </div>
  <div style="display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: var(--fd-space-lg); align-items: start;">
${content}
  </div>
</div>`,
  });
}
