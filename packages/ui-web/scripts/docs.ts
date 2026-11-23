// The documentation files of the Design System components: the types as
// docs and the README and preview of each component.
import { readFileSync } from 'node:fs';
import path from 'node:path';
import { ICON_NAMES, PACKAGE_DIR } from './bundle.ts';

const SOURCE = path.join(PACKAGE_DIR, 'design-system');

/** `components/index.d.ts`: readable without imports, so the icon names are inline. */
export function typesDoc(): string {
  const names = ICON_NAMES.map((name) => `  | '${name}'`).join('\n');
  return `// Types of the FOX DROP components, as documentation. Use them through window.FoxDrop.
type ReactNode = unknown; // text, an element or an array of them

type IconName =
${names};

interface IconProps {
  name: IconName;
  /** The accessible name. Without it the icon is decorative and hidden from screen readers. */
  label?: string;
  /** Default 'md'. */
  size?: 'sm' | 'md' | 'lg';
}

type ButtonVariant = 'primary' | 'secondary' | 'danger' | 'ghost';

interface ButtonBase {
  /** The look: 'primary' by default. */
  variant?: ButtonVariant;
  /** 'comfortable' is 50 high (phones); 'compact' is 40, for the admin panel and the restaurant portal. */
  density?: 'comfortable' | 'compact';
  /** Shows a spinner over the hidden label, keeps the width and ignores presses. */
  loading?: boolean;
  disabled?: boolean;
  type?: 'button' | 'submit' | 'reset';
  onClick?: (event: unknown) => void;
}

interface TextButtonProps extends ButtonBase {
  children: ReactNode;
  /** At the start of the label (right in RTL). */
  icon?: IconName;
  /** At the end of the label (left in RTL). */
  iconEnd?: IconName;
}

interface IconOnlyButtonProps extends ButtonBase {
  /** An icon alone makes a circle. */
  icon: IconName;
  /** Its accessible name. */
  label: string;
}

/** A button with a label, or an icon alone with a label for screen readers. */
type ButtonProps = TextButtonProps | IconOnlyButtonProps;
`;
}

export function readme(component: string): string {
  return readFileSync(path.join(SOURCE, component, 'README.md'), 'utf8');
}

/** The Icon preview lists every icon: its names come from the package, not the template. */
export function preview(component: string): string {
  const html = readFileSync(path.join(SOURCE, component, 'preview.html'), 'utf8');
  return html.replace('__ICON_NAMES__', JSON.stringify(ICON_NAMES));
}
