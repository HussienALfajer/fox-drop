import { formTv, keyboardRing } from '../field/styles';

// The overlays of the approved sheet «Overlays and navigation — batch 4»
// (D.10): the scrim token behind them, `layer.overlay` above the page, the
// high elevation, and motion from the tokens. Under reduced motion only the
// opacity fades.

/** The dim behind a dialog or a drawer. */
export const backdrop = formTv({
  base: [
    'fixed inset-none z-(--fd-layer-overlay) bg-scrim',
    'transition-opacity duration-(--fd-duration-base) ease-(--fd-easing-standard)',
    'data-starting-style:opacity-0 data-ending-style:opacity-0',
  ],
});

/** A centred dialog: raised surface, radius 15, high elevation; it fades and grows from 96%. */
export const dialogPanel = formTv({
  base: [
    'fixed inset-md z-(--fd-layer-overlay) m-auto flex h-fit max-h-full max-w-(--fd-size-dialog) flex-col gap-md overflow-y-auto',
    'rounded-lg bg-surface-raised p-lg text-on-surface shadow-high outline-hidden',
    'transition duration-(--fd-duration-base) ease-(--fd-easing-standard) motion-reduce:transition-opacity',
    'data-starting-style:scale-96 data-starting-style:opacity-0 data-ending-style:scale-96 data-ending-style:opacity-0 motion-reduce:data-starting-style:scale-100 motion-reduce:data-ending-style:scale-100',
  ],
});

/** A dialog's title and the × beside it. */
export const header = formTv({ base: 'flex items-start gap-sm' });
export const title = formTv({
  base: 'm-none min-w-none flex-1 font-bold text-phone-title',
});

/** The × of an overlay's header. */
export const closeButton = formTv({
  base: `-m-xs inline-flex size-(--fd-size-touch-target) shrink-0 cursor-pointer items-center justify-center rounded-full text-on-surface-muted hover:bg-surface-raised-hover active:bg-surface-raised-pressed ${keyboardRing}`,
});
