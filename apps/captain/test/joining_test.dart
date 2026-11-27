import 'dart:typed_data';

import 'package:captain/src/joining/application.dart';
import 'package:captain/src/joining/photo_check.dart';
import 'package:captain/src/joining/texts.dart';
import 'package:captain/src/support/report_photo.dart';
import 'package:core_auth/testing.dart';
import 'package:core_l10n/core_l10n.dart';
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
  List<Map<String, Object?>> requests = const [],
  Map<String, Object?>? interview,
  Map<String, Object?>? rejection,
  List<Map<String, Object?>> history = const [],
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
    'requests': requests,
    'interview': interview,
    'rejection': rejection,
    'history': history,
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

  // Slice 2.34b: the status page at every stage (CA §5.4), a document
  // uploaded again, the history and re-applying after a rejection (K11).
  group('the status rules (CA §5.3–5.4, K11)', () {
    Application of(
      ApplicationStage stage, {
      List<ApplicationDocument> documents = const [],
      List<DocumentRequest> requests = const [],
      Interview? interview,
      Rejection? rejection,
    }) => Application(
      stage: stage,
      fullName: 'محمد أحمد العلي',
      birthDate: '2000-05-01',
      zoneId: _zoneId,
      vehicle: Vehicle.walking,
      plate: null,
      documents: documents,
      missing: const [],
      requests: requests,
      interview: interview,
      rejection: rejection,
    );
    const accepted = ApplicationDocument(
      kind: DocumentKind.nationalId,
      status: DocumentStatus.accepted,
    );
    const rejected = ApplicationDocument(
      kind: DocumentKind.personalPhoto,
      status: DocumentStatus.rejected,
      reason: 'الصورة مقصوصة',
    );
    final request = DocumentRequest(
      kind: DocumentKind.criminalRecord,
      reason: 'الشهادة قديمة',
      requestedAt: DateTime.utc(2026, 11, 7),
    );

    test('uploads again only a requested or rejected document, while the '
        'application is open', () {
      for (final stage in [
        ApplicationStage.newApplication,
        ApplicationStage.underReview,
        ApplicationStage.interview,
        ApplicationStage.awaitingKit,
        ApplicationStage.waitlist,
      ]) {
        final application = of(
          stage,
          documents: const [accepted, rejected],
          requests: [request],
        );
        expect(canUploadAgain(application, DocumentKind.nationalId), isFalse);
        expect(canUploadAgain(application, DocumentKind.personalPhoto), isTrue);
        expect(
          canUploadAgain(application, DocumentKind.criminalRecord),
          isTrue,
        );
        expect(
          canUploadAgain(application, DocumentKind.civilRegistry),
          isFalse,
        );
      }
      for (final stage in [
        ApplicationStage.draft,
        ApplicationStage.active,
        ApplicationStage.rejected,
      ]) {
        expect(
          canUploadAgain(
            of(stage, documents: const [rejected], requests: [request]),
            DocumentKind.personalPhoto,
          ),
          isFalse,
        );
      }
      // The page lists the uploaded and the requested documents.
      expect(
        statusDocuments(
          of(
            ApplicationStage.underReview,
            documents: const [accepted, rejected],
            requests: [request],
          ),
        ),
        [
          DocumentKind.nationalId,
          DocumentKind.personalPhoto,
          DocumentKind.criminalRecord,
        ],
      );
    });

    test('re-applying opens at reapplyFrom on the server clock', () {
      final rejection = Rejection(
        reason: 'المستندات غير مكتملة',
        at: DateTime.utc(2026, 10, 8),
        reapplyFrom: DateTime.utc(2026, 11, 7),
      );
      final application = of(ApplicationStage.rejected, rejection: rejection);
      expect(canReapply(application, DateTime.utc(2026, 11, 6, 23)), isFalse);
      expect(canReapply(application, DateTime.utc(2026, 11, 7)), isTrue);
      expect(canReapply(of(ApplicationStage.rejected), now), isFalse);
      expect(
        canReapply(of(ApplicationStage.waitlist, rejection: rejection), now),
        isFalse,
      );
    });

    test('each stage has the words of CA §5.4', () {
      final l10n = lookupAppLocalizations(const Locale('ar'));
      expect(
        stageText(l10n, of(ApplicationStage.newApplication)),
        'أُرسل طلبك. سنراجعه قريباً.',
      );
      expect(
        stageText(l10n, of(ApplicationStage.underReview)),
        'طلبك قيد المراجعة.',
      );
      expect(requestText(l10n, request), 'يرجى رفع لا حكم عليه: الشهادة قديمة');
      expect(
        stageText(
          l10n,
          of(
            ApplicationStage.interview,
            interview: Interview(
              at: DateTime.utc(2026, 11, 8, 7),
              place: 'مكتب اعزاز',
              latitude: 36.586,
              longitude: 37.044,
            ),
          ),
        ),
        'موعد المقابلة والتدريب: الأحد 08/11/2026 10:00 ص في مكتب اعزاز',
      );
      expect(
        stageText(l10n, of(ApplicationStage.awaitingKit)),
        'اجتزت التدريب. استلم العدة ووقّع العقد في المكتب.',
      );
      expect(
        stageText(l10n, of(ApplicationStage.waitlist)),
        'لا نحتاج كباتن جدداً حالياً. طلبك محفوظ وسنتواصل معك.',
      );
      expect(
        stageText(
          l10n,
          of(
            ApplicationStage.rejected,
            rejection: Rejection(
              reason: 'المستندات غير مكتملة',
              at: DateTime.utc(2026, 11, 1),
              reapplyFrom: DateTime.utc(2026, 12, 1),
            ),
          ),
        ),
        'نعتذر، لم يُقبل طلبك: المستندات غير مكتملة. '
        'يمكنك التقديم مجدداً بعد 01/12/2026.',
      );
      expect(
        historyText(
          l10n,
          StageChange(ApplicationStage.underReview, DateTime.utc(2026, 11, 7)),
        ),
        'قيد المراجعة: 07/11/2026 3:00 ص',
      );
    });
  });

  testWidgets('a requested or rejected document is uploaded again from the '
      'status page', (tester) async {
    final requests = [
      {
        'kind': 'criminal_record',
        'reason': 'الشهادة قديمة',
        'requestedAt': '2026-11-07T08:00:00.000Z',
      },
    ];
    final app = _applicant([
      _application(
        stage: 'under_review',
        documents: [
          _document('national_id', status: 'accepted'),
          _document('personal_photo', status: 'rejected'),
        ],
        missing: [],
        requests: requests,
      ),
    ]);
    app.server.on('/v1/captain/application/documents/upload', [
      const FakeAnswer(201, {
        'uploadId': '00000000-0000-4000-8000-0000000000d3',
        'url': 'https://storage.example/private-docs/incoming/3.jpg',
        'expiresAt': '2026-11-07T13:00:00.000Z',
      }),
    ]);
    app.server.on('/v1/captain/application/documents/personal_photo', [
      FakeAnswer(
        200,
        _application(
          stage: 'under_review',
          documents: [
            _document('national_id', status: 'accepted'),
            _document('personal_photo'),
          ],
          missing: [],
          requests: requests,
        ),
      ),
    ]);
    await app.pump(tester);
    expect(find.text('طلبك قيد المراجعة.'), findsOneWidget);
    expect(find.text('يرجى رفع لا حكم عليه: الشهادة قديمة'), findsOneWidget);
    expect(find.text('مقبول'), findsOneWidget);
    expect(find.text('رفع نسخة جديدة'), findsNWidgets(2));
    expect(
      find.descendant(
        of: find.byKey(const Key('application-document-national_id')),
        matching: find.text('رفع نسخة جديدة'),
      ),
      findsNothing,
    );

    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('application-document-personal_photo')),
        matching: find.text('رفع نسخة جديدة'),
      ),
    );
    await tester.pumpAndSettle();
    // The form's photo checks hold here too.
    app.photoQuality = PhotoQuality.dark;
    app.picked.add(_jpeg);
    await tester.tap(find.byKey(const Key('document-camera')));
    await tester.pumpAndSettle();
    expect(
      find.text('الصورة مظلمة. أعد التصوير في مكان أكثر إضاءة.'),
      findsOneWidget,
    );
    expect(app.pickedFrom.last, PhotoSource.frontCamera);
    app.photoQuality = PhotoQuality.ok;
    app.picked.add(_jpeg);
    await tester.tap(find.byKey(const Key('document-camera')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('document-save')));
    await app.settle(tester);
    await tester.pumpAndSettle();

    expect(app.puts, hasLength(1));
    expect(
      (app.server
              .to('/v1/captain/application/documents/personal_photo')
              .single
              .data
          as Map)['uploadIds'],
      ['00000000-0000-4000-8000-0000000000d3'],
    );
    expect(find.text('بانتظار التحقق'), findsOneWidget);
    // Only the requested document is left to upload.
    expect(find.text('رفع نسخة جديدة'), findsOneWidget);
    await app.done(tester);
  });

  testWidgets('the interview shows its appointment, the office on the map '
      'and the history', (tester) async {
    final app = _applicant([
      _application(
        stage: 'interview',
        documents: [_document('national_id', status: 'accepted')],
        missing: [],
        interview: {
          'at': '2026-11-08T07:00:00.000Z',
          'place': 'مكتب اعزاز',
          'latitude': 36.586,
          'longitude': 37.044,
        },
        history: [
          {'stage': 'new', 'at': '2026-11-05T09:00:00.000Z'},
          {'stage': 'under_review', 'at': '2026-11-06T10:30:00.000Z'},
          {'stage': 'interview', 'at': '2026-11-07T11:00:00.000Z'},
        ],
      ),
    ]);
    await app.pump(tester);
    expect(
      find.text(
        'موعد المقابلة والتدريب: الأحد 08/11/2026 10:00 ص في مكتب اعزاز',
      ),
      findsOneWidget,
    );
    expect(find.text('رفع نسخة جديدة'), findsNothing);
    // The history, oldest first, on the city's clock.
    expect(find.text('مراحل الطلب'), findsOneWidget);
    expect(find.text('جديد: 05/11/2026 12:00 م'), findsOneWidget);
    expect(find.text('قيد المراجعة: 06/11/2026 1:30 م'), findsOneWidget);
    expect(find.text('مقابلة وتدريب: 07/11/2026 2:00 م'), findsOneWidget);

    await tester.tap(find.byKey(const Key('application-interview-map')));
    await tester.pump();
    expect(app.launched.single.host, 'www.google.com');
    expect(app.launched.single.queryParameters['destination'], '36.586,37.044');
    await app.done(tester);
  });

  for (final (stage, text) in [
    ('new', 'أُرسل طلبك. سنراجعه قريباً.'),
    ('awaiting_kit', 'اجتزت التدريب. استلم العدة ووقّع العقد في المكتب.'),
    ('waitlist', 'لا نحتاج كباتن جدداً حالياً. طلبك محفوظ وسنتواصل معك.'),
  ]) {
    testWidgets('the stage $stage shows its sentence', (tester) async {
      final app = _applicant([_application(stage: stage, missing: [])]);
      await app.pump(tester);
      expect(find.text(text), findsOneWidget);
      expect(find.byKey(const Key('application-reapply')), findsNothing);
      await app.done(tester);
    });
  }

  testWidgets('a rejection shows its reason and waits 30 days (K11)', (
    tester,
  ) async {
    final app = _applicant([
      _application(
        stage: 'rejected',
        missing: [],
        rejection: {
          'reason': 'المستندات غير مكتملة',
          'at': '2026-11-01T09:00:00.000Z',
          'reapplyFrom': '2026-12-01T09:00:00.000Z',
        },
      ),
    ]);
    await app.pump(tester);
    expect(
      find.text(
        'نعتذر، لم يُقبل طلبك: المستندات غير مكتملة. '
        'يمكنك التقديم مجدداً بعد 01/12/2026.',
      ),
      findsOneWidget,
    );
    expect(find.byKey(const Key('application-reapply')), findsNothing);
    await app.done(tester);
  });

  Map<String, Object?> rejectedLongAgo() => _application(
    stage: 'rejected',
    missing: [],
    rejection: {
      'reason': 'المستندات غير مكتملة',
      'at': '2026-10-08T09:00:00.000Z',
      'reapplyFrom': '2026-11-07T09:00:00.000Z',
    },
  );

  testWidgets('«تقديم طلب جديد» after 30 days starts a new draft (K11)', (
    tester,
  ) async {
    final app = _applicant([rejectedLongAgo()]);
    app.server.on('/v1/captain/application/personal', [
      FakeAnswer(200, _application(vehicle: null, missing: ['vehicle'])),
    ]);
    await app.pump(tester);
    await tester.tap(find.byKey(const Key('application-reapply')));
    await tester.pumpAndSettle();

    // Step 1 starts from the rejected application's data.
    expect(find.text('محمد أحمد العلي'), findsOneWidget);
    await app.tapVisible(
      tester,
      find.byKey(const Key('application-save-personal')),
    );
    await app.settle(tester);
    final body =
        app.server.to('/v1/captain/application/personal').single.data as Map;
    expect(body['fullName'], 'محمد أحمد العلي');
    expect(body['birthDate'], '2000-05-01');
    expect(body['zoneId'], _zoneId);
    expect(
      find.byKey(const Key('application-vehicle-walking')),
      findsOneWidget,
    );
    await app.done(tester);
  });

  testWidgets('a re-application refused with reapply_wait says to wait', (
    tester,
  ) async {
    final app = _applicant([rejectedLongAgo()]);
    app.server.on('/v1/captain/application/personal', [
      const FakeAnswer(409, {
        'error': 'reapply_wait',
        'reapplyFrom': '2026-11-08T09:00:00.000Z',
      }),
    ]);
    await app.pump(tester);
    await tester.tap(find.byKey(const Key('application-reapply')));
    await tester.pumpAndSettle();
    await app.tapVisible(
      tester,
      find.byKey(const Key('application-save-personal')),
    );
    await app.settle(tester);
    expect(find.text('لم يحن موعد التقديم من جديد.'), findsOneWidget);
    await app.done(tester);
  });
}
