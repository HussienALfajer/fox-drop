import { useId, type ReactNode } from 'react';
import { formTv, keyboardRing } from '../field/styles';
import { Icon, type IconName } from '../icon/icon';

/** The states the stories show (R3). */
export const STATES = [
  'default',
  'value',
  'hover',
  'focus',
  'pressed',
  'danger',
  'disabled',
  'compact',
] as const;

// The D.9 sheet (D.W3b): 56 on the phone with a 40 lead, 40 in the panel
// with a 24 lead, on the raised surface.
const row = formTv({
  base: 'flex w-full items-center gap-(--fd-list-row-gap) bg-(--fd-list-row-color-background) py-(--fd-list-row-padding-block) text-start transition-colors duration-(--fd-duration-base) ease-(--fd-easing-standard)',
  variants: {
    density: {
      comfortable: 'min-h-(--fd-list-row-min-height) px-(--fd-list-row-padding-inline)',
      compact: 'min-h-(--fd-list-row-compact-min-height) px-(--fd-list-row-compact-padding-inline)',
    },
    tone: {
      default: 'text-(color:--fd-list-row-color-label)',
      danger: 'text-(color:--fd-list-row-danger-label)',
    },
    pressable: {
      true: `cursor-pointer hover:bg-(--fd-list-row-color-background-hover) active:bg-(--fd-list-row-color-background-pressed) ${keyboardRing}`,
    },
    disabled: {
      true: 'cursor-not-allowed text-(color:--fd-list-row-color-disabled) hover:bg-(--fd-list-row-color-background) active:bg-(--fd-list-row-color-background)',
    },
  },
  defaultVariants: { density: 'comfortable', tone: 'default' },
});

const lead = formTv({
  base: 'flex shrink-0 items-center justify-center rounded-full',
  variants: {
    tone: {
      default: 'bg-(--fd-list-row-color-lead)',
      danger: 'bg-(--fd-list-row-danger-lead)',
    },
    density: {
      comfortable: 'size-(--fd-list-row-lead-size)',
      compact: 'size-(--fd-list-row-compact-lead-size)',
    },
  },
  // Without them a row that names no density or tone drew no circle (D.W3b).
  defaultVariants: { density: 'comfortable', tone: 'default' },
});

export interface ListRowProps {
  title: string;
  /** The second line: an address, a time. */
  description?: string | undefined;
  /** An icon in a tinted circle at the start. */
  leading?: IconName | undefined;
  /** The end slot: a value or a chip; a switch only when the row has no `onPress` (a button holds no control). */
  end?: ReactNode;
  /** Opens something: the row is then one button with a chevron at the end. */
  onPress?: (() => void) | undefined;
  tone?: 'default' | 'danger';
  disabled?: boolean;
  density?: 'comfortable' | 'compact';
}

/** One row of a list: a lead icon, a title, a second line and an end slot. */
export function ListRow(props: ListRowProps) {
  const { title, description, leading, end, onPress, tone, disabled = false, density } = props;
  const descriptionId = useId();
  const endId = useId();
  // A pressable row is one button: its second line and its end slot (a value,
  // a chip; never a control) describe it.
  const describedBy = [description ? descriptionId : '', end ? endId : '']
    .filter(Boolean)
    .join(' ');
  const pressable = onPress !== undefined;
  const inner = (
    <>
      {leading ? (
        <span className={lead({ tone, density })}>
          <Icon name={leading} size={density === 'compact' ? 'sm' : 'md'} />
        </span>
      ) : null}
      <span className="flex min-w-none flex-1 flex-col">
        <span className={density === 'compact' ? 'text-panel-body' : 'text-phone-body font-medium'}>
          {title}
        </span>
        {description ? (
          <span
            id={descriptionId}
            className={
              disabled
                ? 'text-phone-secondary'
                : 'text-phone-secondary text-(color:--fd-list-row-color-description)'
            }
          >
            {description}
          </span>
        ) : null}
      </span>
      {end ? (
        <span id={endId} className="inline-flex">
          {end}
        </span>
      ) : null}
      {pressable && tone !== 'danger' ? (
        <span className="inline-flex -scale-x-100 text-(color:--fd-list-row-color-chevron)">
          <Icon name="back" size="sm" />
        </span>
      ) : null}
    </>
  );
  if (!pressable) return <div className={row({ tone, density, disabled })}>{inner}</div>;
  // The chevron points along the reading direction (to the left in Arabic):
  // `back` mirrors under RTL, and the span flips it once more.
  return (
    <button
      type="button"
      onClick={onPress}
      disabled={disabled}
      aria-label={title}
      aria-describedby={describedBy || undefined}
      className={row({ tone, density, pressable: true, disabled })}
    >
      {inner}
    </button>
  );
}
