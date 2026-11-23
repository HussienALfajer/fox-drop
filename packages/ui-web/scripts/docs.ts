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

type Density = 'comfortable' | 'compact';

interface FieldProps {
  /** The visible label above the control; it names the control. */
  label: string;
  /** Marks an optional field, in Arabic (اختياري) with its brackets. There is no required star. */
  optionalLabel?: string;
  /** Help below the control; an error replaces it. */
  hint?: string;
  /** The error below the control, with its icon; it describes the control for screen readers. */
  error?: string;
  /** Something at the end of the line below, like a character counter. */
  aside?: ReactNode;
  disabled?: boolean;
  name?: string;
  /** 'comfortable' is 50 high, 'compact' is 40 (panel and portal only). */
  density?: Density;
  /** The control. */
  children: ReactNode;
}

interface TextFieldProps {
  label: string;
  optionalLabel?: string;
  hint?: string;
  error?: string;
  placeholder?: string;
  value?: string;
  defaultValue?: string;
  onValueChange?: (value: string) => void;
  name?: string;
  type?: 'text' | 'email' | 'url' | 'password';
  inputMode?: 'text' | 'email' | 'url' | 'numeric' | 'decimal' | 'search';
  autoComplete?: string;
  maxLength?: number;
  required?: boolean;
  disabled?: boolean;
  density?: Density;
}

interface TextAreaProps {
  label: string;
  optionalLabel?: string;
  hint?: string;
  error?: string;
  placeholder?: string;
  value?: string;
  defaultValue?: string;
  onValueChange?: (value: string) => void;
  name?: string;
  /** Shows the count below the field and stops typing at the limit. */
  maxLength?: number;
  required?: boolean;
  disabled?: boolean;
}

interface SearchFieldProps {
  /** The accessible name of the field; there is no visible label. */
  label: string;
  /** The accessible name of the clear button. */
  clearLabel: string;
  placeholder?: string;
  value?: string;
  defaultValue?: string;
  onValueChange?: (value: string) => void;
  name?: string;
  /** A spinner replaces the clear button while results load. */
  loading?: boolean;
  disabled?: boolean;
  density?: Density;
}

type PhoneCountry = 'sy' | 'tr';
type PhoneDetails = Record<'country', PhoneCountry>;

interface PhoneFieldProps {
  label: string;
  optionalLabel?: string;
  hint?: string;
  error?: string;
  /** The names in the country menu, shown before the calling code. */
  countryLabels: Record<PhoneCountry, string>;
  /** The accessible name of the country chip. */
  countryLabel: string;
  placeholder?: string;
  /** The number in E.164, or an empty string while it is not a complete mobile number. */
  value?: string;
  defaultValue?: string;
  /** Called with the E.164 number once complete (09... or 9... for Syria, 05... or 5... for Turkey), else with an empty string. */
  onValueChange?: (value: string, details: PhoneDetails) => void;
  country?: PhoneCountry;
  /** The picker starts on this country; 'sy' by default. */
  defaultCountry?: PhoneCountry;
  onCountryChange?: (country: PhoneCountry) => void;
  name?: string;
  required?: boolean;
  disabled?: boolean;
  density?: Density;
}

interface CodeFieldProps {
  label: string;
  hint?: string;
  error?: string;
  value?: string;
  defaultValue?: string;
  onValueChange?: (value: string) => void;
  /** Called once with the whole code when the sixth cell is filled. */
  onComplete?: (value: string) => void;
  /** The code was accepted: the cells fill with the brand orange and fuse. */
  done?: boolean;
  name?: string;
  autoFocus?: boolean;
  disabled?: boolean;
}

type SelectItem = Record<'value' | 'label', string>;

interface SelectProps {
  label: string;
  optionalLabel?: string;
  hint?: string;
  error?: string;
  placeholder?: string;
  /** The options: the label is what the trigger shows and what typing finds. */
  items: SelectItem[];
  value?: string;
  defaultValue?: string;
  onValueChange?: (value: string) => void;
  name?: string;
  required?: boolean;
  disabled?: boolean;
  density?: Density;
}

interface CheckboxProps {
  /** The text beside the box; the whole row is the target. */
  label: string;
  /** 'indeterminate' is the mixed state of a parent whose children are partly checked. */
  checked?: boolean | 'indeterminate';
  defaultChecked?: boolean | 'indeterminate';
  onCheckedChange?: (checked: boolean) => void;
  name?: string;
  value?: string;
  required?: boolean;
  disabled?: boolean;
  /** The outline turns red. */
  invalid?: boolean;
}

type RadioOption = Record<'value' | 'label', string>;

interface RadioGroupProps {
  /** The visible question above the options. */
  label: string;
  optionalLabel?: string;
  hint?: string;
  error?: string;
  options: RadioOption[];
  value?: string;
  defaultValue?: string;
  onValueChange?: (value: string) => void;
  name?: string;
  required?: boolean;
  disabled?: boolean;
}

interface SwitchProps {
  /** What the setting is; it stays the same in both states. */
  label: string;
  checked?: boolean;
  defaultChecked?: boolean;
  onCheckedChange?: (checked: boolean) => void;
  name?: string;
  disabled?: boolean;
}

interface QuantityStepperProps {
  /** The accessible name of the group with the count, for example the Arabic word for quantity and 2. */
  label: string;
  increaseLabel: string;
  decreaseLabel: string;
  /** The name of the minus button when it removes the line. */
  removeLabel?: string;
  value?: number;
  defaultValue?: number;
  onValueChange?: (value: number) => void;
  /** Pressing minus at the minimum; the button then shows the delete icon. Without it minus is off at the minimum. */
  onRemove?: () => void;
  /** Default 1. */
  min?: number;
  max?: number;
  disabled?: boolean;
}
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
