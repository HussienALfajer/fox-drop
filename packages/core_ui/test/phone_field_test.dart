import 'package:core_ui/core_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'overlays_harness.dart';
import 'phone_harness.dart';

// D.11 items 5 to 7 and 11: the phone field for every country and its list.
const _countries = testCountries;
final _strings = testPhoneStrings;

/// The field with its own country state, as a screen keeps it.
class _Host extends StatefulWidget {
  const _Host({
    this.busy = false,
    this.lastUsed,
    this.onSubmitted,
    this.readings,
  });

  final bool busy;
  final String? lastUsed;
  final ValueChanged<String>? onSubmitted;
  final List<FoxPhoneReading>? readings;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  String country = 'SY';

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsetsDirectional.all(FoxSpace.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FoxPhoneField(
            label: 'رقم الهاتف',
            country: country,
            countries: _countries,
            strings: _strings,
            busy: widget.busy,
            lastUsedCountry: widget.lastUsed,
            onCountryChanged: (next) => setState(() => country = next),
            onChanged: (reading) => widget.readings?.add(reading),
            onSubmitted: widget.onSubmitted,
          ),
          // Something else to move the focus to.
          const FoxTextField(label: 'الاسم'),
        ],
      ),
    ),
  );
}

Finder get _number => find.byType(EditableText).first;

String _text(WidgetTester tester) =>
    tester.widget<EditableText>(_number).controller.text;

List<String> _radios(WidgetTester tester) => tester
    .widgetList<FoxRadio<String>>(find.byType(FoxRadio<String>))
    .map((r) => r.value)
    .toList();

void main() {
  testWidgets('names the chip by the country, the code once, left to right', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(overlayApp(const _Host()));
    expect(
      find.bySemanticsLabel('الدولة: سوريا، +963. اضغط لتغييرها'),
      findsOneWidget,
    );
    expect(find.text('+963'), findsOneWidget);
    expect(find.text('SY'), findsOneWidget);
    final island = tester.widget<Directionality>(
      find
          .ancestor(
            of: find.text('+963'),
            matching: find.byType(Directionality),
          )
          .first,
    );
    expect(island.textDirection, TextDirection.ltr);
    final field = tester.widget<EditableText>(_number);
    expect(field.keyboardType, TextInputType.phone);
    expect(field.textInputAction, TextInputAction.send);
    expect(field.autofillHints, contains(AutofillHints.telephoneNumber));
    semantics.dispose();
  });

  testWidgets('reports the reading, and the valid mark only when complete', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    final readings = <FoxPhoneReading>[];
    await tester.pumpWidget(overlayApp(_Host(readings: readings)));
    await tester.enterText(_number, '094412345');
    await tester.pump();
    expect(find.bySemanticsLabel('الرقم صحيح'), findsNothing);
    await tester.enterText(_number, '0944123456');
    await tester.pump();
    expect(readings.last.e164, '+963944123456');
    expect(find.bySemanticsLabel('الرقم صحيح'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('no problem while typing; on leaving; live until fixed', (
    tester,
  ) async {
    await tester.pumpWidget(overlayApp(const _Host()));
    await tester.enterText(_number, '094412345');
    await tester.pump();
    expect(find.text('ينقص 1 أرقام.'), findsNothing);
    await tester.tap(find.byType(EditableText).last);
    await tester.pump();
    expect(find.text('ينقص 1 أرقام.'), findsOneWidget);
    await tester.enterText(_number, '0944123456');
    await tester.pump();
    expect(find.text('ينقص 1 أرقام.'), findsNothing);
  });

  testWidgets('the send key shows the problem, or sends a complete number', (
    tester,
  ) async {
    final sent = <String>[];
    await tester.pumpWidget(overlayApp(_Host(onSubmitted: sent.add)));
    await tester.enterText(_number, '0112345678');
    await tester.testTextInput.receiveAction(TextInputAction.send);
    await tester.pump();
    expect(
      find.text('هذا رقم أرضي. أدخل رقم جوال عليه واتساب.'),
      findsOneWidget,
    );
    expect(sent, isEmpty);
    await tester.enterText(_number, '0944123456');
    await tester.testTextInput.receiveAction(TextInputAction.send);
    await tester.pump();
    expect(sent, ['+963944123456']);
  });

  testWidgets('a pasted mobile of another country switches the chip', (
    tester,
  ) async {
    await tester.pumpWidget(overlayApp(const _Host()));
    await tester.enterText(_number, '+49 151 23456789');
    await tester.pump();
    expect(find.text('DE'), findsOneWidget);
    expect(find.text('+49'), findsOneWidget);
    expect(_text(tester), '151 234 567 89');
    expect(find.text('عرفنا الدولة من رمزها: ألمانيا.'), findsOneWidget);
  });

  testWidgets('the clear button empties it', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(overlayApp(const _Host()));
    await tester.enterText(_number, '0944');
    await tester.pump();
    await tester.tap(find.bySemanticsLabel('مسح الرقم'));
    await tester.pump();
    expect(_text(tester), '');
    semantics.dispose();
  });

  testWidgets('is locked while busy', (tester) async {
    await tester.pumpWidget(overlayApp(const _Host(busy: true)));
    expect(tester.widget<EditableText>(_number).readOnly, isTrue);
    expect(find.bySemanticsLabel('مسح الرقم'), findsNothing);
  });

  group('the country sheet', () {
    testWidgets('Syria and Turkey first, then the last used, then the rest', (
      tester,
    ) async {
      phoneScreen(tester);
      await tester.pumpWidget(overlayApp(const _Host(lastUsed: 'DE')));
      await tester.tap(find.text('SY'));
      await tester.pumpAndSettle();
      for (final title in ['الأكثر استعمالاً', 'آخر ما استعملته', 'كل الدول']) {
        expect(find.text(title), findsOneWidget);
      }
      expect(_radios(tester), ['SY', 'TR', 'DE', 'IS']);
    });

    testWidgets('searches by Arabic, English and the calling code', (
      tester,
    ) async {
      phoneScreen(tester);
      await tester.pumpWidget(overlayApp(const _Host()));
      await tester.tap(find.text('SY'));
      await tester.pumpAndSettle();
      final search = find.descendant(
        of: find.byType(FoxCountrySheet),
        matching: find.byType(EditableText),
      );
      for (final query in ['ألمان', 'germ', '+49', '٤٩']) {
        await tester.enterText(search, query);
        await tester.pump();
        expect(_radios(tester), ['DE'], reason: query);
      }
      await tester.enterText(search, 'zzzz');
      await tester.pump();
      expect(find.text('لا دولة بهذا الاسم أو الرمز'), findsOneWidget);
    });

    testWidgets('picking closes it and switches the chip', (tester) async {
      phoneScreen(tester);
      await tester.pumpWidget(overlayApp(const _Host()));
      await tester.tap(find.text('SY'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('تركيا'));
      await tester.pumpAndSettle();
      expect(find.byType(FoxCountrySheet), findsNothing);
      expect(find.text('TR'), findsOneWidget);
      expect(find.text('+90'), findsOneWidget);
    });

    testWidgets('draws no flags: a name and a code per row', (tester) async {
      phoneScreen(tester);
      await tester.pumpWidget(overlayApp(const _Host()));
      await tester.tap(find.text('SY'));
      await tester.pumpAndSettle();
      final flag = RegExp('[\u{1F1E6}-\u{1F1FF}]', unicode: true);
      for (final text in tester.widgetList<Text>(
        find.descendant(
          of: find.byType(FoxCountrySheet),
          matching: find.byType(Text),
        ),
      )) {
        expect(flag.hasMatch(text.data ?? ''), isFalse);
      }
    });
  });

  testWidgets('fits at every scale', (tester) async {
    await expectNoOverflowInApp(tester, () => const _Host());
  });
}
