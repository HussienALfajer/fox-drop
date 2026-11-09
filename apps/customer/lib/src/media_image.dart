import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'media.dart';

/// Where the images are served; tests give their own.
final mediaBaseProvider = Provider<String>((ref) => mediaBaseUrl());

/// How an image's URL is loaded: kept on the phone's disk (CU §4.5), so a
/// logo or photo seen once shows again without the network. Tests answer
/// from memory.
final mediaLoaderProvider = Provider<ImageProvider Function(String url)>(
  (ref) =>
      (url) => CachedNetworkImageProvider(url),
);

/// An image of public-media at [width] × [height] logical pixels, asked at
/// the preset width that fills them on this screen (CU §4.5). While it loads,
/// or if it fails, the space stays empty. Unstyled until the design.
class MediaImage extends ConsumerWidget {
  const MediaImage({
    super.key,
    required this.imageKey,
    required this.width,
    required this.height,
    required this.label,
  });

  final String imageKey;
  final double width;
  final double height;

  /// What the image shows, for screen readers.
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pixels = width * MediaQuery.devicePixelRatioOf(context);
    final url = mediaUrl(ref.watch(mediaBaseProvider), imageKey, pixels);
    return Image(
      image: ref.watch(mediaLoaderProvider)(url),
      width: width,
      height: height,
      fit: BoxFit.cover,
      semanticLabel: label,
      errorBuilder: (context, error, stack) =>
          SizedBox(width: width, height: height),
    );
  }
}
