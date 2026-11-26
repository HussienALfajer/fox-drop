import { formTv, keyboardRing } from '../field/styles';

// The overlays of the approved sheet «Overlays and navigation — batch 4»
// (D.10): the scrim token behind them, `layer.overlay` above the page, the
// high elevation, and motion from the tokens. Under reduced motion only the
// opacity fades.

/** The dim behind a dialog or a drawer. */
export const backdrop = formTv({
  base: [
    'inset-none bg-(--fd-dialog-color-scrim)',
    'transition-opacity duration-(--fd-duration-base) ease-(--fd-easing-standard)',
    'data-starting-style:opacity-0 data-ending-style:opacity-0',
  ],
  variants: {
    // Over the page; inside a frame (`inline`: the components canvas) it dims that frame only.
    inline: { false: 'fixed z-(--fd-layer-overlay)', true: 'absolute' },
  },
  defaultVariants: { inline: false },
});

/** A centred dialog on its `dialog.*` tokens: raised, high elevation; it fades and grows from 96%. */
export const dialogPanel = formTv({
  base: [
    'm-auto flex h-fit max-h-full max-w-(--fd-dialog-width) flex-col gap-(--fd-dialog-gap) overflow-y-auto',
    'rounded-(--fd-dialog-radius) bg-(--fd-dialog-color-background) p-(--fd-dialog-padding) text-(color:--fd-dialog-color-title) shadow-high outline-hidden',
    'transition duration-(--fd-duration-base) ease-(--fd-easing-standard) motion-reduce:transition-opacity',
    'data-starting-style:scale-96 data-starting-style:opacity-0 data-ending-style:scale-96 data-ending-style:opacity-0 motion-reduce:data-starting-style:scale-100 motion-reduce:data-ending-style:scale-100',
  ],
  variants: {
    // Over the page, a margin from its edges; inside a frame (`inline`), in its flow above the frame's scrim.
    inline: { false: 'fixed inset-md z-(--fd-layer-overlay)', true: 'relative' },
  },
  defaultVariants: { inline: false },
});

/** The frame an inline overlay sits in: its scrim fills it, the panel centred with a margin. */
export const inlineFrame = formTv({ base: 'relative isolate flex p-md' });

/** A dialog's title and the × beside it. */
export const header = formTv({ base: 'flex items-start gap-(--fd-dialog-header-gap)' });
export const title = formTv({
  base: 'm-none min-w-none flex-1 font-bold text-phone-title',
});

/** The × of an overlay's header. */
export const closeButton = formTv({
  base: `-m-xs inline-flex size-(--fd-size-touch-target) shrink-0 cursor-pointer items-center justify-center rounded-full text-on-surface-muted hover:bg-surface-raised-hover active:bg-surface-raised-pressed ${keyboardRing}`,
});
