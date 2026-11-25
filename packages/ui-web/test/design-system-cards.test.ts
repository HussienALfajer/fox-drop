// The overlays on a card that ends with its Flutter golden (D.P1 review).
import { describe, expect, it } from 'vitest';
import { MODALS, preview } from '../scripts/docs.ts';

const image = { blob: 'abc123', width: 720, height: 400 };
const live = (html: string) => Number(/height=(\d+)/.exec(html.split('\n')[0]!)![1]);

describe('a card with its golden', () => {
  it.each(['Toaster', 'Dialog', 'Menu'])(
    'keeps the %s overlays in the live part, the image below it',
    (name) => {
      const height = live(preview(name));
      const html = preview(name, image);
      expect(html).toMatch(
        new RegExp(`body \\{[^}]*height: ${height}px;[^}]*transform: translateZ\\(0\\)`),
      );
      expect(html).toMatch(new RegExp(`\\.fd-flutter \\{[^}]*inset-block-start: ${height}px`));
    },
  );

  it.each([...MODALS])('does not open the %s modal by itself over the image', (name) => {
    expect(preview(name)).toContain('setTimeout(');
    expect(preview(name, image)).not.toContain('setTimeout(');
  });

  it('still opens a popover by itself', () => {
    expect(MODALS.has('Menu')).toBe(false);
    expect(preview('Menu', image)).toContain('setTimeout(');
  });
});
