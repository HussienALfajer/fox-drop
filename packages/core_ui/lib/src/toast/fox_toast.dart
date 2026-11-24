import 'dart:async';

import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';

import '../icon/fox_icon.dart';
import '../internal/interaction.dart';
import '../theme/fox_theme.dart';

/// The states every Toast use case and golden shows (R3).
const toastStates = ['success', 'info', 'warning', 'danger', 'action'];

/// The states of the Toaster's use case (R3).
const toasterStates = ['default'];

/// The tone of a toast: the icon says it, never the colour alone.
enum FoxToastTone { success, info, warning, danger }

/// How long a toast stays: success and info 4 s, warning 6 s, one with an
/// action 8 s, danger until closed (null).
Duration? foxToastDuration(FoxToastTone tone, {bool hasAction = false}) {
  if (tone == FoxToastTone.danger) return null;
  if (hasAction) return const Duration(seconds: 8);
  if (tone == FoxToastTone.warning) return const Duration(seconds: 6);
  return const Duration(seconds: 4);
}

/// A short result of the user's own action (D.10, owner: dark blue): the
/// tone's icon, the words, an optional action and the ×. Never the only
/// signal of an alert (AP §7.3 alerts are banners with sound).
class FoxToast extends StatelessWidget {
  const FoxToast({
    super.key,
    required this.tone,
    required this.message,
    required this.closeLabel,
    this.onClose,
    this.actionLabel,
    this.onAction,
  });

  final FoxToastTone tone;
  final String message;
  final String closeLabel;
  final VoidCallback? onClose;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final c = theme.colors;
    final ink = c.onAccent;
    // Light steps of each tone, readable on the dark blue (icons, 3:1).
    final (icon, iconColour) = switch (tone) {
      FoxToastTone.success => (t.FoxIcons.success, c.successSubtle),
      FoxToastTone.info => (t.FoxIcons.info, c.infoSubtle),
      FoxToastTone.warning => (t.FoxIcons.warning, c.warningSubtle),
      FoxToastTone.danger => (t.FoxIcons.error, c.dangerSubtle),
    };
    final actionLabel = this.actionLabel;
    final style = theme.text.secondary.copyWith(
      color: ink,
      fontWeight: FontWeight.w500,
    );
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: t.FoxSize.toast),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.accent,
          borderRadius: BorderRadius.circular(t.FoxRadius.md),
          boxShadow: [theme.shadows.medium],
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.only(
            start: t.FoxSpace.sm,
            top: t.FoxSpace.xxs,
            bottom: t.FoxSpace.xxs,
          ),
          child: Row(
            children: [
              FoxIcon(icon, color: iconColour),
              const SizedBox(width: t.FoxSpace.xs),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: t.FoxSpace.xs),
                  child: Text(message, style: style),
                ),
              ),
              if (actionLabel != null)
                Flexible(
                  child: _TextAction(
                    label: actionLabel,
                    onTap: onAction,
                    style: style.copyWith(
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                      decorationColor: ink,
                    ),
                  ),
                ),
              _CloseAction(label: closeLabel, onTap: onClose, color: ink),
            ],
          ),
        ),
      ),
    );
  }
}

class _TextAction extends StatelessWidget {
  const _TextAction({
    required this.label,
    required this.onTap,
    required this.style,
  });

  final String label;
  final VoidCallback? onTap;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    return Interaction(
      onTap: onTap,
      label: label,
      isButton: true,
      builder: (context, state) => Container(
        constraints: const BoxConstraints(minHeight: t.FoxSize.touchTarget),
        padding: const EdgeInsets.symmetric(horizontal: t.FoxSpace.xs),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(t.FoxRadius.sm),
          border: state.focused
              ? Border.all(
                  color: theme.colors.onAccent,
                  width: theme.input.focusWidth,
                )
              : null,
        ),
        child: Align(
          widthFactor: 1,
          heightFactor: 1,
          child: Text(label, style: style),
        ),
      ),
    );
  }
}

class _CloseAction extends StatelessWidget {
  const _CloseAction({
    required this.label,
    required this.onTap,
    required this.color,
  });

  final String label;
  final VoidCallback? onTap;
  final Color color;

  @override
  Widget build(BuildContext context) => Interaction(
    onTap: onTap,
    label: label,
    isButton: true,
    builder: (context, state) => Container(
      width: t.FoxSize.touchTarget,
      height: t.FoxSize.touchTarget,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: state.focused
            ? Border.all(
                color: color,
                width: FoxTheme.of(context).input.focusWidth,
              )
            : null,
      ),
      child: FoxIcon(t.FoxIcons.close, size: FoxIconSize.sm, color: color),
    ),
  );
}

/// Shows toasts over [child], one at a time: a new one replaces the old.
/// They sit [bottomInset] above the bottom edge (above the bottom
/// navigation), centred on phones. Announced in a polite live region,
/// assertively for danger; the timer pauses while a mouse is over the toast
/// or focus is inside it. Fades and rises 8 px over `duration.base`; a fade
/// only under reduced motion.
class FoxToaster extends StatefulWidget {
  const FoxToaster({super.key, required this.child, this.bottomInset = 0});

  final Widget child;
  final double bottomInset;

  /// The nearest toaster.
  static FoxToasterState of(BuildContext context) {
    final state = context.findAncestorStateOfType<FoxToasterState>();
    if (state == null) {
      throw FlutterError('No FoxToaster above this widget.');
    }
    return state;
  }

  @override
  State<FoxToaster> createState() => FoxToasterState();
}

@immutable
final class _ToastData {
  const _ToastData({
    required this.key,
    required this.tone,
    required this.message,
    required this.closeLabel,
    this.actionLabel,
    this.onAction,
  });

  final Key key;
  final FoxToastTone tone;
  final String message;
  final String closeLabel;
  final String? actionLabel;
  final VoidCallback? onAction;
}

class FoxToasterState extends State<FoxToaster> {
  _ToastData? _current;
  Timer? _timer;
  bool _hovered = false;
  bool _focused = false;
  int _count = 0;

  /// Shows a toast, replacing the one on screen.
  void show({
    required FoxToastTone tone,
    required String message,
    required String closeLabel,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    setState(() {
      _current = _ToastData(
        key: ValueKey(_count++),
        tone: tone,
        message: message,
        closeLabel: closeLabel,
        actionLabel: actionLabel,
        onAction: onAction,
      );
      _hovered = false;
      _focused = false;
    });
    unawaited(
      SemanticsService.sendAnnouncement(
        View.of(context),
        message,
        Directionality.of(context),
        assertiveness: tone == FoxToastTone.danger
            ? Assertiveness.assertive
            : Assertiveness.polite,
      ),
    );
    _start();
  }

  /// Removes the toast on screen.
  void dismiss() {
    _timer?.cancel();
    if (mounted) setState(() => _current = null);
  }

  void _start() {
    _timer?.cancel();
    final current = _current;
    if (current == null || _hovered || _focused) return;
    final duration = foxToastDuration(
      current.tone,
      hasAction: current.actionLabel != null,
    );
    if (duration != null) _timer = Timer(duration, dismiss);
  }

  void _pause() => _timer?.cancel();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = _current;
    final still = MediaQuery.disableAnimationsOf(context);
    final theme = FoxTheme.of(context);
    return Stack(
      children: [
        widget.child,
        PositionedDirectional(
          start: 0,
          end: 0,
          bottom: widget.bottomInset + t.FoxSpace.sm,
          child: AnimatedSwitcher(
            duration: t.FoxDuration.base,
            switchInCurve: theme.easing,
            transitionBuilder: (child, animation) {
              final faded = FadeTransition(
                opacity: animation,
                alwaysIncludeSemantics: true,
                child: child,
              );
              if (still) return faded;
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.15),
                  end: Offset.zero,
                ).animate(animation),
                child: faded,
              );
            },
            child: current == null
                ? const SizedBox.shrink()
                : Padding(
                    key: current.key,
                    padding: const EdgeInsets.symmetric(
                      horizontal: t.FoxSpace.sm,
                    ),
                    child: Center(
                      child: Semantics(
                        container: true,
                        liveRegion: true,
                        child: MouseRegion(
                          onEnter: (_) {
                            _hovered = true;
                            _pause();
                          },
                          onExit: (_) {
                            _hovered = false;
                            _start();
                          },
                          child: Focus(
                            canRequestFocus: false,
                            skipTraversal: true,
                            onFocusChange: (inside) {
                              _focused = inside;
                              inside ? _pause() : _start();
                            },
                            child: FoxToast(
                              tone: current.tone,
                              message: current.message,
                              closeLabel: current.closeLabel,
                              actionLabel: current.actionLabel,
                              onAction: current.onAction == null
                                  ? null
                                  : () {
                                      current.onAction!();
                                      dismiss();
                                    },
                              onClose: dismiss,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
