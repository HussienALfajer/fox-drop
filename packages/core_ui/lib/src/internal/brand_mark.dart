import 'package:flutter/widgets.dart';

import '../drop_loader/fox_drop_loader.dart';
import '../theme/fox_theme.dart';

/// The brand mark, full and still, from the brand file's geometry (the
/// loader's painter): orange with an ivory fox on a light ground, or ivory
/// on orange with [onPrimary]. Decoration only. Not exported.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, required this.size, this.onPrimary = false});

  final double size;
  final bool onPrimary;

  @override
  Widget build(BuildContext context) {
    final c = FoxTheme.of(context).colors;
    return ExcludeSemantics(
      child: CustomPaint(
        size: Size.square(size),
        painter: MarkPainter(
          level: 1,
          opacity: 1,
          wave: 0,
          dropOnly: false,
          drop: onPrimary ? c.primary : c.onPrimary,
          pieces: onPrimary ? c.onPrimary : c.brand,
        ),
      ),
    );
  }
}
