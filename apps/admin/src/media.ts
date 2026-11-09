// imgproxy's widths, in pixels (infra/imgproxy/imgproxy.env; infra.test.mjs
// keeps them equal).
export const MEDIA_WIDTHS = [160, 320, 640, 1280] as const;
export type MediaWidth = (typeof MEDIA_WIDTHS)[number];

// An image of public-media through imgproxy on the panel's own origin
// (architecture §5.8): nginx, and Vite in development, forward /media to it.
export function mediaUrl(key: string, width: MediaWidth): string {
  return `/media/_/w${width}/plain/${key}`;
}
