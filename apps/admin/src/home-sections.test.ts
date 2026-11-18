import { describe, expect, it, vi } from 'vitest';

vi.mock('./api.js', () => ({ api: {} }));

const { customSectionProblem, movedKey, pickedRestaurants } = await import('./home-sections.js');

describe('movedKey', () => {
  it('moves one step and stays at the edges', () => {
    expect(movedKey(['a', 'b', 'c'], 'c', -1)).toEqual(['a', 'c', 'b']);
    expect(movedKey(['a', 'b', 'c'], 'a', 1)).toEqual(['b', 'a', 'c']);
    expect(movedKey(['a', 'b', 'c'], 'a', -1)).toEqual(['a', 'b', 'c']);
    expect(movedKey(['a', 'b', 'c'], 'c', 1)).toEqual(['a', 'b', 'c']);
  });
});

describe('pickedRestaurants', () => {
  it('keeps the order of picking, a new one at the end', () => {
    expect(pickedRestaurants(['b'], 'a', true)).toEqual(['b', 'a']);
    expect(pickedRestaurants(['b', 'a'], 'a', true)).toEqual(['b', 'a']);
    expect(pickedRestaurants(['b', 'a'], 'b', false)).toEqual(['a']);
  });
});

describe('customSectionProblem', () => {
  it('asks for a title of 1 to 40 characters and 1 to 30 restaurants', () => {
    expect(customSectionProblem({ title: '  ', restaurantIds: ['a'] })).toBe('title');
    expect(customSectionProblem({ title: 'ش'.repeat(41), restaurantIds: ['a'] })).toBe('title');
    expect(customSectionProblem({ title: 'شاورما', restaurantIds: [] })).toBe('restaurants');
    const many = Array.from({ length: 31 }, (_, index) => `${index}`);
    expect(customSectionProblem({ title: 'شاورما', restaurantIds: many })).toBe('restaurants');
    expect(customSectionProblem({ title: ' شاورما ', restaurantIds: ['a'] })).toBeNull();
  });
});
