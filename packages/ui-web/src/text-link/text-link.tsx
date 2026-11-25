import type { ReactNode } from 'react';
import { formTv, keyboardRing } from '../field/styles';

export const STATES = ['default', 'hover', 'focus', 'pressed'] as const;

// Underlined primary words with their hover and pressed tokens (R10). The
// box keeps a 48 target around the words without changing their size.
const link = formTv({
  base: [
    'inline-flex min-h-(--fd-size-touch-target) min-w-(--fd-size-touch-target) cursor-pointer items-center justify-center rounded-xs',
    'text-phone-secondary font-bold underline underline-offset-4',
    'text-(--fd-color-primary) hover:text-(--fd-color-primary-hover) active:text-(--fd-color-primary-pressed)',
    'transition-colors duration-(--fd-duration-base) ease-(--fd-easing-standard)',
    keyboardRing,
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
