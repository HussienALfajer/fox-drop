import { describe, expect, it, vi } from 'vitest';

vi.mock('./api.js', () => ({ api: {} }));
vi.mock('./session.js', () => ({ can: () => false }));

const { fileRefusal, linkRefusal } = await import('./restaurant-images.js');
const { mediaUrl } = await import('./media.js');

describe('fileRefusal', () => {
  it('takes JPEG, PNG and WebP up to 8 MB', () => {
    expect(fileRefusal({ type: 'image/jpeg', size: 1000 })).toBeNull();
    expect(fileRefusal({ type: 'image/webp', size: 8 * 1024 * 1024 })).toBeNull();
    expect(fileRefusal({ type: 'image/gif', size: 1000 })).toBe('type');
    expect(fileRefusal({ type: 'image/png', size: 8 * 1024 * 1024 + 1 })).toBe('size');
    expect(fileRefusal({ type: 'image/png', size: 0 })).toBe('size');
  });
});

describe('linkRefusal', () => {
  it('explains a file that is not an image, and retries anything else', () => {
    expect(linkRefusal('upload_invalid')).toBe('not_image');
    expect(linkRefusal('upload_missing')).toBe('upload_failed');
    expect(linkRefusal('upload_expired')).toBe('upload_failed');
  });
});

describe('mediaUrl', () => {
  it('asks imgproxy for a preset width on the panel’s origin', () => {
    expect(mediaUrl('menu/items/a.jpg', 320)).toBe('/media/_/w320/plain/menu/items/a.jpg');
  });
});
