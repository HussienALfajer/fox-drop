import 'package:core_api/core_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../api.dart';

/// A photo picked for a report (CA §13), as the restaurant app's.
class PickedPhoto {
  const PickedPhoto(this.bytes, this.contentType);

  final Uint8List bytes;

  /// `image/jpeg`, `image/png` or `image/webp`, by the file's first bytes.
  final String contentType;
}

/// The server's largest image (architecture §5.8: 8 MB).
const maxPhotoBytes = 8 * 1024 * 1024;

/// The front camera takes the applicant's personal photo (CA §5.3).
enum PhotoSource { camera, frontCamera, gallery }

/// The camera on the phones; elsewhere (tests) a file.
bool get cameraAvailable =>
    defaultTargetPlatform == TargetPlatform.android ||
    defaultTargetPlatform == TargetPlatform.iOS;

/// Picks a photo, scaled down to 1600 pixels; null when cancelled or not an
/// image the server takes. Tests give their own.
typedef PhotoPicker = Future<PickedPhoto?> Function(PhotoSource source);

final photoPickerProvider = Provider<PhotoPicker>(
  (ref) => (source) async {
    final file = await ImagePicker().pickImage(
      source: source == PhotoSource.gallery
          ? ImageSource.gallery
          : ImageSource.camera,
      preferredCameraDevice: source == PhotoSource.frontCamera
          ? CameraDevice.front
          : CameraDevice.rear,
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

/// The PUT of the photo's exact bytes to the storage's signed URL: the one
/// request outside the API client (it goes to the storage, with no session;
/// the signature covers its type and size). Tests give their own.
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

/// Uploads the photo unless it was: `POST /v1/captain/uploads/report-photo`
/// for a signed PUT into the private bucket, then the PUT. Answers its
/// upload id; throws when either fails.
Future<String> uploadPhoto(Ref ref, ReportPhoto photo) async {
  final known = photo.uploadId;
  if (known != null) return known;
  final answer = await ref
      .read(coreApiProvider)
      .getCaptainApi()
      .captainTicketsUploadPhoto(
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

const _types = {
  'image/jpeg': CustomerNewUploadDtoContentTypeEnum.imageSlashJpeg,
  'image/png': CustomerNewUploadDtoContentTypeEnum.imageSlashPng,
  'image/webp': CustomerNewUploadDtoContentTypeEnum.imageSlashWebp,
};
