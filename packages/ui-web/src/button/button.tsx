import { Button as SdkButton } from '@ui-sdk/react/button';
import type { MouseEvent, ReactNode } from 'react';
import { tv } from 'tailwind-variants';
import { createTV } from 'tailwind-variants/config';
import { SIZES } from '../field/styles';
import { DropLoader } from '../drop-loader/drop-loader';
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
  twMergeConfig: { extend: { classGroups: { 'font-size': [{ text: SIZES }] } } },
});

// The look drawn on the approved sheet (`button()` in design-tokens
// `src/button-sheet.ts`) with the interaction states the owner picked on
// 2026-11-24 (architecture §9.5 R10, «Brand tonal steps»): each variant has its
// own hover and pressed tokens, measured visible by design-tokens' R10 test.
// The colour fades over `duration.base`; nothing moves. No shadow.
const button = buttonTv({
  base: [
    'relative inline-flex items-center justify-center rounded-(--fd-button-radius) font-medium whitespace-nowrap',
    'transition-colors duration-(--fd-duration-base) ease-(--fd-easing-standard)',
    'outline-hidden focus-visible:ring-2 focus-visible:ring-(color:--fd-button-focus-ring) focus-visible:ring-offset-2 focus-visible:ring-offset-surface',
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
    interactive: { true: '', false: '' },
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
        'hover:bg-(--fd-button-primary-background-hover) active:bg-(--fd-button-primary-background-pressed)',
    },
    {
      variant: 'secondary',
      interactive: true,
      class:
        'hover:bg-(--fd-button-secondary-background-hover) hover:inset-ring-(--fd-button-secondary-border-hover) active:bg-(--fd-button-secondary-background-pressed)',
    },
    {
      variant: 'danger',
      interactive: true,
      class:
        'hover:bg-(--fd-button-danger-background-hover) active:bg-(--fd-button-danger-background-pressed)',
    },
    {
      variant: 'ghost',
      interactive: true,
      class:
        'hover:bg-(--fd-button-ghost-background-hover) active:bg-(--fd-button-ghost-background-pressed)',
    },
  ],
  defaultVariants: { variant: 'primary', density: 'comfortable' },
});

/**
 * The Button's classes for another element that must look like it: an
 * overlay's Close part (D.10), which is the SDK's own button.
 */
export function buttonClasses(
  variant: ButtonVariant,
  density: 'comfortable' | 'compact',
  disabled = false,
) {
  return button({ variant, density, iconOnly: false, disabled, interactive: !disabled });
}

const content = tv({
  base: 'inline-flex items-center justify-center gap-(--fd-button-gap)',
  // opacity, not `invisible`: visibility hidden would take the label out of
  // the accessibility tree and leave a loading button without a name (found
  // by the axe gate).
  variants: { loading: { true: 'opacity-0' } },
});

interface ButtonBase {
  /** The look: `primary` by default. */
  variant?: ButtonVariant;
  /** `comfortable` is 50 high (phones); `compact` is 40, for the admin panel and the restaurant portal. */
  density?: 'comfortable' | 'compact';
  /** Shows the drop loader over the hidden label, keeps the width and ignores presses. */
  loading?: boolean;
  /** Shown beside the loader while loading, and the button's name then: «جارٍ إرسال الرمز…». */
  loadingLabel?: string;
  disabled?: boolean;
  /**
   * Looks disabled and says so (`aria-disabled`) yet takes presses, so a form
   * can say what is missing when pressed (ConfirmDialog's confirm).
   */
  softDisabled?: boolean;
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

const OWN = new Set([
  'variant',
  'density',
  'loading',
  'loadingLabel',
  'disabled',
  'softDisabled',
  'icon',
  'iconEnd',
  'children',
  'label',
  'type',
  'onClick',
]);

/**
 * The button of every web app (architecture §9.5, §9.9), on the UI SDK's
 * Button. A `loading` button is disabled for presses but stays focusable.
 */
export function Button(props: ButtonProps) {
  const { variant = 'primary', density = 'comfortable', loading = false } = props;
  const disabled = props.disabled ?? false;
  const looksDisabled = disabled || (props.softDisabled ?? false);
  const { icon, iconEnd, children, label, type, onClick, loadingLabel } = props;
  // What an overlay's trigger merges in through the SDK's `render` (D.10): its
  // ARIA state, ref and handlers. Our own props above win.
  const forwarded = Object.fromEntries(Object.entries(props).filter(([key]) => !OWN.has(key)));
  const iconSize = density === 'compact' ? 'sm' : 'md';
  const iconOnly = children === undefined && icon !== undefined;
  return (
    <SdkButton
      {...forwarded}
      {...(type && { type })}
      {...(onClick && { onClick })}
      {...(iconOnly && { 'aria-label': label })}
      {...(loading && loadingLabel !== undefined && { 'aria-label': loadingLabel })}
      {...(loading && { 'aria-busy': true })}
      {...(props.softDisabled && !disabled && { 'aria-disabled': true })}
      disabled={disabled || loading}
      focusableWhenDisabled={loading && !disabled}
      className={button({
        variant,
        density,
        iconOnly,
        disabled: looksDisabled,
        interactive: !looksDisabled && !loading,
      })}
    >
      <span className={content({ loading })}>
        {icon && <Icon name={icon} size={iconSize} />}
        {children}
        {iconEnd && <Icon name={iconEnd} size={iconSize} />}
      </span>
      {loading && (
        <span className="absolute inset-none flex items-center justify-center gap-(--fd-button-gap)">
          <DropLoader
            size={density === 'compact' ? 'sm' : 'md'}
            onPrimary={variant === 'primary' || variant === 'danger'}
          />
          {loadingLabel}
        </span>
      )}
    </SdkButton>
  );
}
