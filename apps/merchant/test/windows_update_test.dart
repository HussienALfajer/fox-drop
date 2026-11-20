import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:merchant/src/windows/update.dart';

import 'board_fixtures.dart';

// RA §4.2 on Windows (slice 2.44): Velopack's feed and the restart's rule.
void main() {
  AppVersion v(String text) => AppVersion.parse(text)!;

  test('orders versions as SemVer 2, pre-releases before their release', () {
    expect(v('0.1.0-staging.10') > v('0.1.0-staging.9'), isTrue);
    expect(v('0.1.0') > v('0.1.0-staging.99'), isTrue);
    expect(v('0.2.0-staging.1') > v('0.1.9'), isTrue);
    expect(v('1.0.0').compareTo(v('1.0.0+7')), 0);
    expect(AppVersion.parse('latest'), isNull);
  });

  test('takes the newest full package of the feed, never a path', () {
    final feed = jsonEncode({
      'Assets': [
        {
          'PackageId': 'FOXDROP.Merchant',
          'Version': '0.1.0-staging.12',
          'Type': 'Full',
          'FileName': 'FOXDROP.Merchant-0.1.0-staging.12-full.nupkg',
          'SHA256': 'AB12',
        },
        {
          'Version': '0.1.0-staging.13',
          'Type': 'Delta',
          'FileName': 'FOXDROP.Merchant-0.1.0-staging.13-delta.nupkg',
          'SHA256': 'CD34',
        },
        {
          'Version': '0.1.0-staging.14',
          'Type': 'Full',
          'FileName': '..\\evil.nupkg',
          'SHA256': 'EF56',
        },
      ],
    });
    final newest = newestFull(feed)!;
    expect(newest.version.text, '0.1.0-staging.12');
    expect(newest.sha256, 'ab12');
    expect(newestFull('{}'), isNull);
  });

  test('reads the installed version from Velopack’s manifest', () {
    expect(
      installedVersion(
        '<?xml version="1.0"?><package><metadata><id>FOXDROP.Merchant</id>'
        '<version>0.1.0-staging.12</version></metadata></package>',
      )?.text,
      '0.1.0-staging.12',
    );
  });

  test(
    'restarts only signed out, or with an empty board that rings nothing',
    () {
      expect(mayRestartForUpdate(signedIn: false, board: null), isTrue);
      expect(mayRestartForUpdate(signedIn: true, board: null), isFalse);
      expect(mayRestartForUpdate(signedIn: true, board: board([])), isTrue);
      // A placed order rings; an accepted one is active.
      expect(
        mayRestartForUpdate(signedIn: true, board: board([orderJson()])),
        isFalse,
      );
      expect(
        mayRestartForUpdate(
          signedIn: true,
          board: board([orderJson(status: 'accepted')]),
        ),
        isFalse,
      );
    },
  );
}
