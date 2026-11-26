import { formTv } from '../field/styles';
import { DROP, PIECES, VIEW_BOX } from '../drop-loader/mark';

/** The states the stories show (R3), as the Flutter twin's. */
export const STATES = ['full', 'compact'] as const;

/** The code is never shown here: six dots in its place. */
export const MASK = '••••••';

// The mark centred in a square, in the brand file's coordinates.
const SIDE = VIEW_BOX.height;
const MARK_BOX = [VIEW_BOX.x - (SIDE - VIEW_BOX.width) / 2, VIEW_BOX.y, SIDE, SIDE].join(' ');

const preview = formTv({
  slots: {
    root: 'flex items-end gap-(--fd-code-preview-gap)',
    avatar: [
      'flex size-(--fd-code-preview-avatar-size) shrink-0 items-center justify-center rounded-full',
      'bg-(--fd-code-preview-color-avatar)',
    ],
    mark: 'size-full scale-(--fd-code-preview-mark-scale)',
    drop: 'fill-primary',
    piece: 'fill-on-primary',
    bubble: [
      'flex min-w-none flex-1 flex-col gap-(--fd-code-preview-line-gap) bg-(--fd-code-preview-color-bubble)',
      'px-(--fd-code-preview-bubble-padding-inline) py-(--fd-code-preview-bubble-padding-block)',
      'rounded-(--fd-code-preview-bubble-radius) rounded-es-(--fd-code-preview-bubble-radius-tail)',
    ],
    sender: 'text-phone-caption font-bold text-on-surface',
    message: 'text-phone-secondary text-on-surface',
    code: 'font-bold text-(color:--fd-code-preview-color-code)',
    time: 'self-end text-phone-caption text-(color:--fd-code-preview-color-time)',
  },
});

export interface CodePreviewProps {
  /** «FOX DROP». */
  sender: string;
  /** The words before the code: «رمز الدخول إلى FOX DROP:». */
  message: string;
  /** «الآن · واتساب». */
  time: string;
  /** What a screen reader reads, once, for the whole preview. */
  label: string;
  /** The keyboard is up: the sender line goes. */
  compact?: boolean;
}

/**
 * What the WhatsApp message with the code will look like (D.11 screen 2, CU
 * §5.2): the brand's round mark, a bubble with the sender, the real words
 * with the code masked, and the time. No WhatsApp logo or green: our tokens
 * only. Read once, by `label`.
 */
export function CodePreview({ sender, message, time, label, compact = false }: CodePreviewProps) {
  const parts = preview();
  const words = `${message} `;
  return (
    <div role="img" aria-label={label} className={parts.root()}>
      <div aria-hidden="true" className="contents">
        <span className={parts.avatar()}>
          <svg viewBox={MARK_BOX} focusable="false" className={parts.mark()}>
            <path d={DROP} className={parts.drop()} />
            {PIECES.map((piece) => (
              <path key={piece} d={piece} className={parts.piece()} />
            ))}
          </svg>
        </span>
        <div className={parts.bubble()}>
          {!compact && <span className={parts.sender()}>{sender}</span>}
          <span className={parts.message()}>
            {words}
            <span className={parts.code()}>{MASK}</span>
          </span>
          <span className={parts.time()}>{time}</span>
        </div>
      </div>
    </div>
  );
}
