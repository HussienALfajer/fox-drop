import { useState, type ReactNode } from 'react';
import { formTv, keyboardRing } from '../field/styles';
import { Icon, type IconName } from '../icon/icon';
import { StatusChip, type Tone } from '../status-chip/status-chip';

/** The states the stories show (R3). */
export const STATES = [
  'default',
  'busy',
  'closed',
  'far',
  'noCover',
  'favourite',
  'hover',
  'focus',
  'pressed',
] as const;

// The approved D.9 sheet, as the Flutter twin draws it: the customer card with
// the offset shadow. The card holds a button of its own (the heart), so it
// cannot be one link: the name is the link, and its ::after stretches over the
// card, behind the content, so the whole card is its target and paints the
// card's hover, pressed and focus states. The content lets the pointer through
// to it; the heart sits above.
const card = formTv({
  base: 'relative isolate flex flex-col rounded-(--fd-card-radius) bg-(--fd-card-color-background) p-(--fd-card-padding) text-start text-(color:--fd-card-color-text) shadow-offset',
});

/** The stretched link of a card: the name, with the card's states on its ::after. */
export const stretchedLink = formTv({
  base: [
    'pointer-events-auto cursor-pointer text-inherit no-underline outline-hidden',
    'after:absolute after:inset-none after:-z-1 after:rounded-(--fd-card-radius) after:transition-colors after:duration-(--fd-duration-base) after:ease-(--fd-easing-standard)',
    'hover:after:bg-(--fd-card-color-background-hover) active:after:bg-(--fd-card-color-background-pressed)',
    'focus-visible:after:ring-2 focus-visible:after:ring-(color:--fd-input-color-focus-ring) focus-visible:after:ring-offset-2 focus-visible:after:ring-offset-surface',
  ],
});

const fade = formTv({
  base: '',
  variants: { faded: { true: 'opacity-(--fd-restaurant-card-faded-opacity)' } },
});

const heart = formTv({
  base: `group/heart pointer-events-auto absolute start-(--fd-restaurant-card-heart-inset) top-(--fd-restaurant-card-heart-inset) inline-flex size-(--fd-size-touch-target) cursor-pointer items-center justify-center rounded-full ${keyboardRing}`,
});

const heartCircle = formTv({
  base: 'inline-flex size-(--fd-restaurant-card-heart-size) items-center justify-center rounded-full bg-(--fd-restaurant-card-color-heart-background) transition-colors duration-(--fd-duration-base) ease-(--fd-easing-standard) group-hover/heart:bg-(--fd-restaurant-card-color-heart-background-hover) group-active/heart:bg-(--fd-restaurant-card-color-heart-background-pressed)',
  variants: {
    favourite: {
      true: 'text-(color:--fd-restaurant-card-color-heart-favourite)',
      false: 'text-(color:--fd-restaurant-card-color-heart)',
    },
  },
});

/** An image the name beside it already says. */
const DECORATIVE = '';

const coverBox = 'aspect-cover overflow-hidden rounded-(--fd-restaurant-card-cover-radius)';

const facts =
  'mt-(--fd-restaurant-card-facts-top) flex flex-wrap items-center gap-x-(--fd-restaurant-card-facts-gap) gap-y-(--fd-restaurant-card-facts-row-gap) text-phone-secondary text-on-surface-muted';

const logoBox = formTv({
  base: 'inline-flex shrink-0 items-center justify-center overflow-hidden rounded-md bg-primary-subtle text-phone-title text-on-primary-subtle',
  variants: {
    large: {
      true: 'size-(--fd-restaurant-card-logo-size)',
      false: 'size-(--fd-size-touch-target)',
    },
  },
});

/**
 * The logo, or the name's first letter on a tint (the Flutter FoxLogo). Local
 * until the web Logo of D.W4b is on main.
 */
function Logo({ name, image, large = false }: { name: string; image?: string; large?: boolean }) {
  const [failed, setFailed] = useState(false);
  const letter = Array.from(name)[0] ?? '';
  return (
    <span aria-hidden="true" className={logoBox({ large })}>
      {image && !failed ? (
        <img
          src={image}
          alt={DECORATIVE}
          onError={() => setFailed(true)}
          className="size-full object-cover"
        />
      ) : (
        letter
      )}
    </span>
  );
}

function Fact({ icon, tone, children }: { icon: IconName; tone?: string; children: ReactNode }) {
  return (
    <span className="inline-flex min-w-none items-center gap-(--fd-restaurant-card-fact-gap)">
      <span className={tone ?? 'text-on-surface-muted'}>
        <Icon name={icon} size="sm" />
      </span>
      {children}
    </span>
  );
}

export interface RestaurantCardProps {
  name: string;
  /** «برجر · وجبات سريعة». */
  categories: string;
  /** The estimate as a range: «20–30 د». */
  eta: string;
  /** A Money, or the words «توصيل مجاني». */
  fee: ReactNode;
  /** The restaurant's page. */
  href: string;
  favourite: boolean;
  /** The heart's name: «المفضلة». */
  favouriteLabel: string;
  onFavourite: () => void;
  /** The cover photo, 16:9. Missing or failing, the logo shows on a tint (R7). */
  cover?: string;
  logo?: string;
  /** «4.5»; without it, `newLabel` («جديد»). */
  rating?: string;
  newLabel?: string;
  /** «مشغول», «مغلق — يفتح السبت 10:00 ص»: a chip on the cover, read with the name. */
  state?: { label: string; tone: Tone };
  /** Fades the card but its state and the heart (U6). */
  closed?: boolean;
}

/**
 * A restaurant in a customer list (CU §8.2): the cover with the heart and the
 * state chip on it, the logo and name, the categories, the rating or «جديد»,
 * the estimate and the fee. One link, named by the restaurant and its state.
 */
export function RestaurantCard(props: RestaurantCardProps) {
  const { name, categories, eta, fee, href, favourite, favouriteLabel, onFavourite } = props;
  const { cover, logo, rating, newLabel, state, closed = false } = props;
  const [coverFailed, setCoverFailed] = useState(false);
  const showCover = cover !== undefined && !coverFailed;
  const label = state ? `${name}، ${state.label}` : name;
  return (
    <article className={card()}>
      <div className="pointer-events-none flex flex-col">
        <div className="relative">
          <div className={fade({ faded: closed, class: coverBox })}>
            {showCover ? (
              <img
                src={cover}
                alt={DECORATIVE}
                onError={() => setCoverFailed(true)}
                className="size-full object-cover"
              />
            ) : (
              <div
                data-cover-fallback=""
                className="flex size-full items-center justify-center bg-(--fd-restaurant-card-color-cover)"
              >
                <Logo name={name} {...(logo !== undefined && { image: logo })} large />
              </div>
            )}
          </div>
          {state && (
            <span
              aria-hidden="true"
              className="absolute end-(--fd-restaurant-card-state-inset) top-(--fd-restaurant-card-state-inset)"
            >
              <StatusChip label={state.label} tone={state.tone} />
            </span>
          )}
        </div>
        {/* The row holding the link is never faded itself: an opacity there
            would lift the link's ::after over the cover. Its parts fade. */}
        <div className="mt-(--fd-restaurant-card-gap) flex items-center gap-(--fd-restaurant-card-gap)">
          {showCover && (
            <span className={fade({ faded: closed, class: 'inline-flex' })}>
              <Logo name={name} {...(logo !== undefined && { image: logo })} />
            </span>
          )}
          <div className="flex min-w-none flex-1 flex-col">
            <a href={href} aria-label={label} className={stretchedLink()}>
              <span className={fade({ faded: closed, class: 'text-phone-subtitle font-bold' })}>
                {name}
              </span>
            </a>
            <span
              className={fade({
                faded: closed,
                class: 'text-phone-secondary text-on-surface-muted',
              })}
            >
              {categories}
            </span>
          </div>
        </div>
        <div className={fade({ faded: closed, class: facts })}>
          {rating !== undefined ? (
            <Fact icon="star" tone="text-(color:--fd-restaurant-card-color-rating)">
              <span className="text-on-surface tabular-nums">{rating}</span>
            </Fact>
          ) : newLabel !== undefined ? (
            <span className="font-medium text-(color:--fd-restaurant-card-color-new)">
              {newLabel}
            </span>
          ) : null}
          <Fact icon="clock">
            <span>{eta}</span>
          </Fact>
          <Fact icon="motorcycle">{fee}</Fact>
        </div>
      </div>
      {/* After the link, so it comes second for the keyboard; over the cover's corner. */}
      <div className="pointer-events-none absolute inset-(--fd-card-padding)">
        <button
          type="button"
          aria-label={favouriteLabel}
          aria-pressed={favourite}
          onClick={onFavourite}
          className={heart()}
        >
          <span className={heartCircle({ favourite })}>
            {/* A favourite is a Bold red heart, not colour alone (R4). */}
            <Icon name="heart" variant={favourite ? 'bold' : 'linear'} />
          </span>
        </button>
      </div>
    </article>
  );
}
