import { formTv } from '../field/styles';
import { Icon, type IconName } from '../icon/icon';

/** The states the stories show (R3). */
export const STATES = ['default', 'soon', 'minutes', 'late', 'waiting', 'compact'] as const;

export type TimerTone = 'calm' | 'soon' | 'late';

/**
 * A running duration as the approved sheet shows it (owner, 2026-11-24; AP
 * §4.7 gives «12 د» and «45 ث», backlog): «4:32» under ten minutes, «12 د» from ten
 * on (whole seconds, never negative). `minuteUnit` is the app's «د».
 */
export function formatDuration(seconds: number, minuteUnit: string): string {
  const whole = Math.max(0, Math.floor(seconds));
  if (whole >= 600) return `${Math.floor(whole / 60)} ${minuteUnit}`;
  return `${Math.floor(whole / 60)}:${String(whole % 60).padStart(2, '0')}`;
}

/** Soon in the last minute of a countdown; late when the app says so. */
export function timerTone(t: {
  seconds: number;
  direction: 'down' | 'up';
  late?: boolean | undefined;
}): TimerTone {
  if (t.late) return 'late';
  return t.direction === 'down' && t.seconds <= 60 ? 'soon' : 'calm';
}

const pill = formTv({
  base: 'inline-flex items-center gap-2xs whitespace-nowrap rounded-full px-sm font-bold tabular-nums',
  variants: {
    tone: {
      calm: 'bg-info-subtle text-on-surface',
      soon: 'bg-warning-subtle text-warning',
      late: 'bg-danger-subtle text-danger',
    },
    density: {
      comfortable: 'min-h-(--fd-size-step) text-phone-subtitle',
      compact: 'min-h-lg text-panel-body',
    },
  },
  defaultVariants: { density: 'comfortable' },
});

export interface TimerProps {
  /** Seconds left (`down`) or gone by (`up`); the app ticks it. */
  seconds: number;
  direction: 'down' | 'up';
  /** «د», the minute unit after ten minutes. */
  minuteUnit: string;
  /** A count-up past its limit: red. */
  late?: boolean;
  /** Overrides the computed tone: a captain waiting is `soon`. */
  tone?: TimerTone;
  /** Words before the time: «متأخر», «ينتظر منذ». */
  prefix?: string;
  icon?: IconName;
  density?: 'comfortable' | 'compact';
}

/**
 * A running time: the auto-cancel and prep countdowns, a late order, a
 * captain waiting. A `timer` role is not announced on every tick.
 */
export function Timer(props: TimerProps) {
  const { seconds, direction, minuteUnit, late, prefix, icon = 'clock', density } = props;
  const tone = props.tone ?? timerTone({ seconds, direction, late });
  const time = formatDuration(seconds, minuteUnit);
  const text = prefix ? `${prefix} ${time}` : time;
  return (
    <span role="timer" data-tone={tone} className={pill({ tone, density })}>
      <Icon name={icon} size="sm" />
      <bdi>{text}</bdi>
    </span>
  );
}
