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
    tone: {
      default: 'text-(color:--fd-empty-state-color-title)',
      error: 'text-(color:--fd-empty-state-color-error-title)',
    },
    density: { comfortable: 'text-phone-title', compact: 'text-panel-title' },
  },
  defaultVariants: { tone: 'default', density: 'comfortable' },
});

// The D.9 sheet's drop (D.W3b): 120 on the phone, 72 in the panel; a bottom
// padding lifts the icon by half of it into the drop's round head.
const drop = formTv({
  base: 'relative flex items-center justify-center text-(color:--fd-empty-state-color-icon)',
  variants: {
    density: {
      comfortable: 'size-(--fd-empty-state-art-size) pb-(--fd-empty-state-art-lift)',
      compact: 'size-(--fd-empty-state-compact-art-size) pb-(--fd-empty-state-compact-art-lift)',
    },
  },
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
    <div className="flex flex-col items-center gap-(--fd-empty-state-gap) p-(--fd-empty-state-padding) text-center">
      <span data-drop="" aria-hidden="true" className={drop({ density })}>
        {/* The drop's round head reaches above the 24 grid: overflow-visible
            draws it whole; the edge keeps its width at every size. */}
        <svg viewBox="0 0 24 24" className="absolute inset-none size-full overflow-visible">
          <path
            d={DROP}
            vectorEffect="non-scaling-stroke"
            className="fill-(--fd-empty-state-color-art-fill) stroke-(--fd-empty-state-color-art-edge) stroke-(length:--fd-empty-state-art-edge-width)"
          />
        </svg>
        <span className="relative">
          <Icon name={icon} size="lg" variant="brand-duo" />
        </span>
      </span>
      <h2 className={title({ tone, density })}>{props.title}</h2>
      {description ? (
        <p className="m-none text-phone-secondary text-(color:--fd-empty-state-color-description)">
          {description}
        </p>
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
