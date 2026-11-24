import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';

import '../theme/fox_theme.dart';
import 'path_data.dart';

/// The states every Icon use case and golden shows (R3), as the web's
/// `STATES` of the Icon.
const iconStates = ['default', 'sm', 'md', 'lg', 'labelled', 'mirrored'];

/// The three icon sizes (`size.icon-*`).
enum FoxIconSize {
  sm(t.FoxSize.iconSm),
  md(t.FoxSize.iconMd),
  lg(t.FoxSize.iconLg);

  const FoxIconSize(this.pixels);

  final double pixels;
}

/// One icon of the FOX DROP set (architecture §9.4): the outline of
/// `FoxIcons.<name>` stroked at 2/24 of its size with round caps and joins.
/// Directional icons (`mirror`) flip under a right-to-left `Directionality`.
///
/// Without a [label] the icon is decoration and hidden from screen readers;
/// with one it is an image of that name. The colour is [color] or the
/// surrounding text colour.
class FoxIcon extends StatelessWidget {
  const FoxIcon(
    this.icon, {
    super.key,
    this.size = FoxIconSize.md,
    this.label,
    this.color,
    this.filled = false,
  });

  final t.FoxIconData icon;
  final FoxIconSize size;
  final String? label;
  final Color? color;

  /// Fills the outline as well as stroking it. The one exception to the
  /// line-only set (R8; owner, 2026-11-24): a chosen favourite's heart, so
  /// the state is not colour alone. Only for a closed shape such as `heart`.
  final bool filled;

  /// Parsed outlines by path data, shared by every icon.
  static final Map<String, Path> _paths = {};

  static Path _path(String data) =>
      _paths.putIfAbsent(data, () => parseSvgPath(data));

  @override
  Widget build(BuildContext context) {
    final paint =
        color ??
        DefaultTextStyle.of(context).style.color ??
        FoxTheme.of(context).colors.onSurface;
    final mirrored =
        icon.mirror && Directionality.of(context) == TextDirection.rtl;
    final drawing = CustomPaint(
      size: Size.square(size.pixels),
      painter: _IconPainter(
        [for (final d in icon.paths) _path(d)],
        paint,
        mirrored: mirrored,
        filled: filled,
      ),
    );
    final name = label;
    if (name == null) return ExcludeSemantics(child: drawing);
    return Semantics(label: name, image: true, child: drawing);
  }
}

class _IconPainter extends CustomPainter {
  _IconPainter(
    this.paths,
    this.color, {
    required this.mirrored,
    this.filled = false,
  });

  final List<Path> paths;
  final Color color;
  final bool mirrored;
  final bool filled;

  static const _grid = 24.0;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / _grid;
    canvas.save();
    if (mirrored) {
      canvas.translate(size.width, 0);
      canvas.scale(-1, 1);
    }
    canvas.scale(scale);
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;
    final fill = Paint()
      ..color = color
      ..isAntiAlias = true;
    for (final path in paths) {
      if (filled) canvas.drawPath(path, fill);
      canvas.drawPath(path, stroke);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_IconPainter old) =>
      old.color != color ||
      old.mirrored != mirrored ||
      old.paths != paths ||
      old.filled != filled;
}
