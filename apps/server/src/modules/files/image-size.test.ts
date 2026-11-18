import { describe, expect, it } from 'vitest';
import { imageSize } from './image-size.js';

// The headers of each type, written by hand: only the bytes the reader looks at.
function png(width: number, height: number): Uint8Array {
  const bytes = new Uint8Array(33);
  bytes.set([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 0, 0, 0, 13]);
  bytes.set([0x49, 0x48, 0x44, 0x52], 12);
  new DataView(bytes.buffer).setUint32(16, width);
  new DataView(bytes.buffer).setUint32(20, height);
  return bytes;
}

function jpeg(width: number, height: number, sofMarker = 0xc0): Uint8Array {
  // SOI, an APP0 segment of 16 bytes, a DQT of 4, then the frame header.
  const app0 = [0xff, 0xe0, 0x00, 0x10, ...new Array<number>(14).fill(0)];
  const dqt = [0xff, 0xdb, 0x00, 0x04, 0, 0];
  const sof = [0xff, sofMarker, 0x00, 0x11, 8, height >> 8, height & 0xff, width >> 8, width & 0xff];
  return Uint8Array.from([0xff, 0xd8, ...app0, ...dqt, ...sof]);
}

function riff(chunk: string, body: number[]): Uint8Array {
  const bytes = new Uint8Array(12 + 8 + body.length);
  bytes.set([0x52, 0x49, 0x46, 0x46, 0, 0, 0, 0, 0x57, 0x45, 0x42, 0x50]);
  bytes.set([...chunk].map((c) => c.charCodeAt(0)), 12);
  bytes.set(body, 20);
  return bytes;
}

describe('imageSize', () => {
  it('reads a PNG', () => {
    expect(imageSize('image/png', png(1200, 500))).toEqual({ width: 1200, height: 500 });
  });

  it('reads a JPEG past its other segments, any frame type', () => {
    expect(imageSize('image/jpeg', jpeg(1200, 500))).toEqual({ width: 1200, height: 500 });
    expect(imageSize('image/jpeg', jpeg(640, 480, 0xc2))).toEqual({ width: 640, height: 480 });
  });

  it('answers null for a JPEG cut before its frame header', () => {
    expect(imageSize('image/jpeg', jpeg(1200, 500).slice(0, 20))).toBeNull();
  });

  it('reads the three WebP forms', () => {
    // Lossy: the frame tag, the start code, then 14-bit sizes, little-endian.
    const lossy = riff('VP8 ', [0, 0, 0, 0x9d, 0x01, 0x2a, 0xb0, 0x04, 0xf4, 0x01]);
    expect(imageSize('image/webp', lossy)).toEqual({ width: 1200, height: 500 });
    // Lossless: the signature, then width-1 and height-1 in 14 bits each.
    const w = 1199;
    const h = 499;
    const bits = w | (h << 14);
    const lossless = riff('VP8L', [
      0x2f,
      bits & 0xff,
      (bits >> 8) & 0xff,
      (bits >> 16) & 0xff,
      (bits >> 24) & 0xff,
    ]);
    expect(imageSize('image/webp', lossless)).toEqual({ width: 1200, height: 500 });
    // Extended: width-1 and height-1 in 24 bits each.
    const extended = riff('VP8X', [0, 0, 0, 0, 0xaf, 0x04, 0x00, 0xf3, 0x01, 0x00]);
    expect(imageSize('image/webp', extended)).toEqual({ width: 1200, height: 500 });
  });

  it('answers null for bytes of another type', () => {
    expect(imageSize('image/png', jpeg(1200, 500))).toBeNull();
    expect(imageSize('image/webp', png(1200, 500))).toBeNull();
  });
});
