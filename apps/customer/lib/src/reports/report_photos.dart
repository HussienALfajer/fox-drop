import 'dart:typed_data';

import 'package:core_api/core_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../api.dart';

/// A photo the customer picked for a report (CU §12.2, §9.5).
class PickedPhoto {
  const PickedPhoto(this.bytes, this.contentType);

  final Uint8List bytes;

  /// `image/jpeg`, `image/png` or `image/webp`, by the file's first bytes.
  final String contentType;
}

/// The server's largest image (architecture §5.8: 8 MB).
const maxPhotoBytes = 8 * 1024 * 1024;

enum PhotoSource { camera, gallery }

/// Picks a photo from the camera or the phone, scaled down to 1600 pixels
/// so it stays well within [maxPhotoBytes]; null when the customer cancels.
/// Tests give their own.
typedef PhotoPicker = Future<PickedPhoto?> Function(PhotoSource source);

final photoPickerProvider = Provider<PhotoPicker>(
  (ref) => (source) async {
    final file = await ImagePicker().pickImage(
      source: source == PhotoSource.camera
          ? ImageSource.camera
          : ImageSource.gallery,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 80,
    );
    if (file == null) return null;
    final bytes = await file.readAsBytes();
    final type = imageTypeOf(bytes);
    return type == null ? null : PickedPhoto(bytes, type);
  },
);

/// The image type by its signature, as the server checks it; null for
/// anything else.
String? imageTypeOf(Uint8List bytes) {
  bool starts(List<int> sign, [int at = 0]) =>
      bytes.length >= at + sign.length &&
      [
        for (var i = 0; i < sign.length; i++) bytes[at + i] == sign[i],
      ].every((same) => same);
  if (starts([0xff, 0xd8, 0xff])) return 'image/jpeg';
  if (starts([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a])) {
    return 'image/png';
  }
  if (starts([0x52, 0x49, 0x46, 0x46]) && starts([0x57, 0x45, 0x42, 0x50], 8)) {
    return 'image/webp';
  }
  return null;
}

/// The PUT of a photo's exact bytes to the storage's signed URL (the files
/// module). The one request outside the API client: it goes to the storage,
/// carries no session, and the signature covers its type and size. Tests
/// give their own.
typedef PhotoPut = Future<void> Function(String url, PickedPhoto photo);

final photoPutProvider = Provider<PhotoPut>(
  (ref) => (url, photo) async {
    await Dio().put<void>(
      url,
      data: Stream.value(photo.bytes),
      options: Options(
        headers: {
          Headers.contentTypeHeader: photo.contentType,
          Headers.contentLengthHeader: photo.bytes.length,
        },
      ),
    );
  },
);

/// A photo on its way into a report: uploaded once, then sent by its upload
/// id however often the report is sent again.
class ReportPhoto {
  ReportPhoto(this.photo);

  final PickedPhoto photo;
  String? uploadId;
}

/// Uploads each photo not uploaded yet: `POST /v1/customer/uploads/report-
/// photo` for a signed PUT into the private bucket, then the PUT. Answers
/// the upload ids in order; throws when one fails.
Future<List<String>> uploadPhotos(Ref ref, List<ReportPhoto> photos) async {
  final api = ref.read(coreApiProvider).getCustomerApi();
  for (final each in photos) {
    if (each.uploadId != null) continue;
    final answer = await api.customerUploadsCreate(
      customerNewUploadDto: CustomerNewUploadDto(
        (b) => b
          ..contentType = _types[each.photo.contentType]
          ..sizeBytes = each.photo.bytes.length,
      ),
    );
    final upload = answer.data!;
    await ref.read(photoPutProvider)(upload.url, each.photo);
    each.uploadId = upload.uploadId;
  }
  return [for (final each in photos) each.uploadId!];
}

/// Forgets the photos' uploads after the server refused one (expired,
/// missing, invalid or used), so the next send uploads them again.
void forgetUploads(List<ReportPhoto> photos) {
  for (final each in photos) {
    each.uploadId = null;
  }
}

const _types = {
  'image/jpeg': CustomerNewUploadDtoContentTypeEnum.imageSlashJpeg,
  'image/png': CustomerNewUploadDtoContentTypeEnum.imageSlashPng,
  'image/webp': CustomerNewUploadDtoContentTypeEnum.imageSlashWebp,
};
