import { readFileSync } from 'node:fs';
import { describe, expect, it } from 'vitest';
import { z } from 'zod';
import { catalogue } from './catalogue.js';

// «الإعدادات» (AP §9.14, slice 2.38a) shows every setting by its Arabic name
// and description from the panel's translations, by key (AP §4.7), so a new
// setting fails here until it has its words. «التطبيقات» names its own.
const ar = JSON.parse(
  readFileSync(new URL('../../../../admin/src/locales/ar.json', import.meta.url), 'utf8'),
) as {
  settings: {
    name: Record<string, string>;
    description: Record<string, string>;
    choice: Record<string, Record<string, string>>;
  };
};

const shown = Object.keys(catalogue).filter((key) => !key.startsWith('app.'));
const weekdays = ['saturday', 'sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday'];

// The values of an enum setting, an enum's or a list of enums'.
function choicesOf(schema: z.ZodType): string[] | null {
  if (schema instanceof z.ZodEnum) return schema.options as string[];
  if (schema instanceof z.ZodArray) return choicesOf(schema.element as z.ZodType);
  return null;
}

describe('the panel names every setting', () => {
  it('has a name and a description for each, and none for a key gone', () => {
    expect(Object.keys(ar.settings.name).sort()).toEqual([...shown].sort());
    expect(Object.keys(ar.settings.description).sort()).toEqual([...shown].sort());
  });

  it('names each choice of an enum setting', () => {
    for (const key of shown) {
      const definition = catalogue[key as keyof typeof catalogue];
      if (definition.type !== 'enum') continue;
      const choices = choicesOf(definition.schema as z.ZodType);
      expect(choices, key).not.toBeNull();
      const words =
        JSON.stringify(choices) === JSON.stringify(weekdays)
          ? ar.settings.choice.weekday
          : ar.settings.choice[key];
      expect(Object.keys(words ?? {}).sort(), key).toEqual([...choices!].sort());
    }
  });
});
