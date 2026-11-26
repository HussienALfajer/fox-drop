import {
  Combobox,
  ComboboxContent,
  ComboboxEmpty,
  ComboboxGroup,
  ComboboxGroupLabel,
  ComboboxInput,
  ComboboxItem,
  ComboboxList,
  ComboboxTrigger,
} from '@ui-sdk/react/combobox';
import {
  createContext,
  useContext,
  useState,
  type ComponentProps,
  type ReactNode,
  type Ref,
} from 'react';
import { formTv, inputClass } from '../field/styles';
import { Icon } from '../icon/icon';
import type { CountryName } from '../phone-field/countries.generated';
import { countrySections } from '../phone-field/country-list';
import { SIDE_OFFSET } from '../select/menu';

/** The states the stories show (R3), as the Flutter twin's. */
export const STATES = ['default', 'lastUsed', 'search', 'empty'] as const;

// The list: the select's listbox (`select/menu.tsx`) with a search field on
// top and named sections (D.11 item 7).
const listTv = formTv({
  slots: {
    content: [
      'z-10 w-(--fd-country-sheet-width) max-w-(--available-width) max-h-(--available-height) overflow-y-auto p-2xs outline-hidden',
      'rounded-(--fd-input-area-radius) bg-(--fd-input-color-background) text-(color:--fd-input-color-text)',
      'shadow-(--fd-elevation-medium)',
    ],
    search: [
      'flex min-h-(--fd-input-compact-height) items-center gap-(--fd-input-gap) rounded-full px-sm',
      'inset-ring-1 inset-ring-(--fd-input-color-border) focus-within:inset-ring-2 focus-within:inset-ring-(--fd-input-color-border-focus)',
    ],
    group: 'flex flex-col pt-(--fd-country-sheet-section-gap)',
    label: 'px-sm pb-2xs text-phone-caption font-medium text-(color:--fd-input-color-hint)',
    item: [
      'flex min-h-(--fd-country-sheet-row-height) cursor-pointer items-center justify-between gap-(--fd-input-gap)',
      'rounded-md px-sm text-phone-body outline-hidden',
      'data-highlighted:bg-surface-hover active:bg-surface-pressed data-selected:font-medium',
    ],
    code: 'text-(color:--fd-country-sheet-color-code) tabular-nums',
    empty: [
      'px-sm py-(--fd-country-sheet-empty-padding-block) text-center text-phone-secondary',
      'text-(color:--fd-country-sheet-color-empty)',
    ],
  },
});
const list = listTv();

const Anchor = createContext<((button: HTMLButtonElement | null) => void) | null>(null);

export interface CountrySheetProps {
  /** The picked country (ISO). */
  value: string;
  onValueChange: (country: string) => void;
  /** The last country used, listed after Syria and Turkey (the app stores it). */
  lastUsed?: string;
  /** The search field: «ابحث باسم الدولة أو رمزها». */
  searchLabel: string;
  /** The sections: «الأكثر استعمالاً», «آخر ما استعملته», «كل الدول». */
  pinnedLabel: string;
  lastUsedLabel: string;
  allLabel: string;
  /** Nothing matched: «لا دولة بهذا الاسم أو الرمز». */
  emptyLabel: string;
  disabled?: boolean;
  /** The search already typed, for the stories. */
  defaultQuery?: string;
  /** The button that opens the list: a `CountrySheetTrigger`. */
  children: ReactNode;
}

/** The button that opens the list; the list opens beside it. */
export function CountrySheetTrigger({
  ref,
  ...props
}: ComponentProps<typeof ComboboxTrigger> & { ref?: Ref<HTMLButtonElement> }) {
  const anchor = useContext(Anchor);
  return (
    <ComboboxTrigger
      {...props}
      ref={(button: HTMLButtonElement | null) => {
        anchor?.(button);
        if (typeof ref === 'function') ref(button);
        else if (ref) ref.current = button;
      }}
    />
  );
}

/**
 * The country list of the phone field (D.11 item 7), on the UI SDK's
 * Combobox: a search field (Arabic name, English name or calling code), then
 * «الأكثر استعمالاً» (Syria and Turkey), «آخر ما استعملته» and «كل الدول» in
 * Arabic order, each a named group of rows 48 high; every row a name and its
 * calling code isolated left to right, no flags. Focus returns to the
 * trigger when it closes. On the web it opens beside its trigger; the
 * Flutter twin is a bottom sheet.
 */
export function CountrySheet(props: CountrySheetProps) {
  const { value, onValueChange, lastUsed, disabled, children } = props;
  const [query, setQuery] = useState(props.defaultQuery ?? '');
  const [button, setButton] = useState<HTMLButtonElement | null>(null);
  const sections = countrySections(query, lastUsed);
  const option = (entry: CountryName) => {
    const dial = ['+', entry.code].join('');
    return (
      <ComboboxItem
        key={entry.iso}
        value={entry.iso}
        label={entry.ar}
        data-value={entry.iso}
        className={list.item()}
      >
        <span>{entry.ar}</span>
        <bdi dir="ltr" className={list.code()}>
          {dial}
        </bdi>
      </ComboboxItem>
    );
  };
  const group = (title: string, entries: CountryName[]) =>
    entries.length > 0 && (
      <ComboboxGroup className={list.group()}>
        <ComboboxGroupLabel className={list.label()}>{title}</ComboboxGroupLabel>
        {entries.map(option)}
      </ComboboxGroup>
    );
  return (
    <Anchor.Provider value={setButton}>
      <Combobox
        value={value}
        filter={false}
        query={query}
        onQueryChange={setQuery}
        {...(disabled && { disabled: true })}
        onOpenChange={(open: boolean) => open && props.defaultQuery === undefined && setQuery('')}
        onOpenChangeComplete={(open: boolean) => !open && button?.focus()}
        onValueChange={(next: string | null) => {
          if (next && next !== value) onValueChange(next);
        }}
      >
        {children}
        <ComboboxContent
          anchor={button}
          sideOffset={SIDE_OFFSET}
          align="start"
          dir="rtl"
          className={list.content()}
        >
          <div className={list.search()}>
            <Icon name="search" size="sm" />
            <ComboboxInput
              autoFocus
              aria-label={props.searchLabel}
              placeholder={props.searchLabel}
              className={inputClass()}
            />
          </div>
          <ComboboxEmpty className={list.empty()}>{props.emptyLabel}</ComboboxEmpty>
          <ComboboxList>
            {group(props.pinnedLabel, sections.pinned)}
            {group(props.lastUsedLabel, sections.lastUsed)}
            {group(props.allLabel, sections.all)}
          </ComboboxList>
        </ComboboxContent>
      </Combobox>
    </Anchor.Provider>
  );
}

CountrySheet.Trigger = CountrySheetTrigger;
