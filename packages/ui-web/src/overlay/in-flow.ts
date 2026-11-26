import { useCallback } from 'react';
import { formTv } from '../field/styles';

// D.C3: the components canvas draws an anchored popup open inside its board,
// in the cell's flow beside its trigger. The SDK (0.1.0-beta.14) has `inline`
// only for its dialogs: Menu, Select, Tooltip, Combobox and DatePicker content
// always joins the browser's top layer (`popover="manual"`) and is placed
// `fixed` from its trigger, so it would take no room and cover the next row.

/** Undoes the SDK's fixed placement (its inline styles), so the popup lays out where it is written. */
export const IN_FLOW = 'static! m-none! max-h-fit!';

/**
 * The trigger and its popup: in flow (`inline`) stacked at the start of the full width, the
 * popup the select's gap (4) under it and the trigger at its own width;
 * otherwise no box at all.
 */
export const inFlowFrame = formTv({
  base: '',
  variants: { inline: { true: 'flex w-full flex-col items-start gap-2xs', false: 'contents' } },
});

/**
 * A ref for an anchored popup's content that, when `on`, takes it out of the
 * top layer each time the SDK puts it there: without its `popover` attribute
 * it is an ordinary element in the page's flow.
 */
export function useInFlow(on: boolean) {
  return useCallback(
    (el: HTMLElement | null) => {
      if (!on || !el) return;
      const leave = () => {
        if (el.hasAttribute('popover')) el.removeAttribute('popover');
      };
      leave();
      const observer = new MutationObserver(leave);
      observer.observe(el, { attributes: true, attributeFilter: ['popover'] });
      return () => observer.disconnect();
    },
    [on],
  );
}
