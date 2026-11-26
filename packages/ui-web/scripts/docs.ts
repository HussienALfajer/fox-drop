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
  /** The style of set v4 Madar; default 'linear'. 'bold' for a selected item, 'brand-duo' for an empty state. */
  variant?: 'linear' | 'duotone' | 'brand-duo' | 'broken' | 'bold' | 'bold-duo';
}

type ButtonVariant = 'primary' | 'secondary' | 'danger' | 'ghost';

interface ButtonBase {
  /** The look: 'primary' by default. */
  variant?: ButtonVariant;
  /** 'comfortable' is 50 high (phones); 'compact' is 40, for the admin panel and the restaurant portal. */
  density?: 'comfortable' | 'compact';
  /** Shows the drop loader over the hidden label, keeps the width and ignores presses. */
  loading?: boolean;
  /** Shown beside the loader while loading, and the button's name then. */
  loadingLabel?: string;
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

interface DropLoaderProps {
  /** 'sm' 16 (inside a field), 'md' 24 (a button, the default), 'lg' 48 (a page part). */
  size?: 'sm' | 'md' | 'lg';
  /** On the orange ground: an ivory drop with an orange fox. */
  onPrimary?: boolean;
  /** Read in a polite live region («جارٍ التحميل»); without it the loader is decoration. */
  label?: string;
}

interface TextLinkProps {
  children: ReactNode;
  /** Where it goes; without it the link acts through onClick. Always read as a link. */
  href?: string;
  onClick?: () => void;
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
  /** The drop loader replaces the clear button while results load. */
  loading?: boolean;
  disabled?: boolean;
  density?: Density;
}

/** Why a number is not a complete mobile yet. */
type PhoneProblem =
  | 'empty'
  | 'missingDigits'
  | 'tooLong'
  | 'landline'
  | 'notMobilePrefix'
  | 'unknownCode';

interface PhoneReading {
  /** The ISO code of the country the number belongs to. */
  country: string;
  national: string;
  /** The national digits in groups of three: '944 123 456'. */
  grouped: string;
  e164?: string;
  problem?: PhoneProblem;
  missing?: number;
  prefix?: string;
  switchedFrom?: string;
}

interface PhoneDetails {
  country: string;
  reading: PhoneReading;
}

/** The words of each problem. */
interface PhoneMessages {
  empty: string;
  missingDigits: (count: number) => string;
  tooLong: string;
  landline: string;
  notMobilePrefix: (prefix: string) => string;
  unknownCode: string;
  switched: (country: string) => string;
}

interface PhoneFieldProps {
  label: string;
  optionalLabel?: string;
  hint?: string;
  /** An error of the screen's own; the field's problems come from messages. */
  error?: string;
  messages: PhoneMessages;
  /** The chip's accessible name, from the country's Arabic name and calling code. */
  chipLabel: (name: string, code: string) => string;
  searchLabel: string;
  pinnedLabel: string;
  lastUsedLabel: string;
  allLabel: string;
  emptyLabel: string;
  validLabel: string;
  clearLabel: string;
  placeholder?: string;
  /** The number in E.164, or an empty string while it is not a complete mobile number. */
  value?: string;
  defaultValue?: string;
  /** Called with the E.164 number once it is a complete mobile of any country, else with an empty string. */
  onValueChange?: (value: string, details: PhoneDetails) => void;
  /** Enter with a complete mobile; otherwise the problem shows. */
  onSubmit?: (value: string) => void;
  /** ISO code, such as 'SY'. */
  country?: string;
  /** The field starts on this country; 'SY' by default. */
  defaultCountry?: string;
  onCountryChange?: (country: string) => void;
  /** Listed after Syria and Turkey. */
  lastUsedCountry?: string;
  /** Locked while the number is being sent. */
  busy?: boolean;
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

interface CountrySheetProps {
  /** ISO code, such as 'SY'. */
  value: string;
  onValueChange: (country: string) => void;
  /** Listed after Syria and Turkey. */
  lastUsed?: string;
  searchLabel: string;
  pinnedLabel: string;
  lastUsedLabel: string;
  allLabel: string;
  emptyLabel: string;
  disabled?: boolean;
  /** The search already typed. */
  defaultQuery?: string;
  /** The button that opens the list: a CountrySheet.Trigger. */
  children: ReactNode;
}

interface DateFieldProps {
  label: string;
  optionalLabel?: string;
  hint?: string;
  error?: string;
  placeholder?: string;
  /** ISO 'YYYY-MM-DD', or null. Shown as dd/mm/yyyy. */
  value?: string | null;
  defaultValue?: string | null;
  onValueChange?: (value: string | null) => void;
  min?: string;
  max?: string;
  previousLabel: string;
  nextLabel: string;
  /** ISO; the browser's by default. */
  today?: string;
  name?: string;
  required?: boolean;
  disabled?: boolean;
}

interface TimeFieldProps {
  label: string;
  optionalLabel?: string;
  hint?: string;
  error?: string;
  /** 'HH:mm', 24-hour, or null. Shown 12-hour with «ص» and «م». */
  value?: string | null;
  defaultValue?: string | null;
  onValueChange?: (value: string | null) => void;
  name?: string;
  required?: boolean;
  disabled?: boolean;
}

interface CodePreviewProps {
  sender: string;
  /** The words before the code; the code itself is never shown, six dots stand in. */
  message: string;
  time: string;
  /** Read once, for the whole preview. */
  label: string;
  /** The keyboard is up: no sender line. */
  compact?: boolean;
}

interface RestaurantCardProps {
  name: string;
  /** «برجر · وجبات سريعة». */
  categories: string;
  /** The estimate as a range: «20–30 د». */
  eta: string;
  /** A Money, or the words «توصيل مجاني». */
  fee: ReactNode;
  /** The restaurant's page: the card is one link to it. */
  href: string;
  favourite: boolean;
  /** The heart's name: «المفضلة». */
  favouriteLabel: string;
  onFavourite: () => void;
  /** The cover photo, 16:9. Missing or failing, the logo shows on a tint. */
  cover?: string;
  logo?: string;
  /** «4.5»; without it, newLabel («جديد»). */
  rating?: string;
  newLabel?: string;
  /** «مشغول», «مغلق — يفتح السبت 10:00 ص»: a chip on the cover, read with the name. */
  state?: { label: string; tone: Tone };
  /** Fades the card but its state and the heart. */
  closed?: boolean;
}

interface DishCardProps {
  name: string;
  /** A Money. */
  price: ReactNode;
  /** «أضف {الطبق}»: the «+» button's name. */
  addLabel: string;
  onAdd: () => void;
  /** The dish's item sheet or page: the card is one link to it. */
  href: string;
  description?: string;
  /** The square photo; without one the card is a text row. */
  photo?: string;
  /** «من» before the lowest price. */
  fromLabel?: string;
  /** How many are in the cart; above zero it replaces «+». */
  count?: number;
  /** «يتوفر غداً»: the dish cannot be added nor opened, and fades. */
  unavailableLabel?: string;
}

interface BottomSheetProps {
  /** The element that opens it, usually a Button. Focus returns to it on close. */
  trigger?: ReactNode;
  open?: boolean;
  onOpenChange?: (open: boolean) => void;
  /** Shown, and the sheet's accessible name. */
  title: string;
  /** The plain top's ×. */
  closeLabel: string;
  children: ReactNode;
  /** The brand's S-curve tab holding the title: the customer's item sheet. No ×. */
  sCurve?: boolean;
  /** False keeps it open on Escape and the scrim. */
  dismissible?: boolean;
  /** Keeps the sheet in its frame instead of over the page, as on this card. */
  inline?: boolean;
}

interface PullToRefreshProps {
  /** The list; the component is its scroll container and fills its parent. */
  children: ReactNode;
  /** Runs once per pull on a touch screen; a Promise keeps the loader until it settles. */
  onRefresh: () => unknown;
  /** The refresh button for screen readers and keyboards: «تحديث». */
  refreshLabel: string;
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
  /** The accessible name of the group, the noun only (the Arabic word for quantity). The count is its description. */
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

// Data display (D.9)

/** Money is given in minor units as a string, as the API sends it: '41000' TRY is 410. */
interface MoneyProps {
  amount: string;
  /** The currency's symbol: the lira sign, '$', or the Syrian pound's Arabic abbreviation. */
  symbol: string;
  /** The currency's minor digits. Default 2. */
  decimals?: number;
  /** A plus on a gain. */
  signed?: boolean;
  size?: 'secondary' | 'body' | 'subtitle' | 'number' | 'compact';
  tone?: 'default' | 'success' | 'danger' | 'muted' | 'inverse';
  bold?: boolean;
}

type OrderStatus = 'placed' | 'accepted' | 'ready' | 'picked_up' | 'arrived' | 'delivered' | 'rejected' | 'cancelled' | 'failed';
type Tone = 'warning' | 'info' | 'success' | 'primary' | 'danger' | 'neutral';

/** Give either status (an order state) or tone with an optional icon. */
interface StatusChipProps {
  /** The words of the app. */
  label: string;
  status?: OrderStatus;
  tone?: Tone;
  icon?: IconName;
  density?: Density;
}

interface CountBadgeProps {
  /** Without it the badge is a dot; zero shows nothing. */
  count?: number;
  /** Default 99. */
  max?: number;
  /** The full count in words for screen readers. */
  label: string;
  tone?: 'danger' | 'primary' | 'accent';
  /** What the badge sits on the corner of; without it the badge is inline. */
  children?: ReactNode;
}

interface CardProps {
  children: ReactNode;
  /** 'offset' is the customer app's Figma shadow; 'outline' everywhere else. */
  elevation?: 'outline' | 'offset';
  /** 'danger' for a late order. */
  tone?: 'default' | 'danger';
  /** Makes the whole card one button. */
  onPress?: () => void;
  label?: string;
}

interface ListRowProps {
  title: string;
  description?: string;
  leading?: IconName;
  /** A value or a chip; a switch only on a row without onPress. A pressable row is described by it. */
  end?: ReactNode;
  /** Makes the row one button with a chevron. */
  onPress?: () => void;
  tone?: 'default' | 'danger';
  disabled?: boolean;
  density?: Density;
}

interface TimerProps {
  /** Seconds left (down) or gone by (up). */
  seconds: number;
  direction: 'down' | 'up';
  /** The minute unit shown from ten minutes on. */
  minuteUnit: string;
  late?: boolean;
  tone?: 'calm' | 'soon' | 'late';
  /** Words before the time. */
  prefix?: string;
  icon?: IconName;
  density?: Density;
}

interface Action {
  label: string;
  onPress: () => void;
}

interface OrderCardProps {
  /** The card's name for screen readers. */
  label: string;
  /** Without the hash sign. */
  number: string;
  since: string;
  items: string;
  captain: string;
  /** A Timer. */
  timer: ReactNode;
  badges?: ReactNode;
  /** The one main button; the portal shows none. */
  action?: Action;
  late?: boolean;
  lateLabel?: string;
  /** Opens the order detail: the number becomes its button. */
  onOpen?: () => void;
}

interface CountdownRingProps {
  /** Seconds left; the app ticks it. Red in the last ten. */
  seconds: number;
  /** The whole time, 45 seconds for a captain's offer. */
  total: number;
  /** The words after the number for screen readers. */
  label: string;
}

interface LogoProps {
  /** The restaurant's name; its first letter stands in for a missing image. */
  name: string;
  /** The logo's image. */
  src?: string;
}

interface OrderRowProps {
  restaurant: string;
  date: string;
  /** A StatusChip with the customer's wording. */
  status: ReactNode;
  /** A Money. */
  total: ReactNode;
  /** The restaurant's logo image; without it, its first letter. */
  logo?: string;
  /** The reorder action of a past order. */
  trailing?: ReactNode;
  /** Opens the order: the restaurant's name becomes its button. */
  onPress?: () => void;
}

interface TrackingStep {
  icon: IconName;
  label: string;
}

interface TrackingStepsProps {
  /** The list's name. */
  label: string;
  steps: TrackingStep[];
  /** The current step; the steps' count marks every step done. */
  current: number;
  /** Read after a done step's name. */
  doneLabel: string;
  /** Read after the current step's name. */
  nowLabel: string;
}

interface AmountLine {
  label: string;
  /** Minor units. */
  amount: string;
  /** Words instead of the amount, for a free fee. */
  text?: string;
  tone?: 'default' | 'success' | 'danger';
}

interface AmountsTotal {
  label: string;
  amount: string;
}

interface AmountsSummaryProps {
  lines: AmountLine[];
  total: AmountsTotal;
  symbol: string;
  decimals?: number;
  /** One equivalent per accepted currency, under the total. */
  equivalents?: string;
  /** 'prominent' is the customer cart's orange total bar. */
  variant?: 'plain' | 'prominent';
  density?: Density;
}

/** Lay out Skeleton.Block elements (shape: line, title, circle, square, media, pill) inside. */
interface SkeletonProps {
  /** Read once by screen readers. */
  label: string;
  children: ReactNode;
}

interface EmptyStateProps {
  icon: IconName;
  title: string;
  description?: string;
  action?: Action;
  tone?: 'default' | 'error';
  density?: Density;
}

interface Column {
  key: string;
  header: string;
  cell: (row: unknown) => ReactNode;
  numeric?: boolean;
  sortable?: boolean;
}

interface Sort {
  key: string;
  direction: 'ascending' | 'descending';
}

interface DataTableProps {
  label: string;
  columns: Column[];
  rows: unknown[];
  rowKey: (row: unknown) => string;
  sort?: Sort;
  onSortChange?: (sort: Sort) => void;
  selection?: Set<string>;
  onSelectionChange?: (selection: Set<string>) => void;
  /** The checkbox's name for a row. */
  rowLabel?: (row: unknown) => string;
  onRowOpen?: (row: unknown) => void;
  loading?: boolean;
  loadingLabel?: string;
  /** An EmptyState shown inside the table. */
  empty?: ReactNode;
}

type BannerTone = 'danger' | 'caution' | 'warning' | 'info' | 'neutral';

interface BannerAction {
  label: string;
  onAction: () => void;
  /** An icon before the words, when the action names a channel (a call, WhatsApp). */
  icon?: IconName;
}

interface BannerDismiss {
  /** The close control's name, read by screen readers: «إغلاق». */
  label: string;
  onDismiss: () => void;
}

interface BannerProps {
  tone: BannerTone;
  /** What happened, in words: the tone is never the only signal. */
  children: ReactNode;
  /** Another icon than the tone's, such as 'offline'. */
  icon?: IconName;
  action?: BannerAction;
  /** A second action; with two, both move to a line under the words. */
  secondaryAction?: BannerAction;
  /** A banner the user may put away for now, such as an update on offer. */
  dismiss?: BannerDismiss;
  density?: Density;
}

interface StackedBanner {
  id: string;
  tone: BannerTone;
  text: string;
  icon?: IconName;
  action?: BannerAction;
  secondaryAction?: BannerAction;
  dismiss?: BannerDismiss;
}

interface BannerStackProps {
  /** In the app's priority order, highest first. */
  banners: StackedBanner[];
  /** The counter's words for the hidden count. */
  moreLabel: (hidden: number) => string;
  lessLabel: string;
  density?: Density;
}

interface BlockingBannerProps {
  /** Shown until the sound plays; the app closes it then. */
  open: boolean;
  text: string;
  actionLabel: string;
  /** Runs inside the press, so the browser lets audio start. */
  onEnable: () => void;
}

interface DialogProps {
  /** The element that opens it, usually a Button. */
  trigger?: ReactNode;
  open?: boolean;
  onOpenChange?: (open: boolean) => void;
  title: string;
  description?: string;
  children?: ReactNode;
  confirmLabel: string;
  cancelLabel: string;
  closeLabel: string;
  /** 'danger' for a destructive action; the safe action takes focus first. */
  tone?: 'primary' | 'danger';
  /** A Promise keeps it open, pending, until it settles. */
  onConfirm?: () => unknown;
  density?: Density;
  /** Open, it stays in its frame with its scrim instead of over the page (the components canvas). */
  inline?: boolean;
}

interface ConfirmDialogProps {
  trigger?: ReactNode;
  open?: boolean;
  onOpenChange?: (open: boolean) => void;
  title: string;
  reasonLabel: string;
  reasonPlaceholder?: string;
  /** Shown after a try without a reason. */
  reasonError: string;
  /** The money-effect preview (an AmountsSummary). */
  effect?: ReactNode;
  effectTitle?: string;
  notifyTitle: string;
  notified: string[];
  confirmLabel: string;
  cancelLabel: string;
  closeLabel: string;
  /** Receives the reason, trimmed. */
  onConfirm: (reason: string) => unknown;
}

interface DrawerProps {
  trigger?: ReactNode;
  open?: boolean;
  onOpenChange?: (open: boolean) => void;
  title: string;
  closeLabel: string;
  /** 'end' (left in RTL) for a quick view; 'start' for the sidebar on a phone. */
  side?: 'start' | 'end';
  headerAction?: ReactNode;
  children: ReactNode;
}

type ToastTone = 'success' | 'info' | 'warning' | 'danger';

interface ToastOptions {
  tone: ToastTone;
  text: string;
  action?: BannerAction;
}

/** Wrap the app once; show a toast with FoxDrop.useToast().show(options). */
interface ToasterProps {
  label: string;
  closeLabel: string;
  /** How many show at once. Default 3. */
  max?: number;
  children: ReactNode;
}

interface MenuAction {
  label: string;
  icon?: IconName;
  destructive?: boolean;
  disabled?: boolean;
  onSelect: () => void;
}

interface MenuProps {
  triggerLabel: string;
  triggerStart?: ReactNode;
  /** An icon-only trigger; triggerLabel is its name. */
  triggerIcon?: IconName;
  /** Actions and 'separator'. */
  items: (MenuAction | 'separator')[];
  density?: Density;
}

interface TooltipProps {
  content: string;
  /** A button or a link with a name of its own. */
  children: ReactNode;
  side?: 'top' | 'bottom' | 'start' | 'end';
}

interface TabItem {
  value: string;
  label: string;
  count?: number;
  countLabel?: string;
  disabled?: boolean;
  content: ReactNode;
}

interface TabsProps {
  label: string;
  items: TabItem[];
  value?: string;
  defaultValue?: string;
  onValueChange?: (value: string) => void;
  variant?: 'underline' | 'pill';
  density?: Density;
}

interface TopBarAction {
  icon: IconName;
  label: string;
  count?: number;
  countLabel?: string;
  onAction: () => void;
}

interface TopBarMenu {
  label: string;
  onMenu: () => void;
}

interface TopBarProps {
  label: string;
  title?: string;
  /** The button that opens the sidebar drawer on a phone. */
  menu?: TopBarMenu;
  start?: ReactNode;
  children?: ReactNode;
  actions?: TopBarAction[];
  end?: ReactNode;
}

interface SidebarItem {
  href: string;
  label: string;
  /** Without one the item shows a dot. */
  icon?: IconName;
  count?: number;
  countLabel?: string;
}

interface SidebarProps {
  label: string;
  items: SidebarItem[];
  /** The current page's href. */
  current: string;
  brand?: ReactNode;
  collapsed?: boolean;
  onCollapsedChange?: (collapsed: boolean) => void;
  collapseLabel: string;
  expandLabel: string;
  /** 'rail' beside the page, 'drawer' below the tablet width. */
  form?: 'rail' | 'drawer';
  open?: boolean;
  onOpenChange?: (open: boolean) => void;
  closeLabel?: string;
}

interface RestaurantBarProps {
  name: string;
  /** The status pill: a StatusChip, or a button that opens the status sheet. */
  status: ReactNode;
  connected: boolean;
  /** «متصل» or «غير متصل», shown beside the dot. */
  connectionLabel: string;
  supportLabel: string;
  onSupport?: () => void;
}

interface BottomNavigationItem {
  icon: IconName;
  /** Read by screen readers: the bar shows icons only. */
  label: string;
  count?: number;
  /** A dot instead of a count. */
  dot?: boolean;
  /** The badge in words, read with the name; needed with count or dot. */
  countLabel?: string;
}

interface BottomNavigationProps {
  label: string;
  items: BottomNavigationItem[];
  selected: number;
  onSelect: (index: number) => void;
}

interface SignInPerk {
  icon: IconName;
  label: string;
}

type SignInOrigin =
  | {
      kind: 'checkout';
      restaurant: string;
      details: string;
      /** Minor units. */
      amount: string;
      symbol: string;
      decimals?: number;
      savedLabel: string;
    }
  | { kind: 'orders'; title: string; statusLabel: string; steps: ReactNode }
  | { kind: 'account'; perks: SignInPerk[] };

interface SignInHeroProps {
  origin: SignInOrigin;
  title: string;
  lead?: string;
  /** The keyboard is up: the title alone. */
  keyboard?: boolean;
}

/** BlockingHeads.VersionTicket: the forced update's head. */
interface VersionTicketProps {
  installedLabel: string;
  installed: string;
  requiredLabel: string;
  required: string;
  /** Read once, for the whole ticket. */
  label: string;
}

/** BlockingHeads.ShopSign: the maintenance head. */
interface ShopSignProps {
  title: string;
  subtitle: string;
  /** «نعود الساعة 3:00 م», when the panel gave one. */
  returnTime?: string;
  /** Read once, for the whole sign. */
  label: string;
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
