import { Tooltip as SdkTooltip, TooltipContent, TooltipTrigger } from '@ui-sdk/react/tooltip';
import { useState, type ReactElement } from 'react';
import { formTv } from '../field/styles';

/** The states the stories show (R3): closed, open, on the collapsed sidebar. */
export const STATES = ['default', 'open', 'sidebar'] as const;

/** The approved sheet: 500 ms on hover; at once on keyboard focus. */
export const TOOLTIP_DELAY = 500;

// Navy (on-surface) with ivory text, radius 10, at most 240 wide; it fades in
// duration.fast. Pointer devices only: on touch the label is visible instead.
const content = formTv({
  base: [
    'z-(--fd-layer-tooltip) max-w-(--fd-tooltip-max-width) rounded-(--fd-tooltip-radius) px-(--fd-tooltip-padding-inline) py-(--fd-tooltip-padding-block)',
    'bg-(--fd-tooltip-color-background) text-panel-secondary font-medium text-(color:--fd-tooltip-color-text)',
    'transition-opacity duration-(--fd-duration-fast) ease-(--fd-easing-standard) data-starting-style:opacity-0 data-ending-style:opacity-0',
  ],
});

export interface TooltipProps {
  /** What it says. It describes the trigger, which keeps its own name. */
  content: string;
  /** The element it explains: a button or a link with a name of its own. */
  children: ReactElement;
  side?: 'top' | 'bottom' | 'start' | 'end';
}

/** A short description on hover (after 500 ms) and on keyboard focus (at once). */
export function Tooltip({ content: text, children, side = 'bottom' }: TooltipProps) {
  const [open, setOpen] = useState(false);
  return (
    <SdkTooltip
      delay={TOOLTIP_DELAY}
      type="description"
      open={open}
      onOpenChange={(next: boolean) => setOpen(next)}
    >
      <TooltipTrigger
        render={children}
        // Escape hides it while focus stays on the trigger (WCAG 1.4.13).
        onKeyDown={(event) => {
          if (event.key === 'Escape' && open) setOpen(false);
        }}
      />
      {/* Mounted only while open: a closed tooltip leaves no description behind. */}
      {open && (
        <TooltipContent className={content()} side={side}>
          {text}
        </TooltipContent>
      )}
    </SdkTooltip>
  );
}
