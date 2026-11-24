import { readFileSync } from 'node:fs';
import path from 'node:path';
import { beforeAll, describe, expect, it } from 'vitest';
import { buildBundle, checkJs, COMPONENTS, ICON_NAMES, PACKAGE_DIR } from '../scripts/bundle.ts';
import { preview, typesDoc } from '../scripts/docs.ts';
import type { AmountsSummaryProps } from '../src/amounts-summary/amounts-summary';
import type { ButtonProps } from '../src/button/button';
import type { CardProps } from '../src/card/card';
import type { CountBadgeProps } from '../src/count-badge/count-badge';
import type { DataTableProps } from '../src/data-table/data-table';
import type { EmptyStateProps } from '../src/empty-state/empty-state';
import type { ListRowProps } from '../src/list-row/list-row';
import type { MoneyProps } from '../src/money/money';
import type { OrderCardProps } from '../src/order-card/order-card';
import type { SkeletonProps } from '../src/skeleton/skeleton';
import type { StatusChipProps } from '../src/status-chip/status-chip';
import type { TimerProps } from '../src/timer/timer';
import type { CheckboxProps } from '../src/checkbox/checkbox';
import type { CodeFieldProps } from '../src/code-field/code-field';
import type { FieldProps } from '../src/field/field';
import type { IconProps } from '../src/icon/icon';
import type { PhoneFieldProps } from '../src/phone-field/phone-field';
import type { QuantityStepperProps } from '../src/quantity-stepper/quantity-stepper';
import type { RadioGroupProps } from '../src/radio-group/radio-group';
import type { SearchFieldProps } from '../src/search-field/search-field';
import type { SelectProps } from '../src/select/select';
import type { SwitchProps } from '../src/switch/switch';
import type { TextAreaProps } from '../src/text-area/text-area';
import type { TextFieldProps } from '../src/text-field/text-field';
import type { BannerProps } from '../src/banner/banner';
import type { BannerStackProps } from '../src/banner-stack/banner-stack';
import type { BlockingBannerProps } from '../src/blocking-banner/blocking-banner';
import type { DialogProps } from '../src/dialog/dialog';
import type { ConfirmDialogProps } from '../src/confirm-dialog/confirm-dialog';
import type { DrawerProps } from '../src/drawer/drawer';
import type { ToasterProps } from '../src/toaster/toaster';
import type { MenuProps } from '../src/menu/menu';
import type { TooltipProps } from '../src/tooltip/tooltip';
import type { TabsProps } from '../src/tabs/tabs';
import type { TopBarProps } from '../src/top-bar/top-bar';
import type { SidebarProps } from '../src/sidebar/sidebar';

describe('the Design System bundle', () => {
  let bundle: { js: string; css: string };
  beforeAll(async () => {
    bundle = await buildBundle();
  }, 60_000);

  it('is a classic script that names the components and hides nothing risky', () => {
    expect(bundle.js.split('\n')[0]).toMatch(/^\/\* @ds-bundle: .*"Button".*"Icon".* \*\/$/);
    expect(bundle.js.toLowerCase()).not.toContain('</script');
    expect(bundle.js).not.toContain('<!--');
    expect(bundle.js).not.toMatch(/^\s*(import|export)\s/m);
  });

  it('defines window.FoxDrop with the components and React', () => {
    delete (window as unknown as Record<string, unknown>)['React'];
    window.eval(bundle.js);
    const api = (window as unknown as { FoxDrop: Record<string, unknown> }).FoxDrop;
    expect(Object.keys(api)).toEqual(expect.arrayContaining([...COMPONENTS, 'React', 'ReactDOM']));
    for (const name of COMPONENTS) expect(typeof api[name], name).toBe('function');
    expect((window as unknown as { React: unknown }).React).toBe(api['React']);
  });

  it('carries the --fd-* variables and the component classes, with no font and no style end', () => {
    expect(bundle.css).toContain('--fd-button-primary-background');
    expect(bundle.css).toContain('min-h-');
    // the form components: the classes of src/field/styles.ts and the input tokens
    expect(bundle.css).toContain('--fd-input-color-border-focus');
    expect(bundle.css).toContain('inset-ring');
    expect(bundle.css.toLowerCase()).not.toContain('</style');
    expect(bundle.css).not.toContain('@font-face');
    expect(bundle.css).not.toContain('.fonts');
  });
});

describe('the escape of the bundle', () => {
  it('escapes a script end and a comment start', () => {
    expect(checkJs('a="</script>"+"<!--"')).toBe('a="<\\/script>"+"<\\!--"');
  });
});

describe('the component docs', () => {
  it('declares the props types with every icon name inline', () => {
    const types = typesDoc();
    expect(types).toContain('interface IconProps');
    expect(types).toContain('type ButtonProps');
    expect(types).not.toMatch(/^import /m);
    for (const name of ICON_NAMES) expect(types).toContain(`'${name}'`);
  });

  // The doc's types are written by hand: these lists are checked against the
  // real prop types at compile time (`satisfies` fails on a missing or extra
  // key) and against the generated text at run time, so they cannot drift.
  type Keys<T> = T extends unknown ? keyof T : never;
  const buttonProps = {
    variant: true,
    density: true,
    loading: true,
    disabled: true,
    type: true,
    onClick: true,
    children: true,
    icon: true,
    iconEnd: true,
    label: true,
  } satisfies Record<Keys<ButtonProps>, true>;
  const iconProps = { name: true, label: true, size: true } satisfies Record<Keys<IconProps>, true>;
  const fieldProps = {
    label: true,
    optionalLabel: true,
    hint: true,
    error: true,
    aside: true,
    disabled: true,
    name: true,
    density: true,
    children: true,
  } satisfies Record<Keys<FieldProps>, true>;
  const textFieldProps = {
    label: true,
    optionalLabel: true,
    hint: true,
    error: true,
    placeholder: true,
    value: true,
    defaultValue: true,
    onValueChange: true,
    name: true,
    type: true,
    inputMode: true,
    autoComplete: true,
    maxLength: true,
    required: true,
    disabled: true,
    density: true,
  } satisfies Record<Keys<TextFieldProps>, true>;
  const textAreaProps = {
    label: true,
    optionalLabel: true,
    hint: true,
    error: true,
    placeholder: true,
    value: true,
    defaultValue: true,
    onValueChange: true,
    name: true,
    maxLength: true,
    required: true,
    disabled: true,
  } satisfies Record<Keys<TextAreaProps>, true>;
  const searchFieldProps = {
    label: true,
    clearLabel: true,
    placeholder: true,
    value: true,
    defaultValue: true,
    onValueChange: true,
    name: true,
    loading: true,
    disabled: true,
    density: true,
  } satisfies Record<Keys<SearchFieldProps>, true>;
  const phoneFieldProps = {
    label: true,
    optionalLabel: true,
    hint: true,
    error: true,
    countryLabels: true,
    countryLabel: true,
    placeholder: true,
    value: true,
    defaultValue: true,
    onValueChange: true,
    country: true,
    defaultCountry: true,
    onCountryChange: true,
    name: true,
    required: true,
    disabled: true,
    density: true,
  } satisfies Record<Keys<PhoneFieldProps>, true>;
  const codeFieldProps = {
    label: true,
    hint: true,
    error: true,
    value: true,
    defaultValue: true,
    onValueChange: true,
    onComplete: true,
    done: true,
    name: true,
    autoFocus: true,
    disabled: true,
  } satisfies Record<Keys<CodeFieldProps>, true>;
  const selectProps = {
    label: true,
    optionalLabel: true,
    hint: true,
    error: true,
    placeholder: true,
    items: true,
    value: true,
    defaultValue: true,
    onValueChange: true,
    name: true,
    required: true,
    disabled: true,
    density: true,
  } satisfies Record<Keys<SelectProps>, true>;
  const checkboxProps = {
    label: true,
    checked: true,
    defaultChecked: true,
    onCheckedChange: true,
    name: true,
    value: true,
    required: true,
    disabled: true,
    invalid: true,
  } satisfies Record<Keys<CheckboxProps>, true>;
  const radioGroupProps = {
    label: true,
    optionalLabel: true,
    hint: true,
    error: true,
    options: true,
    value: true,
    defaultValue: true,
    onValueChange: true,
    name: true,
    required: true,
    disabled: true,
  } satisfies Record<Keys<RadioGroupProps>, true>;
  const switchProps = {
    label: true,
    checked: true,
    defaultChecked: true,
    onCheckedChange: true,
    name: true,
    disabled: true,
  } satisfies Record<Keys<SwitchProps>, true>;
  const stepperProps = {
    label: true,
    increaseLabel: true,
    decreaseLabel: true,
    removeLabel: true,
    value: true,
    defaultValue: true,
    onValueChange: true,
    onRemove: true,
    min: true,
    max: true,
    disabled: true,
  } satisfies Record<Keys<QuantityStepperProps>, true>;

  /** The property names declared in the doc's interfaces of that name, sorted. */
  const documented = (types: string, interfaces: string[]) =>
    [
      ...new Set(
        interfaces.flatMap((name) => {
          const body = new RegExp(`interface ${name}\\b[^{]*\\{([^}]*)\\}`).exec(types)?.[1] ?? '';
          return [...body.matchAll(/^ {2}(\w+)\??:/gm)].map((match) => match[1]!);
        }),
      ),
    ].sort();

  it('documents exactly the props of the real components', () => {
    const types = typesDoc();
    expect(documented(types, ['ButtonBase', 'TextButtonProps', 'IconOnlyButtonProps'])).toEqual(
      Object.keys(buttonProps).sort(),
    );
    expect(documented(types, ['IconProps'])).toEqual(Object.keys(iconProps).sort());
    const forms = {
      FieldProps: fieldProps,
      TextFieldProps: textFieldProps,
      TextAreaProps: textAreaProps,
      SearchFieldProps: searchFieldProps,
      PhoneFieldProps: phoneFieldProps,
      CodeFieldProps: codeFieldProps,
      SelectProps: selectProps,
      CheckboxProps: checkboxProps,
      RadioGroupProps: radioGroupProps,
      SwitchProps: switchProps,
      QuantityStepperProps: stepperProps,
    };
    for (const [name, props] of Object.entries(forms)) {
      expect(documented(types, [name]), name).toEqual(Object.keys(props).sort());
    }
  });

  // Data display (D.9).
  const data = {
    MoneyProps: {
      amount: true,
      symbol: true,
      decimals: true,
      signed: true,
      size: true,
      tone: true,
      bold: true,
    } satisfies Record<Keys<MoneyProps>, true>,
    StatusChipProps: {
      label: true,
      status: true,
      tone: true,
      icon: true,
      density: true,
    } satisfies Record<Keys<StatusChipProps>, true>,
    CountBadgeProps: {
      count: true,
      max: true,
      label: true,
      tone: true,
      children: true,
    } satisfies Record<Keys<CountBadgeProps>, true>,
    CardProps: {
      children: true,
      elevation: true,
      tone: true,
      onPress: true,
      label: true,
    } satisfies Record<Keys<CardProps>, true>,
    ListRowProps: {
      title: true,
      description: true,
      leading: true,
      end: true,
      onPress: true,
      tone: true,
      disabled: true,
      density: true,
    } satisfies Record<Keys<ListRowProps>, true>,
    TimerProps: {
      seconds: true,
      direction: true,
      minuteUnit: true,
      late: true,
      tone: true,
      prefix: true,
      icon: true,
      density: true,
    } satisfies Record<Keys<TimerProps>, true>,
    OrderCardProps: {
      label: true,
      number: true,
      since: true,
      items: true,
      captain: true,
      timer: true,
      badges: true,
      action: true,
      late: true,
      lateLabel: true,
      onOpen: true,
    } satisfies Record<Keys<OrderCardProps>, true>,
    AmountsSummaryProps: {
      lines: true,
      total: true,
      symbol: true,
      decimals: true,
      equivalents: true,
      variant: true,
      density: true,
    } satisfies Record<Keys<AmountsSummaryProps>, true>,
    SkeletonProps: { label: true, children: true } satisfies Record<Keys<SkeletonProps>, true>,
    EmptyStateProps: {
      icon: true,
      title: true,
      description: true,
      action: true,
      tone: true,
      density: true,
    } satisfies Record<Keys<EmptyStateProps>, true>,
    DataTableProps: {
      label: true,
      columns: true,
      rows: true,
      rowKey: true,
      sort: true,
      onSortChange: true,
      selection: true,
      onSelectionChange: true,
      rowLabel: true,
      onRowOpen: true,
      loading: true,
      loadingLabel: true,
      empty: true,
    } satisfies Record<Keys<DataTableProps<unknown>>, true>,
  };

  it('documents exactly the props of the data display components', () => {
    const types = typesDoc();
    for (const [name, props] of Object.entries(data))
      expect(documented(types, [name]), name).toEqual(Object.keys(props).sort());
  });

  // D.10: overlays and navigation.
  const overlays = {
    BannerProps: {
      tone: true,
      children: true,
      icon: true,
      action: true,
      density: true,
    } satisfies Record<Keys<BannerProps>, true>,
    BannerStackProps: {
      banners: true,
      moreLabel: true,
      lessLabel: true,
      density: true,
    } satisfies Record<Keys<BannerStackProps>, true>,
    BlockingBannerProps: {
      open: true,
      text: true,
      actionLabel: true,
      onEnable: true,
    } satisfies Record<Keys<BlockingBannerProps>, true>,
    DialogProps: {
      trigger: true,
      open: true,
      onOpenChange: true,
      title: true,
      description: true,
      children: true,
      confirmLabel: true,
      cancelLabel: true,
      closeLabel: true,
      tone: true,
      onConfirm: true,
      density: true,
    } satisfies Record<Keys<DialogProps>, true>,
    ConfirmDialogProps: {
      trigger: true,
      open: true,
      onOpenChange: true,
      title: true,
      reasonLabel: true,
      reasonPlaceholder: true,
      reasonError: true,
      effect: true,
      effectTitle: true,
      notifyTitle: true,
      notified: true,
      confirmLabel: true,
      cancelLabel: true,
      closeLabel: true,
      onConfirm: true,
    } satisfies Record<Keys<ConfirmDialogProps>, true>,
    DrawerProps: {
      trigger: true,
      open: true,
      onOpenChange: true,
      title: true,
      closeLabel: true,
      side: true,
      headerAction: true,
      children: true,
    } satisfies Record<Keys<DrawerProps>, true>,
    ToasterProps: {
      label: true,
      closeLabel: true,
      max: true,
      children: true,
    } satisfies Record<Keys<ToasterProps>, true>,
    MenuProps: {
      triggerLabel: true,
      triggerStart: true,
      triggerIcon: true,
      items: true,
      density: true,
    } satisfies Record<Keys<MenuProps>, true>,
    TooltipProps: {
      content: true,
      children: true,
      side: true,
    } satisfies Record<Keys<TooltipProps>, true>,
    TabsProps: {
      label: true,
      items: true,
      value: true,
      defaultValue: true,
      onValueChange: true,
      variant: true,
      density: true,
    } satisfies Record<Keys<TabsProps>, true>,
    TopBarProps: {
      label: true,
      title: true,
      menu: true,
      start: true,
      children: true,
      actions: true,
      end: true,
    } satisfies Record<Keys<TopBarProps>, true>,
    SidebarProps: {
      label: true,
      items: true,
      current: true,
      brand: true,
      collapsed: true,
      onCollapsedChange: true,
      collapseLabel: true,
      expandLabel: true,
      form: true,
      open: true,
      onOpenChange: true,
      closeLabel: true,
    } satisfies Record<Keys<SidebarProps>, true>,
  };

  it('documents exactly the props of the overlays and navigation', () => {
    const types = typesDoc();
    for (const [name, props] of Object.entries(overlays))
      expect(documented(types, [name]), name).toEqual(Object.keys(props).sort());
  });

  it.each(COMPONENTS)('gives %s a card first line and a summary', (name) => {
    const html = preview(name);
    expect(html.split('\n')[0]).toMatch(/^<!-- @dsCard group="\w+" height=\d+ -->$/);
    expect(html).toContain('dir="rtl" lang="ar"');
    expect(html).not.toContain('<iframe');
    expect(html).not.toContain('__ICON_NAMES__');
    const readme = readFileSync(path.join(PACKAGE_DIR, 'design-system', name, 'README.md'), 'utf8');
    expect(readme.split('\n')[2]).toMatch(/\.$/);
  });
});
