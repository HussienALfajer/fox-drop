import type { ReactNode } from 'react';
import { Button } from '../button/button';
import { formTv, keyboardRing } from '../field/styles';
import { Icon } from '../icon/icon';

/** The states the stories show (R3). */
export const STATES = ['default', 'preparing', 'late', 'readOnly', 'open'] as const;

// The outline card's frame (card.json), as the Flutter twin's FoxCard; the
// parts' spacing and inks are the order card's own.
const card = formTv({
  base: 'flex flex-col gap-(--fd-order-card-gap) rounded-(--fd-card-radius) p-(--fd-card-padding) text-(color:--fd-order-card-color-items)',
  variants: {
    late: {
      true: 'bg-(--fd-card-danger-background) inset-ring-(length:--fd-card-danger-border-width) inset-ring-(--fd-card-danger-border)',
      false:
        'bg-(--fd-card-color-background) inset-ring-(length:--fd-card-border-width) inset-ring-(--fd-card-color-border)',
    },
  },
});

const numberType = 'text-phone-title font-bold tabular-nums';

const opener = formTv({
  base: `cursor-pointer rounded-xs ${numberType} text-(color:--fd-order-card-color-opener) underline-offset-4 hover:underline ${keyboardRing}`,
});

const numberText = `${numberType} text-(color:--fd-order-card-color-number)`;

const muted = 'text-phone-secondary text-(color:--fd-order-card-color-muted)';

const captainLine = `m-none flex items-center gap-(--fd-order-card-line-gap) ${muted}`;

export interface OrderCardProps {
  /** The card's name for screen readers: «طلب #10423». */
  label: string;
  /** The order number without its «#»: «10423». */
  number: string;
  /** Time since it was placed: «منذ 1 د». */
  since: string;
  /** The item count and the first items. */
  items: string;
  /** The captain line of RA §8.1. */
  captain: string;
  /** The column's running timer, a `Timer`. */
  timer: ReactNode;
  /** Badges (RA §8.4), such as an item-unavailable chip. */
  badges?: ReactNode;
  /** The one main button: «قبول», «الطلب جاهز», «تأكيد الاستلام». The portal shows none. */
  action?: { label: string; onPress: () => void };
  /** Past its limit: red, and said in words. */
  late?: boolean;
  /** «متأخر», added to the card's name when late. */
  lateLabel?: string;
  /** Opens the order detail (RA §8.2), the portal's read-only view too: the number becomes its button. */
  onOpen?: () => void;
}

/** The compact card of the restaurant's orders board (RA §8.2). */
export function OrderCard(props: OrderCardProps) {
  const { label, number, since, items, captain, timer, badges, action } = props;
  const { late = false, lateLabel, onOpen } = props;
  const heading = `#${number}`;
  const name = late && lateLabel ? `${label}، ${lateLabel}` : label;
  return (
    <article aria-label={name} className={card({ late })}>
      <div className="flex items-center gap-(--fd-order-card-head-gap)">
        {/* The card holds a button of its own, so it cannot be one: its number opens it. */}
        {onOpen ? (
          <button type="button" onClick={onOpen} aria-label={name} className={opener()}>
            {heading}
          </button>
        ) : (
          <span className={numberText}>{heading}</span>
        )}
        <span className={muted}>{since}</span>
        <span className="flex-1" />
        {timer}
      </div>
      <p className="m-none text-phone-body">{items}</p>
      <p className={captainLine}>
        <Icon name="motorcycle" size="sm" />
        {captain}
      </p>
      {badges ? (
        <div className="flex flex-wrap gap-(--fd-order-card-head-gap)">{badges}</div>
      ) : null}
      {action ? (
        // A grid cell stretches the button to the card's width.
        <div className="grid">
          <Button onClick={action.onPress}>{action.label}</Button>
        </div>
      ) : null}
    </article>
  );
}
