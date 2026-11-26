import { useEffect, useLayoutEffect, useRef, useState, type ReactNode } from 'react';
import { Card } from '../card/card';
import { formTv } from '../field/styles';
import { Icon, type IconName } from '../icon/icon';
import { Money } from '../money/money';
import { StatusChip } from '../status-chip/status-chip';

/** The states the stories show (R3), as the Flutter twin's. */
export const STATES = ['checkout', 'orders', 'account', 'short', 'keyboard'] as const;

/** One thing an account keeps: «عناوينك», «أكوادك», «مفضّلتك». */
export interface SignInPerk {
  icon: IconName;
  label: string;
}

/**
 * Where the guest came from (D.11 screen 2): the saved cart, the way an
 * order is followed, or what an account keeps. The screen picks it from the
 * route; the words and amounts come in here.
 */
export type SignInOrigin =
  | {
      kind: 'checkout';
      restaurant: string;
      /** «3 أصناف · إلى حي الجلاء». */
      details: string;
      /** The total in minor units. */
      amount: string;
      symbol: string;
      decimals?: number;
      /** «سلّتك محفوظة كما هي». */
      savedLabel: string;
    }
  | {
      kind: 'orders';
      title: string;
      statusLabel: string;
      /** The tracking steps on a sample order (TrackingSteps). */
      steps: ReactNode;
    }
  | { kind: 'account'; perks: readonly SignInPerk[] };

export interface SignInHeroProps {
  origin: SignInOrigin;
  title: string;
  lead?: string;
  /** The keyboard is up: the title alone, smaller, at the bottom. */
  keyboard?: boolean;
}

const hero = formTv({
  slots: {
    root: [
      'flex size-full flex-col overflow-hidden',
      'px-(--fd-sign-in-hero-padding-inline) py-(--fd-sign-in-hero-padding-block)',
    ],
    art: 'mb-(--fd-sign-in-hero-art-gap)',
    title: 'm-none text-(color:--fd-sign-in-hero-color-title)',
    lead: 'm-none mt-(--fd-sign-in-hero-lead-gap) text-phone-body text-(color:--fd-sign-in-hero-color-lead)',
    badge: [
      'flex size-(--fd-sign-in-hero-badge-size) shrink-0 items-center justify-center rounded-full',
      'bg-(--fd-sign-in-hero-color-badge) text-(color:--fd-sign-in-hero-color-badge-icon)',
    ],
    row: 'flex items-center gap-(--fd-sign-in-hero-row-gap)',
    words: 'flex min-w-none flex-1 flex-col',
    restaurant: 'text-phone-subtitle font-bold',
    details: 'text-phone-caption text-(color:--fd-sign-in-hero-color-details)',
    total: 'ms-(--fd-sign-in-hero-detail-gap)',
    foot: 'flex flex-wrap items-center justify-between gap-(--fd-sign-in-hero-detail-gap)',
    dishes: 'flex',
    dish: [
      'flex size-(--fd-sign-in-hero-badge-size) items-center justify-center rounded-full',
      'border-solid border-(length:--fd-sign-in-hero-dish-ring-width) border-(--fd-sign-in-hero-color-dish-ring)',
      'text-(color:--fd-sign-in-hero-color-badge-icon) not-first:-ms-(--fd-sign-in-hero-dish-overlap)',
    ],
    ordersHead: 'flex items-center gap-(--fd-sign-in-hero-detail-gap)',
    ordersTitle: 'min-w-none flex-1 text-phone-secondary font-bold',
    perks: 'flex items-start gap-(--fd-sign-in-hero-row-gap)',
    perk: 'flex min-w-none flex-1 flex-col items-center gap-(--fd-sign-in-hero-detail-gap) text-center',
    perkLabel: 'text-phone-secondary font-medium',
  },
  variants: {
    keyboard: {
      true: { root: 'justify-end', title: 'text-phone-title' },
      false: { root: 'justify-center', title: 'text-phone-large-title' },
    },
  },
});

const DISHES = [
  'bg-(--fd-sign-in-hero-color-dish-1)',
  'bg-(--fd-sign-in-hero-color-dish-2)',
  'bg-(--fd-sign-in-hero-color-dish-3)',
];

function Art({ origin }: { origin: SignInOrigin }) {
  const parts = hero();
  if (origin.kind === 'checkout')
    return (
      <Card elevation="offset">
        <div className={parts.row()}>
          <span className={parts.badge()}>
            <Icon name="restaurant" variant="bold" />
          </span>
          <span className={parts.words()}>
            <span className={parts.restaurant()}>{origin.restaurant}</span>
            <span className={parts.details()}>{origin.details}</span>
          </span>
          <span className={parts.total()}>
            <Money
              amount={origin.amount}
              symbol={origin.symbol}
              decimals={origin.decimals ?? 2}
              size="subtitle"
              bold
            />
          </span>
        </div>
        <div className={parts.foot()}>
          <span className={parts.dishes()}>
            {DISHES.map((tint) => (
              <span key={tint} className={parts.dish({ class: tint })}>
                <Icon name="plate" size="sm" variant="bold" />
              </span>
            ))}
          </span>
          <StatusChip tone="success" icon="success" label={origin.savedLabel} />
        </div>
      </Card>
    );
  if (origin.kind === 'orders')
    return (
      <Card elevation="offset">
        <div className={parts.ordersHead()}>
          <span className={parts.ordersTitle()}>{origin.title}</span>
          <StatusChip status="picked_up" label={origin.statusLabel} />
        </div>
        {origin.steps}
      </Card>
    );
  return (
    <div className={parts.perks()}>
      {origin.perks.map((perk) => (
        <span key={perk.label} className="flex min-w-none flex-1">
          <Card>
            <span className={parts.perk()}>
              <span className={parts.badge()}>
                <Icon name={perk.icon} variant="bold" />
              </span>
              <span className={parts.perkLabel()}>{perk.label}</span>
            </span>
          </Card>
        </span>
      ))}
    </div>
  );
}

/** What is shown: everything, the lead gone, or the title alone. */
type Fit = 'all' | 'no-lead' | 'title';

/**
 * The sign-in screen's head (D.11 screen 2, CU §5.1): the origin's
 * illustration, the title and the lead, centred in the height it is given.
 * It gives way by its own height: first the lead, then the illustration,
 * never the title; a part that gave way is not rendered. With the keyboard
 * up it is the title alone. The illustration is decoration: the title and
 * the lead say it in words.
 */
export function SignInHero({ origin, title, lead, keyboard = false }: SignInHeroProps) {
  const root = useRef<HTMLDivElement>(null);
  const [fit, setFit] = useState<Fit>('all');
  const [size, setSize] = useState(0);

  // A new height starts again from everything shown.
  useEffect(() => {
    const element = root.current;
    if (!element || typeof ResizeObserver === 'undefined') return;
    const observer = new ResizeObserver(() => {
      setSize(element.clientHeight);
      setFit('all');
    });
    observer.observe(element);
    return () => observer.disconnect();
  }, []);

  // New words or a new origin start again from everything shown, as the
  // Flutter twin lays out afresh (reset while rendering, React's pattern for
  // state that follows props).
  const [shownFor, setShownFor] = useState({ lead, origin, title });
  if (shownFor.lead !== lead || shownFor.origin !== origin || shownFor.title !== title) {
    setShownFor({ lead, origin, title });
    setFit('all');
  }

  // While the content overflows, drop the next part.
  useLayoutEffect(() => {
    const element = root.current;
    if (!element || element.scrollHeight <= element.clientHeight) return;
    setFit((now) => (now === 'all' && lead ? 'no-lead' : 'title'));
  }, [fit, size, lead, origin, title]);

  const parts = hero({ keyboard });
  const showArt = !keyboard && fit !== 'title';
  const showLead = !keyboard && fit === 'all' && lead;
  return (
    <div ref={root} className={parts.root()}>
      {showArt && (
        <div aria-hidden="true" className={parts.art()}>
          <Art origin={origin} />
        </div>
      )}
      <h1 className={parts.title()}>{title}</h1>
      {showLead && <p className={parts.lead()}>{lead}</p>}
    </div>
  );
}
