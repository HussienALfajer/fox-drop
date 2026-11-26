import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';

import '../icon/path_data.dart';
import '../theme/fox_theme.dart';
import 'mark_geometry.dart';

/// The states every DropLoader use case and golden shows (R3).
const dropLoaderStates = ['default', 'onPrimary', 'small', 'large', 'labelled'];

/// `sm` 16 (inside a field), `md` 24 (a button), `lg` 48 (a page part).
enum FoxDropLoaderSize { sm, md, lg }

/// The fill's level (0 empty, 1 full) and the full mark's opacity at [cycle]
/// (0 to 1) of `motion.mark-fill`: the liquid rises over the first `rise`
/// with the calm easing, then the full mark fades back over the last `fade`.
({double level, double opacity}) markFillAt(double cycle) {
  const rise = t.FoxMotion.markFillRise;
  const fade = t.FoxMotion.markFillFade;
  final c = cycle.clamp(0.0, 1.0);
  final level = _calm.transform((c / rise).clamp(0.0, 1.0));
  final opacity = c <= 1 - fade ? 1.0 : (1 - c) / fade;
  return (level: level, opacity: opacity.clamp(0.0, 1.0));
}

const _calm = Cubic(0.2, 0, 0, 1);

/// The project's one loader (brand expression §2): the mark, faint, fills
/// with a liquid whose surface sways, then fades back; one cycle of
/// `motion.mark-fill.duration` without a pause. Under reduced motion it
/// stands still, half full. Orange with an ivory fox on a light ground;
/// [onPrimary], an ivory drop with an orange fox. Size `sm` draws the drop
/// alone with a flat surface. A [label] («جارٍ التحميل», from the caller) is
/// read in a live region; without it the loader is decoration inside a
/// control that is itself busy.
class FoxDropLoader extends StatefulWidget {
  const FoxDropLoader({
    super.key,
    this.size = FoxDropLoaderSize.md,
    this.onPrimary = false,
    this.label,
    this.phase,
    this.level,
  });

  final FoxDropLoaderSize size;
  final bool onPrimary;
  final String? label;

  /// A fixed point of the cycle (0 to 1), still: for goldens and widgetbook.
  final double? phase;

  /// A fixed level (0 to 1), full opacity and still: pull to refresh draws
  /// the pull with it.
  final double? level;

  @override
  State<FoxDropLoader> createState() => _FoxDropLoaderState();
}

class _FoxDropLoaderState extends State<FoxDropLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _cycle = AnimationController(
    vsync: this,
    duration: t.FoxMotion.markFillDuration,
  );

  bool get _fixed => widget.phase != null || widget.level != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(FoxDropLoader old) {
    super.didUpdateWidget(old);
    _sync();
  }

  void _sync() {
    final still = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (still || _fixed) {
      _cycle.stop();
    } else if (!_cycle.isAnimating) {
      _cycle.repeat();
    }
  }

  @override
  void dispose() {
    _cycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dropLoader = FoxTheme.of(context).components.dropLoader;
    final side = switch (widget.size) {
      FoxDropLoaderSize.sm => dropLoader.sizeSm,
      FoxDropLoaderSize.md => dropLoader.sizeMd,
      FoxDropLoaderSize.lg => dropLoader.sizeLg,
    };
    final small = widget.size == FoxDropLoaderSize.sm;
    final still = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    // On light: an ivory drop under orange pieces (the fox shows ivory); on
    // orange the other way round. The drop alone takes the pieces' colour.
    final markColour = Color(
      widget.onPrimary
          ? dropLoader.colorOnPrimaryPieces
          : dropLoader.colorPieces,
    );
    final otherColour = Color(
      widget.onPrimary ? dropLoader.colorOnPrimaryDrop : dropLoader.colorDrop,
    );
    Widget paint(double level, double opacity, double wave) => CustomPaint(
      size: Size.square(side),
      painter: MarkPainter(
        level: level,
        opacity: opacity,
        wave: small ? 0 : wave,
        dropOnly: small,
        drop: small ? markColour : otherColour,
        pieces: markColour,
      ),
    );

    final Widget mark;
    if (widget.level != null) {
      mark = paint(widget.level!.clamp(0.0, 1.0), 1, 0);
    } else if (widget.phase != null) {
      final at = markFillAt(widget.phase!);
      mark = paint(at.level, at.opacity, _wave(widget.phase!));
    } else if (still) {
      mark = paint(t.FoxMotion.markFillStillLevel, 1, 0);
    } else {
      mark = AnimatedBuilder(
        animation: _cycle,
        builder: (context, _) {
          final at = markFillAt(_cycle.value);
          return paint(at.level, at.opacity, _wave(_cycle.value));
        },
      );
    }
    final label = widget.label;
    if (label == null) return ExcludeSemantics(child: mark);
    return Semantics(
      label: label,
      liveRegion: true,
      child: ExcludeSemantics(child: mark),
    );
  }

  /// The surface's sway: one wavelength per `wave-period`.
  static double _wave(double cycle) {
    final ms = cycle * t.FoxMotion.markFillDuration.inMilliseconds;
    return (ms / t.FoxMotion.markFillWavePeriod.inMilliseconds) % 1;
  }
}

/// Paints the mark: faint at `faint-opacity`, then the full mark under the
/// liquid's surface at [level], at [opacity]. Exposed for tests.
class MarkPainter extends CustomPainter {
  MarkPainter({
    required this.level,
    required this.opacity,
    required this.wave,
    required this.dropOnly,
    required this.drop,
    required this.pieces,
  });

  final double level;
  final double opacity;

  /// The sway, 0 to 1 of a wavelength; 0 with [dropOnly] (a flat surface).
  final double wave;
  final bool dropOnly;
  final Color drop;
  final Color pieces;

  static final Path _drop = parseSvgPath(markDrop);
  static final List<Path> _pieces = [
    for (final p in markPieces) parseSvgPath(p),
  ];

  // The mark centred in a square, in the brand file's units.
  static const _side = 1659.0;
  static final _left = markBox.x - (_side - markBox.width) / 2;
  static const _top = 258.0;
  static const _wavelength = 830.0;
  static const _amplitude = 40.0;

  void _mark(Canvas canvas) {
    canvas.drawPath(_drop, Paint()..color = drop);
    if (dropOnly) return;
    final paint = Paint()..color = pieces;
    for (final piece in _pieces) {
      canvas.drawPath(piece, paint);
    }
  }

  Path _surface() {
    // Level 0 sits below the mark with the wave's height; level 1 above it.
    final y = _top + _side + _amplitude - level * (_side + 2 * _amplitude);
    final path = Path();
    if (dropOnly) {
      return path
        ..addRect(Rect.fromLTRB(_left, y, _left + _side, _top + _side));
    }
    var x = _left - 2 * _wavelength + wave * _wavelength;
    path.moveTo(x, y);
    final end = _left + _side + _wavelength;
    while (x < end) {
      path
        ..quadraticBezierTo(
          x + _wavelength / 4,
          y - _amplitude,
          x + _wavelength / 2,
          y,
        )
        ..quadraticBezierTo(
          x + _wavelength * 3 / 4,
          y + _amplitude,
          x + _wavelength,
          y,
        );
      x += _wavelength;
    }
    return path
      ..lineTo(x, _top + _side + _amplitude)
      ..lineTo(_left - 2 * _wavelength, _top + _side + _amplitude)
      ..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..save()
      ..scale(size.width / _side)
      ..translate(-_left, -_top);
    final bounds = Rect.fromLTWH(_left, _top, _side, _side);
    // A layer's paint counts by its alpha only: the mark's own colour, faded.
    canvas.saveLayer(
      bounds,
      Paint()
        ..color = pieces.withValues(alpha: t.FoxMotion.markFillFaintOpacity),
    );
    _mark(canvas);
    canvas.restore();
    if (level > 0 && opacity > 0) {
      canvas
        ..saveLayer(bounds, Paint()..color = pieces.withValues(alpha: opacity))
        ..clipPath(_surface());
      _mark(canvas);
      canvas.restore();
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(MarkPainter old) =>
      old.level != level ||
      old.opacity != opacity ||
      old.wave != wave ||
      old.dropOnly != dropOnly ||
      old.drop != drop ||
      old.pieces != pieces;
}
