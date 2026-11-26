import type { ReactNode } from 'react';
import { formTv } from '../field/styles';

/** The states the stories show (R3). */
export const STATES = ['default', 'listRows', 'orderCard'] as const;

// The approved calm pulse (owner, 2026-11-24): `animate-skeleton` in
// styles.css, opacity 1 → 0.55 → 1 over duration.moment; still under reduced
// motion. Drawn in the shape of what will come, never a spinner over content.
const block = formTv({
  base: 'block bg-(--fd-skeleton-background) motion-safe:animate-skeleton',
  variants: {
    shape: {
      line: 'h-(--fd-skeleton-line-height) w-full rounded-(--fd-skeleton-radius)',
      title: 'h-(--fd-skeleton-web-title-height) w-full rounded-(--fd-skeleton-radius)',
      circle: 'size-(--fd-skeleton-web-circle-size) rounded-full',
      square: 'size-(--fd-skeleton-web-square-size) rounded-(--fd-skeleton-web-square-radius)',
      media: 'aspect-cover w-full rounded-(--fd-skeleton-web-media-radius)',
      pill: 'h-(--fd-skeleton-web-pill-height) w-full rounded-full',
    },
  },
  defaultVariants: { shape: 'line' },
});

export interface SkeletonBlockProps {
  shape?: 'line' | 'title' | 'circle' | 'square' | 'media' | 'pill';
}

/** One grey block of a skeleton. */
export function SkeletonBlock({ shape }: SkeletonBlockProps) {
  return <span aria-hidden="true" data-skeleton-block="" className={block({ shape })} />;
}

export interface SkeletonProps {
  /** Read once by screen readers: «جارٍ التحميل». */
  label: string;
  /** The blocks, laid out like the content they stand for. */
  children: ReactNode;
}

/** The loading state of R6: blocks in the shape of the content. */
function SkeletonRoot({ label, children }: SkeletonProps) {
  return (
    <div
      role="status"
      aria-label={label}
      aria-busy="true"
      className="flex flex-col gap-(--fd-skeleton-web-gap)"
    >
      {/* A live region announces its text, not its name. */}
      <span className="sr-only">{label}</span>
      {children}
    </div>
  );
}

/** `Skeleton` with its block as `Skeleton.Block`. */
export const Skeleton = Object.assign(SkeletonRoot, { Block: SkeletonBlock });
