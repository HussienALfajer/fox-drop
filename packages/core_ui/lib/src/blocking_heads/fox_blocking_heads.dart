import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';

import '../internal/brand_mark.dart';
import '../theme/fox_theme.dart';

/// The states every VersionTicket use case and golden shows (R3).
const versionTicketStates = ['default'];

/// The states every ShopSign use case and golden shows (R3).
const shopSignStates = ['default', 'returnTime'];

/// The forced update's head (D.11 screen 7, CU §4.2): a ticket, the
/// installed version struck above the perforation, the required one below
/// beside the mark. Versions show left to right. Read once, as
/// [semanticLabel].
class FoxVersionTicket extends StatelessWidget {
  const FoxVersionTicket({
    super.key,
    required this.installedLabel,
    required this.installed,
    required this.requiredLabel,
    required this.required,
    required this.semanticLabel,
  });

  /// «إصدارك».
  final String installedLabel;
  final String installed;

  /// «الإصدار الجديد».
  final String requiredLabel;
  final String required;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final c = theme.colors;
    final muted = theme.text.secondary.copyWith(color: c.onSurfaceMuted);
    return Semantics(
      container: true,
      image: true,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: ConstrainedBox(
          // Wider as the text grows, so the words keep their lines.
          constraints: BoxConstraints(
            maxWidth: _scaled(context, t.FoxSize.tooltip),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: c.surfaceRaised,
              borderRadius: BorderRadius.circular(t.FoxRadius.lg),
              boxShadow: [theme.shadows.offset],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.all(t.FoxSpace.md),
                  // A wrap: at large text the version moves under its label.
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: t.FoxSpace.sm,
                    children: [
                      Text(installedLabel, style: muted),
                      _Ltr(
                        installed,
                        theme.text.title.copyWith(
                          color: c.onSurfaceMuted,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: c.onSurfaceMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const _Perforation(),
                Padding(
                  padding: const EdgeInsetsDirectional.all(t.FoxSpace.md),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(requiredLabel, style: muted),
                            const SizedBox(height: t.FoxSpace.xxs),
                            _Ltr(
                              required,
                              theme.text.number.copyWith(color: c.heading),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: t.FoxSpace.sm),
                      const BrandMark(size: t.FoxSize.touchTarget),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// [width] grown with the text scale, at most the screen's width less its
/// margins.
double _scaled(BuildContext context, double width) {
  final grown = MediaQuery.textScalerOf(context).scale(width);
  final room = MediaQuery.sizeOf(context).width - 2 * t.FoxSpace.md;
  return grown < room ? grown : (width < room ? room : width);
}

class _Ltr extends StatelessWidget {
  const _Ltr(this.text, this.style);

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.ltr,
    child: Text(text, style: style),
  );
}

/// A dashed line with a half circle cut from each edge, in the ground's
/// colour.
class _Perforation extends StatelessWidget {
  const _Perforation();

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final c = theme.colors;
    return SizedBox(
      height: t.FoxSpace.lg,
      child: CustomPaint(
        painter: _PerforationPainter(
          line: c.borderStrong,
          ground: c.surface,
          width: theme.input.borderWidth,
        ),
      ),
    );
  }
}

class _PerforationPainter extends CustomPainter {
  _PerforationPainter({
    required this.line,
    required this.ground,
    required this.width,
  });

  final Color line;
  final Color ground;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;
    final paint = Paint()
      ..color = line
      ..strokeWidth = width;
    const dash = t.FoxSpace.xxs;
    for (var x = t.FoxSpace.md; x < size.width - t.FoxSpace.md; x += 2 * dash) {
      canvas.drawLine(Offset(x, y), Offset(x + dash, y), paint);
    }
    final cut = Paint()..color = ground;
    canvas
      ..drawCircle(Offset(0, y), size.height / 2, cut)
      ..drawCircle(Offset(size.width, y), size.height / 2, cut);
  }

  @override
  bool shouldRepaint(_PerforationPainter old) =>
      old.line != line || old.ground != ground || old.width != width;
}

/// The maintenance head (D.11 screen 7, CU §4.7): an orange board hung by
/// two strings from a nail, on its pressed-orange edge: the title, the
/// subtitle and, when the panel gave one, the return time. Read once, as
/// [semanticLabel].
class FoxShopSign extends StatelessWidget {
  const FoxShopSign({
    super.key,
    required this.title,
    required this.subtitle,
    required this.semanticLabel,
    this.returnTime,
  });

  /// «نعود قريباً».
  final String title;

  /// «صيانة قصيرة».
  final String subtitle;

  /// «نعود الساعة 3:00 م», from the maintenance return time.
  final String? returnTime;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final c = theme.colors;
    final ink = c.onPrimary;
    final returnTime = this.returnTime;
    final width = _scaled(context, t.FoxSize.touchTarget * 4);
    return Semantics(
      container: true,
      image: true,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: SizedBox(
          width: width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // The nail, over the strings' meeting point.
              DecoratedBox(
                decoration: BoxDecoration(
                  color: c.borderStrong,
                  shape: BoxShape.circle,
                ),
                child: const SizedBox.square(dimension: t.FoxSpace.sm),
              ),
              Transform.translate(
                offset: const Offset(0, -t.FoxSpace.sm / 2),
                child: SizedBox(
                  height: t.FoxSize.touchTarget - t.FoxSpace.xs,
                  width: width,
                  child: CustomPaint(painter: _Strings(colour: c.borderStrong)),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: c.primary,
                  borderRadius: BorderRadius.circular(t.FoxRadius.lg),
                  boxShadow: [
                    BoxShadow(
                      color: c.primaryPressed,
                      offset: const Offset(0, t.FoxSpace.xs),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    for (final start in [true, false])
                      PositionedDirectional(
                        top: t.FoxSpace.xs,
                        start: start ? t.FoxSpace.md : null,
                        end: start ? null : t.FoxSpace.md,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: c.surface,
                            shape: BoxShape.circle,
                          ),
                          child: const SizedBox.square(
                            dimension: t.FoxSpace.xs,
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        t.FoxSpace.md,
                        t.FoxSpace.lg,
                        t.FoxSpace.md,
                        t.FoxSpace.md,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: theme.text.largeTitle.copyWith(
                              color: ink,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: t.FoxSpace.xxs),
                          Text(
                            subtitle,
                            textAlign: TextAlign.center,
                            style: theme.text.secondary.copyWith(color: ink),
                          ),
                          if (returnTime != null) ...[
                            const SizedBox(height: t.FoxSpace.xxs),
                            Text(
                              returnTime,
                              textAlign: TextAlign.center,
                              style: theme.text.secondary.copyWith(
                                color: ink,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Two strings from the nail to the board's corners (the drawing's
/// 192 × 40 box: from 96,2 to 20,38 and 172,38).
class _Strings extends CustomPainter {
  _Strings({required this.colour});

  final Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colour
      ..strokeWidth = t.FoxSpace.xxs / 2
      ..strokeCap = StrokeCap.round;
    final top = Offset(size.width / 2, size.height * 2 / 40);
    final y = size.height * 38 / 40;
    canvas
      ..drawLine(top, Offset(size.width * 20 / 192, y), paint)
      ..drawLine(top, Offset(size.width * 172 / 192, y), paint);
  }

  @override
  bool shouldRepaint(_Strings old) => old.colour != colour;
}
