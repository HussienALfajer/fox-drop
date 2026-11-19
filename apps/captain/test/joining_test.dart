import 'dart:typed_data';

import 'package:captain/src/joining/application.dart';
import 'package:captain/src/joining/photo_check.dart';
import 'package:captain/src/support/report_photo.dart';
import 'package:core_auth/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

// CA §5.1–5.4 (slice 2.34a): «انضم ككابتن», the form's steps and the
// documents' photo checks, and the status page.

const _zoneId = '00000000-0000-4000-8000-0000000000a1';

Map<String, Object?> _application({
  String stage = 'draft',
  String? vehicle = 'walking',
  List<Map<String, Object?>> documents = const [],
  List<String> missing = const [
    'document:national_id',
    'document:personal_photo',
    'document:civil_registry',
    'document:criminal_record',
    'terms',
  ],
}) => {
  'application': {
    'id': '00000000-0000-4000-8000-0000000000b1',
    'stage': stage,
    'fullName': 'محمد أحمد العلي',
    'birthDate': '2000-05-01',
    'zoneId': _zoneId,
    'vehicle': vehicle,
    'plate': null,
    'documents': documents,
    'missing': missing,
    'submittedAt': stage == 'draft' ? null : '2026-11-19T09:00:00.000Z',
  },
};

Map<String, Object?> _document(String kind, {String status = 'pending'}) => {
  'kind': kind,
  'status': status,
  'reason': status == 'rejected' ? 'الصورة مقصوصة' : null,
  'fileCount': kind == 'national_id' ? 2 : 1,
  'number': kind == 'national_id' ? '01234567890' : null,
  'issueDate': null,
  'expiresOn': null,
  'uploadedAt': '2026-11-19T08:00:00.000Z',
};

/// An applicant signed in: the session answers no captain.
TestApp _applicant(List<Map<String, Object?>> applications) {
  final app = TestApp();
  app.server.on('/v1/captain/auth/session', [
    const FakeAnswer(200, {
      'accountId': accountId,
      'captainId': null,
      'sessionId': '00000000-0000-4000-8000-000000000003',
    }),
  ]);
  app.server.on('/v1/captain/application', [
    for (final each in applications) FakeAnswer(200, each),
  ]);
  app.server.on('/v1/captain/application/zones', [
    const FakeAnswer(200, {
      'zones': [
        {
          'id': _zoneId,
          'name': 'الحي الشمالي',
          'cityId': '00000000-0000-4000-8000-0000000000c1',
          'cityName': 'اعزاز',
        },
      ],
    }),
  ]);
  return app;
}

final _jpeg = PickedPhoto(
  Uint8List.fromList([0xff, 0xd8, 0xff, 0xe0, 1, 2, 3]),
  'image/jpeg',
);

void main() {
  group('the photo check (CA §5.3)', () {
    Uint8List pixels(int width, int height, int Function(int x, int y) grey) {
      final rgba = Uint8List(width * height * 4);
      for (var y = 0; y < height; y++) {
        for (var x = 0; x < width; x++) {
          final at = (y * width + x) * 4;
          final value = grey(x, y);
          rgba[at] = value;
          rgba[at + 1] = value;
          rgba[at + 2] = value;
          rgba[at + 3] = 255;
        }
      }
      return rgba;
    }

    test('asks for a retake of a dark or a blurred photo', () {
      expect(
        photoQuality(pixels(40, 40, (x, y) => 20), 40, 40),
        PhotoQuality.dark,
      );
      // Bright but without an edge: blurred.
      expect(
        photoQuality(pixels(40, 40, (x, y) => 180 + (x ~/ 10)), 40, 40),
        PhotoQuality.blurry,
      );
      // Sharp text-like edges.
      expect(
        photoQuality(
          pixels(40, 40, (x, y) => (x ~/ 2 + y ~/ 2).isEven ? 230 : 40),
          40,
          40,
        ),
        PhotoQuality.ok,
      );
    });
  });

  group('the form rules (CA §5.2–5.3)', () {
    test('opens a draft at its first step with something missing', () {
      expect(firstOpenStep(null), personalStep);
      Application of(List<Missing> missing) => Application(
        stage: ApplicationStage.draft,
        fullName: 'محمد أحمد العلي',
        birthDate: '2000-05-01',
        zoneId: _zoneId,
        vehicle: Vehicle.walking,
        plate: null,
        documents: const [],
        missing: missing,
      );
      expect(firstOpenStep(of(const [MissingVehicle()])), vehicleStep);
      expect(
        firstOpenStep(
          of(const [
            MissingDocument(DocumentKind.civilRegistry),
            MissingTerms(),
          ]),
        ),
        documentsStep,
      );
      expect(firstOpenStep(of(const [MissingTerms()])), termsStep);
      expect(firstOpenStep(of(const [])), reviewStep);
    });

    test('shows the vehicle papers for a motor vehicle only', () {
      expect(formDocuments(Vehicle.car), contains(DocumentKind.vehiclePapers));
      expect(
        formDocuments(Vehicle.bicycle),
        isNot(contains(DocumentKind.vehiclePapers)),
      );
      expect(formDocuments(null), contains(DocumentKind.drivingLicence));
    });
  });

  testWidgets('«انضم ككابتن» sends the join code and opens the form', (
    tester,
  ) async {
    final app = _applicant([
      {'application': null},
    ]);
    await app.pump(tester, stored: {});
    await tester.tap(find.byKey(const Key('welcome-join')));
    await tester.pumpAndSettle();
    expect(find.text('انضم ككابتن'), findsWidgets);

    app.server.on('/v1/captain/auth/code', [
      FakeAnswer(200, {
        'channel': 'whatsapp',
        'resendAfterSec': 60,
        'expiresAt': DateTime.now()
            .add(const Duration(minutes: 5))
            .toUtc()
            .toIso8601String(),
      }),
    ]);
    app.server.on('/v1/captain/auth/sign-in', [
      FakeAnswer(200, {
        'accountId': accountId,
        'captainId': null,
        ...tokens('1', DateTime.now().add(const Duration(minutes: 15))),
      }),
    ]);
    await tester.enterText(find.byKey(const Key('sign-in-phone')), '944123456');
    await tester.tap(find.text('إرسال الرمز'));
    await tester.pumpAndSettle();
    expect(
      (app.server.to('/v1/captain/auth/code').single.data as Map)['join'],
      true,
    );
    await tester.enterText(find.byKey(const Key('sign-in-code')), '123456');
    await app.settle(tester);

    expect(find.text('طلب الانضمام'), findsOneWidget);
    expect(find.byKey(const Key('application-name')), findsOneWidget);
    // No captain call is made for an applicant.
    expect(app.server.to('/v1/captain/availability'), isEmpty);
    expect(app.server.to('/v1/captain/push-token'), isEmpty);
    await app.done(tester);
  });

  testWidgets('saves step 1 and moves on', (tester) async {
    final app = _applicant([
      {'application': null},
    ]);
    app.server.on('/v1/captain/application/personal', [
      FakeAnswer(200, _application(vehicle: null, missing: ['vehicle'])),
    ]);
    await app.pump(tester);
    await tester.enterText(
      find.byKey(const Key('application-name')),
      'محمد أحمد العلي',
    );
    await tester.tap(find.byKey(const Key('application-birth-date')));
    await tester.pumpAndSettle();
    final ok = MaterialLocalizations.of(
      tester.element(find.byType(DatePickerDialog)),
    ).okButtonLabel;
    await tester.tap(find.text(ok));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('application-zone')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('الحي الشمالي').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('application-save-personal')));
    await app.settle(tester);

    final body =
        app.server.to('/v1/captain/application/personal').single.data as Map;
    expect(body['fullName'], 'محمد أحمد العلي');
    expect(body['zoneId'], _zoneId);
    expect(body['birthDate'], matches(RegExp(r'^\d{4}-01-01$')));
    expect(
      find.byKey(const Key('application-vehicle-walking')),
      findsOneWidget,
    );
    await app.done(tester);
  });

  testWidgets('checks each document photo, then uploads and saves it', (
    tester,
  ) async {
    final app = _applicant([_application()]);
    app.server.on('/v1/captain/application/documents/upload', [
      const FakeAnswer(201, {
        'uploadId': '00000000-0000-4000-8000-0000000000d1',
        'url': 'https://storage.example/private-docs/incoming/1.jpg',
        'expiresAt': '2026-11-19T10:00:00.000Z',
      }),
      const FakeAnswer(201, {
        'uploadId': '00000000-0000-4000-8000-0000000000d2',
        'url': 'https://storage.example/private-docs/incoming/2.jpg',
        'expiresAt': '2026-11-19T10:00:00.000Z',
      }),
    ]);
    app.server.on('/v1/captain/application/documents/national_id', [
      FakeAnswer(
        200,
        _application(
          documents: [_document('national_id')],
          missing: [
            'document:personal_photo',
            'document:civil_registry',
            'document:criminal_record',
            'terms',
          ],
        ),
      ),
    ]);
    await app.pump(tester);
    // The draft opens at the documents.
    expect(find.text('لم يُرفع بعد'), findsWidgets);
    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('application-document-national_id')),
        matching: find.text('رفع'),
      ),
    );
    await tester.pumpAndSettle();

    // A blurred photo is refused before any upload.
    app.photoQuality = PhotoQuality.blurry;
    app.picked.add(_jpeg);
    await tester.tap(find.byKey(const Key('document-camera')));
    await tester.pumpAndSettle();
    expect(find.text('الصورة غير واضحة. أعد التصوير.'), findsOneWidget);
    expect(app.server.to('/v1/captain/application/documents/upload'), isEmpty);

    app.photoQuality = PhotoQuality.ok;
    app.picked.addAll([_jpeg, _jpeg]);
    await tester.tap(find.byKey(const Key('document-camera')));
    await tester.pumpAndSettle();
    expect(find.text('الوجه الأمامي'), findsOneWidget);
    await tester.tap(find.byKey(const Key('document-camera')));
    await tester.pumpAndSettle();
    expect(find.text('الوجه الخلفي'), findsOneWidget);
    expect(app.pickedFrom, everyElement(PhotoSource.camera));
    await tester.enterText(
      find.byKey(const Key('document-number')),
      '01234567890',
    );
    await tester.tap(find.byKey(const Key('document-save')));
    await app.settle(tester);
    await tester.pumpAndSettle();

    expect(app.puts, hasLength(2));
    final saved =
        app.server
                .to('/v1/captain/application/documents/national_id')
                .single
                .data
            as Map;
    expect(saved['uploadIds'], [
      '00000000-0000-4000-8000-0000000000d1',
      '00000000-0000-4000-8000-0000000000d2',
    ]);
    expect(saved['number'], '01234567890');
    expect(find.text('بانتظار التحقق'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('sends the application and shows its status (CA §5.4)', (
    tester,
  ) async {
    final complete = [
      _document('national_id'),
      _document('personal_photo'),
      _document('civil_registry'),
      _document('criminal_record'),
    ];
    final app = _applicant([_application(documents: complete, missing: [])]);
    app.server.on('/v1/captain/application/submit', [
      FakeAnswer(
        200,
        _application(stage: 'new', documents: complete, missing: []),
      ),
    ]);
    await app.pump(tester);
    await app.tapVisible(tester, find.byKey(const Key('application-submit')));
    await app.settle(tester);

    expect(app.server.to('/v1/captain/application/submit'), hasLength(1));
    expect(find.text('أُرسل طلبك. سنراجعه قريباً.'), findsOneWidget);
    expect(find.text('بانتظار التحقق'), findsNWidgets(4));
    await app.done(tester);
  });

  testWidgets('a rejected document shows its reason', (tester) async {
    final app = _applicant([
      _application(
        stage: 'under_review',
        documents: [_document('personal_photo', status: 'rejected')],
        missing: [],
      ),
    ]);
    await app.pump(tester);
    expect(find.text('طلبك قيد المراجعة.'), findsOneWidget);
    expect(find.text('مرفوض: الصورة مقصوصة'), findsOneWidget);
    await app.done(tester);
  });
}
