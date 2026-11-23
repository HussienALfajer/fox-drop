import 'package:core_ui/core_ui.dart';
import 'package:core_ui/src/internal/interaction.dart' show Interaction;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'forms_harness.dart';

final _i = FoxThemeData.phone().input;

/// The painted square or circle of a checkbox or radio.
AnimatedContainer _box(WidgetTester tester) => tester.widget<AnimatedContainer>(
  find.descendant(
    of: find.byType(Interaction),
    matching: find.byType(AnimatedContainer),
  ),
);

Color _fill(WidgetTester tester) =>
    (_box(tester).decoration! as BoxDecoration).color!;

Color _edge(WidgetTester tester) =>
    ((_box(tester).decoration! as BoxDecoration).border! as Border).top.color;

final _ring = find.byWidgetPredicate(
  (w) => w is CustomPaint && w.foregroundPainter != null,
);

void _keyboard() {
  FocusManager.instance.highlightStrategy =
      FocusHighlightStrategy.alwaysTraditional;
  addTearDown(
    () => FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.automatic,
  );
}

void main() {
  group('FoxCheckbox', () {
    Widget checkbox(bool? value, ValueChanged<bool>? onChanged) => formApp(
      FoxCheckbox(
        value: value,
        onChanged: onChanged,
        label: 'أوافق على الشروط',
      ),
    );

    testWidgets('is a labelled checkbox whose whole row is a 48 target', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(checkbox(false, (_) {}));
      expect(
        tester.getSize(find.byType(FoxCheckbox)).height,
        greaterThanOrEqualTo(48),
      );
      expect(
        tester.getSize(find.byType(AnimatedContainer)),
        const Size(24, 24),
      );
      expect(
        tester.getSemantics(find.byType(FoxCheckbox)),
        matchesSemantics(
          label: 'أوافق على الشروط',
          hasCheckedState: true,
          isChecked: false,
          hasEnabledState: true,
          isEnabled: true,
          isFocusable: true,
          hasTapAction: true,
          hasFocusAction: true,
        ),
      );
      await tester.pumpWidget(checkbox(null, (_) {}));
      expect(
        tester.getSemantics(find.byType(FoxCheckbox)),
        matchesSemantics(
          label: 'أوافق على الشروط',
          hasCheckedState: true,
          isCheckStateMixed: true,
          hasEnabledState: true,
          isEnabled: true,
          isFocusable: true,
          hasTapAction: true,
          hasFocusAction: true,
        ),
      );
      semantics.dispose();
    });

    testWidgets('a tap on the label toggles; mixed becomes checked', (
      tester,
    ) async {
      final seen = <bool>[];
      await tester.pumpWidget(checkbox(false, seen.add));
      await tester.tap(find.text('أوافق على الشروط'));
      await tester.pumpWidget(checkbox(true, seen.add));
      await tester.tap(find.byType(FoxCheckbox));
      await tester.pumpWidget(checkbox(null, seen.add));
      await tester.tap(find.byType(FoxCheckbox));
      expect(seen, [true, false, true]);
    });

    testWidgets('Space toggles from the keyboard, Enter does not', (
      tester,
    ) async {
      _keyboard();
      final seen = <bool>[];
      await tester.pumpWidget(checkbox(false, seen.add));
      Focus.of(tester.element(find.byType(GestureDetector))).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(seen, isEmpty);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      expect(seen, [true]);
      expect(_ring, findsOneWidget);
    });

    testWidgets('paints the states from the tokens', (tester) async {
      await tester.pumpWidget(checkbox(false, (_) {}));
      expect(_fill(tester), _i.checkBackground);
      expect(_edge(tester), _i.checkBorder);
      await hover(tester, find.byType(FoxCheckbox));
      expect(_fill(tester), _i.checkBackgroundHover);
      expect(_edge(tester), _i.checkBorderHover);

      await tester.pumpWidget(checkbox(true, (_) {}));
      expect(_fill(tester), _i.checkChecked);
      expect(_edge(tester), _i.checkChecked);

      final pressed = await tester.startGesture(
        tester.getCenter(find.byType(FoxCheckbox)),
      );
      await tester.pump(const Duration(milliseconds: 250));
      expect(_fill(tester), _i.checkCheckedPressed);
      await pressed.up();

      await tester.pumpWidget(checkbox(false, null));
      expect(_fill(tester), _i.disabled);
      expect(_edge(tester), _i.onDisabled);
      expect(
        tester.getSemantics(find.byType(FoxCheckbox)),
        isNot(isSemantics(isFocusable: true)),
      );
    });

    testWidgets('invalid draws the danger border', (tester) async {
      await tester.pumpWidget(
        formApp(
          FoxCheckbox(
            value: false,
            onChanged: (_) {},
            label: 'x',
            invalid: true,
          ),
        ),
      );
      expect(_edge(tester), _i.borderInvalid);
    });

    testWidgets('fits at every scale', (tester) async {
      await expectNoOverflow(
        tester,
        () => FoxCheckbox(
          value: true,
          onChanged: (_) {},
          label: 'أوافق على شروط الاستخدام وسياسة الخصوصية وإشعارات التطبيق',
        ),
      );
    });
  });

  group('FoxRadio', () {
    Widget radio(String? group, ValueChanged<String>? onChanged) => formApp(
      Column(
        children: [
          FoxRadio<String>(
            value: 'cash',
            groupValue: group,
            onChanged: onChanged,
            label: 'الدفع نقدًا',
          ),
          FoxRadio<String>(
            value: 'card',
            groupValue: group,
            onChanged: onChanged,
            label: 'بطاقة',
          ),
        ],
      ),
    );

    testWidgets('is a group member with one selected', (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(radio('cash', (_) {}));
      expect(
        tester.getSemantics(find.byType(FoxRadio<String>).first),
        matchesSemantics(
          label: 'الدفع نقدًا',
          hasCheckedState: true,
          isChecked: true,
          isInMutuallyExclusiveGroup: true,
          hasEnabledState: true,
          isEnabled: true,
          isFocusable: true,
          hasTapAction: true,
          hasFocusAction: true,
        ),
      );
      expect(
        tester.getSize(find.byType(FoxRadio<String>).first).height,
        greaterThanOrEqualTo(48),
      );
      semantics.dispose();
    });

    testWidgets('selects on a tap, ignores a tap on the selected one', (
      tester,
    ) async {
      final seen = <String>[];
      await tester.pumpWidget(radio('cash', seen.add));
      await tester.tap(find.text('الدفع نقدًا'));
      await tester.tap(find.text('بطاقة'));
      expect(seen, ['card']);
    });

    testWidgets('Space selects the focused one', (tester) async {
      _keyboard();
      final seen = <String>[];
      await tester.pumpWidget(radio('cash', seen.add));
      Focus.of(
        tester.element(find.byType(GestureDetector).last),
      ).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      expect(seen, ['card']);
      expect(_ring, findsOneWidget);
    });

    testWidgets('paints a dot and the accent when selected', (tester) async {
      await tester.pumpWidget(radio('cash', (_) {}));
      final selected = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer).first,
      );
      expect(
        ((selected.decoration! as BoxDecoration).border! as Border).top.color,
        _i.checkChecked,
      );
      final unselected = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer).last,
      );
      expect(
        ((unselected.decoration! as BoxDecoration).border! as Border).top.color,
        _i.checkBorder,
      );
      expect((unselected.decoration! as BoxDecoration).shape, BoxShape.circle);
    });

    testWidgets('disabled is not focusable', (tester) async {
      await tester.pumpWidget(radio('cash', null));
      expect(
        tester.getSemantics(find.byType(FoxRadio<String>).first),
        isNot(isSemantics(isFocusable: true)),
      );
    });

    testWidgets('fits at every scale', (tester) async {
      await expectNoOverflow(
        tester,
        () => FoxRadio<int>(
          value: 1,
          groupValue: 1,
          onChanged: (_) {},
          label: 'الدفع عند الاستلام نقدًا بالليرة السورية أو التركية',
        ),
      );
    });
  });

  group('FoxRadioGroup', () {
    // Radios in a group; [disabled] values have no callback. The selection
    // is kept by the harness, as an app's state would.
    String? selected;
    final seen = <String>[];

    Widget radios(
      List<String> values, {
      bool grouped = true,
      bool row = false,
      Set<String> disabled = const {},
      TextDirection direction = TextDirection.rtl,
      String? label,
      String? hint,
      String? error,
      FocusNode? before,
    }) => formApp(
      direction: direction,
      StatefulBuilder(
        builder: (context, setState) {
          final items = [
            for (final v in values)
              () {
                final radio = FoxRadio<String>(
                  value: v,
                  groupValue: selected,
                  label: v,
                  onChanged: disabled.contains(v)
                      ? null
                      : (value) => setState(() {
                          selected = value;
                          seen.add(value);
                        }),
                );
                return row ? Expanded(child: radio) : radio;
              }(),
          ];
          final body = row ? Row(children: items) : Column(children: items);
          final group = grouped
              ? FoxRadioGroup(
                  label: label,
                  hint: hint,
                  error: error,
                  child: body,
                )
              : body;
          return before == null
              ? group
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Focus(
                      focusNode: before,
                      child: const SizedBox(height: FoxSpace.xs),
                    ),
                    group,
                  ],
                );
        },
      ),
    );

    bool focused(WidgetTester tester, String label) =>
        Focus.of(tester.element(find.text(label))).hasPrimaryFocus;

    Future<void> focusFirst(WidgetTester tester) async {
      _keyboard();
      Focus.of(
        tester.element(find.byType(GestureDetector).first),
      ).requestFocus();
      await tester.pump();
    }

    setUp(() {
      selected = 'a';
      seen.clear();
    });

    testWidgets('Down and Up move and select, wrapping round', (tester) async {
      await tester.pumpWidget(radios(['a', 'b', 'c']));
      await focusFirst(tester);
      for (var i = 0; i < 3; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();
      }
      expect(seen, ['b', 'c', 'a']);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      expect(seen.last, 'c');
      await tester.pump();
      expect(_ring, findsOneWidget);
    });

    testWidgets('Start and End follow the reading direction', (tester) async {
      for (final direction in TextDirection.values) {
        selected = 'a';
        seen.clear();
        await tester.pumpWidget(
          radios(['a', 'b', 'c'], row: true, direction: direction),
        );
        await focusFirst(tester);
        final toEnd = direction == TextDirection.rtl
            ? LogicalKeyboardKey.arrowLeft
            : LogicalKeyboardKey.arrowRight;
        final toStart = direction == TextDirection.rtl
            ? LogicalKeyboardKey.arrowRight
            : LogicalKeyboardKey.arrowLeft;
        await tester.sendKeyEvent(toEnd);
        await tester.pump();
        await tester.sendKeyEvent(toEnd);
        await tester.pump();
        expect(seen, ['b', 'c'], reason: '$direction to the end');
        await tester.sendKeyEvent(toStart);
        expect(seen.last, 'b', reason: '$direction to the start');
      }
    });

    testWidgets('Tab reaches only the selected radio, arrows move inside', (
      tester,
    ) async {
      _keyboard();
      final before = FocusNode();
      addTearDown(before.dispose);
      selected = 'b';
      await tester.pumpWidget(radios(['a', 'b', 'c'], before: before));
      before.requestFocus();
      await tester.pump();
      // The harness has no WidgetsApp, so no Tab shortcut: ask for the next
      // focus as the shortcut does.
      FocusManager.instance.primaryFocus!.nextFocus();
      await tester.pump();
      expect(focused(tester, 'b'), isTrue);
      // Tab again leaves the group: no other radio is a tab stop.
      // The harness has no WidgetsApp, so no Tab shortcut: ask for the next
      // focus as the shortcut does.
      FocusManager.instance.primaryFocus!.nextFocus();
      await tester.pump();
      expect(focused(tester, 'a'), isFalse);
      expect(focused(tester, 'b'), isFalse);
      expect(focused(tester, 'c'), isFalse);
      // The tab stop follows the selection.
      before.requestFocus();
      await tester.pump();
      // The harness has no WidgetsApp, so no Tab shortcut: ask for the next
      // focus as the shortcut does.
      FocusManager.instance.primaryFocus!.nextFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(selected, 'c');
      before.requestFocus();
      await tester.pump();
      // The harness has no WidgetsApp, so no Tab shortcut: ask for the next
      // focus as the shortcut does.
      FocusManager.instance.primaryFocus!.nextFocus();
      await tester.pump();
      expect(focused(tester, 'c'), isTrue);
    });

    testWidgets('with none selected Tab reaches the first enabled radio', (
      tester,
    ) async {
      _keyboard();
      final before = FocusNode();
      addTearDown(before.dispose);
      selected = null;
      await tester.pumpWidget(
        radios(['a', 'b', 'c'], before: before, disabled: {'a'}),
      );
      before.requestFocus();
      await tester.pump();
      // The harness has no WidgetsApp, so no Tab shortcut: ask for the next
      // focus as the shortcut does.
      FocusManager.instance.primaryFocus!.nextFocus();
      await tester.pump();
      expect(focused(tester, 'b'), isTrue);
    });

    testWidgets('names the group, with the error as its description', (
      tester,
    ) async {
      await tester.pumpWidget(
        radios(
          ['a', 'b'],
          label: 'طريقة الدفع',
          hint: 'اختر واحدة',
          error: 'اختر طريقة الدفع',
        ),
      );
      final node = tester.getSemantics(find.byType(FoxRadioGroup));
      expect(node.label, contains('طريقة الدفع'));
      expect(node.hint, 'اختر طريقة الدفع');
      expect(find.text('اختر طريقة الدفع'), findsOneWidget);
      expect(find.text('اختر واحدة'), findsNothing);
      await tester.pumpWidget(
        radios(['a', 'b'], label: 'طريقة الدفع', hint: 'اختر واحدة'),
      );
      expect(
        tester.getSemantics(find.byType(FoxRadioGroup)).hint,
        'اختر واحدة',
      );
      await expectNoOverflow(
        tester,
        () => FoxRadioGroup(
          label: 'طريقة الدفع',
          error: 'اختر طريقة الدفع',
          child: Column(
            children: [
              FoxRadio<int>(
                value: 1,
                groupValue: 1,
                onChanged: (_) {},
                label: 'نقدًا',
              ),
            ],
          ),
        ),
      );
    });

    testWidgets('skips a disabled radio', (tester) async {
      await tester.pumpWidget(radios(['a', 'b', 'c'], disabled: {'b'}));
      await focusFirst(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      expect(seen, ['c']);
    });

    testWidgets('does nothing outside a group', (tester) async {
      await tester.pumpWidget(radios(['a', 'b'], grouped: false));
      await focusFirst(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      expect(seen, isEmpty);
    });

    testWidgets('a radio still takes Space and taps in a group', (
      tester,
    ) async {
      await tester.pumpWidget(radios(['a', 'b']));
      await tester.tap(find.text('b'));
      expect(seen, ['b']);
    });
  });

  group('FoxSwitch', () {
    Widget toggle(bool value, ValueChanged<bool>? onChanged) => formApp(
      FoxSwitch(value: value, onChanged: onChanged, label: 'الإشعارات'),
    );

    testWidgets('is a 52 by 32 track in a 48 target, a toggle by name', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(toggle(false, (_) {}));
      expect(
        tester.getSize(find.byType(AnimatedContainer).first),
        const Size(52, 32),
      );
      expect(tester.getSize(find.byType(FoxSwitch)).height, 48);
      expect(
        tester.getSemantics(find.byType(FoxSwitch)),
        matchesSemantics(
          label: 'الإشعارات',
          hasToggledState: true,
          isToggled: false,
          hasEnabledState: true,
          isEnabled: true,
          isFocusable: true,
          hasTapAction: true,
          hasFocusAction: true,
        ),
      );
      semantics.dispose();
    });

    testWidgets('off rests at the start, on slides to the end', (tester) async {
      for (final direction in TextDirection.values) {
        await tester.pumpWidget(
          formApp(
            FoxSwitch(value: false, onChanged: (_) {}, label: 'x'),
            direction: direction,
          ),
        );
        final track = tester.getRect(find.byType(AnimatedContainer).first);
        final off = tester.getRect(find.byType(DecoratedBox).last);
        final rtl = direction == TextDirection.rtl;
        expect(
          rtl ? track.right - off.right : off.left - track.left,
          4,
          reason: '$direction off',
        );
        await tester.pumpWidget(
          formApp(
            FoxSwitch(value: true, onChanged: (_) {}, label: 'x'),
            direction: direction,
          ),
        );
        await tester.pump(const Duration(milliseconds: 300));
        final on = tester.getRect(find.byType(DecoratedBox).last);
        expect(
          rtl ? on.left - track.left : track.right - on.right,
          4,
          reason: '$direction on',
        );
      }
    });

    testWidgets('a tap and Space toggle it', (tester) async {
      _keyboard();
      final seen = <bool>[];
      await tester.pumpWidget(toggle(false, seen.add));
      await tester.tap(find.byType(FoxSwitch));
      Focus.of(tester.element(find.byType(GestureDetector))).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      expect(seen, [true, true]);
      expect(_ring, findsOneWidget);
    });

    testWidgets('the track takes the tokens of each state', (tester) async {
      Color track() =>
          (tester
                      .widget<AnimatedContainer>(
                        find.byType(AnimatedContainer).first,
                      )
                      .decoration!
                  as BoxDecoration)
              .color!;
      await tester.pumpWidget(toggle(false, (_) {}));
      expect(track(), _i.switchTrack);
      await hover(tester, find.byType(FoxSwitch));
      expect(track(), _i.switchTrackHover);
      // Unchecked and pressed has its own token, not the hover one.
      final press = await tester.startGesture(
        tester.getCenter(find.byType(FoxSwitch)),
      );
      await tester.pump(const Duration(milliseconds: 250));
      expect(track(), _i.switchTrackPressed);
      expect(_i.switchTrackPressed, isNot(_i.switchTrackHover));
      await press.up();
      await tester.pumpWidget(toggle(true, (_) {}));
      expect(track(), _i.switchTrackOn);
      await tester.pumpWidget(toggle(true, null));
      expect(track(), _i.disabled);
    });

    testWidgets('keeps its thumb still when animations are off', (
      tester,
    ) async {
      await tester.pumpWidget(
        formApp(
          FoxSwitch(value: true, onChanged: (_) {}, label: 'x'),
          disableAnimations: true,
        ),
      );
      expect(
        tester.widget<AnimatedAlign>(find.byType(AnimatedAlign)).duration,
        Duration.zero,
      );
    });

    testWidgets('fits at every scale', (tester) async {
      await expectNoOverflow(
        tester,
        () => FoxSwitch(value: true, onChanged: (_) {}, label: 'x'),
      );
    });
  });

  group('FoxQuantityStepper', () {
    Widget stepper(
      int value, {
      int? max,
      VoidCallback? onDelete,
      ValueChanged<int>? onChanged,
      bool enabled = true,
    }) => formApp(
      FoxQuantityStepper(
        value: value,
        onChanged: onChanged ?? (_) {},
        onDelete: onDelete,
        max: max,
        enabled: enabled,
        label: 'الكمية',
        increaseLabel: 'زيادة',
        decreaseLabel: 'إنقاص',
        deleteLabel: 'حذف',
      ),
    );

    testWidgets('announces «الكمية 2» and has two named 48 buttons', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(stepper(2));
      final group = tester.getSemantics(find.bySemanticsLabel('الكمية'));
      expect(group.label, 'الكمية');
      expect(group.value, '2');
      for (final name in ['زيادة', 'إنقاص']) {
        final button = find.bySemanticsLabel(name);
        expect(button, findsOneWidget);
        expect(tester.getSize(button).width, greaterThanOrEqualTo(48));
        expect(tester.getSize(button).height, greaterThanOrEqualTo(48));
      }
      semantics.dispose();
    });

    testWidgets('the buttons take the stepper tokens and the focus width', (
      tester,
    ) async {
      BoxDecoration circle() =>
          (tester
                  .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
                  .firstWhere((c) => c.constraints?.maxWidth == _i.stepperSize)
                  .decoration!
              as BoxDecoration);
      await tester.pumpWidget(stepper(2));
      expect(circle().color, _i.stepperBackground);
      expect((circle().border! as Border).top.width, _i.focusWidth);
      await hover(tester, find.byType(Interaction).first);
      expect(circle().color, _i.stepperBackgroundHover);
      final press = await tester.startGesture(
        tester.getCenter(find.byType(Interaction).first),
      );
      await tester.pump(const Duration(milliseconds: 250));
      expect(circle().color, _i.stepperBackgroundPressed);
      await press.up();
    });

    testWidgets('«+» is at the start and «−» at the end', (tester) async {
      for (final direction in TextDirection.values) {
        await tester.pumpWidget(
          formApp(
            FoxQuantityStepper(
              value: 2,
              onChanged: (_) {},
              label: 'q',
              increaseLabel: 'زيادة',
              decreaseLabel: 'إنقاص',
              deleteLabel: 'حذف',
            ),
            direction: direction,
          ),
        );
        final plus = tester.getCenter(find.byType(Interaction).first);
        final minus = tester.getCenter(find.byType(Interaction).last);
        expect(
          direction == TextDirection.rtl
              ? plus.dx > minus.dx
              : plus.dx < minus.dx,
          isTrue,
          reason: '$direction',
        );
      }
    });

    testWidgets('changes the count and respects the maximum', (tester) async {
      final seen = <int>[];
      await tester.pumpWidget(stepper(2, max: 3, onChanged: seen.add));
      await tester.tap(find.bySemanticsLabel('زيادة'));
      await tester.tap(find.bySemanticsLabel('إنقاص'));
      expect(seen, [3, 1]);
      seen.clear();
      await tester.pumpWidget(stepper(3, max: 3, onChanged: seen.add));
      await tester.tap(find.byType(Interaction).first, warnIfMissed: false);
      expect(seen, isEmpty);
    });

    testWidgets('at the minimum «−» becomes delete', (tester) async {
      var deleted = 0;
      final seen = <int>[];
      await tester.pumpWidget(
        stepper(1, onChanged: seen.add, onDelete: () => deleted++),
      );
      expect(find.bySemanticsLabel('إنقاص'), findsNothing);
      expect(find.bySemanticsLabel('حذف'), findsOneWidget);
      expect(
        tester.widget<FoxIcon>(find.byType(FoxIcon).last).icon,
        FoxIcons.delete,
      );
      await tester.tap(find.bySemanticsLabel('حذف'));
      expect(deleted, 1);
      expect(seen, isEmpty);
    });

    testWidgets('Enter works on a focused button', (tester) async {
      _keyboard();
      final seen = <int>[];
      await tester.pumpWidget(stepper(2, onChanged: seen.add));
      Focus.of(
        tester.element(find.byType(GestureDetector).first),
      ).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(seen, [3]);
      expect(_ring, findsWidgets);
    });

    testWidgets('disabled dims both and ignores taps', (tester) async {
      final seen = <int>[];
      await tester.pumpWidget(stepper(2, onChanged: seen.add, enabled: false));
      await tester.tap(find.byType(Interaction).first, warnIfMissed: false);
      expect(seen, isEmpty);
      expect(
        tester.getSemantics(find.byType(Interaction).first),
        isNot(isSemantics(isFocusable: true)),
      );
    });

    testWidgets('fits at every scale', (tester) async {
      await expectNoOverflow(
        tester,
        () => FoxQuantityStepper(
          value: 12,
          onChanged: (_) {},
          onDelete: () {},
          label: 'الكمية',
          increaseLabel: 'زيادة',
          decreaseLabel: 'إنقاص',
          deleteLabel: 'حذف',
        ),
      );
    });
  });
}
