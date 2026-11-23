import { Button as SdkButton } from '@ui-sdk/react/button';
import type { MouseEvent, ReactNode } from 'react';
import { tv } from 'tailwind-variants';
import { createTV } from 'tailwind-variants/config';
import { Icon, type IconName } from '../icon/icon';

/**
 * The states the stories show (R3): hover, focus and pressed are driven in the
 * browser by the visual gate, so the stories for them are interactive.
 */
export const STATES = [
  'default',
  'hover',
  'focus',
  'pressed',
  'disabled',
  'loading',
  'comfortable',
  'compact',
] as const;

export const VARIANTS = ['primary', 'secondary', 'danger', 'ghost'] as const;
export type ButtonVariant = (typeof VARIANTS)[number];

// tailwind-merge does not know our `text-<surface>-<role>` font sizes and took
// them for colours: `text-(color:--fd-button-*)` then dropped the size (the 130%
// text gate found the label at 16px). Declare the ones used here.
const buttonTv = createTV({
  twMergeConfig: {
    extend: { classGroups: { 'font-size': [{ text: ['phone-subtitle', 'panel-subtitle'] }] } },
  },
});

// The look drawn on the approved sheet (`button()` in design-tokens
// `src/button-sheet.ts`). Hover and pressed are an overlay: the pressed colour
// at 50% over the fill (owner, 2026-11-24) or at 60% over a transparent ghost,
// so a class never needs an arbitrary `color-mix`. The
// overlay sits behind the label (`isolate`, `-z-10`) and goes away while the
// button is pressed, when the pressed colour is the fill itself. No shadow.
const button = buttonTv({
  base: [
    'relative isolate inline-flex items-center justify-center rounded-(--fd-button-radius) font-medium whitespace-nowrap',
    'outline-hidden focus-visible:ring-2 focus-visible:ring-(color:--fd-button-focus-ring) focus-visible:ring-offset-2 focus-visible:ring-offset-surface',
    'before:pointer-events-none before:absolute before:inset-none before:-z-10 before:rounded-(--fd-button-radius) before:opacity-0',
  ],
  variants: {
    variant: { primary: '', secondary: '', danger: '', ghost: '' },
    density: {
      comfortable: 'min-h-(--fd-button-height) text-phone-subtitle',
      compact: 'min-h-(--fd-button-compact-height) text-panel-subtitle',
    },
    iconOnly: { true: 'px-none', false: 'px-(--fd-button-padding-inline)' },
    disabled: {
      true: 'cursor-not-allowed text-(color:--fd-button-disabled-label)',
      false: 'cursor-pointer',
    },
    interactive: { true: 'hover:before:opacity-50 active:before:opacity-0', false: '' },
  },
  compoundVariants: [
    { density: 'comfortable', iconOnly: true, class: 'w-(--fd-button-height)' },
    { density: 'compact', iconOnly: true, class: 'w-(--fd-button-compact-height)' },
    {
      disabled: true,
      variant: ['primary', 'secondary', 'danger'],
      class: 'bg-(--fd-button-disabled-background)',
    },
    { disabled: true, variant: 'ghost', class: 'bg-transparent' },
    {
      variant: 'primary',
      disabled: false,
      class: 'bg-(--fd-button-primary-background) text-(color:--fd-button-primary-label)',
    },
    {
      variant: 'secondary',
      disabled: false,
      class:
        'bg-(--fd-button-secondary-background) text-(color:--fd-button-secondary-label) inset-ring-1 inset-ring-(--fd-button-secondary-border)',
    },
    {
      variant: 'danger',
      disabled: false,
      class: 'bg-(--fd-button-danger-background) text-(color:--fd-button-danger-label)',
    },
    {
      variant: 'ghost',
      disabled: false,
      class: 'bg-transparent text-(color:--fd-button-ghost-label)',
    },
    {
      variant: 'primary',
      interactive: true,
      class:
        'before:bg-(--fd-button-primary-background-pressed) active:bg-(--fd-button-primary-background-pressed)',
    },
    {
      variant: 'secondary',
      interactive: true,
      class:
        'before:bg-(--fd-button-secondary-background-pressed) active:bg-(--fd-button-secondary-background-pressed)',
    },
    {
      variant: 'danger',
      interactive: true,
      class:
        'before:bg-(--fd-button-danger-background-pressed) active:bg-(--fd-button-danger-background-pressed)',
    },
    {
      variant: 'ghost',
      interactive: true,
      class:
        'before:bg-(--fd-button-ghost-background-pressed) active:bg-(--fd-button-ghost-background-pressed) hover:before:opacity-60',
    },
  ],
  defaultVariants: { variant: 'primary', density: 'comfortable' },
});

const content = tv({
  base: 'inline-flex items-center justify-center gap-(--fd-button-gap)',
  // opacity, not `invisible`: visibility hidden would take the label out of
  // the accessibility tree and leave a loading button without a name (found
  // by the axe gate).
  variants: { loading: { true: 'opacity-0' } },
});

const spinner = tv({
  base: 'animate-spin motion-reduce:animate-none',
  variants: {
    density: {
      comfortable: 'size-(--fd-size-icon-md)',
      compact: 'size-(--fd-size-icon-sm)',
    },
  },
});

interface ButtonBase {
  /** The look: `primary` by default. */
  variant?: ButtonVariant;
  /** `comfortable` is 50 high (phones); `compact` is 40, for the admin panel and the restaurant portal. */
  density?: 'comfortable' | 'compact';
  /** Shows a spinner over the hidden label, keeps the width and ignores presses. */
  loading?: boolean;
  disabled?: boolean;
  type?: 'button' | 'submit' | 'reset';
  onClick?: (event: MouseEvent<HTMLElement>) => void;
}

interface TextButton {
  children: ReactNode;
  /** At the start of the label (right in RTL). */
  icon?: IconName;
  /** At the end of the label (left in RTL). */
  iconEnd?: IconName;
  label?: never;
}

interface IconOnlyButton {
  /** An icon alone makes a circle; its accessible name is `label`. */
  icon: IconName;
  label: string;
  iconEnd?: never;
  children?: never;
}

export type ButtonProps = ButtonBase & (TextButton | IconOnlyButton);

/**
 * The button of every web app (architecture §9.5, §9.9), on the UI SDK's
 * Button. A `loading` button is disabled for presses but stays focusable.
 */
export function Button(props: ButtonProps) {
  const { variant = 'primary', density = 'comfortable', loading = false, disabled = false } = props;
  const { icon, iconEnd, children, label, type, onClick } = props;
  const iconSize = density === 'compact' ? 'sm' : 'md';
  const iconOnly = children === undefined && icon !== undefined;
  return (
    <SdkButton
      {...(type && { type })}
      {...(onClick && { onClick })}
      {...(iconOnly && { 'aria-label': label })}
      {...(loading && { 'aria-busy': true })}
      disabled={disabled || loading}
      focusableWhenDisabled={loading && !disabled}
      className={button({
        variant,
        density,
        iconOnly,
        disabled,
        interactive: !disabled && !loading,
      })}
    >
      <span className={content({ loading })}>
        {icon && <Icon name={icon} size={iconSize} />}
        {children}
        {iconEnd && <Icon name={iconEnd} size={iconSize} />}
      </span>
      {loading && (
        <span className="absolute inset-none flex items-center justify-center">
          <svg
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth={2.5}
            strokeLinecap="round"
            aria-hidden="true"
            className={spinner({ density })}
          >
            <path d="M12 3a9 9 0 1 0 9 9" />
          </svg>
        </span>
      )}
    </SdkButton>
  );
}
