import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:core_storage/core_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../joining/application.dart';
import '../joining/application_screen.dart';
import '../joining/texts.dart';
import '../support/report_photo.dart';

/// CA §12.3–12.4 (slice 2.35a): the captain's contract, kit and deposit,
/// read on opening «العقد والعدة» and on a contract phase push.
final contractProvider = FutureProvider.autoDispose<CaptainContractDtoOutput>(
  (ref) async =>
      (await ref
              .watch(coreApiProvider)
              .getCaptainApi()
              .captainContractContract())
          .data!,
);

String phaseText(
  AppLocalizations l10n,
  CaptainContractDtoOutputContractPhaseEnum phase,
) => switch (phase) {
  CaptainContractDtoOutputContractPhaseEnum.commitment =>
    l10n.captainContractCommitment,
  CaptainContractDtoOutputContractPhaseEnum.open => l10n.captainContractOpen,
  _ => l10n.captainContractProbation,
};

/// CA §12.2: one document of the captain as the server answers it.
class CaptainDocument {
  const CaptainDocument({
    required this.kind,
    required this.required,
    required this.state,
    required this.expiresOn,
    required this.pending,
    required this.rejection,
  });

  final DocumentKind kind;
  final bool required;
  final DocumentState state;
  // The one in force's expiry, YYYY-MM-DD; null for none.
  final String? expiresOn;
  final bool pending;
  // The latest copy's rejection while no newer one replaced it.
  final String? rejection;
}

enum DocumentState { valid, expiring, expired, missing }

List<CaptainDocument> documentsOf(CaptainDocumentsDtoOutput answer) => [
  for (final document in answer.documents)
    if (DocumentKind.values
            .where((each) => each.name == document.kind.name)
            .toList()
        case [final DocumentKind kind])
      CaptainDocument(
        kind: kind,
        required: document.required_,
        state: DocumentState.values.firstWhere(
          (each) => each.name == document.state.name,
        ),
        expiresOn: document.valid?.expiresOn?.toString(),
        pending: document.pending != null,
        rejection: document.rejection?.reason,
      ),
];

String documentStateText(AppLocalizations l10n, CaptainDocument document) =>
    switch (document.state) {
      DocumentState.valid => l10n.captainDocumentValid,
      DocumentState.expiring => l10n.captainDocumentExpiring,
      DocumentState.expired => l10n.captainDocumentExpired,
      DocumentState.missing => l10n.captainDocumentNotUploaded,
    };

/// The amber banner of CA §12.2: each document expiring or expired.
List<String> documentBanners(
  AppLocalizations l10n,
  List<CaptainDocument> documents,
) => [
  for (final document in documents)
    if (document.state == DocumentState.expiring && document.expiresOn != null)
      l10n.captainDocumentExpiringBanner(
        documentText(l10n, document.kind),
        dayText(l10n, document.expiresOn!),
      )
    else if (document.state == DocumentState.expired)
      l10n.captainDocumentExpiredBanner(documentText(l10n, document.kind)),
];

/// CA §12.2: the documents, and «رفع نسخة جديدة», whose copy waits for
/// OPS while the one in force stays valid until it expires.
class CaptainDocumentsController extends AsyncNotifier<List<CaptainDocument>> {
  CaptainApi get _api => ref.read(coreApiProvider).getCaptainApi();

  @override
  Future<List<CaptainDocument>> build() async => documentsOf(
    (await ref
            .watch(coreApiProvider)
            .getCaptainApi()
            .captainDocumentsDocuments())
        .data!,
  );

  /// Throws an [ApplicationRefusal], as the application's documents.
  Future<void> replace(
    DocumentKind kind,
    List<DocumentPhoto> photos, {
    String? number,
    String? issueDate,
  }) async {
    if (photos.length < kind.minFiles) {
      throw ApplicationRefusal(
        kind == DocumentKind.nationalId
            ? ApplicationRefusal.twoSides
            : ApplicationRefusal.failed,
      );
    }
    try {
      final ids = [for (final photo in photos) await _upload(photo)];
      final answer = await _api.captainDocumentsReplace(
        kind: kind.wire,
        captainDocumentReplacementDto: CaptainDocumentReplacementDto(
          (b) => b
            ..uploadIds.replace(ids)
            ..number = number
            ..issueDate = issueDate == null
                ? null
                : DateTime.parse(issueDate).toDate(),
        ),
      );
      state = AsyncData(documentsOf(answer.data!));
    } on DioException catch (error) {
      throw refusalOf(error);
    }
  }

  Future<String> _upload(DocumentPhoto photo) async {
    final known = photo.uploadId;
    if (known != null) return known;
    final answer = await _api.captainDocumentsUpload(
      customerNewUploadDto: CustomerNewUploadDto(
        (b) => b
          ..contentType = _types[photo.photo.contentType]
          ..sizeBytes = photo.photo.bytes.length,
      ),
    );
    final upload = answer.data!;
    await ref.read(photoPutProvider)(upload.url, photo.photo);
    return photo.uploadId = upload.uploadId;
  }
}

final captainDocumentsProvider =
    AsyncNotifierProvider<CaptainDocumentsController, List<CaptainDocument>>(
      CaptainDocumentsController.new,
    );

const _types = {
  'image/jpeg': CustomerNewUploadDtoContentTypeEnum.imageSlashJpeg,
  'image/png': CustomerNewUploadDtoContentTypeEnum.imageSlashPng,
  'image/webp': CustomerNewUploadDtoContentTypeEnum.imageSlashWebp,
};

/// CA §5.5 (slice 2.35a): the welcome tour shows once on this device after
/// the activation, for a captain with a contract. Tests give their own
/// store.
final deviceStoreProvider = Provider<DeviceStore>(
  (ref) => PreferencesDeviceStore(),
);

String _tourKey(String captainId) => 'captain.welcome_tour.$captainId';

final tourSeenProvider = FutureProvider.autoDispose.family<bool, String>(
  (ref, captainId) async =>
      await ref.watch(deviceStoreProvider).read(_tourKey(captainId)) != null,
);

Future<void> markTourSeen(DeviceStore store, String captainId) =>
    store.write(_tourKey(captainId), 'seen');
