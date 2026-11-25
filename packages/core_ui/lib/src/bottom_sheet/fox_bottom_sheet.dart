import 'dart:math' as math;

import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../button/fox_button.dart';
import '../theme/fox_theme.dart';

/// The states every BottomSheet use case and golden shows (R3).
const bottomSheetStates = ['plain', 's-curve', 'long'];

/// The share of the screen a sheet may take at most.
const double _maxShare = 0.9;

/// Opens [builder]'s sheet from the bottom edge over the scrim (D.10): it
/// slides in over `duration.slow`, a fade only under reduced motion. A drag
/// down, the scrim, Escape and the system back button close it unless
/// [dismissible] is false.
Future<T?> showFoxBottomSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool dismissible = true,
  String? dismissLabel,
}) {
  final theme = FoxTheme.of(context);
  return Navigator.of(context).push<T>(
    _SheetRoute<T>(
      theme: theme,
      builder: builder,
      dismissible: dismissible,
      dismissLabel: dismissLabel,
    ),
  );
}

class _SheetRoute<T> extends PopupRoute<T> {
  _SheetRoute({
    required this.theme,
    required this.builder,
    required this.dismissible,
    required this.dismissLabel,
  });

  final FoxThemeData theme;
  final WidgetBuilder builder;
  final bool dismissible;
  final String? dismissLabel;

  @override
  Color get barrierColor => theme.colors.scrim;

  @override
  bool get barrierDismissible => dismissible;

  @override
  String? get barrierLabel => dismissLabel;

  @override
  Duration get transitionDuration => t.FoxDuration.slow;

  @override
  Widget buildPage(BuildContext context, _, _) => FoxTheme(
    data: theme,
    child: Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: _DragToDismiss(
          enabled: dismissible,
          child: Builder(builder: builder),
        ),
      ),
    ),
  );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    _,
    Widget child,
  ) {
    final curved = CurvedAnimation(parent: animation, curve: theme.easing);
    if (MediaQuery.disableAnimationsOf(context)) {
      return FadeTransition(opacity: curved, child: child);
    }
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, t.FoxMotion.enterSheet),
        end: Offset.zero,
      ).animate(curved),
      child: child,
    );
  }
}

/// A drag down past a quarter of the sheet, or a fling, closes it; a shorter
/// one springs back.
class _DragToDismiss extends StatefulWidget {
  const _DragToDismiss({required this.enabled, required this.child});

  final bool enabled;
  final Widget child;

  @override
  State<_DragToDismiss> createState() => _DragToDismissState();
}

class _DragToDismissState extends State<_DragToDismiss> {
  double _offset = 0;
  bool _dragging = false;

  void _end(DragEndDetails details) {
    final height = context.size?.height ?? 1;
    final fling = (details.primaryVelocity ?? 0) > 700;
    if (fling || _offset > height / 4) {
      Navigator.maybeOf(context)?.maybePop();
    } else {
      setState(() {
        _dragging = false;
        _offset = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    return GestureDetector(
      onVerticalDragStart: (_) => setState(() => _dragging = true),
      onVerticalDragUpdate: (details) => setState(
        () => _offset = math.max(0, _offset + details.primaryDelta!),
      ),
      onVerticalDragEnd: _end,
      child: AnimatedContainer(
        duration: _dragging ? Duration.zero : t.FoxDuration.base,
        curve: FoxTheme.of(context).easing,
        transform: Matrix4.translationValues(0, _offset, 0),
        child: widget.child,
      ),
    );
  }
}

/// A sheet from the bottom edge (D.10): a handle, its [title] and its
/// content, at most 90% of the screen (the content scrolls past it), the
/// home indicator and the keyboard kept clear. [sCurve] draws the brand's
/// S-curve tab holding the title (brand expression §2: the customer's item
/// sheet); otherwise the top is plain with a ×.
class FoxBottomSheet extends StatelessWidget {
  const FoxBottomSheet({
    super.key,
    required this.title,
    required this.closeLabel,
    required this.child,
    this.sCurve = false,
    this.onClose,
  });

  /// Shown, and the sheet's accessible name.
  final String title;

  /// The × of the plain top, and the screen reader's dismiss action.
  final String closeLabel;
  final Widget child;
  final bool sCurve;

  /// Null pops the route.
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final c = theme.colors;
    final media = MediaQuery.of(context);
    final close = onClose ?? () => Navigator.maybeOf(context)?.maybePop();
    final background = sCurve ? c.surface : c.surfaceRaised;
    final handle = Center(
      child: Container(
        width: t.FoxSpace.xl + t.FoxSpace.xs,
        height: t.FoxSpace.xxs,
        decoration: BoxDecoration(
          color: c.borderStrong,
          borderRadius: BorderRadius.circular(t.FoxRadius.full),
        ),
      ),
    );
    final titleText = Text(
      title,
      style: (sCurve ? theme.text.subtitle : theme.text.title).copyWith(
        color: sCurve ? c.heading : c.onSurface,
        fontWeight: FontWeight.w700,
      ),
    );
    final Widget top = sCurve
        ? LayoutBuilder(
            builder: (context, constraints) => CustomPaint(
              painter: _SCurvePainter(
                color: background,
                direction: Directionality.of(context),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: t.FoxSpace.lg,
                  top: t.FoxSpace.xs,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth:
                              constraints.maxWidth * _SCurvePainter.tabShare -
                              t.FoxSpace.xl,
                        ),
                        child: titleText,
                      ),
                    ),
                    const SizedBox(height: t.FoxSpace.sm),
                    handle,
                    const SizedBox(height: t.FoxSpace.xs),
                  ],
                ),
              ),
            ),
          )
        : ColoredBox(
            color: background,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                start: t.FoxSpace.lg,
                end: t.FoxSpace.sm,
                top: t.FoxSpace.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  handle,
                  Row(
                    children: [
                      Expanded(child: titleText),
                      FoxButton.icon(
                        icon: t.FoxIcons.close,
                        label: closeLabel,
                        variant: FoxButtonVariant.ghost,
                        onPressed: close,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
    final radius = BorderRadius.vertical(
      top: Radius.circular(sCurve ? 0 : t.FoxRadius.xl),
    );
    return Semantics(
      container: true,
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: title,
      onDismiss: close,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: media.size.height * _maxShare),
        child: ClipRRect(
          borderRadius: radius,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              top,
              Flexible(
                child: ColoredBox(
                  color: background,
                  child: SingleChildScrollView(
                    padding: EdgeInsetsDirectional.only(
                      start: t.FoxSpace.lg,
                      end: t.FoxSpace.lg,
                      bottom:
                          t.FoxSpace.md +
                          math.max(
                            media.viewPadding.bottom,
                            media.viewInsets.bottom,
                          ),
                    ),
                    child: child,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The S-curve tab (brand expression §2): a soft bump rising from the top
/// edge on the start side, the rest of the edge lower by the tab's height.
class _SCurvePainter extends CustomPainter {
  _SCurvePainter({required this.color, required this.direction});

  final Color color;
  final TextDirection direction;

  /// The share of the width the tab takes.
  static const double tabShare = 0.6;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    // The full-width edge sits under the title, at the handle's band.
    final edge = math.max(0.0, h - t.FoxSpace.lg);
    const r = t.FoxRadius.xl;
    final tab = w * (1 - tabShare);
    const s = t.FoxSpace.xl;
    // Drawn with the tab at the right (RTL's start), mirrored for LTR.
    final path = Path()
      ..moveTo(0, edge + r)
      ..quadraticBezierTo(0, edge, r, edge)
      ..lineTo(math.max(r, tab - s), edge)
      ..cubicTo(tab - s / 3, edge, tab - s / 3, 0, tab + s / 2, 0)
      ..lineTo(w - r, 0)
      ..quadraticBezierTo(w, 0, w, r)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    if (direction == TextDirection.ltr) {
      canvas
        ..translate(w, 0)
        ..scale(-1, 1);
    }
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_SCurvePainter old) =>
      old.color != color || old.direction != direction;
}
