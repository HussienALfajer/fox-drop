import type { ReactNode } from 'react';
import { formTv } from '../field/styles';

export const STATES = ['default', 'hover', 'focus', 'pressed'] as const;

// Underlined primary words with their hover and pressed tokens (R10). The
// box keeps a 48 target around the words without changing their size.
const link = formTv({
  base: [
    'inline-flex min-h-(--fd-text-link-target) min-w-(--fd-text-link-target) cursor-pointer items-center justify-center rounded-(--fd-text-link-radius)',
    'text-phone-secondary font-bold underline underline-offset-4',
    'text-(--fd-text-link-color-text) hover:text-(--fd-text-link-color-text-hover) active:text-(--fd-text-link-color-text-pressed)',
    'transition-colors duration-(--fd-duration-base) ease-(--fd-easing-standard)',
    'outline-hidden focus-visible:ring-2 focus-visible:ring-(color:--fd-text-link-color-focus-ring) focus-visible:ring-offset-2 focus-visible:ring-offset-surface',
  ],
});

export interface TextLinkProps {
  children: ReactNode;
  /** Where it goes; without it, the link acts through `onClick`. */
  href?: string;
  onClick?: () => void;
}

/**
 * Underlined words that act: «ليس الآن», «تعديل الرقم», «الشروط». Always read
 * as a link; an address makes it a real one. Without one it is a button,
 * so Space acts too: harmless, and kept (review, 2026-11-25).
 */
export function TextLink({ children, href, onClick }: TextLinkProps) {
  if (href) {
    return (
      <a href={href} onClick={onClick} className={link()}>
        {children}
      </a>
    );
  }
  return (
    <button type="button" role="link" onClick={onClick} className={link()}>
      {children}
    </button>
  );
}
