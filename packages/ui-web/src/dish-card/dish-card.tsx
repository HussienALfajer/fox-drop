import { useState, type ReactNode } from 'react';
import { formTv, keyboardRing } from '../field/styles';
import { Icon } from '../icon/icon';
import { stretchedLink } from '../restaurant-card/restaurant-card';

/** The states the stories show (R3). */
export const STATES = [
  'default',
  'from',
  'inCart',
  'noPhoto',
  'unavailable',
  'hover',
  'focus',
  'pressed',
] as const;

// The approved D.9 sheet, option A, as the Flutter twin draws it: the text at
// the start, the square photo, and «+» in the thumb's reach. As on the
// restaurant card, the name is the card's one link stretched over it, and «+»
// is a button of its own above it.
const card = formTv({
  base: 'relative isolate flex items-end rounded-(--fd-card-radius) bg-(--fd-card-color-background) p-(--fd-card-padding) text-start text-(color:--fd-card-color-text) inset-ring-(length:--fd-card-border-width) inset-ring-(--fd-card-color-border)',
});

const fade = formTv({
  base: '',
  variants: { faded: { true: 'opacity-(--fd-dish-card-faded-opacity)' } },
});

// The link's ::after paints the hover and pressed colours over the article's
// own inset ring: it draws the outline again, so it stays in every state.
const outlineOnTop =
  'after:inset-ring-(length:--fd-card-border-width) after:inset-ring-(--fd-card-color-border)';

/** A photo the name beside it already says. */
const DECORATIVE = '';
const muted = 'text-phone-secondary text-on-surface-muted';
const photoBox =
  'pointer-events-none ms-(--fd-dish-card-gap) size-(--fd-dish-card-photo-size) shrink-0 overflow-hidden rounded-(--fd-dish-card-photo-radius)';

const add = formTv({
  base: `group/add relative ms-(--fd-dish-card-add-gap) inline-flex size-(--fd-size-touch-target) shrink-0 cursor-pointer items-center justify-center rounded-full ${keyboardRing}`,
});

const addCircle = formTv({
  base: 'inline-flex size-(--fd-dish-card-add-size) items-center justify-center rounded-full transition-colors duration-(--fd-duration-base) ease-(--fd-easing-standard) motion-reduce:transition-none',
  variants: {
    inCart: {
      true: 'bg-(--fd-dish-card-color-count) text-phone-body font-bold text-(color:--fd-dish-card-color-on-count) tabular-nums',
      false:
        'bg-(--fd-dish-card-color-add) text-(color:--fd-dish-card-color-on-add) group-hover/add:bg-(--fd-dish-card-color-add-hover) group-active/add:bg-(--fd-dish-card-color-add-pressed)',
    },
  },
});

export interface DishCardProps {
  name: string;
  /** A Money. */
  price: ReactNode;
  /** «أضف {الطبق}»: the «+» button's name. */
  addLabel: string;
  onAdd: () => void;
  /** The dish's item sheet or page. */
  href: string;
  description?: string;
  /** The square photo; without one the card is a text row (brand expression §5). */
  photo?: string;
  /** «من» before the lowest price, when a required group changes it. */
  fromLabel?: string;
  /** How many are in the cart; above zero it replaces «+». */
  count?: number;
  /** «يتوفر غداً», «غير متوفر حالياً»: the dish cannot be added nor opened. */
  unavailableLabel?: string;
}

/**
 * A dish in a restaurant's menu (CU §9.3, option A). An unavailable dish stays
 * in place, faded, with its reason at full contrast, and is no link.
 */
export function DishCard(props: DishCardProps) {
  const { name, price, addLabel, onAdd, href, description, photo, fromLabel } = props;
  const { count = 0, unavailableLabel } = props;
  const [photoFailed, setPhotoFailed] = useState(false);
  const unavailable = unavailableLabel !== undefined;
  const inCart = count > 0;
  const countText = String(count);
  const addName = inCart ? `${addLabel}، ${countText}` : addLabel;
  const articleName = unavailable ? `${name}، ${unavailableLabel}` : undefined;
  const faded = fade({ faded: unavailable });
  const title = (
    <span className="text-phone-subtitle font-bold text-(color:--fd-dish-card-color-name)">
      {name}
    </span>
  );
  return (
    <article {...(articleName && { 'aria-label': articleName })} className={card()}>
      <div className="pointer-events-none flex min-w-none flex-1 flex-col">
        <div className={faded}>
          {unavailable ? (
            title
          ) : (
            <a href={href} className={stretchedLink({ class: outlineOnTop })}>
              {title}
            </a>
          )}
        </div>
        {description !== undefined && (
          <span className={fade({ faded: unavailable, class: muted })}>{description}</span>
        )}
        <div className="mt-(--fd-dish-card-price-gap) flex flex-wrap items-center gap-(--fd-dish-card-price-gap) text-phone-secondary">
          {fromLabel !== undefined && (
            <span className={fade({ faded: unavailable, class: 'text-on-surface' })}>
              {fromLabel}
            </span>
          )}
          <span className={faded}>{price}</span>
          {unavailable && (
            <span className="font-medium text-on-surface-muted">{unavailableLabel}</span>
          )}
        </div>
      </div>
      {photo !== undefined && !photoFailed && (
        <span className={fade({ faded: unavailable, class: photoBox })}>
          <img
            src={photo}
            alt={DECORATIVE}
            onError={() => setPhotoFailed(true)}
            className="size-full object-cover"
          />
        </span>
      )}
      {!unavailable && (
        <button type="button" aria-label={addName} onClick={onAdd} className={add()}>
          <span className={addCircle({ inCart })}>
            {inCart ? <span dir="ltr">{countText}</span> : <Icon name="add" />}
          </span>
        </button>
      )}
    </article>
  );
}
