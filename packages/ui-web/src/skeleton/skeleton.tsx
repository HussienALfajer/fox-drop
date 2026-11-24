import type { ReactNode } from 'react';
import { formTv } from '../field/styles';

/** The states the stories show (R3). */
export const STATES = ['default', 'listRows', 'orderCard'] as const;

// The approved calm pulse (owner, 2026-11-24): `animate-skeleton` in
// styles.css, opacity 1 → 0.55 → 1 over duration.moment; still under reduced
// motion. Drawn in the shape of what will come, never a spinner over content.
const block = formTv({
  base: 'block bg-neutral-subtle motion-safe:animate-skeleton',
  variants: {
    shape: {
      line: 'h-sm w-full rounded-xs',
      title: 'h-md w-full rounded-xs',
      circle: 'size-xl rounded-full',
      square: 'size-2xl rounded-md',
      media: 'aspect-cover w-full rounded-lg',
      pill: 'h-(--fd-size-control) w-full rounded-full',
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
    <div role="status" aria-label={label} aria-busy="true" className="flex flex-col gap-sm">
      {/* A live region announces its text, not its name. */}
      <span className="sr-only">{label}</span>
      {children}
    </div>
  );
}

/** `Skeleton` with its block as `Skeleton.Block`. */
export const Skeleton = Object.assign(SkeletonRoot, { Block: SkeletonBlock });
