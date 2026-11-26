import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useRef,
  useState,
  type ReactNode,
} from 'react';
import { formTv, keyboardRing } from '../field/styles';
import { Icon, type IconName } from '../icon/icon';

/** The states the stories show (R3): each tone, with an action, stacked. */
export const STATES = ['default', 'info', 'warning', 'danger', 'action', 'stacked'] as const;

/**
 * How long a toast stays (the approved sheet): success and info 4 s, warning
 * 6 s, any toast with an action 8 s; danger stays until it is closed.
 */
export const TOAST_DURATION = { success: 4000, info: 4000, warning: 6000, action: 8000 } as const;

export type ToastTone = 'success' | 'info' | 'warning' | 'danger';

export interface ToastOptions {
  tone: ToastTone;
  text: string;
  action?: { label: string; onAction: () => void };
}

interface Item extends ToastOptions {
  id: number;
}

const ICON: Record<ToastTone, IconName> = {
  success: 'success',
  info: 'info',
  warning: 'warning',
  danger: 'error',
};

// The approved sheet, option A (owner, 2026-11-24): dark blue with ivory
// text, the tone carried by the icon (tinted to read on the blue) and the
// words. It rises 8 px as it fades in; under reduced motion it only fades.
const toast = formTv({
  base: [
    'pointer-events-auto flex w-full max-w-(--fd-toast-width) items-center gap-(--fd-toast-gap) rounded-(--fd-toast-radius) py-sm shadow-medium',
    'bg-(--fd-toast-color-background) px-(--fd-toast-padding-inline) text-(color:--fd-toast-color-text)',
    'text-phone-secondary font-medium',
    'transition duration-(--fd-duration-base) ease-(--fd-easing-standard)',
    'starting:translate-y-xs starting:opacity-0 motion-reduce:starting:translate-y-none',
  ],
});

const iconTone = formTv({
  base: 'flex shrink-0',
  variants: {
    tone: {
      success: 'text-(color:--fd-toast-color-icon-success)',
      info: 'text-(color:--fd-toast-color-icon-info)',
      warning: 'text-(color:--fd-toast-color-icon-warning)',
      danger: 'text-(color:--fd-toast-color-icon-danger)',
    },
  },
});

const textButton = formTv({
  base: `shrink-0 cursor-pointer rounded-sm font-bold underline underline-offset-4 ${keyboardRing}`,
});

const close = formTv({
  base: `-m-2xs inline-flex size-xl shrink-0 cursor-pointer items-center justify-center rounded-full hover:bg-on-accent/10 ${keyboardRing}`,
});

const ToastContext = createContext<{ show: (options: ToastOptions) => void } | null>(null);

/** Shows a toast from anywhere under the Toaster. */
export function useToast() {
  const context = useContext(ToastContext);
  if (!context) throw new Error('useToast() needs a <Toaster> above it.');
  return context;
}

function Toast({
  item,
  closeLabel,
  onClose,
  stays,
}: {
  item: Item;
  closeLabel: string;
  onClose: (id: number) => void;
  /** Until it is closed, whatever its tone. */
  stays: boolean;
}) {
  const duration =
    stays || item.tone === 'danger'
      ? null
      : item.action
        ? TOAST_DURATION.action
        : TOAST_DURATION[item.tone];
  const [hovered, setHovered] = useState(false);
  const [focused, setFocused] = useState(false);
  const remaining = useRef(duration ?? 0);
  const paused = hovered || focused;

  useEffect(() => {
    if (duration === null || paused) return;
    const started = Date.now();
    const timer = setTimeout(() => onClose(item.id), remaining.current);
    return () => {
      clearTimeout(timer);
      remaining.current = Math.max(0, remaining.current - (Date.now() - started));
    };
  }, [duration, paused, item.id, onClose]);

  return (
    <li
      data-toast=""
      data-tone={item.tone}
      className={toast()}
      onPointerEnter={() => setHovered(true)}
      onPointerLeave={() => setHovered(false)}
      onFocus={() => setFocused(true)}
      onBlur={(event) => {
        if (!event.currentTarget.contains(event.relatedTarget)) setFocused(false);
      }}
    >
      <span className={iconTone({ tone: item.tone })}>
        <Icon name={ICON[item.tone]} />
      </span>
      <span className="min-w-none flex-1">{item.text}</span>
      {item.action && (
        <button
          type="button"
          className={textButton()}
          onClick={() => {
            item.action?.onAction();
            onClose(item.id);
          }}
        >
          {item.action.label}
        </button>
      )}
      <button
        type="button"
        aria-label={closeLabel}
        className={close()}
        onClick={() => onClose(item.id)}
      >
        <Icon name="close" size="sm" />
      </button>
    </li>
  );
}

export interface ToasterProps {
  /** The region's name: «الإشعارات». */
  label: string;
  /** Each toast's ×: «إغلاق». */
  closeLabel: string;
  /** How many show at once; the newest wins. The web shows three. */
  max?: number;
  /** Toasts shown from the start, as if shown on mounting. */
  toasts?: readonly ToastOptions[];
  /**
   * Draws the toasts where it is written instead of at the screen's corner,
   * each staying until it is closed (the components canvas).
   */
  inline?: boolean;
  children: ReactNode;
}

const region = formTv({
  base: 'pointer-events-none flex flex-col gap-xs',
  variants: {
    // Across the screen less md on each side, each toast at the end of it: a
    // screen narrower than a toast keeps both margins (D.W3c).
    inline: { false: 'fixed inset-x-md bottom-md z-(--fd-layer-toast)', true: '' },
  },
});

/**
 * Holds the toasts of an app: at the bottom end corner (left in RTL), away
 * from the sidebar, up to three. A toast is announced in a polite live region,
 * a danger one in an assertive region; hover and focus pause its timer.
 */
export function Toaster(props: ToasterProps) {
  const { label, closeLabel, max = 3, children, inline = false } = props;
  const [items, setItems] = useState<Item[]>(() =>
    (props.toasts ?? []).slice(-max).map((options, i) => ({ ...options, id: i + 1 })),
  );
  const next = useRef(items.length);
  const show = useCallback(
    (options: ToastOptions) => {
      next.current += 1;
      const item = { ...options, id: next.current };
      setItems((current) => {
        const next = [...current, item];
        // Over the limit, the oldest toast that leaves by itself goes first: a
        // danger toast stays until it is closed.
        while (next.length > max) {
          const index = next.findIndex((entry) => entry.tone !== 'danger');
          next.splice(index === -1 ? 0 : index, 1);
        }
        return next;
      });
    },
    [max],
  );
  const remove = useCallback((id: number) => {
    setItems((current) => current.filter((item) => item.id !== id));
  }, []);
  const value = useMemo(() => ({ show }), [show]);
  const list = (assertive: boolean) => (
    <ul
      aria-live={assertive ? 'assertive' : 'polite'}
      className="m-none flex list-none flex-col items-end gap-xs p-none"
    >
      {items
        .filter((item) => (item.tone === 'danger') === assertive)
        .map((item) => (
          <Toast
            key={item.id}
            item={item}
            closeLabel={closeLabel}
            onClose={remove}
            stays={inline}
          />
        ))}
    </ul>
  );
  return (
    <ToastContext.Provider value={value}>
      {children}
      <section aria-label={label} className={region({ inline })}>
        {list(false)}
        {list(true)}
      </section>
    </ToastContext.Provider>
  );
}
