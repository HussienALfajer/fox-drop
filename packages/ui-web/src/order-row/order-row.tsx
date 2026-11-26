import type { ReactNode } from 'react';
import { Card } from '../card/card';
import { keyboardRing } from '../field/styles';
import { Logo } from '../logo/logo';

/** The states the stories show (R3), as the Flutter twin's. */
export const STATES = ['active', 'past', 'cancelled'] as const;

const title = 'text-start text-phone-subtitle text-(color:--fd-order-row-color-title)';

// The name's target covers the card (its `after`), as the Flutter card is
// one button; the reorder action sits above it.
const opener = `cursor-pointer rounded-xs ${title} after:absolute after:inset-none ${keyboardRing}`;

export interface OrderRowProps {
  restaurant: string;
  /** «اليوم · 9:45 م» or the date. */
  date: string;
  /** A `StatusChip` with the customer's wording. */
  status: ReactNode;
  /** A `Money`. */
  total: ReactNode;
  /** The restaurant's logo; without it, its first letter. */
  logo?: string;
  /** «اطلب مرة أخرى» on a past order. */
  trailing?: ReactNode;
  /** Opens the order. */
  onPress?: () => void;
}

/**
 * One order in the customer's «طلباتي» (CU §12.3): the restaurant, the date,
 * the status and the total, on the customer's offset card. An article named
 * by the restaurant and the date; with `onPress` the restaurant's name is a
 * button whose target covers the card, and the reorder action stays its own.
 */
export function OrderRow(props: OrderRowProps) {
  const { restaurant, date, status, total, logo, trailing, onPress } = props;
  const name = `${restaurant}، ${date}`;
  return (
    <article aria-label={name} className="relative">
      <Card elevation="offset">
        <div className="flex flex-col gap-(--fd-order-row-gap)">
          <div className="flex items-center gap-(--fd-order-row-gap)">
            <Logo name={restaurant} {...(logo !== undefined && { src: logo })} />
            <div className="flex min-w-none flex-1 flex-wrap items-center justify-between gap-x-(--fd-order-row-total-gap)">
              <div className="flex flex-col">
                {onPress ? (
                  <button type="button" aria-label={name} onClick={onPress} className={opener}>
                    {restaurant}
                  </button>
                ) : (
                  <span className={title}>{restaurant}</span>
                )}
                <span className="text-phone-secondary text-(color:--fd-order-row-color-date)">
                  {date}
                </span>
              </div>
              {total}
            </div>
          </div>
          <div className="flex flex-wrap items-center justify-between gap-(--fd-order-row-status-gap)">
            {status}
            {trailing ? <span className="relative">{trailing}</span> : null}
          </div>
        </div>
      </Card>
    </article>
  );
}
