import { DROP, PIECES, VIEW_BOX } from '../drop-loader/mark';
import { formTv } from '../field/styles';

/**
 * The states the stories show (R3), as the Flutter twins' (`versionTicketStates`,
 * `shopSignStates`): the two heads share one folder and one Storybook title.
 */
export const STATES = ['versionTicket', 'shopSign', 'shopSignReturnTime'] as const;

// The mark centred in a square, in the brand file's coordinates.
const SIDE = VIEW_BOX.height;
const MARK_BOX = [VIEW_BOX.x - (SIDE - VIEW_BOX.width) / 2, VIEW_BOX.y, SIDE, SIDE].join(' ');

const ticket = formTv({
  slots: {
    root: [
      'flex w-full max-w-(--fd-blocking-heads-ticket-max-width) flex-col',
      'rounded-(--fd-blocking-heads-ticket-radius) bg-(--fd-blocking-heads-color-ticket) shadow-offset',
    ],
    top: 'flex flex-wrap items-center justify-between gap-(--fd-blocking-heads-ticket-gap) p-(--fd-blocking-heads-ticket-padding)',
    label: 'text-phone-secondary text-(color:--fd-blocking-heads-color-label)',
    installed:
      'text-phone-title text-(color:--fd-blocking-heads-color-label) line-through decoration-(--fd-blocking-heads-color-label)',
    perforation: [
      'relative flex h-(--fd-blocking-heads-ticket-perforation-height) items-center',
      'px-(--fd-blocking-heads-ticket-padding)',
    ],
    dashes: [
      'flex-1 border-t-(length:--fd-blocking-heads-ticket-perforation-width) border-dashed',
      'border-(--fd-blocking-heads-color-perforation)',
    ],
    // A circle of the band's height centred on each edge: half of it cut from the ticket.
    cut: 'absolute top-none size-(--fd-blocking-heads-ticket-perforation-height) rounded-full bg-(--fd-blocking-heads-color-cut)',
    cutStart: '-start-(--fd-blocking-heads-ticket-cut-offset)',
    cutEnd: '-end-(--fd-blocking-heads-ticket-cut-offset)',
    bottom:
      'flex items-center gap-(--fd-blocking-heads-ticket-gap) p-(--fd-blocking-heads-ticket-padding)',
    required: 'flex min-w-none flex-1 flex-col gap-(--fd-blocking-heads-ticket-line-gap)',
    version: 'self-start text-phone-number text-(color:--fd-blocking-heads-color-required)',
    mark: 'size-(--fd-blocking-heads-ticket-mark-size) shrink-0',
  },
});

export interface VersionTicketProps {
  /** «إصدارك». */
  installedLabel: string;
  installed: string;
  /** «الإصدار الجديد». */
  requiredLabel: string;
  required: string;
  /** What a screen reader reads, once, for the whole ticket. */
  label: string;
}

/**
 * The forced update's head (D.11 screen 7, CU §4.2): a ticket, the installed
 * version struck above the perforation, the required one below beside the
 * mark. Versions show left to right. Read once, by `label`.
 */
export function VersionTicket({
  installedLabel,
  installed,
  requiredLabel,
  required,
  label,
}: VersionTicketProps) {
  const parts = ticket();
  return (
    <div role="img" aria-label={label} className={parts.root()}>
      <div className={parts.top()}>
        <span className={parts.label()}>{installedLabel}</span>
        <span dir="ltr" className={parts.installed()}>
          {installed}
        </span>
      </div>
      {/* The perforation: a dashed line with a half circle cut from each edge. */}
      <div aria-hidden="true" className={parts.perforation()}>
        <span className={parts.dashes()} />
        <span className={parts.cut({ class: parts.cutStart() })} />
        <span className={parts.cut({ class: parts.cutEnd() })} />
      </div>
      <div className={parts.bottom()}>
        <span className={parts.required()}>
          <span className={parts.label()}>{requiredLabel}</span>
          <span dir="ltr" className={parts.version()}>
            {required}
          </span>
        </span>
        <svg aria-hidden="true" focusable="false" viewBox={MARK_BOX} className={parts.mark()}>
          <path d={DROP} className="fill-on-primary" />
          {PIECES.map((piece) => (
            <path key={piece} d={piece} className="fill-brand" />
          ))}
        </svg>
      </div>
    </div>
  );
}

const sign = formTv({
  slots: {
    root: 'flex w-(--fd-blocking-heads-sign-width) flex-col items-center',
    // Positioned, so it paints over the strings that meet under it.
    nail: 'relative size-(--fd-blocking-heads-sign-nail-size) rounded-full bg-(--fd-blocking-heads-color-perforation)',
    strings: [
      'h-(--fd-blocking-heads-sign-strings-height) w-full overflow-visible fill-none',
      'stroke-(--fd-blocking-heads-color-perforation) stroke-(length:--fd-blocking-heads-sign-string-width)',
      // Lifted to meet under the nail; the board stays where the box ends.
      '-mt-(--fd-blocking-heads-sign-strings-lift) mb-(--fd-blocking-heads-sign-strings-lift)',
    ],
    // The board's solid pressed-orange edge: the board's own shape, `edge` lower.
    edge: 'w-full rounded-(--fd-blocking-heads-sign-radius) bg-(--fd-blocking-heads-color-board-edge) pb-(--fd-blocking-heads-sign-edge)',
    board: [
      'relative flex w-full flex-col gap-(--fd-blocking-heads-sign-line-gap) text-center',
      'rounded-(--fd-blocking-heads-sign-radius) bg-(--fd-blocking-heads-color-board) text-(color:--fd-blocking-heads-color-board-ink)',
      'px-(--fd-blocking-heads-sign-padding-inline) pt-(--fd-blocking-heads-sign-padding-top) pb-(--fd-blocking-heads-sign-padding-bottom)',
    ],
    hole: [
      'absolute top-(--fd-blocking-heads-sign-hole-inset-block) size-(--fd-blocking-heads-sign-hole-size)',
      'rounded-full bg-(--fd-blocking-heads-color-cut)',
    ],
    holeStart: 'start-(--fd-blocking-heads-sign-hole-inset-inline)',
    holeEnd: 'end-(--fd-blocking-heads-sign-hole-inset-inline)',
    title: 'text-phone-large-title font-bold',
    subtitle: 'text-phone-secondary',
    time: 'text-phone-secondary font-bold',
  },
});

export interface ShopSignProps {
  /** «نعود قريباً». */
  title: string;
  /** «صيانة قصيرة». */
  subtitle: string;
  /** «نعود الساعة 3:00 م», from the maintenance return time. */
  returnTime?: string;
  /** What a screen reader reads, once, for the whole sign. */
  label: string;
}

/**
 * The maintenance head (D.11 screen 7, CU §4.7): an orange board hung by two
 * strings from a nail, on its pressed-orange edge: the title, the subtitle
 * and, when the panel gave one, the return time. Read once, by `label`.
 */
export function ShopSign({ title, subtitle, returnTime, label }: ShopSignProps) {
  const parts = sign();
  return (
    <div role="img" aria-label={label} className={parts.root()}>
      <span aria-hidden="true" className={parts.nail()} />
      {/* The strings from the nail to the board's corners, in the drawing's 192 × 40 box. */}
      <svg
        aria-hidden="true"
        focusable="false"
        viewBox="0 0 192 40"
        preserveAspectRatio="none"
        className={parts.strings()}
      >
        <path
          d="M96 2 L20 38 M96 2 L172 38"
          strokeLinecap="round"
          vectorEffect="non-scaling-stroke"
        />
      </svg>
      <div className={parts.edge()}>
        <div className={parts.board()}>
          <span aria-hidden="true" className={parts.hole({ class: parts.holeStart() })} />
          <span aria-hidden="true" className={parts.hole({ class: parts.holeEnd() })} />
          <span className={parts.title()}>{title}</span>
          <span className={parts.subtitle()}>{subtitle}</span>
          {returnTime && <span className={parts.time()}>{returnTime}</span>}
        </div>
      </div>
    </div>
  );
}
