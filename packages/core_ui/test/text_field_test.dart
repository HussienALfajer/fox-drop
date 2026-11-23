import 'package:core_ui/core_ui.dart';
import 'package:core_ui/src/field/fox_field.dart' show FieldBox;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' as m;

import 'forms_harness.dart';

final _theme = FoxThemeData.phone();

AnimatedContainer _box(WidgetTester tester) => tester.widget<AnimatedContainer>(
  find.descendant(
    of: find.byType(FieldBox),
    matching: find.byType(AnimatedContainer),
  ),
);

BoxBorder? _border(WidgetTester tester) =>
    (_box(tester).foregroundDecoration! as BoxDecoration).border;

Color _borderColour(WidgetTester tester) =>
    (_border(tester)! as Border).top.color;

double _borderWidth(WidgetTester tester) =>
    (_border(tester)! as Border).top.width;

void main() {
  group('FoxTextField', () {
    testWidgets('is a 50 high pill with the label, hint and marker', (
      tester,
    ) async {
      await tester.pumpWidget(
        formApp(
          const FoxTextField(
            label: 'الاسم',
            marker: '(اختياري)',
            hint: 'كما في الهوية',
            placeholder: 'اكتب اسمك',
          ),
        ),
      );
      expect(find.byType(FieldBox), findsOneWidget);
      expect(tester.getSize(find.byType(FieldBox)).height, 50);
      expect(find.text('الاسم'), findsNothing);
      expect(find.textContaining('الاسم', findRichText: true), findsOneWidget);
      expect(find.text('كما في الهوية'), findsOneWidget);
      final radius =
          (_box(tester).decoration! as BoxDecoration).borderRadius!
              as BorderRadius;
      expect(radius.topLeft.x, _theme.input.radius);
    });

    testWidgets('names the control and describes it with the error', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        formApp(
          const FoxTextField(
            label: 'الاسم',
            marker: '(اختياري)',
            error: 'الاسم قصير',
          ),
        ),
      );
      final node = tester.getSemantics(find.byType(EditableText));
      expect(node.label, contains('الاسم'));
      expect(node.label, contains('(اختياري)'));
      expect(node.hint, 'الاسم قصير');
      // The visible error is not announced a second time.
      expect(find.bySemanticsLabel('الاسم قصير'), findsNothing);
      semantics.dispose();
    });

    testWidgets('paints rest, hover, focus, invalid and disabled', (
      tester,
    ) async {
      final i = _theme.input;
      await tester.pumpWidget(formApp(const FoxTextField(placeholder: 'x')));
      expect(_borderColour(tester), i.border);
      expect(_borderWidth(tester), i.borderWidth);

      await hover(tester, find.byType(FieldBox));
      expect(_borderColour(tester), i.borderHover);
      expect(_borderWidth(tester), i.borderWidth);

      await tester.tap(find.byType(EditableText));
      await tester.pump(const Duration(milliseconds: 250));
      expect(_borderColour(tester), i.borderFocus);
      expect(_borderWidth(tester), i.focusWidth);
      // The outline is a foreground decoration: no layout change.
      expect(tester.getSize(find.byType(FieldBox)).height, 50);

      await tester.pumpWidget(
        formApp(const FoxTextField(placeholder: 'x', error: 'خطأ')),
      );
      expect(_borderColour(tester), i.borderInvalid);
      expect(_borderWidth(tester), i.focusWidth);
      expect(find.byType(FoxField), findsOneWidget);

      await tester.pumpWidget(
        formApp(const FoxTextField(placeholder: 'x', enabled: false)),
      );
      expect(_border(tester), isNull);
      expect((_box(tester).decoration! as BoxDecoration).color, i.disabled);
      await tester.tap(find.byType(EditableText), warnIfMissed: false);
      await tester.pump();
      expect(
        tester
            .state<EditableTextState>(find.byType(EditableText))
            .widget
            .focusNode
            .hasFocus,
        isFalse,
      );
    });

    testWidgets('types, reports changes and submits from the keyboard', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      final changes = <String>[];
      String? submitted;
      await tester.pumpWidget(
        formApp(
          FoxTextField(
            controller: controller,
            onChanged: changes.add,
            onSubmitted: (v) => submitted = v,
          ),
        ),
      );
      await tester.enterText(find.byType(EditableText), 'محمد');
      expect(controller.text, 'محمد');
      expect(changes, ['محمد']);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      expect(submitted, 'محمد');
    });

    testWidgets('has no ripple and no Material look around the entry', (
      tester,
    ) async {
      await tester.pumpWidget(formApp(const FoxTextField()));
      expect(find.byType(m.InkWell), findsNothing);
      expect(find.byType(m.InkResponse), findsNothing);
    });

    testWidgets('fits in both directions, both themes, 130% and 200%', (
      tester,
    ) async {
      await expectNoOverflow(
        tester,
        () => const FoxTextField(
          label: 'الاسم الكامل كما يظهر للمطعم والكابتن',
          marker: '(اختياري)',
          hint: 'كما يظهر للمطعم والكابتن عند الطلب',
          startIcon: FoxIcons.search,
        ),
      );
    });
  });

  group('FoxTextArea', () {
    testWidgets('uses the area radius, 3 lines, and counts', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        formApp(FoxTextArea(controller: controller, maxLength: 20)),
      );
      final radius =
          (_box(tester).decoration! as BoxDecoration).borderRadius!
              as BorderRadius;
      expect(radius.topLeft.x, _theme.input.areaRadius);
      final text = tester.widget<EditableText>(find.byType(EditableText));
      expect(text.minLines, 3);
      expect(text.maxLines, 6);
      expect(
        tester.getSize(find.byType(FieldBox)).height,
        greaterThan(_theme.input.height * 1.5),
      );
      expect(find.text('0/20'), findsOneWidget);
      await tester.enterText(find.byType(EditableText), 'بدون بصل');
      await tester.pump();
      expect(find.text('8/20'), findsOneWidget);
      await tester.enterText(find.byType(EditableText), 'x' * 30);
      await tester.pump();
      expect(controller.text.length, 20);
    });

    testWidgets('grows to six lines then scrolls', (tester) async {
      await tester.pumpWidget(formApp(const FoxTextArea()));
      final three = tester.getSize(find.byType(FieldBox)).height;
      await tester.enterText(
        find.byType(EditableText),
        List.filled(12, 'سطر').join('\n'),
      );
      await tester.pump();
      final six = tester.getSize(find.byType(FieldBox)).height;
      expect(six, greaterThan(three));
      await tester.enterText(
        find.byType(EditableText),
        List.filled(20, 'سطر').join('\n'),
      );
      await tester.pump();
      expect(tester.getSize(find.byType(FieldBox)).height, six);
    });

    testWidgets('shows the invalid outline', (tester) async {
      await tester.pumpWidget(formApp(const FoxTextArea(error: 'طويل')));
      expect(_borderColour(tester), _theme.input.borderInvalid);
    });

    testWidgets('fits at every scale', (tester) async {
      await expectNoOverflow(
        tester,
        () => const FoxTextArea(label: 'ملاحظات الطلب', maxLength: 200),
      );
    });
  });

  group('FoxSearchField', () {
    Widget search({bool loading = false, TextEditingController? controller}) =>
        formApp(
          FoxSearchField(
            placeholder: 'ابحث عن طبق أو مطعم',
            clearLabel: 'مسح',
            loadingLabel: 'جارٍ البحث',
            loading: loading,
            controller: controller,
          ),
        );

    testWidgets('has an orange lens and no clear button while empty', (
      tester,
    ) async {
      await tester.pumpWidget(search());
      expect(find.bySemanticsLabel('مسح'), findsNothing);
      expect(find.byType(FoxIcon), findsOneWidget);
      expect(
        tester.widget<FoxIcon>(find.byType(FoxIcon)).color,
        _theme.input.accent,
      );
    });

    testWidgets('clears what was typed with a button that has a name', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(search(controller: controller));
      await tester.enterText(find.byType(EditableText), 'شاورما');
      await tester.pump();
      final clear = find.bySemanticsLabel('مسح');
      expect(clear, findsOneWidget);
      expect(tester.getSize(clear).width, greaterThanOrEqualTo(48));
      expect(
        tester.getSemantics(clear),
        matchesSemantics(
          label: 'مسح',
          isButton: true,
          hasEnabledState: true,
          isEnabled: true,
          isFocusable: true,
          hasTapAction: true,
          hasFocusAction: true,
        ),
      );
      await tester.tap(clear);
      await tester.pump();
      expect(controller.text, isEmpty);
      expect(find.bySemanticsLabel('مسح'), findsNothing);
      semantics.dispose();
    });

    testWidgets('the clear button works from the keyboard', (tester) async {
      final controller = TextEditingController(text: 'شاورما');
      addTearDown(controller.dispose);
      await tester.pumpWidget(search(controller: controller));
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      addTearDown(
        () => FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.automatic,
      );
      Focus.of(
        tester.element(find.byType(GestureDetector).last),
      ).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(controller.text, isEmpty);
    });

    testWidgets('shows a spinner instead of clear while loading', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'شاورما');
      addTearDown(controller.dispose);
      await tester.pumpWidget(search(loading: true, controller: controller));
      expect(find.bySemanticsLabel('مسح'), findsNothing);
      expect(find.bySemanticsLabel('جارٍ البحث'), findsOneWidget);
    });

    testWidgets('fits at every scale', (tester) async {
      await expectNoOverflow(
        tester,
        () => const FoxSearchField(placeholder: 'ابحث', clearLabel: 'مسح'),
      );
    });
  });
}
