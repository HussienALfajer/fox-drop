/**
 * The states the stories show (R3), as the Flutter twin's: the image is the
 * app's, so the catalogue shows the letter that stands in for a missing one.
 */
export const STATES = ['letter'] as const;

const graphemes = new Intl.Segmenter(undefined, { granularity: 'grapheme' });

/** The letter that stands in for a missing logo: the name's first, a Latin one in capitals. */
export function logoInitial(name: string): string {
  const first = graphemes.segment(name.trim())[Symbol.iterator]().next();
  return first.done ? '' : first.value.segment.toLocaleUpperCase('en');
}

export interface LogoProps {
  /** The restaurant's name, shown beside the logo; its first letter stands in for a missing image. */
  name: string;
  /** The logo's image; the app serves it. */
  src?: string;
}

/**
 * A restaurant's logo in a rounded square, or the first letter of its name on
 * a tint when it has none (brand expression §5: never a drop, never a fake
 * image). Decoration: the name beside it says who it is.
 */
export function Logo({ name, src }: LogoProps) {
  // An empty alternative text: the name beside the logo already says it.
  const decorative = '';
  return (
    <span
      aria-hidden="true"
      className="inline-flex size-(--fd-logo-size) shrink-0 items-center justify-center overflow-hidden rounded-(--fd-logo-radius) bg-(--fd-logo-color-background) text-phone-title text-(color:--fd-logo-color-letter)"
    >
      {src ? (
        <img src={src} alt={decorative} className="size-full object-cover" />
      ) : (
        logoInitial(name)
      )}
    </span>
  );
}
