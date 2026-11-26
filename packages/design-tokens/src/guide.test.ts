import { describe, expect, it } from 'vitest';
import { boards, canvas, rules } from './guide.ts';
import { exported } from './generate.ts';
import { resolveAll } from './resolve.ts';

const themes = await resolveAll();
const config = { system: 'https://claude.ai/artifact/example', created: '2026-11-23T00:00:00Z' };
const list = boards(themes, config, '0.0.0');
const index = JSON.parse(canvas(list, config, '2026-11-23T01:00:00Z')) as {
  boards: Record<string, { w: number; h: number }>;
  order: string[];
  designSystems: { namespace: string; artifact: string }[];
};

describe('the Fox Drop Guide (architecture §9.8)', () => {
  it('has the six pages, Main first', () => {
    expect(index.order).toEqual([
      'Main.dc.html',
      'Colour.dc.html',
      'Type.dc.html',
      'Foundations.dc.html',
      'Shapes.dc.html',
      'Rules.dc.html',
    ]);
  });

  it.each(list.map((b) => [b.file, b] as const))('%s follows the artboard skeleton', (file, b) => {
    expect(b.html).toContain('<script src="./support.js"></script>');
    expect(b.html).toMatch(/<script type="text\/x-dc" data-dc-script data-props='[^']*'>/);
    expect(b.html).toContain('class Component extends DCLogic');
    expect(b.html).toContain('<html lang="ar" dir="rtl">');
    const props = /data-props='([^']*)'/.exec(b.html)![1]!;
    const preview = (JSON.parse(props) as { $preview: { width: number; height: number } }).$preview;
    expect(preview).toEqual({ width: index.boards[file]!.w, height: index.boards[file]!.h });
  });

  it('shows every semantic colour of every theme on the Colour page', () => {
    const html = list.find((b) => b.file === 'Colour.dc.html')!.html;
    for (const theme of Object.values(themes))
      for (const token of exported(theme).filter((t) => t.path[0] === 'color')) {
        expect(html, token.path.join('.')).toContain(`>${token.path.slice(1).join('-')}<`);
        expect(html, token.path.join('.')).toContain(String(token.value));
      }
    expect(html).toContain('owner exception');
  });

  it('lists the twenty rules of §9.5', () => {
    expect(rules().map((r) => r.id)).toEqual([
      'R1',
      'R2',
      'R3',
      'R4',
      'R5',
      'R6',
      'R7',
      'R8',
      'R9',
      'R10',
      'R11',
      'R12',
      'R13',
      'R14',
      'R15',
      'R16',
      'R17',
      'R18',
      'R19',
      'R20',
    ]);
  });

  // The canvas is right to left: English prose is isolated, or its full
  // stops and brackets jump to the start of the line.
  it('isolates every English heading line and description', () => {
    for (const b of list)
      for (const [, text] of b.html.matchAll(/<(?:h1|p)\b[^>]*>([\s\S]*?)<\/(?:h1|p)>/g))
        expect(text, b.file).toMatch(/^<span dir="ltr">[\s\S]*<\/span>$/);
  });

  // A board is a fixed frame: a size token is drawn at its own width, so a
  // wide one (a dialog, a drawer) is a bar, never a circle as tall as it is.
  it('draws only control-sized sizes as circles and grows Foundations with them', () => {
    const html = list.find((b) => b.file === 'Foundations.dc.html')!.html;
    for (const [, w, h] of html.matchAll(/width: (\d+)px; height: (\d+)px; border-radius: 9999px/g))
      if (w === h) expect(Number(w)).toBeLessThanOrEqual(64);
    expect(html).toMatch(/height: 16px; width: 460px/);
    expect(index.boards['Foundations.dc.html']!.h).toBeGreaterThan(2500);
  });

  it('installs the Fox Drop Design System', () => {
    expect(index.designSystems).toEqual([
      expect.objectContaining({ namespace: 'fox-drop', artifact: config.system }),
    ]);
  });
});
