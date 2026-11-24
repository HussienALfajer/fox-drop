import { Button } from '../button/button';
import { formTv } from '../field/styles';
import { Icon, type IconName } from '../icon/icon';

/** The states the stories show (R3). */
export const STATES = ['default', 'action', 'error', 'compact'] as const;

// The logo's drop (brand expression §2): the frame of empty-state art. In the
// panel and portal it holds a large icon, no scenes (§5).
const DROP = 'M12 23s9-8.4 9-14.5a9 9 0 0 0-18 0C3 14.6 12 23 12 23Z';

const title = formTv({
  base: 'm-none font-bold',
  variants: {
    tone: { default: 'text-heading', error: 'text-danger' },
    density: { comfortable: 'text-phone-title', compact: 'text-panel-title' },
  },
  defaultVariants: { tone: 'default', density: 'comfortable' },
});

const drop = formTv({
  base: 'relative flex items-center justify-center text-on-primary-subtle',
  variants: { density: { comfortable: 'size-3xl', compact: 'size-2xl' } },
  defaultVariants: { density: 'comfortable' },
});

export interface EmptyStateProps {
  icon: IconName;
  title: string;
  /** One line under the title. */
  description?: string;
  /** At most one action: «أعد المحاولة», «مسح الفلاتر». */
  action?: { label: string; onPress: () => void };
  tone?: 'default' | 'error';
  density?: 'comfortable' | 'compact';
}

/** An empty, error or offline state (R6): an icon in the drop, a title, a line, one action. */
export function EmptyState(props: EmptyStateProps) {
  const { icon, description, action, tone, density = 'comfortable' } = props;
  return (
    <div className="flex flex-col items-center gap-sm p-lg text-center">
      <span data-drop="" aria-hidden="true" className={drop({ density })}>
        <svg viewBox="0 0 24 24" className="absolute inset-none size-full">
          <path d={DROP} className="fill-primary-subtle stroke-primary" strokeWidth={0.6} />
        </svg>
        <span className="relative -mt-md">
          <Icon name={icon} size="lg" variant="brand-duo" />
        </span>
      </span>
      <h2 className={title({ tone, density })}>{props.title}</h2>
      {description ? (
        <p className="m-none text-phone-secondary text-on-surface-muted">{description}</p>
      ) : null}
      {action ? (
        <Button
          variant={tone === 'error' ? 'primary' : 'secondary'}
          density={density}
          onClick={action.onPress}
        >
          {action.label}
        </Button>
      ) : null}
    </div>
  );
}
