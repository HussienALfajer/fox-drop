import type { ReactNode } from 'react';
import { Button } from '../button/button';
import { formTv } from '../field/styles';

/** The states the stories show (R3), as the Flutter twin's. */
export const STATES = ['connected', 'offline'] as const;

const bar = formTv({
  slots: {
    root: [
      'flex min-h-(--fd-restaurant-bar-min-height) items-center gap-(--fd-restaurant-bar-gap)',
      'px-(--fd-restaurant-bar-padding-inline) py-(--fd-restaurant-bar-padding-block)',
      'bg-(--fd-restaurant-bar-color-background)',
      'border-b-(length:--fd-restaurant-bar-border-width) border-(--fd-restaurant-bar-color-border)',
    ],
    lead: 'flex min-w-none flex-1 items-center gap-(--fd-restaurant-bar-gap)',
    name: 'm-none min-w-none truncate text-phone-subtitle font-bold text-(color:--fd-restaurant-bar-color-name)',
    connection: 'flex min-w-none items-center gap-(--fd-restaurant-bar-dot-gap)',
    dot: 'size-(--fd-restaurant-bar-dot-size) shrink-0 rounded-full',
    words: 'min-w-none truncate text-phone-caption font-medium',
  },
  variants: {
    connected: {
      true: {
        dot: 'bg-(--fd-restaurant-bar-color-connected)',
        words: 'text-(color:--fd-restaurant-bar-color-connected)',
      },
      false: {
        dot: 'bg-(--fd-restaurant-bar-color-offline)',
        words: 'text-(color:--fd-restaurant-bar-color-offline)',
      },
    },
  },
});

export interface RestaurantBarProps {
  /** The restaurant's name: the screen's heading. */
  name: string;
  /** The status pill the app gives (a StatusChip, or a button that opens the status sheet). */
  status: ReactNode;
  connected: boolean;
  /** «متصل» or «غير متصل»: shown beside the dot, never colour alone. */
  connectionLabel: string;
  /** The support button's name: «الدعم». */
  supportLabel: string;
  onSupport?: () => void;
}

/**
 * The restaurant app's bar on every screen (RA §6.2): the name, the status
 * pill, the connection dot with its words beside it (a live status, so a
 * drop is announced) and the round support button.
 */
export function RestaurantBar({
  name,
  status,
  connected,
  connectionLabel,
  supportLabel,
  onSupport,
}: RestaurantBarProps) {
  const parts = bar({ connected });
  return (
    <header className={parts.root()}>
      <div className={parts.lead()}>
        <h1 className={parts.name()}>{name}</h1>
        {status}
        <span role="status" className={parts.connection()}>
          <span aria-hidden="true" className={parts.dot()} />
          <span className={parts.words()}>{connectionLabel}</span>
        </span>
      </div>
      <Button
        icon="chat"
        label={supportLabel}
        variant="secondary"
        {...(onSupport && { onClick: () => onSupport() })}
      />
    </header>
  );
}
