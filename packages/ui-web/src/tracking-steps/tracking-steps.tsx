import { formTv } from '../field/styles';
import { Icon, type IconName } from '../icon/icon';

/** The states the stories show (R3), as the Flutter twin's. */
export const STATES = ['first', 'middle', 'last', 'done'] as const;

type StepState = 'done' | 'now' | 'later';

const circle = formTv({
  base: 'relative flex size-(--fd-tracking-steps-circle) shrink-0 items-center justify-center rounded-full',
  variants: {
    state: {
      done: 'bg-(--fd-tracking-steps-color-done) text-(color:--fd-tracking-steps-color-on-done)',
      now: 'bg-(--fd-tracking-steps-color-current) text-(color:--fd-tracking-steps-color-on-current)',
      later: 'bg-(--fd-tracking-steps-color-later) text-(color:--fd-tracking-steps-color-on-later)',
    },
  },
});

const name = formTv({
  base: 'text-center text-phone-caption',
  variants: {
    state: {
      done: 'font-medium text-(color:--fd-tracking-steps-color-done-label)',
      now: 'font-bold text-(color:--fd-tracking-steps-color-current-label)',
      later: 'font-medium text-(color:--fd-tracking-steps-color-later-label)',
    },
  },
});

// Two rings grow and fade from the current circle, half a cycle apart
// (`motion.pulse`, theme.css). Without the animation (reduced motion, or a
// shot with animations cancelled) the first stands still at the `still-*`
// values, its own look, and the second is gone.
const pulse = formTv({
  base: 'pointer-events-none absolute inset-none rounded-full border-(length:--fd-tracking-steps-line-width) border-(--fd-tracking-steps-color-pulse) motion-safe:animate-step-pulse',
  variants: {
    late: {
      false: 'scale-(--fd-motion-pulse-still-scale) opacity-(--fd-motion-pulse-still-opacity)',
      true: 'step-pulse-late motion-reduce:hidden',
    },
  },
});

/** Half a link, from a circle's edge to its column's edge: none, solid or dashed. */
function Half({ kind }: { kind: 'none' | 'done' | 'later' }) {
  if (kind === 'none') return <span className="flex-1" />;
  if (kind === 'done')
    return (
      <span className="h-(--fd-tracking-steps-line-width) flex-1 bg-(--fd-tracking-steps-color-done)" />
    );
  return (
    <svg aria-hidden="true" focusable="false" className="h-(--fd-tracking-steps-line-width) flex-1">
      <line
        x1="0"
        x2="100%"
        y1="50%"
        y2="50%"
        className="tracking-dash stroke-(--fd-tracking-steps-color-later-line) stroke-(length:--fd-tracking-steps-line-width)"
      />
    </svg>
  );
}

export interface TrackingStep {
  icon: IconName;
  label: string;
}

export interface TrackingStepsProps {
  /** The list's name: «حالة الطلب». */
  label: string;
  steps: readonly TrackingStep[];
  /** The current step; the steps' count marks every step done. */
  current: number;
  /** «تم», read after a done step's name. */
  doneLabel: string;
  /** «الآن», read after the current step's name. */
  nowLabel: string;
}

/**
 * An order's way in equal columns (D.11b): done steps in the brand blue, the
 * current step an orange circle with two soft rings, later steps dashed. An
 * ordered list; the current step is `aria-current="step"`, and each done or
 * current step says so in words, never by colour alone.
 */
export function TrackingSteps({ label, steps, current, doneLabel, nowLabel }: TrackingStepsProps) {
  const last = steps.length - 1;
  return (
    <ol aria-label={label} className="m-none grid list-none auto-cols-fr grid-flow-col p-none">
      {steps.map((step, n) => {
        const state: StepState = n < current ? 'done' : n === current ? 'now' : 'later';
        const words = state === 'done' ? doneLabel : state === 'now' ? nowLabel : undefined;
        const spoken = words === undefined ? null : `، ${words}`;
        const before = n === 0 ? 'none' : n - 1 < current ? 'done' : 'later';
        const after = n === last ? 'none' : n < current ? 'done' : 'later';
        return (
          <li
            key={step.label}
            aria-current={state === 'now' ? 'step' : undefined}
            className="flex min-w-none flex-col items-center gap-(--fd-tracking-steps-label-gap)"
          >
            <span aria-hidden="true" className="flex w-full items-center">
              <Half kind={before} />
              <span className={circle({ state })}>
                {state === 'now' ? (
                  <>
                    <span data-part="pulse" className={pulse({ late: false })} />
                    <span data-part="pulse" className={pulse({ late: true })} />
                  </>
                ) : null}
                {state === 'later' ? (
                  <svg
                    aria-hidden="true"
                    focusable="false"
                    className="absolute inset-none size-full"
                  >
                    {/* 16 dashes, each half of its sixteenth, as the Flutter twin. */}
                    <circle
                      cx="50%"
                      cy="50%"
                      pathLength={32}
                      strokeDasharray="1 1"
                      className="tracking-outline fill-none stroke-(--fd-tracking-steps-color-later-line) stroke-(length:--fd-tracking-steps-line-width)"
                    />
                  </svg>
                ) : null}
                <Icon name={step.icon} variant={state === 'later' ? 'linear' : 'bold'} />
              </span>
              <Half kind={after} />
            </span>
            <span className={name({ state })}>
              {step.label}
              {spoken ? <span className="sr-only">{spoken}</span> : null}
            </span>
          </li>
        );
      })}
    </ol>
  );
}
