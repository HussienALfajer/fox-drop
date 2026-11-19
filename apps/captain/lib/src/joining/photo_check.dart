import 'dart:typed_data';
import 'dart:ui' as ui;

/// CA §5.3: the app checks each document photo for blur and darkness before
/// it uploads it, and asks for a retake when it fails.
enum PhotoQuality { ok, dark, blurry }

/// The width the photo is read at: enough to tell a sharp page from a blurred
/// one, small enough to read in a moment.
const photoCheckWidth = 320;

/// Below this mean brightness (0 to 255) a photo is too dark to read
/// (decided by us).
const darkBelow = 60.0;

/// Below this variance of the Laplacian (on [photoCheckWidth]) a photo has
/// no sharp edges: blurred or shaken (decided by us).
const blurryBelow = 40.0;

/// The check on RGBA pixels, [width] × [height]: darkness by the mean
/// brightness, blur by the variance of the Laplacian of the brightness.
PhotoQuality photoQuality(Uint8List rgba, int width, int height) {
  if (width < 3 || height < 3) return PhotoQuality.blurry;
  final luma = Float64List(width * height);
  var sum = 0.0;
  for (var i = 0; i < luma.length; i++) {
    final at = i * 4;
    final value =
        0.299 * rgba[at] + 0.587 * rgba[at + 1] + 0.114 * rgba[at + 2];
    luma[i] = value;
    sum += value;
  }
  if (sum / luma.length < darkBelow) return PhotoQuality.dark;
  var count = 0;
  var mean = 0.0;
  var squares = 0.0;
  for (var y = 1; y < height - 1; y++) {
    for (var x = 1; x < width - 1; x++) {
      final at = y * width + x;
      final laplacian =
          luma[at - width] +
          luma[at + width] +
          luma[at - 1] +
          luma[at + 1] -
          4 * luma[at];
      count++;
      mean += laplacian;
      squares += laplacian * laplacian;
    }
  }
  mean /= count;
  final variance = squares / count - mean * mean;
  return variance < blurryBelow ? PhotoQuality.blurry : PhotoQuality.ok;
}

/// Reads an encoded photo at [photoCheckWidth] and checks it; null when it
/// cannot be decoded.
Future<PhotoQuality?> checkPhoto(Uint8List bytes) async {
  try {
    final codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: photoCheckWidth,
    );
    final frame = await codec.getNextFrame();
    final image = frame.image;
    final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    final quality = data == null
        ? null
        : photoQuality(data.buffer.asUint8List(), image.width, image.height);
    image.dispose();
    codec.dispose();
    return quality;
  } on Object {
    return null;
  }
}
