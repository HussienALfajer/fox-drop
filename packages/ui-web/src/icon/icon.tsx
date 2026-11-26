import { icons, type IconName } from '@fox-drop/design-tokens/icons';
import { tv, type VariantProps } from 'tailwind-variants';

export type { IconName };

/** A style of set v4 Madar (architecture §9.4). */
export type IconStyle = 'linear' | 'duotone' | 'brand-duo' | 'broken' | 'bold' | 'bold-duo';

/** The six styles, Linear first. */
export const ICON_STYLES: readonly IconStyle[] = [
  'linear',
  'duotone',
  'brand-duo',
  'broken',
  'bold',
  'bold-duo',
];

/** The states the stories show (R3): the default, each size, labelled, mirrored, each style. */
export const STATES = [
  'default',
  'sm',
  'md',
  'lg',
  'labelled',
  'mirrored',
  // The styles, named as their stories are (R3).
  'duotone',
  'brandDuo',
  'broken',
  'bold',
  'boldDuo',
] as const;

// The sizes are the `icon.size.*` tokens; an icon that mirrors flips under RTL.
const icon = tv({
  base: 'shrink-0',
  variants: {
    size: {
      sm: 'size-(--fd-icon-size-sm)',
      md: 'size-(--fd-icon-size-md)',
      lg: 'size-(--fd-icon-size-lg)',
    },
    mirror: { true: 'rtl:-scale-x-100' },
  },
  defaultVariants: { size: 'md' },
});

// Not the whole VariantProps: `mirror` comes from the icon's own data, never a prop.
export interface IconProps {
  name: IconName;
  size?: VariantProps<typeof icon>['size'];
  /**
   * The style (§9.4): `bold` for a selected item, `brand-duo` for an empty
   * state. Named `variant` because the web lint keeps `style` for nothing (R1).
   */
  variant?: IconStyle | undefined;
  /** The accessible name. Without it the icon is decorative and hidden from screen readers. */
  label?: string;
}

/** The stroke of the line styles on the 24 grid: `icon-stroke.phone` (no web surface is the captain's). */
const STROKE = 1.5;
const BRAND = 'var(--fd-color-brand)';

/**
 * An icon of set v4 Madar on the 24 grid (architecture §9.4), drawn in
 * `currentColor`: Linear, Duotone, Brand Duo and Broken are strokes that
 * scale with the size; Bold and Bold Duo are fills baked at generate time.
 * The icons that point somewhere flip right to left.
 */
export function Icon({ name, size, variant = 'linear', label }: IconProps) {
  const data = icons[name];
  const bold = variant === 'bold' || variant === 'bold-duo';
  const paths = (() => {
    switch (variant) {
      case 'bold':
      case 'bold-duo':
        return (variant === 'bold' ? data.bold : data.boldDuo).map((layer) => (
          <path key={layer.d} d={layer.d} {...(layer.faded ? { fillOpacity: 0.5 } : {})} />
        ));
      case 'broken':
        return data.broken.map((d) => <path key={d} d={d} />);
      default:
        return data.elements.map((e) => (
          <path
            key={e.d}
            d={e.d}
            {...(variant === 'duotone' && !e.accent ? { opacity: 0.5 } : {})}
            {...(variant === 'brand-duo' && e.accent ? { stroke: BRAND } : {})}
          />
        ));
    }
  })();
  return (
    <svg
      viewBox="0 0 24 24"
      {...(bold
        ? { fill: 'currentColor', stroke: 'none' }
        : {
            fill: 'none',
            stroke: 'currentColor',
            strokeWidth: STROKE,
            strokeLinecap: 'round' as const,
            strokeLinejoin: 'round' as const,
          })}
      className={icon({ size, mirror: data.mirror })}
      {...(label ? { role: 'img', 'aria-label': label } : { 'aria-hidden': true })}
    >
      {paths}
    </svg>
  );
}
