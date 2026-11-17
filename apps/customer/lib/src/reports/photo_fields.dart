import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'report_photos.dart';

/// A report's photos (CU §12.2, §9.5): each one picked with «التقاط صورة»
/// or «من المعرض» and shown with «حذف الصورة», up to [max]. It changes
/// [photos] in place and calls [onChanged]. Unstyled until the design.
class PhotoFields extends ConsumerWidget {
  const PhotoFields({
    super.key,
    required this.photos,
    required this.max,
    required this.onChanged,
  });

  final List<ReportPhoto> photos;
  final int max;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    Future<void> pick(PhotoSource source) async {
      final photo = await ref.read(photoPickerProvider)(source);
      if (photo == null || !context.mounted) return;
      if (photo.bytes.length > maxPhotoBytes) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.customerPhotoTooLarge)));
        return;
      }
      photos.add(ReportPhoto(photo));
      onChanged();
    }

    return Column(
      children: [
        for (final (index, each) in photos.indexed)
          ListTile(
            key: Key('report-photo-$index'),
            leading: Image.memory(each.photo.bytes, width: 56, height: 56),
            trailing: TextButton(
              key: Key('report-photo-remove-$index'),
              onPressed: () {
                photos.removeAt(index);
                onChanged();
              },
              child: Text(l10n.customerPhotoRemove),
            ),
          ),
        if (photos.length < max)
          Wrap(
            children: [
              TextButton(
                key: const Key('report-photo-camera'),
                onPressed: () => pick(PhotoSource.camera),
                child: Text(l10n.customerPhotoCamera),
              ),
              TextButton(
                key: const Key('report-photo-gallery'),
                onPressed: () => pick(PhotoSource.gallery),
                child: Text(l10n.customerPhotoGallery),
              ),
            ],
          ),
      ],
    );
  }
}
