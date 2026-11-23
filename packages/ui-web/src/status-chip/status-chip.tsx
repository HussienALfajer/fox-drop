import { formTv } from '../field/styles';
import { Icon, type IconName } from '../icon/icon';

/** AP §8.1: the order states, in their order. */
export const ORDER_STATUSES = [
  'placed',
  'accepted',
  'ready',
  'picked_up',
  'arrived',
  'delivered',
  'rejected',
  'cancelled',
  'failed',
] as const;
export type OrderStatus = (typeof ORDER_STATUSES)[number];

export type Tone = 'warning' | 'info' | 'success' | 'primary' | 'danger' | 'neutral';

/** The states the stories show (R3): each order state, a free tone, compact. */
export const STATES = [...ORDER_STATUSES, 'tone', 'compact'] as const;

/**
 * The tone and icon of each order state, as the approved sheet draws them
 * (owner, 2026-11-24): waiting amber, preparing blue, ready and delivered
 * green, with the captain orange, refused and failed red, cancelled grey.
 */
export const STATUS_LOOK: Record<OrderStatus, { tone: Tone; icon: IconName }> = {
  placed: { tone: 'warning', icon: 'clock' },
  accepted: { tone: 'info', icon: 'restaurant' },
  ready: { tone: 'success', icon: 'plate' },
  picked_up: { tone: 'primary', icon: 'motorcycle' },
  arrived: { tone: 'primary', icon: 'house' },
  delivered: { tone: 'success', icon: 'success' },
  rejected: { tone: 'danger', icon: 'close' },
  cancelled: { tone: 'neutral', icon: 'close' },
  failed: { tone: 'danger', icon: 'warning' },
};

// The tone's text on its tint; orange text is `on-primary-subtle` (blue for
// the captain, whose app has no orange text).
const chip = formTv({
  base: 'inline-flex items-center gap-2xs whitespace-nowrap rounded-full font-medium',
  variants: {
    tone: {
      warning: 'bg-warning-subtle text-warning',
      info: 'bg-info-subtle text-info',
      success: 'bg-success-subtle text-success',
      primary: 'bg-primary-subtle text-on-primary-subtle',
      danger: 'bg-danger-subtle text-danger',
      neutral: 'bg-neutral-subtle text-neutral',
    },
    density: {
      comfortable: 'min-h-(--fd-size-step) px-sm text-phone-secondary',
      compact: 'min-h-lg px-xs text-panel-caption',
    },
  },
  defaultVariants: { density: 'comfortable' },
});

interface Base {
  /** The words of the caller's app: «مع الكابتن», «في الطريق إليك». */
  label: string;
  density?: 'comfortable' | 'compact';
}
export type StatusChipProps = Base &
  (
    | { status: OrderStatus; tone?: never; icon?: never }
    | { status?: never; tone: Tone; icon?: IconName }
  );

/** An order state, or another state (a restaurant «مشغول»), as an icon and a word on its tint. */
export function StatusChip(props: StatusChipProps) {
  const look = props.status ? STATUS_LOOK[props.status] : { tone: props.tone, icon: props.icon };
  return (
    <span data-tone={look.tone} className={chip({ tone: look.tone, density: props.density })}>
      {look.icon ? <Icon name={look.icon} size="sm" /> : null}
      <span>{props.label}</span>
    </span>
  );
}
