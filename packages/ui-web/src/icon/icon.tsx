import { icons, type IconName } from '@fox-drop/design-tokens/icons';
import { tv, type VariantProps } from 'tailwind-variants';

export type { IconName };

/** The states the stories show (R3): the default, each size, labelled, mirrored. */
export const STATES = ['default', 'sm', 'md', 'lg', 'labelled', 'mirrored'] as const;

// The sizes are the `size.icon-*` tokens; an icon that mirrors flips under RTL.
const icon = tv({
  base: 'shrink-0',
  variants: {
    size: {
      sm: 'size-(--fd-size-icon-sm)',
      md: 'size-(--fd-size-icon-md)',
      lg: 'size-(--fd-size-icon-lg)',
    },
    mirror: { true: 'rtl:-scale-x-100' },
  },
  defaultVariants: { size: 'md' },
});

// Not the whole VariantProps: `mirror` comes from the icon's own data, never a prop.
export interface IconProps {
  name: IconName;
  size?: VariantProps<typeof icon>['size'];
  /** The accessible name. Without it the icon is decorative and hidden from screen readers. */
  label?: string;
}

/**
 * A line icon on the 24 grid (architecture §9.4): drawn in `currentColor`,
 * its stroke scales with the size, and the icons that point somewhere flip
 * right to left.
 */
export function Icon({ name, size, label }: IconProps) {
  const { d, mirror } = icons[name];
  return (
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth={2}
      strokeLinecap="round"
      strokeLinejoin="round"
      className={icon({ size, mirror })}
      {...(label ? { role: 'img', 'aria-label': label } : { 'aria-hidden': true })}
    >
      {d.map((path) => (
        <path key={path} d={path} />
      ))}
    </svg>
  );
}
