import { mkdirSync, mkdtempSync, readdirSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import path from 'node:path';
import { describe, expect, it } from 'vitest';
import { COMPONENT_DIR, componentUsage, ROOTS } from './component-usage.ts';

// Every token of a component file that declares its folders is read on both
// sides (slice D.W1, architecture §9.2): no unread tokens.
describe('the component tokens are read where they are declared', () => {
  const declaring = readdirSync(COMPONENT_DIR).filter(
    (file) => componentUsage(path.join(COMPONENT_DIR, file), ROOTS).declared,
  );

  it('covers button.json', () => {
    expect(declaring).toContain('button.json');
  });

  it.each(readdirSync(COMPONENT_DIR))('%s: every declared token is read', (file) => {
    expect(componentUsage(path.join(COMPONENT_DIR, file), ROOTS).problems).toEqual([]);
  });

  describe('a fixture', () => {
    const root = mkdtempSync(path.join(tmpdir(), 'fd-usage-'));
    const roots = { web: path.join(root, 'web'), flutter: path.join(root, 'flutter') };
    mkdirSync(path.join(roots.web, 'chip'), { recursive: true });
    mkdirSync(path.join(roots.flutter, 'chip'), { recursive: true });
    writeFileSync(
      path.join(roots.web, 'chip/chip.tsx'),
      "export const c = 'h-(--fd-chip-height) bg-(--fd-chip-fill-hover) px-(--fd-chip-wide-only)';",
    );
    writeFileSync(
      path.join(roots.flutter, 'chip/fox_chip.dart'),
      'final a = theme.components.chip.height + chip.fillHover + chip.gap;',
    );
    const write = (
      name: string,
      tokens: object,
      folders = { web: ['chip'], flutter: ['chip'] },
    ) => {
      const file = path.join(root, `${name}.json`);
      writeFileSync(
        file,
        JSON.stringify({ chip: { $extensions: { 'app.foxdrop': folders }, ...tokens } }),
      );
      return componentUsage(file, roots);
    };
    const height = { height: { $type: 'dimension', $value: '{size.control}' } };
    const fillHover = { fill: { hover: { $type: 'color', $value: '{color.surface-hover}' } } };

    it('passes when both sides read every token', () => {
      expect(write('ok', { ...height, ...fillHover }).problems).toEqual([]);
    });

    it('fails a token no web file reads, with its name', () => {
      const result = write('web', { ...height, gap: { $type: 'dimension', $value: '{space.xs}' } });
      expect(result.problems).toEqual([expect.stringMatching(/chip\.gap.*web.*--fd-chip-gap/)]);
    });

    it('fails a token no Flutter file reads, with its name', () => {
      const result = write('flutter', {
        ...height,
        'wide-only': { $type: 'dimension', $value: '{space.md}' },
      });
      expect(result.problems).toEqual([
        expect.stringMatching(/chip\.wide-only.*Flutter.*wideOnly/),
      ]);
    });

    it('lets a token say it belongs to the web side only', () => {
      const result = write('web-only', {
        ...height,
        'wide-only': {
          $type: 'dimension',
          $value: '{space.md}',
          $extensions: { 'app.foxdrop': { sides: ['web'] } },
        },
      });
      expect(result.problems).toEqual([]);
    });

    it('lets a deprecated token go unread, for its last release (§9.2)', () => {
      const result = write('deprecated', {
        ...height,
        gap: { $type: 'dimension', $value: '{space.xs}', $deprecated: 'the skeleton block' },
      });
      expect(result.problems).toEqual([]);
    });

    it('fails a declared folder that does not exist', () => {
      const result = write('missing', height, { web: ['chip', 'gone'], flutter: ['chip'] });
      expect(result.problems).toEqual([expect.stringMatching(/web folder gone.*does not exist/)]);
    });

    it('does not count a field of another object as a Flutter read (review of D.W1)', () => {
      writeFileSync(path.join(roots.flutter, 'chip/other.dart'), 'final b = this.size + old.size;');
      const result = write('other', {
        ...height,
        size: { $type: 'dimension', $value: '{size.icon-sm}' },
      });
      expect(result.problems).toContainEqual(
        expect.stringMatching(/chip\.size: no Flutter file .* reads chip\.size/),
      );
    });

    it('does not count a longer token name as a read', () => {
      const result = write('prefix', {
        ...height,
        fill: { $type: 'color', $value: '{color.surface}' },
      });
      expect(result.problems).toEqual([
        expect.stringMatching(/chip\.fill: .*web/),
        expect.stringMatching(/chip\.fill: .*Flutter/),
      ]);
    });
  });
});
