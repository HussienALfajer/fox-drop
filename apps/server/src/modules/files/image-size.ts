import type { ImageType } from './schema.js';

export interface ImageSize {
  width: number;
  height: number;
}

// The JPEG markers that start a frame header (SOF0 to SOF15 but DHT, JPG and
// DAC), which holds the height and the width.
const FRAME_MARKERS = new Set([
  0xc0, 0xc1, 0xc2, 0xc3, 0xc5, 0xc6, 0xc7, 0xc9, 0xca, 0xcb, 0xcd, 0xce, 0xcf,
]);

// The pixel size written in an image's header (slice 2.27c: a banner must be
// exactly 1200×500), or null when the bytes are not that type or end before
// the size. Reads only the header, never decodes the image.
export function imageSize(type: ImageType, bytes: Uint8Array): ImageSize | null {
  const at = (i: number) => bytes[i] ?? 0;
  const u16be = (i: number) => (at(i) << 8) | at(i + 1);
  const u16le = (i: number) => at(i) | (at(i + 1) << 8);
  const u24le = (i: number) => at(i) | (at(i + 1) << 8) | (at(i + 2) << 16);
  const is = (text: string, i: number) =>
    [...text].every((c, k) => bytes[i + k] === c.charCodeAt(0));
  switch (type) {
    case 'image/png':
      if (bytes.length < 24 || at(0) !== 0x89 || !is('PNG', 1) || !is('IHDR', 12)) return null;
      return {
        width: new DataView(bytes.buffer, bytes.byteOffset).getUint32(16),
        height: new DataView(bytes.buffer, bytes.byteOffset).getUint32(20),
      };
    case 'image/jpeg': {
      if (at(0) !== 0xff || at(1) !== 0xd8) return null;
      let i = 2;
      while (i + 9 <= bytes.length) {
        if (at(i) !== 0xff) return null;
        const marker = at(i + 1);
        // Fill bytes before a marker.
        if (marker === 0xff) {
          i += 1;
          continue;
        }
        if (FRAME_MARKERS.has(marker)) return { width: u16be(i + 7), height: u16be(i + 5) };
        // The markers without a length.
        if (marker === 0x01 || (marker >= 0xd0 && marker <= 0xd8)) {
          i += 2;
          continue;
        }
        // The scan's data, or the end, before any frame header.
        if (marker === 0xda || marker === 0xd9) return null;
        i += 2 + u16be(i + 2);
      }
      return null;
    }
    case 'image/webp':
      if (!is('RIFF', 0) || !is('WEBP', 8)) return null;
      if (is('VP8 ', 12)) {
        if (bytes.length < 30 || at(23) !== 0x9d || at(24) !== 0x01 || at(25) !== 0x2a) return null;
        return { width: u16le(26) & 0x3fff, height: u16le(28) & 0x3fff };
      }
      if (is('VP8L', 12)) {
        if (bytes.length < 25 || at(20) !== 0x2f) return null;
        const bits = (at(21) | (at(22) << 8) | (at(23) << 16) | (at(24) << 24)) >>> 0;
        return { width: (bits & 0x3fff) + 1, height: ((bits >>> 14) & 0x3fff) + 1 };
      }
      if (is('VP8X', 12) && bytes.length >= 30)
        return { width: u24le(24) + 1, height: u24le(27) + 1 };
      return null;
  }
}
