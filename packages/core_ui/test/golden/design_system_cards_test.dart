@Tags(['golden'])
library;

import 'package:core_ui/core_ui.dart';
import 'package:core_ui/testing.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'sheet.dart';

// One image per core_ui component for the Design System (owner, 2026-11-24:
// every component, the Flutter ones too, in the system). Each card is 720
// wide on the app ground, RTL, the phone theme, and the captain theme where
// that app draws the component differently. `packages/core_ui/design-system/
// cards.json` names, groups and describes each image.

/// The card's width, less the sheet's padding on both sides.
const _width = 720.0 - FoxSpace.lg * 2;
const _lira = '₺';

/// A small English caption above an example.
class _Caption extends StatelessWidget {
  const _Caption(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    // English captions read left to right, at the start of the RTL card.
    return Align(
      alignment: AlignmentDirectional.centerStart,
      widthFactor: 1,
      child: Text(
        text,
        textDirection: TextDirection.ltr,
        style: theme.text.caption.copyWith(color: theme.colors.onSurfaceMuted),
      ),
    );
  }
}

/// [child] with its caption above it.
Widget _example(String caption, Widget child) => Column(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    _Caption(caption),
    const SizedBox(height: FoxSpace.xs),
    child,
  ],
);

/// Examples side by side, wrapping onto new rows.
Widget _row(List<Widget> examples) => Wrap(
  spacing: FoxSpace.lg,
  runSpacing: FoxSpace.lg,
  crossAxisAlignment: WrapCrossAlignment.start,
  children: examples,
);

/// A fixed-width example column, for components that stretch.
Widget _box(double width, Widget child) => SizedBox(width: width, child: child);

/// The card body: [phone] examples, then the captain's when given.
Widget _card(List<Widget> phone, {List<Widget>? captain}) => SizedBox(
  width: _width,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _row(phone),
      if (captain != null) ...[
        const SizedBox(height: FoxSpace.xl),
        _CaptainSection(children: captain),
      ],
    ],
  ),
);

/// The captain's examples in the captain theme, under their own caption.
class _CaptainSection extends StatelessWidget {
  const _CaptainSection({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final captain = FoxThemeData.captain();
    return FoxTheme(
      data: captain,
      child: DefaultTextStyle(
        style: captain.text.body.copyWith(color: captain.colors.onSurface),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _Caption('Captain app'),
            const SizedBox(height: FoxSpace.sm),
            _row(children),
          ],
        ),
      ),
    );
  }
}

/// A fixed area with an Overlay, so a menu or a select can open on it.
Widget _onOverlay(double height, Widget child) => SizedBox(
  width: _width,
  height: height,
  child: Overlay(initialEntries: [OverlayEntry(builder: (_) => child)]),
);

// ---------- the cards ----------

Widget _buttons() {
  List<Widget> examples() => [
    for (final variant in FoxButtonVariant.values)
      _example(
        variant.name,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FoxButton(label: 'اطلب الآن', variant: variant, onPressed: () {}),
            gap,
            FoxButton(
              label: 'التالي',
              iconEnd: FoxIcons.back,
              variant: variant,
              onPressed: () {},
            ),
            gap,
            FoxButton.icon(
              icon: FoxIcons.add,
              label: 'إضافة',
              variant: variant,
              onPressed: () {},
            ),
          ],
        ),
      ),
    _example(
      'disabled · loading',
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const FoxButton(label: 'اطلب الآن', onPressed: null),
          gap,
          FoxButton(label: 'اطلب الآن', loading: true, onPressed: () {}),
        ],
      ),
    ),
  ];
  return _card(examples(), captain: examples());
}

Widget _icons() => _card([
  _example(
    'every icon, md',
    SizedBox(
      width: _width,
      child: Wrap(
        spacing: FoxSpace.sm,
        runSpacing: FoxSpace.md,
        children: [
          for (final MapEntry(:key, :value) in FoxIcons.all.entries)
            SizedBox(
              width: (_width - FoxSpace.sm * 5) / 6,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FoxIcon(value),
                  const SizedBox(height: FoxSpace.xxs),
                  _Caption(key),
                ],
              ),
            ),
        ],
      ),
    ),
  ),
  _example(
    'sm · md · lg · filled',
    const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FoxIcon(FoxIcons.home, size: FoxIconSize.sm),
        gap,
        FoxIcon(FoxIcons.home),
        gap,
        FoxIcon(FoxIcons.home, size: FoxIconSize.lg),
        gap,
        FoxIcon(FoxIcons.heart, size: FoxIconSize.lg, style: FoxIconStyle.bold),
      ],
    ),
  ),
]);

const _field = 320.0;

Widget _field_() => _card([
  _example(
    'label, hint',
    _box(
      _field,
      const FoxField(
        label: 'ملاحظة',
        hint: 'تظهر للمطعم',
        child: FoxTextField(placeholder: 'اكتب ملاحظتك'),
      ),
    ),
  ),
  _example(
    'optional marker, error',
    _box(
      _field,
      const FoxField(
        label: 'ملاحظة',
        marker: '(اختياري)',
        error: 'الملاحظة طويلة',
        child: FoxTextField(placeholder: 'اكتب ملاحظتك'),
      ),
    ),
  ),
]);

Widget _textField(TextEditingController filled, TextEditingController wrong) =>
    _card([
      _example(
        'default',
        _box(
          _field,
          const FoxTextField(
            label: 'الاسم الكامل',
            hint: 'كما يظهر للمطعم والكابتن',
            placeholder: 'اكتب اسمك',
          ),
        ),
      ),
      _example(
        'filled, icon',
        _box(
          _field,
          FoxTextField(
            controller: filled,
            label: 'الاسم الكامل',
            marker: '(اختياري)',
            startIcon: FoxIcons.search,
          ),
        ),
      ),
      _example(
        'error',
        _box(
          _field,
          FoxTextField(
            controller: wrong,
            label: 'الاسم الكامل',
            error: 'الاسم قصير جدًا',
          ),
        ),
      ),
      _example(
        'disabled',
        _box(
          _field,
          const FoxTextField(
            label: 'الاسم الكامل',
            placeholder: 'اكتب اسمك',
            enabled: false,
          ),
        ),
      ),
    ]);

Widget _textArea(TextEditingController notes) => _card([
  _example(
    'empty',
    _box(
      _field,
      const FoxTextArea(label: 'ملاحظات الطلب', placeholder: 'مثلاً: بدون بصل'),
    ),
  ),
  _example(
    'filled, counter',
    _box(
      _field,
      FoxTextArea(
        controller: notes,
        label: 'ملاحظات الطلب',
        marker: '(اختياري)',
        maxLength: 200,
      ),
    ),
  ),
  _example(
    'error',
    _box(
      _field,
      const FoxTextArea(
        label: 'ملاحظات الطلب',
        error: 'الملاحظة أقصر من اللازم',
      ),
    ),
  ),
]);

Widget _search(TextEditingController query) => _card([
  _example(
    'empty',
    _box(
      _field,
      const FoxSearchField(
        placeholder: 'ابحث عن طبق أو مطعم',
        clearLabel: 'مسح',
      ),
    ),
  ),
  _example(
    'filled',
    _box(
      _field,
      FoxSearchField(
        controller: query,
        placeholder: 'ابحث عن طبق أو مطعم',
        clearLabel: 'مسح',
      ),
    ),
  ),
  _example(
    'loading',
    _box(
      _field,
      FoxSearchField(
        controller: query,
        placeholder: 'ابحث عن طبق أو مطعم',
        clearLabel: 'مسح',
        loading: true,
        loadingLabel: 'جارٍ البحث',
      ),
    ),
  ),
]);

const _names = {
  FoxPhoneCountry.syria: 'سوريا',
  FoxPhoneCountry.turkey: 'تركيا',
};

Widget _phone(TextEditingController syria, TextEditingController turkey) =>
    _card([
      _example(
        'Syria, hint',
        _box(
          _field,
          FoxPhoneField(
            controller: syria,
            country: FoxPhoneCountry.syria,
            onChanged: (_) {},
            onCountryChanged: (_) {},
            countryNames: _names,
            countryLabel: 'رمز الدولة',
            label: 'رقم الهاتف',
            hint: 'سنرسل لك رمز التحقق',
          ),
        ),
      ),
      _example(
        'Turkey, error',
        _box(
          _field,
          FoxPhoneField(
            controller: turkey,
            country: FoxPhoneCountry.turkey,
            onChanged: (_) {},
            onCountryChanged: (_) {},
            countryNames: _names,
            countryLabel: 'رمز الدولة',
            label: 'رقم الهاتف',
            error: 'رقم غير صحيح',
          ),
        ),
      ),
    ]);

Widget _code(List<TextEditingController> codes) => _card([
  _example(
    'typing',
    FoxCodeField(
      controller: codes[0],
      label: 'رمز التحقق',
      onCompleted: (_) {},
    ),
  ),
  _example(
    'error',
    FoxCodeField(
      controller: codes[1],
      label: 'رمز التحقق',
      error: 'الرمز غير صحيح',
      onCompleted: (_) {},
    ),
  ),
  _example(
    'done',
    FoxCodeField(
      controller: codes[2],
      done: true,
      label: 'رمز التحقق',
      onCompleted: (_) {},
    ),
  ),
]);

const _districts = [
  FoxSelectOption(value: 1, label: 'الكفين'),
  FoxSelectOption(value: 2, label: 'المركز'),
  FoxSelectOption(value: 3, label: 'الجامعة'),
];

Widget _select() => _onOverlay(
  300,
  Align(
    alignment: AlignmentDirectional.topStart,
    child: _row([
      _example(
        'open, a choice ticked',
        _box(
          _field,
          FoxSelect<int>(
            label: 'الحي',
            value: 2,
            onChanged: (_) {},
            initiallyOpen: true,
            options: _districts,
          ),
        ),
      ),
      _example(
        'empty, error',
        _box(
          _field,
          FoxSelect<int>(
            label: 'الحي',
            value: null,
            placeholder: 'اختر الحي',
            error: 'اختر حيًّا',
            onChanged: (_) {},
            options: _districts,
          ),
        ),
      ),
    ]),
  ),
);

Widget _date() => _card([
  _example(
    'chosen',
    _box(
      _field,
      FoxDateField(
        value: DateTime(2026, 3, 5),
        onChanged: (_) {},
        firstDate: DateTime(2026),
        lastDate: DateTime(2027),
        label: 'تاريخ التوصيل',
      ),
    ),
  ),
  _example(
    'empty, error',
    _box(
      _field,
      FoxDateField(
        value: null,
        onChanged: (_) {},
        firstDate: DateTime(2026),
        lastDate: DateTime(2027),
        label: 'تاريخ',
        placeholder: 'اختر التاريخ',
        error: 'اختر يومًا قادمًا',
      ),
    ),
  ),
]);

Widget _time() => _card([
  _example(
    'chosen',
    _box(
      _field,
      FoxTimeField(
        value: const FoxTimeOfDay(15, 5),
        onChanged: (_) {},
        label: 'وقت التوصيل',
      ),
    ),
  ),
  _example(
    'disabled',
    _box(
      _field,
      FoxTimeField(
        value: const FoxTimeOfDay(9, 30),
        onChanged: null,
        label: 'وقت التوصيل',
      ),
    ),
  ),
]);

Widget _checkbox() => _card([
  for (final (caption, value, disabled, invalid) in const [
    ('unchecked', false, false, false),
    ('checked', true, false, false),
    ('mixed', null, false, false),
    ('invalid', false, false, true),
    ('disabled', true, true, false),
  ])
    _example(
      caption,
      FoxCheckbox(
        value: value,
        label: 'أوافق على الشروط',
        invalid: invalid,
        onChanged: disabled ? null : (_) {},
      ),
    ),
]);

Widget _radio() => _card([
  _example(
    'group, one chosen',
    _box(
      _field,
      FoxRadioGroup(
        label: 'طريقة الدفع',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FoxRadio<String>(
              value: 'cash',
              groupValue: 'cash',
              label: 'نقداً عند الاستلام',
              onChanged: (_) {},
            ),
            FoxRadio<String>(
              value: 'wallet',
              groupValue: 'cash',
              label: 'المحفظة',
              onChanged: (_) {},
            ),
          ],
        ),
      ),
    ),
  ),
  _example(
    'error, disabled',
    _box(
      _field,
      FoxRadioGroup(
        label: 'طريقة الدفع',
        error: 'اختر طريقة الدفع',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FoxRadio<String>(
              value: 'cash',
              groupValue: null,
              label: 'نقداً عند الاستلام',
              onChanged: (_) {},
            ),
            const FoxRadio<String>(
              value: 'wallet',
              groupValue: null,
              label: 'المحفظة',
              onChanged: null,
            ),
          ],
        ),
      ),
    ),
  ),
]);

Widget _switch() => _card([
  for (final (caption, value, disabled) in const [
    ('off', false, false),
    ('on', true, false),
    ('off, disabled', false, true),
    ('on, disabled', true, true),
  ])
    _example(
      caption,
      FoxSwitch(
        value: value,
        label: 'إشعارات الطلبات',
        onChanged: disabled ? null : (_) {},
      ),
    ),
]);

Widget _stepper() {
  Widget stepper(int value, {int? max, bool enabled = true}) =>
      FoxQuantityStepper(
        value: value,
        max: max,
        enabled: enabled,
        onChanged: (_) {},
        onDelete: () {},
        label: 'الكمية',
        increaseLabel: 'زيادة',
        decreaseLabel: 'إنقاص',
        deleteLabel: 'حذف',
      );
  return _card([
    _example('default', stepper(2)),
    _example('minimum: delete', stepper(1)),
    _example('maximum', stepper(5, max: 5)),
    _example('disabled', stepper(2, enabled: false)),
  ]);
}

Widget _money() {
  List<Widget> examples() => [
    _example(
      'secondary · body · number',
      const Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FoxMoney(
            amount: '45000',
            symbol: _lira,
            role: FoxMoneyRole.secondary,
          ),
          gap,
          FoxMoney(amount: '45000', symbol: _lira),
          gap,
          FoxMoney(amount: '47000', symbol: _lira, role: FoxMoneyRole.number),
        ],
      ),
    ),
    _example(
      'currencies, signs, tones',
      const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FoxMoney(amount: '1050', symbol: r'$'),
          gap,
          FoxMoney(amount: '330000000', symbol: 'ل.س'),
          gap,
          FoxMoney(amount: '-2500', symbol: _lira, tone: FoxTone.success),
          gap,
          FoxMoney(amount: '-30000', symbol: _lira, tone: FoxTone.danger),
        ],
      ),
    ),
  ];
  return _card(examples(), captain: examples());
}

const _statuses = [
  (FoxOrderStatus.placed, 'بانتظار المطعم'),
  (FoxOrderStatus.accepted, 'قيد التحضير'),
  (FoxOrderStatus.ready, 'جاهز'),
  (FoxOrderStatus.pickedUp, 'مع الكابتن'),
  (FoxOrderStatus.arrived, 'الكابتن وصل'),
  (FoxOrderStatus.delivered, 'تم التسليم'),
  (FoxOrderStatus.rejected, 'مرفوض'),
  (FoxOrderStatus.cancelled, 'ملغى'),
  (FoxOrderStatus.failed, 'فشل التسليم'),
];

Widget _chips() {
  Widget all({bool compact = false}) => SizedBox(
    width: _width,
    child: Wrap(
      spacing: FoxSpace.xs,
      runSpacing: FoxSpace.xs,
      children: [
        for (final (status, label) in _statuses)
          FoxStatusChip(status: status, label: label, compact: compact),
      ],
    ),
  );
  return _card(
    [
      _example('the nine order states', all()),
      _example('compact', all(compact: true)),
      _example(
        'a free tone',
        const FoxStatusChip(
          tone: FoxTone.warning,
          icon: FoxIcons.clock,
          label: 'مشغول',
        ),
      ),
    ],
    captain: [_example('the nine order states', all())],
  );
}

Widget _badges() => _card([
  for (final (caption, badge) in const [
    (
      'dot',
      FoxCountBadge(semanticLabel: 'جديد', child: FoxIcon(FoxIcons.bell)),
    ),
    (
      'count',
      FoxCountBadge(
        count: 3,
        semanticLabel: '3',
        child: FoxIcon(FoxIcons.bell),
      ),
    ),
    (
      '99+',
      FoxCountBadge(
        count: 120,
        semanticLabel: '120',
        child: FoxIcon(FoxIcons.bell),
      ),
    ),
    (
      'cart, orange',
      FoxCountBadge(
        count: 12,
        tone: FoxBadgeTone.primary,
        semanticLabel: '12',
        child: FoxIcon(FoxIcons.cart),
      ),
    ),
    (
      'inline, in a tab',
      FoxCountBadge(count: 4, tone: FoxBadgeTone.accent, semanticLabel: '4'),
    ),
  ])
    _example(
      caption,
      Padding(padding: const EdgeInsets.all(FoxSpace.xs), child: badge),
    ),
]);

Widget _cards() => _card([
  for (final (caption, elevation, tone, pressable) in const [
    ('outline', FoxCardElevation.outline, FoxCardTone.normal, false),
    ('offset (customer)', FoxCardElevation.offset, FoxCardTone.normal, false),
    ('pressable', FoxCardElevation.outline, FoxCardTone.normal, true),
    ('late', FoxCardElevation.outline, FoxCardTone.danger, false),
  ])
    _example(
      caption,
      _box(
        _field,
        FoxCard(
          elevation: elevation,
          tone: tone,
          onPressed: pressable ? () {} : null,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text('برجر كبصو'), Text('برجر · وجبات سريعة')],
          ),
        ),
      ),
    ),
]);

Widget _rows() => _card([
  _example(
    'pressable, value, danger, disabled',
    _box(
      400,
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FoxListRow(
            title: 'المنزل',
            description: 'أعزاز — دوار الكفين',
            leading: FoxIcons.house,
            onPressed: () {},
          ),
          const FoxListRow(
            title: 'رصيد العهدة',
            leading: FoxIcons.wallet,
            end: FoxMoney(amount: '125000', symbol: _lira, bold: true),
          ),
          const FoxListRow(
            title: 'طلب #10423',
            leading: FoxIcons.receipt,
            end: FoxStatusChip(
              status: FoxOrderStatus.delivered,
              label: 'تم التسليم',
            ),
          ),
          FoxListRow(
            title: 'حذف العنوان',
            leading: FoxIcons.delete,
            tone: FoxListRowTone.danger,
            onPressed: () {},
          ),
          FoxListRow(
            title: 'أكوادي',
            description: 'لا أكواد الآن',
            leading: FoxIcons.gift,
            enabled: false,
            onPressed: () {},
          ),
        ],
      ),
    ),
  ),
]);

Widget _timers() {
  List<Widget> examples() => [
    _example(
      'calm',
      const FoxTimer(seconds: 272, countsDown: true, minuteUnit: 'د'),
    ),
    _example(
      'soon',
      const FoxTimer(seconds: 48, countsDown: true, minuteUnit: 'د'),
    ),
    _example(
      'minutes',
      const FoxTimer(seconds: 1080, countsDown: true, minuteUnit: 'د'),
    ),
    _example(
      'late, counting up',
      const FoxTimer(
        seconds: 180,
        countsDown: false,
        late: true,
        prefix: 'متأخر',
        minuteUnit: 'د',
      ),
    ),
  ];
  return _card(examples(), captain: examples());
}

Widget _rings() {
  List<Widget> examples() => [
    _example('38 s of 45', const FoxCountdownRing(seconds: 38, total: 45)),
    _example('20 s of 45', const FoxCountdownRing(seconds: 20, total: 45)),
    _example('8 s of 45', const FoxCountdownRing(seconds: 8, total: 45)),
  ];
  return _card(examples(), captain: examples());
}

Widget _orderCards() => _card([
  _example(
    'new, with its timer',
    _box(
      _field,
      FoxOrderCard(
        number: '10423',
        since: 'منذ 1 د',
        items: '3 أصناف · وجبة كريسبي، لفة شاورما…',
        captain: 'بانتظار كابتن',
        timer: const FoxTimer(seconds: 272, countsDown: true, minuteUnit: 'د'),
        action: FoxOrderAction('قبول', () {}),
      ),
    ),
  ),
  _example(
    'late, with a badge',
    _box(
      _field,
      FoxOrderCard(
        number: '10412',
        since: 'منذ 24 د',
        items: '5 أصناف · وجبة عائلية…',
        captain: 'وصل الكابتن — ينتظر منذ 3 د',
        timer: const FoxTimer(
          seconds: 240,
          countsDown: false,
          late: true,
          prefix: 'متأخر',
          minuteUnit: 'د',
        ),
        badges: const [
          FoxStatusChip(
            tone: FoxTone.warning,
            icon: FoxIcons.warning,
            label: 'صنف نفد',
          ),
        ],
        late: true,
        lateLabel: 'متأخر',
        action: FoxOrderAction('الطلب جاهز', () {}),
      ),
    ),
  ),
]);

Widget _orderRows() => _card([
  _example(
    'the customer\'s «طلباتي»',
    _box(
      400,
      const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FoxOrderRow(
            restaurant: 'برجر كبصو',
            date: 'اليوم · 9:45 م',
            status: FoxStatusChip(
              status: FoxOrderStatus.pickedUp,
              label: 'في الطريق إليك',
            ),
            total: FoxMoney(amount: '47000', symbol: _lira, bold: true),
          ),
          gap,
          FoxOrderRow(
            restaurant: 'كنافة أعزاز',
            date: 'أمس · 8:10 م',
            status: FoxStatusChip(
              status: FoxOrderStatus.delivered,
              label: 'تم التسليم',
            ),
            total: FoxMoney(amount: '23500', symbol: _lira, bold: true),
          ),
        ],
      ),
    ),
  ),
]);

Widget _logos() => _card([
  _example(
    'initials when there is no logo',
    const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FoxLogo(name: 'برجر كبصو'),
        gap,
        FoxLogo(name: 'كنافة أعزاز'),
        gap,
        FoxLogo(name: 'Pizza Roma'),
      ],
    ),
  ),
]);

const _lines = [
  FoxAmountLine('قيمة الأصناف', '45200'),
  FoxAmountLine('رسوم التوصيل', '0', text: 'مجاني'),
  FoxAmountLine('الخصم (FOX25)', '-2500', tone: FoxTone.success),
  FoxAmountLine('تقريب', '-200'),
];

Widget _summaries() => _card([
  _example(
    'prominent (customer cart)',
    _box(
      _field,
      const FoxAmountsSummary(
        variant: FoxAmountsVariant.prominent,
        lines: _lines,
        total: FoxAmountLine('المجموع', '42500'),
        symbol: _lira,
        equivalents: r'أو 11.50 $ · 3,300,000 ل.س',
      ),
    ),
  ),
  _example(
    'plain',
    _box(
      _field,
      const FoxAmountsSummary(
        lines: _lines,
        total: FoxAmountLine('المجموع', '42500'),
        symbol: _lira,
      ),
    ),
  ),
]);

Widget _restaurantCards() => _card([
  _example(
    'open, favourite',
    _box(
      _field,
      FoxRestaurantCard(
        name: 'برجر كبصو',
        categories: 'برجر · وجبات سريعة',
        rating: '4.6',
        eta: '25–35 د',
        fee: const FoxMoney(
          amount: '0',
          symbol: _lira,
          role: FoxMoneyRole.secondary,
        ),
        favourite: true,
        favouriteLabel: 'المفضلة',
        onFavourite: () {},
      ),
    ),
  ),
  _example(
    'closed',
    _box(
      _field,
      FoxRestaurantCard(
        name: 'كنافة أعزاز',
        categories: 'حلويات',
        rating: '4.8',
        eta: '30–40 د',
        fee: const FoxMoney(
          amount: '1000',
          symbol: _lira,
          role: FoxMoneyRole.secondary,
        ),
        state: const FoxStatusChip(
          tone: FoxTone.neutral,
          label: 'مغلق — يفتح السبت 10:00 ص',
        ),
        closed: true,
        favourite: false,
        favouriteLabel: 'المفضلة',
        onFavourite: () {},
      ),
    ),
  ),
]);

Widget _dishCards() => _card([
  _example(
    'in the cart, unavailable, plain',
    _box(
      400,
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FoxDishCard(
            name: 'وجبة كريسبي',
            description: 'قطعتان مع بطاطس ومشروب',
            price: const FoxMoney(amount: '12000', symbol: _lira, bold: true),
            fromLabel: 'من',
            count: 2,
            addLabel: 'أضف',
            onAdd: () {},
          ),
          gap,
          FoxDishCard(
            name: 'فطور شامي',
            price: const FoxMoney(amount: '9000', symbol: _lira, bold: true),
            unavailableLabel: 'يتوفر غداً',
            addLabel: 'أضف',
            onAdd: () {},
          ),
          gap,
          FoxDishCard(
            name: 'كوب عيران',
            description: 'مقاس كبير',
            price: const FoxMoney(amount: '2500', symbol: _lira, bold: true),
            addLabel: 'أضف',
            onAdd: () {},
          ),
        ],
      ),
    ),
  ),
]);

Widget _skeleton() => _card([
  _example(
    'a restaurant card loading',
    _box(
      _field,
      const FoxSkeleton(
        label: 'جارٍ التحميل',
        child: Column(
          children: [
            FoxSkeletonBlock(height: FoxSpace.xxxl * 2),
            gap,
            Row(
              children: [
                FoxSkeletonBlock.circle(FoxSpace.xl),
                gap,
                Expanded(child: FoxSkeletonBlock()),
              ],
            ),
            gap,
            FoxSkeletonBlock(),
          ],
        ),
      ),
    ),
  ),
]);

Widget _empty() => _card([
  _example(
    'empty',
    _box(
      _field,
      FoxEmptyState(
        icon: FoxIcons.orders,
        title: 'لا طلبات بعد',
        description: 'اطلب من مطعمك المفضّل',
        action: FoxEmptyAction('تصفّح المطاعم', () {}),
      ),
    ),
  ),
  _example(
    'error',
    _box(
      _field,
      FoxEmptyState(
        icon: FoxIcons.error,
        title: 'حدث خطأ',
        description: 'لم نتمكن من تحميل الطلبات',
        tone: FoxEmptyTone.error,
        action: FoxEmptyAction('أعد المحاولة', () {}),
      ),
    ),
  ),
]);

Widget _dialog() {
  Widget dialog() => FoxDialog(
    title: 'حذف هذا العنوان؟',
    body: '«البيت — حي الشهداء» يُحذف من عناوينك.',
    closeLabel: 'إغلاق',
    onClose: () {},
    primary: FoxDialogAction(label: 'حذف', destructive: true, onPressed: () {}),
    secondary: FoxDialogAction(label: 'إلغاء', onPressed: () {}),
  );
  return _card(
    [
      _example(
        'destructive, the safe action first in focus',
        _box(360, dialog()),
      ),
    ],
    captain: [_example('the same, captain theme', _box(360, dialog()))],
  );
}

Widget _confirm() => _card([
  _example(
    'AP §7.4: reason, money effect, who is notified',
    _box(
      420,
      FoxConfirmDialog(
        title: 'إلغاء الطلب #10423',
        closeLabel: 'إغلاق',
        reasonLabel: 'السبب',
        reasonMarker: '*',
        reasonPlaceholder: 'اكتب سبب الإلغاء',
        reasonError: 'السبب مطلوب',
        showError: true,
        effectTitle: 'أثره على الأرصدة',
        effect: const FoxAmountsSummary(
          lines: [
            FoxAmountLine('يُعاد للزبون', '47000', tone: FoxTone.success),
            FoxAmountLine('يُخصم من المطعم', '-42000'),
          ],
          total: FoxAmountLine('عمولة المنصة', '-5000'),
          symbol: _lira,
        ),
        notifiedTitle: 'سيُبلَّغ',
        notified: const ['الزبون', 'المطعم', 'الكابتن'],
        confirmLabel: 'تأكيد الإلغاء',
        cancelLabel: 'تراجع',
        onConfirm: (_) {},
        onCancel: () {},
      ),
    ),
  ),
]);

Widget _sheets() => Builder(
  builder: (context) => _card([
    for (final (caption, title, sCurve, text) in const [
      (
        'the S-curve tab (customer item)',
        'شاورما عربي',
        true,
        'لحم، بطاطا، مخلل وثوم',
      ),
      (
        'plain (restaurant status)',
        'حالة المطعم',
        false,
        'مفتوح · يغلق اليوم 11:30 م',
      ),
    ])
      _example(
        caption,
        ColoredBox(
          color: FoxTheme.of(context).colors.scrim,
          child: Padding(
            padding: const EdgeInsets.only(top: FoxSpace.lg),
            child: _box(
              320,
              FoxBottomSheet(
                title: title,
                closeLabel: 'إغلاق',
                sCurve: sCurve,
                onClose: () {},
                child: Text(text),
              ),
            ),
          ),
        ),
      ),
  ]),
);

Widget _toasts() => _card([
  _example(
    'the four tones, an action',
    _box(
      360,
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const FoxToast(
            tone: FoxToastTone.success,
            message: 'حُفظت التغييرات',
            closeLabel: 'إغلاق',
          ),
          gap,
          const FoxToast(
            tone: FoxToastTone.info,
            message: 'نُسخ رقم الطلب',
            closeLabel: 'إغلاق',
          ),
          gap,
          const FoxToast(
            tone: FoxToastTone.warning,
            message: 'الصورة كبيرة، ضغطناها قبل الرفع',
            closeLabel: 'إغلاق',
          ),
          gap,
          FoxToast(
            tone: FoxToastTone.danger,
            message: 'تعذّر الحفظ',
            closeLabel: 'إغلاق',
            actionLabel: 'أعد المحاولة',
            onAction: () {},
          ),
        ],
      ),
    ),
  ),
]);

List<FoxBanner> _bannerList() => [
  const FoxBanner(
    tone: FoxBannerTone.danger,
    icon: FoxIcons.offline,
    message: 'لا يوجد اتصال بالإنترنت — لن تصلك الطلبات الجديدة',
  ),
  FoxBanner(
    tone: FoxBannerTone.caution,
    message: 'فشل فحص الجهاز: الإشعارات متوقفة',
    actionLabel: 'افتح الإعدادات',
    onAction: () {},
  ),
  FoxBanner(
    tone: FoxBannerTone.warning,
    message: 'وضع الضغط مفعّل: +10 د',
    actionLabel: 'إلغاء',
    onAction: () {},
  ),
  const FoxBanner(
    tone: FoxBannerTone.info,
    message: 'وضع التجربة: الطلبات لا تصل للزبائن',
  ),
  FoxBanner(
    tone: FoxBannerTone.neutral,
    message: 'يتوفر تحديث للتطبيق',
    actionLabel: 'تحديث',
    onAction: () {},
  ),
];

Widget _banners() {
  List<Widget> examples() => [
    _example(
      'red solid, the rest tinted',
      _box(
        _width,
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _bannerList(),
        ),
      ),
    ),
  ];
  return _card(examples(), captain: examples());
}

const _opened = ValueKey('opened');

Widget _stack() => _card([
  _example(
    'two shown, the rest behind a counter',
    _box(
      _width,
      FoxBannerStack(
        banners: _bannerList(),
        moreLabel: (n) => '+$n تنبيهات أخرى',
        lessLabel: 'إخفاء',
      ),
    ),
  ),
  _example(
    'opened',
    _box(
      _width,
      FoxBannerStack(
        key: _opened,
        banners: _bannerList(),
        moreLabel: (n) => '+$n تنبيهات أخرى',
        lessLabel: 'إخفاء',
      ),
    ),
  ),
]);

Widget _menu() => _onOverlay(
  260,
  Align(
    alignment: AlignmentDirectional.topStart,
    child: _example(
      'the user menu, open',
      FoxMenu(
        label: 'قائمة المستخدم',
        initiallyOpen: true,
        items: [
          FoxMenuItem(
            label: 'الملف الشخصي',
            icon: FoxIcons.account,
            onSelected: () {},
          ),
          FoxMenuItem(
            label: 'الجلسات',
            icon: FoxIcons.settings,
            onSelected: () {},
          ),
          const FoxMenuItem.separator(),
          FoxMenuItem(
            label: 'تسجيل الخروج',
            destructive: true,
            onSelected: () {},
          ),
        ],
        builder: (context, open) => FoxButton(
          label: 'سارة م.',
          variant: FoxButtonVariant.secondary,
          onPressed: open,
        ),
      ),
    ),
  ),
);

Widget _tabs() {
  List<Widget> examples() => [
    _example(
      'underline, counts',
      FoxTabs(
        tabs: const [
          FoxTab(label: 'جديدة', count: 3, countLabel: '3 طلبات'),
          FoxTab(label: 'قيد التحضير', count: 5, countLabel: '5 طلبات'),
          FoxTab(label: 'جاهزة'),
          FoxTab(label: 'مع الكابتن'),
        ],
        selected: 0,
        onChanged: (_) {},
      ),
    ),
    _example(
      'pill (customer)',
      FoxTabs(
        style: FoxTabsStyle.pill,
        tabs: const [
          FoxTab(label: 'الكل'),
          FoxTab(label: 'برجر'),
          FoxTab(label: 'شاورما'),
          FoxTab(label: 'حلويات'),
        ],
        selected: 1,
        onChanged: (_) {},
      ),
    ),
  ];
  return _card(examples(), captain: examples());
}

Widget _topBar() {
  List<Widget> examples() => [
    _example(
      'back, title, end action',
      _box(
        400,
        FoxTopBar(
          title: 'سلة المشتريات',
          backLabel: 'رجوع',
          onBack: () {},
          end: FoxButton.icon(
            icon: FoxIcons.delete,
            label: 'إفراغ السلة',
            variant: FoxButtonVariant.secondary,
            onPressed: () {},
          ),
        ),
      ),
    ),
    _example(
      'title only',
      _box(400, FoxTopBar(title: 'عهدتي', backLabel: 'رجوع', onBack: () {})),
    ),
  ];
  return _card(examples(), captain: examples());
}

Widget _restaurantBar() => _card([
  for (final (caption, connected, status) in const [
    (
      'connected, open',
      true,
      FoxStatusChip(tone: FoxTone.success, label: 'مفتوح'),
    ),
    (
      'offline, busy',
      false,
      FoxStatusChip(tone: FoxTone.warning, label: 'مشغول +10 د'),
    ),
  ])
    _example(
      caption,
      _box(
        _width,
        FoxRestaurantBar(
          name: 'برجر كبصو',
          status: status,
          connected: connected,
          connectionLabel: connected ? 'متصل' : 'غير متصل',
          supportLabel: 'الدعم',
          onSupport: () {},
        ),
      ),
    ),
]);

const _customerItems = [
  FoxNavItem(icon: FoxIcons.home, label: 'الرئيسية'),
  FoxNavItem(icon: FoxIcons.search, label: 'البحث'),
  FoxNavItem(
    icon: FoxIcons.orders,
    label: 'طلباتي',
    badgeCount: 1,
    badgeLabel: '1 جديد',
  ),
  FoxNavItem(icon: FoxIcons.account, label: 'حسابي'),
];

const _captainItems = [
  FoxNavItem(icon: FoxIcons.home, label: 'الرئيسية'),
  FoxNavItem(icon: FoxIcons.wallet, label: 'أرباحي'),
  FoxNavItem(
    icon: FoxIcons.cash,
    label: 'عهدتي',
    dot: true,
    badgeLabel: 'جديد',
  ),
  FoxNavItem(icon: FoxIcons.more, label: 'المزيد'),
];

const _restaurantItems = [
  FoxNavItem(
    icon: FoxIcons.orders,
    label: 'الطلبات',
    badgeCount: 3,
    badgeLabel: '3 جديدة',
  ),
  FoxNavItem(icon: FoxIcons.plate, label: 'القائمة'),
  FoxNavItem(icon: FoxIcons.restaurant, label: 'الحالة'),
  FoxNavItem(icon: FoxIcons.more, label: 'المزيد'),
];

Widget _bottomNavigation() => _card(
  [
    _example(
      'customer: home selected',
      _box(
        400,
        FoxBottomNavigation(
          items: _customerItems,
          selected: 0,
          onSelected: (_) {},
        ),
      ),
    ),
    _example(
      'customer: «طلباتي» selected',
      _box(
        400,
        FoxBottomNavigation(
          items: _customerItems,
          selected: 2,
          onSelected: (_) {},
        ),
      ),
    ),
    _example(
      'restaurant phone',
      _box(
        400,
        FoxBottomNavigation(
          items: _restaurantItems,
          selected: 0,
          onSelected: (_) {},
        ),
      ),
    ),
  ],
  captain: [
    _example(
      'captain',
      _box(
        400,
        FoxBottomNavigation(
          items: _captainItems,
          selected: 0,
          onSelected: (_) {},
        ),
      ),
    ),
  ],
);

Widget _rail() => _card([
  _example(
    'restaurant tablet and Windows, start side',
    SizedBox(
      height: FoxSpace.xxxl * 7,
      child: FoxNavigationRail(
        items: const [
          FoxNavItem(
            icon: FoxIcons.orders,
            label: 'الطلبات',
            badgeCount: 3,
            badgeLabel: '3 جديدة',
          ),
          FoxNavItem(icon: FoxIcons.clock, label: 'السجل'),
          FoxNavItem(icon: FoxIcons.plate, label: 'القائمة'),
          FoxNavItem(icon: FoxIcons.restaurant, label: 'الحالة'),
          FoxNavItem(icon: FoxIcons.star, label: 'التقييمات'),
          FoxNavItem(icon: FoxIcons.settings, label: 'الإعدادات'),
        ],
        selected: 0,
        onSelected: (_) {},
      ),
    ),
  ),
]);

Widget _refresh() => _card([
  _example('pulled 30%', const FoxRefreshDrop(progress: 0.3)),
  _example('pulled 70%', const FoxRefreshDrop(progress: 0.7)),
  _example('loading', const FoxRefreshDrop(progress: 1, refreshing: true)),
]);

// ---------- the tests ----------

typedef _Build = Widget Function(List<TextEditingController> text);

TextEditingController _text(String value) => TextEditingController(text: value);

void main() {
  setUpAll(loadFoxFonts);

  final cards = <String, (_Build, List<String>)>{
    'FoxButton': ((_) => _buttons(), const []),
    'FoxIcon': ((_) => _icons(), const []),
    'FoxField': ((_) => _field_(), const []),
    'FoxTextField': ((c) => _textField(c[0], c[1]), const ['محمد الأحمد', 'م']),
    'FoxTextArea': ((c) => _textArea(c[0]), const ['بدون بصل، والصلصة جانبًا']),
    'FoxSearchField': ((c) => _search(c[0]), const ['شاورما']),
    'FoxPhoneField': ((c) => _phone(c[0], c[1]), const ['0912345678', '53212']),
    'FoxCodeField': ((c) => _code(c), const ['482', '482915', '482915']),
    'FoxSelect': ((_) => _select(), const []),
    'FoxDateField': ((_) => _date(), const []),
    'FoxTimeField': ((_) => _time(), const []),
    'FoxCheckbox': ((_) => _checkbox(), const []),
    'FoxRadio': ((_) => _radio(), const []),
    'FoxSwitch': ((_) => _switch(), const []),
    'FoxQuantityStepper': ((_) => _stepper(), const []),
    'FoxMoney': ((_) => _money(), const []),
    'FoxStatusChip': ((_) => _chips(), const []),
    'FoxCountBadge': ((_) => _badges(), const []),
    'FoxCard': ((_) => _cards(), const []),
    'FoxListRow': ((_) => _rows(), const []),
    'FoxTimer': ((_) => _timers(), const []),
    'FoxCountdownRing': ((_) => _rings(), const []),
    'FoxOrderCard': ((_) => _orderCards(), const []),
    'FoxOrderRow': ((_) => _orderRows(), const []),
    'FoxLogo': ((_) => _logos(), const []),
    'FoxAmountsSummary': ((_) => _summaries(), const []),
    'FoxRestaurantCard': ((_) => _restaurantCards(), const []),
    'FoxDishCard': ((_) => _dishCards(), const []),
    'FoxSkeleton': ((_) => _skeleton(), const []),
    'FoxEmptyState': ((_) => _empty(), const []),
    'FoxDialog': ((_) => _dialog(), const []),
    // The reason field takes focus, and a focused field needs an Overlay.
    'FoxConfirmDialog': (
      (_) => _onOverlay(
        680,
        Align(alignment: AlignmentDirectional.topStart, child: _confirm()),
      ),
      const [],
    ),
    'FoxBottomSheet': ((_) => _sheets(), const []),
    'FoxToast': ((_) => _toasts(), const []),
    'FoxBanner': ((_) => _banners(), const []),
    'FoxBannerStack': ((_) => _stack(), const []),
    'FoxMenu': ((_) => _menu(), const []),
    'FoxTabs': ((_) => _tabs(), const []),
    'FoxTopBar': ((_) => _topBar(), const []),
    'FoxRestaurantBar': ((_) => _restaurantBar(), const []),
    'FoxBottomNavigation': ((_) => _bottomNavigation(), const []),
    'FoxNavigationRail': ((_) => _rail(), const []),
    'FoxPullToRefresh': ((_) => _refresh(), const []),
  };

  for (final MapEntry(key: name, value: (build, texts)) in cards.entries) {
    testWidgets('$name card', (tester) async {
      final controllers = [for (final value in texts) _text(value)];
      addTearDown(() {
        for (final c in controllers) {
          c.dispose();
        }
      });
      // Soft elevations drawn as on a device; the binding checks the flag is
      // back before the test ends.
      debugDisableShadows = false;
      await pumpSheet(
        tester,
        FoxThemeData.phone(),
        build(controllers),
        size: const Size(720, 2600),
      );
      if (name == 'FoxBannerStack') {
        await tester.tap(
          find.descendant(
            of: find.byKey(_opened),
            matching: find.text('+3 تنبيهات أخرى'),
          ),
        );
      }
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 1500));
      await expectLater(
        find.byKey(sheetKey),
        matchesGoldenFile('goldens/design-system/$name.png'),
      );
      debugDisableShadows = true;
    });
  }
}
