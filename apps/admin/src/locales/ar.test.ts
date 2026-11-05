import { describe, expect, it } from 'vitest';
import ar from './ar.json';

function strings(value: unknown): string[] {
  if (typeof value === 'string') return [value];
  return Object.values(value as Record<string, unknown>).flatMap(strings);
}

describe('Arabic translations', () => {
  it('has no empty string', () => {
    expect(strings(ar).filter((text) => text.trim() === '')).toEqual([]);
  });

  // AP §4.7: numbers use Western digits (0–9), never Arabic-Indic ones.
  it('uses Western digits only', () => {
    expect(strings(ar).filter((text) => /[٠-٩۰-۹]/.test(text))).toEqual([]);
  });
});
