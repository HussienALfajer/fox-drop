import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/widgets.dart';

import '../button/fox_button.dart';
import '../icon/fox_icon.dart';
import '../theme/fox_theme.dart';

/// The states every EmptyState use case and golden shows (R3), as the web's.
const emptyStateStates = ['default', 'action', 'error'];

/// An error writes its title in danger and makes its action primary.
enum FoxEmptyTone { normal, error }

/// The one action of an empty or error state: «أعد المحاولة».
@immutable
final class FoxEmptyAction {
  const FoxEmptyAction(this.label, this.onPressed);

  final String label;
  final VoidCallback onPressed;
}

/// An empty, error or offline state (R6): an icon inside the logo's drop
/// (brand expression §2, §5; the fox scenes take its place once drawn and
/// approved), a title, one line and at most one action.
class FoxEmptyState extends StatelessWidget {
  const FoxEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.action,
    this.tone = FoxEmptyTone.normal,
  });

  final t.FoxIconData icon;
  final String title;
  final String? description;
  final FoxEmptyAction? action;
  final FoxEmptyTone tone;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final c = theme.colors;
    final description = this.description;
    final action = this.action;
    final error = tone == FoxEmptyTone.error;
    const drop = t.FoxSpace.xxxl * 2;
    return Padding(
      padding: const EdgeInsetsDirectional.all(t.FoxSpace.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExcludeSemantics(
            child: SizedBox(
              width: drop,
              height: drop,
              child: CustomPaint(
                painter: _Drop(
                  fill: c.primarySubtle,
                  edge: c.primary,
                  width: theme.input.borderWidth,
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(bottom: drop / 4),
                  child: Center(
                    child: FoxIcon(
                      icon,
                      size: FoxIconSize.lg,
                      style: FoxIconStyle.brandDuo,
                      color: c.onPrimarySubtle,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: t.FoxSpace.sm),
          Semantics(
            header: true,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: theme.text.title.copyWith(
                color: error ? c.danger : c.heading,
              ),
            ),
          ),
          if (description != null) ...[
            const SizedBox(height: t.FoxSpace.xxs),
            Text(
              description,
              textAlign: TextAlign.center,
              style: theme.text.secondary.copyWith(color: c.onSurfaceMuted),
            ),
          ],
          if (action != null) ...[
            const SizedBox(height: t.FoxSpace.md),
            FoxButton(
              label: action.label,
              onPressed: action.onPressed,
              variant: error
                  ? FoxButtonVariant.primary
                  : FoxButtonVariant.secondary,
            ),
          ],
        ],
      ),
    );
  }
}

/// The logo's drop, a map pin's round head and point, on the 24 grid.
class _Drop extends CustomPainter {
  _Drop({required this.fill, required this.edge, required this.width});

  final Color fill;
  final Color edge;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;
    // M12 23s9-8.4 9-14.5a9 9 0 0 0-18 0C3 14.6 12 23 12 23Z
    final path = Path()
      ..moveTo(12 * s, 23 * s)
      ..cubicTo(12 * s, 23 * s, 21 * s, 14.6 * s, 21 * s, 8.5 * s)
      ..arcToPoint(
        Offset(3 * s, 8.5 * s),
        radius: Radius.circular(9 * s),
        largeArc: false,
        clockwise: false,
      )
      ..cubicTo(3 * s, 14.6 * s, 12 * s, 23 * s, 12 * s, 23 * s)
      ..close();
    canvas
      ..drawPath(path, Paint()..color = fill)
      ..drawPath(
        path,
        Paint()
          ..color = edge
          ..style = PaintingStyle.stroke
          ..strokeWidth = width * 2,
      );
  }

  @override
  bool shouldRepaint(_Drop old) => old.fill != fill || old.edge != edge;
}
