import 'package:flutter/foundation.dart';

import 'api.dart';

/// imgproxy's widths, in pixels (`infra/imgproxy/imgproxy.env`; infra.test.mjs
/// keeps them equal).
const mediaWidths = [160, 320, 640, 1280];

/// Where the images are served (architecture §5.8), set with
/// `--dart-define=MEDIA_BASE_URL=...`. Without it: the API's own host under
/// `/media` (nginx on staging and production), or, in a debug build, the
/// development machine's imgproxy on port 8088 (compose.yaml).
const _mediaBaseUrl = String.fromEnvironment('MEDIA_BASE_URL');

String mediaBaseUrl() {
  if (_mediaBaseUrl.isNotEmpty) return _mediaBaseUrl;
  final api = Uri.parse(apiBaseUrl());
  if (kDebugMode) return api.replace(port: 8088, path: '/media').toString();
  return api.replace(path: '/media').toString();
}

/// The smallest width that fills [pixels], else the largest.
int mediaWidth(double pixels) => mediaWidths.firstWhere(
  (width) => width >= pixels,
  orElse: () => mediaWidths.last,
);

/// An image of public-media at the width that fills [pixels] physical pixels
/// (CU §4.5): imgproxy resizes it and converts it to WebP.
String mediaUrl(String base, String key, double pixels) =>
    '$base/_/w${mediaWidth(pixels)}/plain/$key';
