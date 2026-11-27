import 'package:core_auth/testing.dart';
import 'package:customer/src/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support.dart';

const _saved = FakeAnswer(200, {
  'completed': true,
  'phone': '+963944123456',
  'profile': {
    'firstName': 'أحمد',
    'lastName': 'الحلبي',
    'gender': 'male',
    'birthday': null,
  },
});

void main() {
  test('names follow CU §5.3', () {
    expect(validName('أحمد'), isTrue);
    expect(validName('Ahmad'), isTrue);
    expect(validName('عبد الرحمن'), isTrue);
    expect(validName('آل-حسن'), isTrue);
    expect(validName('مُحمّد'), isTrue);
    expect(validName('أ'), isFalse);
    expect(validName('Ahmad1'), isFalse);
    expect(validName('أحمد٣'), isFalse);
    expect(validName('a' * 31), isFalse);
    expect(validName(' - '), isFalse);
  });

  // No sign-in screen yet: the account starts signed in, its details not
  // completed.
  testWidgets(
    'a new account completes its details, then returns where it was',
    (tester) async {
      final app = TestApp(signedIn: true);
      app.server.on('/v1/customer/profile', [
        const FakeAnswer(200, {
          'completed': false,
          'profile': null,
          'phone': '+963944123456',
        }),
        _saved,
      ]);
      await app.pump(tester);

      expect(find.text('أكمل بياناتك'), findsOneWidget);
      await tester.tap(find.text('حفظ'));
      await tester.pumpAndSettle();
      expect(find.text('اكتب من 2 إلى 30 حرفاً عربياً أو لاتينياً'), findsOne);
      expect(find.text('اختر الجنس'), findsOneWidget);
      expect(find.text('يجب الموافقة على الشروط للمتابعة'), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('profile-first-name')),
        'أحمد',
      );
      await tester.enterText(
        find.byKey(const Key('profile-last-name')),
        'الحلبي',
      );
      await tester.tap(find.text('ذكر'));
      await tester.tap(find.byKey(const Key('profile-terms')));
      await tester.pump();
      await tester.tap(find.text('حفظ'));
      await tester.pumpAndSettle();

      final saves = app.server
          .to('/v1/customer/profile')
          .where((request) => request.method == 'PUT');
      expect(saves, hasLength(1));
      expect(saves.single.data, {
        'firstName': 'أحمد',
        'lastName': 'الحلبي',
        'gender': 'male',
        'birthday': null,
        'acceptTerms': true,
      });
      expect(find.text('أكمل بياناتك'), findsNothing);
      expect(find.text('أين نوصل طلبك؟'), findsOneWidget);
    },
  );

  testWidgets('an app stopped before the details shows them again', (
    tester,
  ) async {
    final app = TestApp(signedIn: true);
    app.server.on('/v1/customer/profile', [
      const FakeAnswer(200, {
        'completed': false,
        'profile': null,
        'phone': '+963944123456',
      }),
    ]);
    await app.pump(tester);

    expect(find.text('أكمل بياناتك'), findsOneWidget);
  });
}
