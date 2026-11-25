import 'package:core_ui/core_ui.dart';
import 'package:core_ui/src/field/fox_field.dart' show FieldBox;
import 'package:core_ui/src/internal/fox_material_localizations.dart';
import 'package:core_ui/src/internal/interaction.dart' show Interaction;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' as m;

import 'forms_harness.dart';
import 'phone_harness.dart';

final _i = FoxThemeData.phone().input;

void _keyboard() {
  FocusManager.instance.highlightStrategy =
      FocusHighlightStrategy.alwaysTraditional;
  addTearDown(
    () => FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.automatic,
  );
}

Border _outline(WidgetTester tester, Finder box) =>
    (tester
                    .widget<AnimatedContainer>(
                      find.descendant(
                        of: box,
                        matching: find.byType(AnimatedContainer),
                      ),
                    )
                    .foregroundDecoration!
                as BoxDecoration)
            .border!
        as Border;

void main() {
  group('FoxPhoneField', () {
    Widget phone({String? error}) => formApp(
      FoxPhoneField(
        country: 'SY',
        countries: testCountries,
        strings: testPhoneStrings,
        onChanged: (_) {},
        onCountryChanged: (_) {},
        label: 'رقم الهاتف',
        error: error,
      ),
    );

    testWidgets('is one pill: the chip and the digits run left to right', (
      tester,
    ) async {
      await tester.pumpWidget(phone());
      expect(find.byType(FieldBox), findsOneWidget);
      expect(find.text('+963'), findsOneWidget);
      // The label sits at the start (right) while the chip is at the left.
      final chip = tester.getCenter(find.text('+963'));
      final digits = tester.getCenter(find.byType(EditableText));
      expect(chip.dx, lessThan(digits.dx));
      final label = tester.getTopRight(find.text('رقم الهاتف'));
      final box = tester.getTopRight(find.byType(FieldBox));
      expect(label.dx, closeTo(box.dx, 1));
    });

    // Reading, switching, the country list and every scale:
    // phone_field_test.dart and phone_rules_test.dart (D.11b).

    testWidgets('names the chip and the field, and describes the error', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(phone(error: 'رقم غير صالح'));
      expect(
        find.bySemanticsLabel('الدولة: سوريا، +963. اضغط لتغييرها'),
        findsOneWidget,
      );
      final node = tester.getSemantics(find.byType(EditableText));
      expect(node.label, 'رقم الهاتف');
      expect(node.hint, 'رقم غير صالح');
      expect(
        _outline(tester, find.byType(FieldBox)).top.color,
        _i.borderInvalid,
      );
      semantics.dispose();
    });
  });

  group('FoxCodeField', () {
    Widget code({
      ValueChanged<String>? onCompleted,
      TextEditingController? controller,
      String? error,
      bool done = false,
      bool disableAnimations = false,
    }) => formApp(
      FoxCodeField(
        onCompleted: onCompleted ?? (_) {},
        controller: controller,
        error: error,
        done: done,
      ),
      disableAnimations: disableAnimations,
    );

    List<AnimatedContainer> cells(WidgetTester tester) => [
      for (final c in tester.widgetList<AnimatedContainer>(
        find.byType(AnimatedContainer),
      ))
        if (c.constraints?.maxWidth == 48) c,
    ];

    testWidgets('is six 48 circles, left to right, over one input', (
      tester,
    ) async {
      await tester.pumpWidget(code());
      expect(cells(tester), hasLength(6));
      expect(find.byType(EditableText), findsOneWidget);
      final first = tester.getCenter(find.byType(AnimatedContainer).first);
      final last = tester.getCenter(
        find
            .byWidgetPredicate(
              (w) => w is AnimatedContainer && w.constraints?.maxWidth == 48,
            )
            .last,
      );
      expect(first.dx, lessThan(last.dx));
      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.autofillHints, contains(AutofillHints.oneTimeCode));
      expect(editable.keyboardType, TextInputType.number);
    });

    testWidgets('takes typing and a paste, completes at the last digit', (
      tester,
    ) async {
      final done = <String>[];
      await tester.pumpWidget(code(onCompleted: done.add));
      await tester.enterText(find.byType(EditableText), '123');
      await tester.pump();
      expect(done, isEmpty);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      // A paste (or an autofill) arrives as the whole text at once.
      await tester.enterText(find.byType(EditableText), '482915');
      expect(done, ['482915']);
      // A longer paste keeps its first six digits (the old code is replaced
      // first, see «new digits replace a full code»).
      await tester.enterText(find.byType(EditableText), '');
      await tester.enterText(find.byType(EditableText), '4829150000');
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).controller.text,
        '482915',
      );
    });

    testWidgets('reads Arabic-Indic and Persian digits as 0-9', (tester) async {
      final done = <String>[];
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        code(controller: controller, onCompleted: done.add),
      );
      await tester.enterText(find.byType(EditableText), '٤٨٢');
      expect(controller.text, '482');
      // A paste of mixed digits and letters, as one-time-code autofill sends.
      await tester.enterText(find.byType(EditableText), '٤٨۲٩١٥x');
      expect(controller.text, '482915');
      expect(done, ['482915']);
    });

    testWidgets('new digits replace a full code', (tester) async {
      final done = <String>[];
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        code(controller: controller, onCompleted: done.add),
      );
      await tester.enterText(find.byType(EditableText), '482915');
      // A paste of a whole new code.
      await tester.enterText(find.byType(EditableText), '123456');
      expect(controller.text, '123456');
      expect(done, ['482915', '123456']);
      // A keystroke on a full code starts a new one.
      await tester.enterText(find.byType(EditableText), '1234567');
      expect(controller.text, '7');
      expect(done, hasLength(2));
      // A paste in the middle of a full code is the new code.
      await tester.enterText(find.byType(EditableText), '');
      await tester.enterText(find.byType(EditableText), '482915');
      await tester.enterText(find.byType(EditableText), '48777915');
      expect(controller.text, '777');
    });

    testWidgets('keeps digits only', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(code(controller: controller));
      await tester.enterText(find.byType(EditableText), '1a2-3');
      expect(controller.text, '123');
    });

    testWidgets('the next cell has the orange outline once focused', (
      tester,
    ) async {
      await tester.pumpWidget(code());
      await tester.tap(find.byType(EditableText));
      await tester.enterText(find.byType(EditableText), '12');
      await tester.pump(const Duration(milliseconds: 250));
      final outlined = [
        for (final c in cells(tester))
          if (c.foregroundDecoration != null)
            ((c.foregroundDecoration! as BoxDecoration).border! as Border).top,
      ];
      expect(outlined.where((b) => b.color == _i.borderFocus), hasLength(1));
      expect(outlined.where((b) => b.width == _i.focusWidth), hasLength(1));
      expect(outlined.where((b) => b.color == _i.border), hasLength(5));
    });

    testWidgets('an error draws every cell 2 danger and is announced', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(code(error: 'الرمز غير صحيح'));
      for (final c in cells(tester)) {
        final side =
            ((c.foregroundDecoration! as BoxDecoration).border! as Border).top;
        expect(side.color, _i.borderInvalid);
        expect(side.width, 2);
      }
      expect(
        tester.getSemantics(find.byType(EditableText)).hint,
        'الرمز غير صحيح',
      );
      semantics.dispose();
    });

    testWidgets('done fills orange and fuses for 1200 ms, even when reduced', (
      tester,
    ) async {
      final controller = TextEditingController(text: '123456');
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        code(controller: controller, done: true, disableAnimations: true),
      );
      for (final c in cells(tester)) {
        expect((c.decoration! as BoxDecoration).color, _i.codeDone);
        expect(c.duration, FoxDuration.moment);
        expect(c.foregroundDecoration, isNull);
      }
      final spacer = tester
          .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
          .where(
            (c) =>
                c.constraints?.maxWidth != 48 &&
                c.duration == FoxDuration.moment,
          );
      expect(spacer, isNotEmpty);
      await tester.pump(FoxDuration.moment);
      final row = tester.getSize(find.byType(Row).first);
      expect(row.width, 6 * 48);
    });

    testWidgets('fits at every scale', (tester) async {
      await expectNoOverflow(
        tester,
        () => FoxCodeField(
          onCompleted: (_) {},
          label: 'رمز التحقق',
          hint: 'أرسلناه إلى هاتفك',
        ),
      );
    });
  });

  group('FoxSelect', () {
    const options = [
      FoxSelectOption(value: 1, label: 'الكفين'),
      FoxSelectOption(value: 2, label: 'المركز'),
      FoxSelectOption(value: 3, label: 'الجامعة'),
    ];

    Widget select({
      int? value,
      ValueChanged<int>? onChanged,
      String? error,
      bool open = false,
    }) => formApp(
      FoxSelect<int>(
        options: options,
        value: value,
        onChanged: onChanged,
        label: 'الحي',
        placeholder: 'اختر الحي',
        error: error,
        initiallyOpen: open,
      ),
    );

    testWidgets('shows the placeholder, then the chosen label', (tester) async {
      await tester.pumpWidget(select(onChanged: (_) {}));
      expect(find.text('اختر الحي'), findsOneWidget);
      expect(tester.getSize(find.byType(FieldBox)).height, 50);
      await tester.pumpWidget(select(value: 2, onChanged: (_) {}));
      expect(find.text('المركز'), findsOneWidget);
      expect(find.text('اختر الحي'), findsNothing);
    });

    testWidgets('opens a menu under the field, as wide as it, and picks', (
      tester,
    ) async {
      final seen = <int>[];
      await tester.pumpWidget(select(value: 2, onChanged: seen.add));
      await tester.tap(find.byType(FieldBox));
      await tester.pump();
      final field = tester.getRect(find.byType(FieldBox));
      final menu = tester.getRect(find.text('الجامعة'));
      expect(menu.top, greaterThan(field.bottom));
      expect(menu.width, lessThanOrEqualTo(field.width));
      await tester.tap(find.text('الجامعة'));
      await tester.pump();
      expect(seen, [3]);
      expect(find.text('الجامعة'), findsNothing);
    });

    testWidgets('arrows move, Enter picks, Escape closes and refocuses', (
      tester,
    ) async {
      _keyboard();
      final seen = <int>[];
      await tester.pumpWidget(select(value: 1, onChanged: seen.add));
      await tester.tap(find.byType(FieldBox));
      await tester.pump();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(seen, [2]);

      await tester.tap(find.byType(FieldBox));
      await tester.pump();
      await tester.pump();
      expect(find.text('الجامعة'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(find.text('الجامعة'), findsNothing);
      expect(seen, [2]);
    });

    testWidgets('typing letters moves to the first matching option', (
      tester,
    ) async {
      _keyboard();
      final seen = <String>[];
      await tester.pumpWidget(
        formApp(
          FoxSelect<String>(
            options: const [
              FoxSelectOption(value: 'k', label: 'الكفين'),
              FoxSelectOption(value: 'm', label: 'المركز'),
              FoxSelectOption(value: 'j', label: 'الجامعة'),
              FoxSelectOption(value: 'Apple', label: 'Apple'),
              FoxSelectOption(value: 'Banana', label: 'Banana'),
            ],
            value: 'k',
            onChanged: seen.add,
          ),
        ),
      );
      await tester.tap(find.byType(FieldBox));
      await tester.pump();
      await tester.pump();
      // «الج» narrows from the first «ال…» to the third option.
      await tester.sendKeyEvent(LogicalKeyboardKey.keyA, character: 'ا');
      await tester.sendKeyEvent(LogicalKeyboardKey.keyL, character: 'ل');
      await tester.sendKeyEvent(LogicalKeyboardKey.keyJ, character: 'ج');
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(seen, ['j']);

      // Latin letters match without regard to case, a letter that matches
      // nothing leaves the focus where it is, and Space is not a letter.
      await tester.tap(find.byType(FieldBox));
      await tester.pump();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.keyB, character: 'b');
      await tester.sendKeyEvent(LogicalKeyboardKey.keyZ, character: 'z');
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(seen, ['j', 'Banana']);
    });

    testWidgets('a tap outside closes it without choosing', (tester) async {
      final seen = <int>[];
      await tester.pumpWidget(select(onChanged: seen.add));
      await tester.tap(find.byType(FieldBox));
      await tester.pump();
      expect(find.text('المركز'), findsOneWidget);
      await tester.tapAt(const Offset(5, 500));
      await tester.pump();
      expect(find.text('المركز'), findsNothing);
      expect(seen, isEmpty);
    });

    testWidgets('is a named button with a value, expanded when open', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        select(value: 2, onChanged: (_) {}, error: 'اختر حيًّا'),
      );
      expect(
        tester.getSemantics(find.byType(Interaction)),
        matchesSemantics(
          label: 'الحي',
          value: 'المركز',
          hint: 'اختر حيًّا',
          isButton: true,
          hasEnabledState: true,
          isEnabled: true,
          isFocusable: true,
          hasTapAction: true,
          hasFocusAction: true,
          hasExpandedState: true,
        ),
      );
      semantics.dispose();
    });

    testWidgets('states: invalid and disabled', (tester) async {
      await tester.pumpWidget(select(onChanged: (_) {}, error: 'خطأ'));
      expect(
        _outline(tester, find.byType(FieldBox)).top.color,
        _i.borderInvalid,
      );
      await tester.pumpWidget(select());
      expect(
        tester
            .widget<AnimatedContainer>(
              find.descendant(
                of: find.byType(FieldBox),
                matching: find.byType(AnimatedContainer),
              ),
            )
            .foregroundDecoration,
        isA<BoxDecoration>().having((d) => d.border, 'border', isNull),
      );
    });

    testWidgets('fits at every scale', (tester) async {
      await expectNoOverflow(
        tester,
        () => FoxSelect<int>(
          options: options,
          value: 1,
          onChanged: (_) {},
          label: 'الحي الذي تسكن فيه حاليًا في مدينة اعزاز',
        ),
      );
    });
  });

  group('FoxDateField and FoxTimeField', () {
    final first = DateTime(2026, 1, 1);
    final last = DateTime(2026, 12, 31);

    testWidgets('the date shows as dd/mm/yyyy with Western digits', (
      tester,
    ) async {
      await tester.pumpWidget(
        formApp(
          FoxDateField(
            value: DateTime(2026, 3, 5),
            onChanged: (_) {},
            firstDate: first,
            lastDate: last,
            label: 'التاريخ',
          ),
        ),
      );
      expect(find.text('05/03/2026'), findsOneWidget);
    });

    testWidgets('picks a date: Syriac months, the week from Saturday', (
      tester,
    ) async {
      final seen = <DateTime>[];
      await tester.pumpWidget(
        formApp(
          FoxDateField(
            value: DateTime(2026, 1, 15),
            onChanged: seen.add,
            firstDate: first,
            lastDate: last,
            label: 'التاريخ',
          ),
        ),
      );
      await tester.tap(find.byType(FieldBox));
      await tester.pumpAndSettle();
      expect(find.text('كانون الثاني 2026'), findsOneWidget);
      // The first weekday letter is Saturday's.
      final weekdays = [
        for (final letter in ['س', 'ح', 'ن', 'ث', 'ر', 'خ', 'ج'])
          tester.getCenter(find.text(letter).first).dx,
      ];
      expect(weekdays.first, greaterThan(weekdays[1]));
      await tester.tap(find.text('20'));
      await tester.pump();
      await tester.tap(find.text(FoxMaterialLocalizations().okButtonLabel));
      await tester.pumpAndSettle();
      expect(seen, [DateTime(2026, 1, 20)]);
    });

    testWidgets('the typed-in mode reads dd/mm/yyyy', (tester) async {
      final seen = <DateTime>[];
      await tester.pumpWidget(
        formApp(
          FoxDateField(
            value: DateTime(2026, 1, 15),
            onChanged: seen.add,
            firstDate: first,
            lastDate: last,
          ),
        ),
      );
      await tester.tap(find.byType(FieldBox));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(m.Icons.edit_outlined));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(EditableText).last, '07/04/2026');
      await tester.tap(find.text(FoxMaterialLocalizations().okButtonLabel));
      await tester.pumpAndSettle();
      expect(seen, [DateTime(2026, 4, 7)]);
    });

    testWidgets('the time shows as 3:05 م and 12-hour with ص and م', (
      tester,
    ) async {
      await tester.pumpWidget(
        formApp(
          FoxTimeField(
            value: const FoxTimeOfDay(15, 5),
            onChanged: (_) {},
            label: 'الوقت',
          ),
        ),
      );
      expect(find.text('3:05 م'), findsOneWidget);
      // The time reads right to left: the digits as their own run and «م»
      // after them, at the left (a date is the one forced to LTR).
      expect(
        Directionality.of(tester.element(find.text('3:05 م'))),
        TextDirection.rtl,
      );
      final text = tester.widget<Text>(find.text('3:05 م'));
      expect(text.textAlign, isNull);
      expect(FoxMaterialLocalizations.time(0, 0), '12:00 ص');
      expect(FoxMaterialLocalizations.time(12, 30), '12:30 م');
      expect(FoxMaterialLocalizations.time(9, 7), '9:07 ص');
    });

    testWidgets('the time picker opens typed in boxes', (tester) async {
      final seen = <FoxTimeOfDay>[];
      await tester.pumpWidget(
        formApp(
          FoxTimeField(value: const FoxTimeOfDay(15, 5), onChanged: seen.add),
        ),
      );
      await tester.tap(find.byType(FieldBox));
      await tester.pumpAndSettle();
      expect(find.byType(EditableText), findsNWidgets(2));
      await tester.tap(find.text(FoxMaterialLocalizations().okButtonLabel));
      await tester.pumpAndSettle();
      expect(seen, [const FoxTimeOfDay(15, 5)]);
    });

    testWidgets('are disabled without a callback', (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        formApp(
          FoxDateField(
            value: null,
            onChanged: null,
            firstDate: first,
            lastDate: last,
            label: 'التاريخ',
            placeholder: 'اختر',
          ),
        ),
      );
      expect(
        tester.getSemantics(find.byType(Interaction)),
        isNot(isSemantics(isEnabled: true)),
      );
      semantics.dispose();
    });

    testWidgets('fit at every scale', (tester) async {
      await expectNoOverflow(
        tester,
        () => Column(
          children: [
            FoxDateField(
              value: DateTime(2026, 3, 5),
              onChanged: (_) {},
              firstDate: first,
              lastDate: last,
              label: 'تاريخ التوصيل المطلوب لهذا الطلب',
            ),
            FoxTimeField(
              value: const FoxTimeOfDay(15, 5),
              onChanged: (_) {},
              label: 'الوقت',
            ),
          ],
        ),
      );
    });
  });

  group('the Syriac, Saturday-first, dd/mm/yyyy strings', () {
    final l10n = FoxMaterialLocalizations();

    test('the typed-in hint says dd/mm/yyyy and only Arabic is supported', () {
      expect(l10n.dateHelpText, 'dd/mm/yyyy');
      const delegate = FoxMaterialLocalizations.delegate;
      expect(delegate.isSupported(const Locale('ar')), isTrue);
      expect(delegate.isSupported(const Locale('en')), isFalse);
    });

    test('twelve months from كانون الثاني to كانون الأول', () {
      expect(syriacMonths.first, 'كانون الثاني');
      expect(syriacMonths.last, 'كانون الأول');
      expect(syriacMonths, hasLength(12));
      expect(l10n.formatMonthYear(DateTime(2026, 10)), 'تشرين الأول 2026');
    });

    test('Saturday first, Western digits, ص and م', () {
      expect(l10n.firstDayOfWeekIndex, 6);
      expect(l10n.formatDecimal(1234), '1234');
      expect(l10n.formatCompactDate(DateTime(2026, 3, 5)), '05/03/2026');
      expect(l10n.anteMeridiemAbbreviation, 'ص');
      expect(l10n.postMeridiemAbbreviation, 'م');
      expect(
        l10n.timeOfDayFormat(alwaysUse24HourFormat: true),
        m.TimeOfDayFormat.h_colon_mm_space_a,
      );
    });

    test('parses dd/mm/yyyy and refuses impossible dates', () {
      expect(l10n.parseCompactDate('07/04/2026'), DateTime(2026, 4, 7));
      expect(l10n.parseCompactDate('31/02/2026'), isNull);
      expect(l10n.parseCompactDate('2026-04-07'), isNull);
      expect(l10n.parseCompactDate(null), isNull);
    });
  });
}
