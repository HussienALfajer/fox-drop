import { describe, expect, it } from 'vitest';
import { mapLink } from './map-link.js';

describe('mapLink', () => {
  it('opens Google Maps at the point (AP §9.1.3 «فتح الخريطة»)', () => {
    expect(mapLink({ latitude: 36.5875, longitude: 37.046 })).toBe(
      'https://www.google.com/maps/search/?api=1&query=36.5875%2C37.046',
    );
  });
});
