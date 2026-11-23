@Tags(['golden'])
library;

import 'package:core_ui/core_ui.dart';
import 'package:core_ui/testing.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'sheet.dart';

const _names = {
  FoxPhoneCountry.syria: 'سوريا',
  FoxPhoneCountry.turkey: 'تركيا',
};

/// The width of a phone form's column, and of the sheet that holds a menu.
const _column340 = 340.0;
const _overlayWidth = 760.0;

/// A column the width of a phone form.
Widget _column(List<Widget> children) => SizedBox(
  width: _column340,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      for (final child in children) ...[child, gap],
    ],
  ),
);

/// The sheet on an Overlay, so a menu can open on it.
Widget _onOverlay(Widget child, {double height = 1100}) => SizedBox(
  width: _overlayWidth,
  height: height,
  child: Overlay(initialEntries: [OverlayEntry(builder: (_) => child)]),
);

void _keyboardFocus() => FocusManager.instance.highlightStrategy =
    FocusHighlightStrategy.alwaysTraditional;

void main() {
  setUpAll(loadFoxFonts);
  tearDown(() {
    FocusManager.instance.highlightStrategy = FocusHighlightStrategy.automatic;
  });

  final themes = {
    'phone': FoxThemeData.phone(),
    'captain': FoxThemeData.captain(),
  };

  for (final MapEntry(key: surface, value: theme) in themes.entries) {
    testWidgets('$surface: the fields in their states', (tester) async {
      final hovered = GlobalKey();
      final focus = FocusNode();
      addTearDown(focus.dispose);
      final typing = FocusNode();
      addTearDown(typing.dispose);
      final controllers = [
        TextEditingController(text: 'محمد الأحمد'),
        TextEditingController(text: 'م'),
        TextEditingController(text: 'بدون بصل، والصلصة جانبًا'),
        TextEditingController(text: 'شاورما'),
        TextEditingController(text: '0912345678'),
        TextEditingController(text: '482'),
      ];
      addTearDown(() {
        for (final c in controllers) {
          c.dispose();
        }
      });
      await pumpSheet(
        tester,
        theme,
        // Focus needs an Overlay, as in an app.
        _onOverlay(
          _column([
            const FoxTextField(
              label: 'الاسم الكامل',
              hint: 'كما يظهر للمطعم والكابتن',
              placeholder: 'اكتب اسمك',
            ),
            FoxTextField(
              key: hovered,
              label: 'الاسم الكامل',
              placeholder: 'تمرير المؤشر',
            ),
            FoxTextField(
              focusNode: focus,
              label: 'الاسم الكامل',
              placeholder: 'تركيز',
            ),
            FoxTextField(
              controller: controllers[0],
              label: 'الاسم الكامل',
              marker: '(اختياري)',
              startIcon: FoxIcons.search,
            ),
            FoxTextField(
              controller: controllers[1],
              label: 'الاسم الكامل',
              error: 'الاسم قصير جدًا',
            ),
            const FoxTextField(
              label: 'الاسم الكامل',
              placeholder: 'معطل',
              enabled: false,
            ),
            FoxTextArea(
              controller: controllers[2],
              label: 'ملاحظات الطلب',
              marker: '(اختياري)',
              maxLength: 200,
            ),
            FoxSearchField(
              controller: controllers[3],
              placeholder: 'ابحث عن طبق أو مطعم',
              clearLabel: 'مسح',
            ),
            const FoxSearchField(
              placeholder: 'ابحث عن طبق أو مطعم',
              clearLabel: 'مسح',
            ),
            FoxPhoneField(
              controller: controllers[4],
              country: FoxPhoneCountry.syria,
              onChanged: (_) {},
              onCountryChanged: (_) {},
              countryNames: _names,
              countryLabel: 'رمز الدولة',
              label: 'رقم الهاتف',
              hint: 'سنرسل لك رمز التحقق',
            ),
            FoxCodeField(
              controller: controllers[5],
              focusNode: typing,
              label: 'رمز التحقق',
              onCompleted: (_) {},
            ),
          ]),
          height: 1800,
        ),
        size: const Size(800, 1900),
      );
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(find.byKey(hovered)));
      focus.requestFocus();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 400));
      // Only one field holds focus at a time: the sheet shows the text
      // field's; the code's current cell is checked in the unit test.
      await expectLater(
        find.byKey(sheetKey),
        matchesGoldenFile('goldens/forms_${surface}_fields.png'),
      );
      await mouse.removePointer();
    });

    testWidgets('$surface: the controls in their states', (tester) async {
      final hovered = GlobalKey();
      final pressed = GlobalKey();
      final focused = GlobalKey();
      Widget box(
        bool? value, {
        Key? key,
        bool disabled = false,
        bool invalid = false,
      }) => FoxCheckbox(
        key: key,
        value: value,
        label: 'أوافق على الشروط',
        invalid: invalid,
        onChanged: disabled ? null : (_) {},
      );
      Widget radio(String group, {Key? key, bool disabled = false}) =>
          FoxRadio<String>(
            key: key,
            value: 'cash',
            groupValue: group,
            label: 'الدفع نقدًا',
            onChanged: disabled ? null : (_) {},
          );
      Widget toggle(bool value, {Key? key, bool disabled = false}) => FoxSwitch(
        key: key,
        value: value,
        label: 'الإشعارات',
        onChanged: disabled ? null : (_) {},
      );
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
      await pumpSheet(
        tester,
        theme,
        _column([
          box(false),
          box(false, key: hovered),
          box(false, key: focused),
          box(false, key: pressed),
          box(true),
          box(null),
          box(false, disabled: true),
          box(true, disabled: true),
          box(false, invalid: true),
          radio('cash'),
          radio('card'),
          radio('card', disabled: true),
          Row(
            children: [
              toggle(false),
              gap,
              toggle(true),
              gap,
              toggle(false, disabled: true),
              gap,
              toggle(true, disabled: true),
            ],
          ),
          stepper(2),
          stepper(1),
          stepper(5, max: 5),
          stepper(2, enabled: false),
        ]),
        size: const Size(800, 1900),
      );
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(find.byKey(hovered)));
      await tester.startGesture(tester.getCenter(find.byKey(pressed)));
      _keyboardFocus();
      Focus.of(
        tester.element(
          find.descendant(
            of: find.byKey(focused),
            matching: find.byType(GestureDetector),
          ),
        ),
      ).requestFocus();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 400));
      await expectLater(
        find.byKey(sheetKey),
        matchesGoldenFile('goldens/forms_${surface}_controls.png'),
      );
      await mouse.removePointer();
    });

    testWidgets('$surface: the menus, the pickers and the code', (
      tester,
    ) async {
      final controllers = [
        TextEditingController(text: '482915'),
        TextEditingController(text: '482915'),
      ];
      addTearDown(() {
        for (final c in controllers) {
          c.dispose();
        }
      });
      await pumpSheet(
        tester,
        theme,
        _onOverlay(
          _Wide(
            left: [
              FoxSelect<int>(
                label: 'الحي',
                value: 2,
                onChanged: (_) {},
                initiallyOpen: true,
                options: const [
                  FoxSelectOption(value: 1, label: 'الكفين'),
                  FoxSelectOption(value: 2, label: 'المركز'),
                  FoxSelectOption(value: 3, label: 'الجامعة'),
                ],
              ),
            ],
            right: [
              FoxDateField(
                value: DateTime(2026, 3, 5),
                onChanged: (_) {},
                firstDate: DateTime(2026),
                lastDate: DateTime(2027),
                label: 'تاريخ التوصيل',
              ),
              FoxTimeField(
                value: const FoxTimeOfDay(15, 5),
                onChanged: (_) {},
                label: 'وقت التوصيل',
              ),
              FoxDateField(
                value: null,
                onChanged: (_) {},
                firstDate: DateTime(2026),
                lastDate: DateTime(2027),
                label: 'تاريخ',
                placeholder: 'اختر التاريخ',
                error: 'اختر يومًا قادمًا',
              ),
              FoxCodeField(
                controller: controllers[0],
                done: true,
                label: 'رمز التحقق',
                onCompleted: (_) {},
              ),
              FoxCodeField(
                controller: controllers[1],
                error: 'الرمز غير صحيح',
                onCompleted: (_) {},
              ),
            ],
          ),
          height: 700,
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 1500));
      await expectLater(
        find.byKey(sheetKey),
        matchesGoldenFile('goldens/forms_${surface}_pick.png'),
      );
    });

    testWidgets('$surface: at 130% text', (tester) async {
      await pumpSheet(
        tester,
        theme,
        _column([
          const FoxTextField(
            label: 'الاسم الكامل',
            marker: '(اختياري)',
            hint: 'كما يظهر للمطعم والكابتن',
            placeholder: 'اكتب اسمك',
          ),
          FoxCheckbox(value: true, label: 'أوافق', onChanged: (_) {}),
          FoxQuantityStepper(
            value: 12,
            onChanged: (_) {},
            label: 'الكمية',
            increaseLabel: 'زيادة',
            decreaseLabel: 'إنقاص',
            deleteLabel: 'حذف',
          ),
        ]),
        textScale: 1.3,
      );
      await expectLater(
        find.byKey(sheetKey),
        matchesGoldenFile('goldens/forms_${surface}_text_130.png'),
      );
    });
  }
}

/// Two columns of 340: the select (whose menu opens downward) on the left,
/// the rest on the right.
class _Wide extends StatelessWidget {
  const _Wide({required this.left, required this.right});

  final List<Widget> left;
  final List<Widget> right;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [_column(left), gap, gap, _column(right)],
  );
}
