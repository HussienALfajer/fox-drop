import { describe, expect, it, vi } from 'vitest';

vi.mock('./api.js', () => ({ api: {} }));

const { chosenCategories } = await import('./categories.js');

const category = (id: string, active = true) => ({ id, name: id, imageKey: null, active });

describe('chosenCategories', () => {
  const order = [category('a'), category('b', false), category('c'), category('d')];

  it('keeps the platform’s order whatever the order of the ticks', () => {
    expect(chosenCategories(order, ['d'], 'a', true)).toEqual(['a', 'd']);
    expect(chosenCategories(order, ['d', 'a'], 'c', true)).toEqual(['a', 'c', 'd']);
  });

  it('unticks one, and drops a removed category once the choice is saved', () => {
    expect(chosenCategories(order, ['a', 'c'], 'a', false)).toEqual(['c']);
    expect(chosenCategories(order, ['b', 'c'], 'd', true)).toEqual(['c', 'd']);
  });
});
