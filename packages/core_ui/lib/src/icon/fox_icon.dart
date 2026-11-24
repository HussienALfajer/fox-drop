import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';

import '../theme/fox_theme.dart';
import 'path_data.dart';

/// The six styles of set v4 Madar (architecture §9.4), Linear first.
enum FoxIconStyle {
  /// Every element stroked: the default.
  linear,

  /// Linear with the non-accent elements at half opacity.
  duotone,

  /// Linear with the accent stroked in `brand`: empty states, promo cards.
  brandDuo,

  /// Linear with the bite cut in the body.
  broken,

  /// Filled, the details knocked out: a selected tab, a chosen favourite.
  bold,

  /// Bold with the non-accent bodies at half opacity.
  boldDuo,
}

/// The states every Icon use case and golden shows (R3), as the web's
/// `STATES` of the Icon: the default, each size, labelled, mirrored, and each
/// style but Linear.
const iconStates = [
  'default',
  'sm',
  'md',
  'lg',
  'labelled',
  'mirrored',
  'duotone',
  'brandDuo',
  'broken',
  'bold',
  'boldDuo',
];

/// The three icon sizes (`size.icon-*`).
enum FoxIconSize {
  sm(t.FoxSize.iconSm),
  md(t.FoxSize.iconMd),
  lg(t.FoxSize.iconLg);

  const FoxIconSize(this.pixels);

  final double pixels;
}

/// One icon of the FOX DROP set v4 Madar (architecture §9.4) in one of its
/// six [FoxIconStyle]s. The line styles stroke at the theme's icon weight
/// (1.5 on the phone, 1.75 for the captain) with round caps and joins; Bold
/// and Bold Duo fill the layers baked for that weight. Directional icons
/// (`mirror`) flip under a right-to-left `Directionality`.
///
/// Without a [label] the icon is decoration and hidden from screen readers;
/// with one it is an image of that name. The colour is [color] or the
/// surrounding text colour; Brand Duo's accent is the theme's `brand`.
class FoxIcon extends StatelessWidget {
  const FoxIcon(
    this.icon, {
    super.key,
    this.size = FoxIconSize.md,
    this.style = FoxIconStyle.linear,
    this.label,
    this.color,
  });

  final t.FoxIconData icon;
  final FoxIconSize size;
  final FoxIconStyle style;
  final String? label;
  final Color? color;

  /// Parsed outlines by path data, shared by every icon.
  static final Map<String, Path> _paths = {};

  static Path _path(String data) =>
      _paths.putIfAbsent(data, () => parseSvgPath(data));

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final ink =
        color ??
        DefaultTextStyle.of(context).style.color ??
        theme.colors.onSurface;
    final weight = theme.iconWeight;
    final layers = switch (style) {
      FoxIconStyle.linear => [
        for (final e in icon.elements) _Layer(_path(e.d), ink),
      ],
      FoxIconStyle.duotone => [
        for (final e in icon.elements)
          _Layer(_path(e.d), e.accent ? ink : ink.withValues(alpha: 0.5)),
      ],
      FoxIconStyle.brandDuo => [
        for (final e in icon.elements)
          _Layer(_path(e.d), e.accent ? theme.colors.brand : ink),
      ],
      FoxIconStyle.broken => [
        for (final d in icon.broken) _Layer(_path(d), ink),
      ],
      FoxIconStyle.bold => [
        for (final l in icon.bold(weight)) _Layer(_path(l.d), ink, fill: true),
      ],
      FoxIconStyle.boldDuo => [
        for (final l in icon.boldDuo(weight))
          _Layer(
            _path(l.d),
            l.faded ? ink.withValues(alpha: 0.5) : ink,
            fill: true,
          ),
      ],
    };
    final mirrored =
        icon.mirror && Directionality.of(context) == TextDirection.rtl;
    final drawing = CustomPaint(
      size: Size.square(size.pixels),
      painter: _IconPainter(
        layers,
        style: style,
        weight: weight,
        mirrored: mirrored,
      ),
    );
    final name = label;
    if (name == null) return ExcludeSemantics(child: drawing);
    return Semantics(label: name, image: true, child: drawing);
  }
}

/// One path of a drawing: stroked in the line styles, filled in the bold.
@immutable
final class _Layer {
  const _Layer(this.path, this.color, {this.fill = false});

  final Path path;
  final Color color;
  final bool fill;

  @override
  bool operator ==(Object other) =>
      other is _Layer &&
      other.path == path &&
      other.color == color &&
      other.fill == fill;

  @override
  int get hashCode => Object.hash(path, color, fill);
}

class _IconPainter extends CustomPainter {
  _IconPainter(
    this.layers, {
    required this.style,
    required this.weight,
    required this.mirrored,
  });

  final List<_Layer> layers;
  final FoxIconStyle style;
  final t.FoxIconWeight weight;
  final bool mirrored;

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
    for (final layer in layers) {
      final paint = Paint()
        ..color = layer.color
        ..isAntiAlias = true;
      if (!layer.fill) {
        paint
          ..style = PaintingStyle.stroke
          ..strokeWidth = weight.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;
      }
      canvas.drawPath(layer.path, paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_IconPainter old) =>
      old.mirrored != mirrored ||
      old.weight != weight ||
      old.style != style ||
      !_same(old.layers, layers);

  static bool _same(List<_Layer> a, List<_Layer> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
