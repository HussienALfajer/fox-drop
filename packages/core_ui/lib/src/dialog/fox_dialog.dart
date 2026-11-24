import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../button/fox_button.dart';
import '../icon/fox_icon.dart';
import '../text_field/fox_text_field.dart';
import '../theme/fox_theme.dart';

/// The states every Dialog use case and golden shows (R3).
const dialogStates = ['default', 'destructive', 'single'];

/// The states every ConfirmDialog use case and golden shows (R3).
const confirmDialogStates = ['empty', 'error', 'filled'];

/// Where a dialog sits: centred, or in the thumb zone (the captain app).
enum FoxDialogPlacement { center, bottom }

/// One action of a dialog. The app closes the dialog in [onPressed]
/// (`Navigator.pop`), so it can wait for a command first.
@immutable
final class FoxDialogAction {
  const FoxDialogAction({
    required this.label,
    required this.onPressed,
    this.destructive = false,
  });

  final String label;
  final VoidCallback? onPressed;

  /// Drawn in danger, and never the first focus.
  final bool destructive;
}

/// Opens [builder]'s dialog over the scrim (D.10): it fades in with a 0.96
/// to 1 scale over `duration.base`, a fade only under reduced motion.
/// Escape, the system back button and a tap on the scrim close it unless
/// [dismissible] is false; focus stays inside and returns to the trigger.
Future<T?> showFoxDialog<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool dismissible = true,
  String? dismissLabel,
  FoxDialogPlacement placement = FoxDialogPlacement.center,
}) {
  final theme = FoxTheme.of(context);
  return Navigator.of(context).push<T>(
    RawDialogRoute<T>(
      barrierDismissible: dismissible,
      barrierLabel: dismissLabel,
      barrierColor: theme.colors.scrim,
      transitionDuration: t.FoxDuration.base,
      pageBuilder: (routeContext, _, _) => FoxTheme(
        data: theme,
        child: Shortcuts(
          shortcuts: const {
            SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(t.FoxSpace.md),
              child: Align(
                alignment: placement == FoxDialogPlacement.bottom
                    ? Alignment.bottomCenter
                    : Alignment.center,
                child: Builder(builder: builder),
              ),
            ),
          ),
        ),
      ),
      transitionBuilder: (context, animation, _, child) {
        final curved = CurvedAnimation(parent: animation, curve: theme.easing);
        final faded = FadeTransition(opacity: curved, child: child);
        if (MediaQuery.disableAnimationsOf(context)) return faded;
        return ScaleTransition(
          scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
          child: faded,
        );
      },
    ),
  );
}

/// The panel of a dialog (D.10): its title, words, optional [content] and
/// one or two actions, the first in reading order the [primary]. The safe
/// action takes the first focus: [secondary] when the primary is
/// destructive, else the primary.
class FoxDialog extends StatelessWidget {
  const FoxDialog({
    super.key,
    required this.title,
    required this.closeLabel,
    required this.primary,
    this.body,
    this.content,
    this.secondary,
    this.onClose,
  });

  final String title;
  final String? body;
  final Widget? content;
  final FoxDialogAction primary;
  final FoxDialogAction? secondary;

  /// The name of the × button.
  final String closeLabel;

  /// The × and nothing else; null pops the route.
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final secondary = this.secondary;
    final safeIsSecondary = primary.destructive && secondary != null;
    final body = this.body;
    return DialogPanel(
      title: title,
      closeLabel: closeLabel,
      onClose: onClose,
      sections: [
        if (body != null)
          Text(
            body,
            style: theme.text.body.copyWith(color: theme.colors.onSurfaceMuted),
          ),
        ?content,
      ],
      actions: [
        FoxButton(
          label: primary.label,
          onPressed: primary.onPressed,
          variant: primary.destructive
              ? FoxButtonVariant.danger
              : FoxButtonVariant.primary,
          autofocus: !primary.destructive,
        ),
        if (secondary != null)
          FoxButton(
            label: secondary.label,
            onPressed: secondary.onPressed,
            variant: secondary.destructive
                ? FoxButtonVariant.danger
                : FoxButtonVariant.secondary,
            autofocus: safeIsSecondary,
          ),
      ],
    );
  }
}

/// The confirmation of a destructive or financial action in the panel (AP
/// §7.4): the reason (required: a blank one shows [reasonError] and
/// confirms nothing), the money effect when ledgers move, and who is
/// notified. The reason field takes the first focus.
class FoxConfirmDialog extends StatefulWidget {
  const FoxConfirmDialog({
    super.key,
    required this.title,
    required this.closeLabel,
    required this.reasonLabel,
    required this.reasonError,
    required this.notifiedTitle,
    required this.notified,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.onConfirm,
    this.reasonMarker,
    this.reasonPlaceholder,
    this.effectTitle,
    this.effect,
    this.onCancel,
    this.initialReason,
    this.showError = false,
  });

  final String title;
  final String closeLabel;
  final String reasonLabel;
  final String? reasonMarker;
  final String? reasonPlaceholder;
  final String reasonError;

  /// «أثره على الأرصدة» over [effect] (an amounts summary).
  final String? effectTitle;
  final Widget? effect;

  /// «سيُبلَّغ» over the names in [notified].
  final String notifiedTitle;
  final List<String> notified;
  final String confirmLabel;
  final String cancelLabel;

  /// Called with the trimmed reason; the app closes the dialog.
  final ValueChanged<String> onConfirm;

  /// Null pops the route.
  final VoidCallback? onCancel;

  /// For the catalogue and goldens: a reason already written, or the error
  /// already shown.
  final String? initialReason;
  final bool showError;

  @override
  State<FoxConfirmDialog> createState() => _FoxConfirmDialogState();
}

class _FoxConfirmDialogState extends State<FoxConfirmDialog> {
  late final TextEditingController _reason = TextEditingController(
    text: widget.initialReason,
  );
  final FocusNode _field = FocusNode(debugLabel: 'FoxConfirmDialog.reason');
  late bool _showError = widget.showError;

  @override
  void dispose() {
    _reason.dispose();
    _field.dispose();
    super.dispose();
  }

  void _confirm() {
    final reason = _reason.text.trim();
    if (reason.isEmpty) {
      setState(() => _showError = true);
      _field.requestFocus();
      return;
    }
    widget.onConfirm(reason);
  }

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final c = theme.colors;
    final effect = widget.effect;
    final effectTitle = widget.effectTitle;
    final strong = theme.text.secondary.copyWith(
      color: c.onSurface,
      fontWeight: FontWeight.w700,
    );
    return DialogPanel(
      title: widget.title,
      closeLabel: widget.closeLabel,
      onClose: widget.onCancel,
      sections: [
        FoxTextField(
          controller: _reason,
          focusNode: _field,
          label: widget.reasonLabel,
          marker: widget.reasonMarker,
          placeholder: widget.reasonPlaceholder,
          error: _showError && _reason.text.trim().isEmpty
              ? widget.reasonError
              : null,
          autofocus: true,
          onChanged: (_) => setState(() {}),
        ),
        if (effect != null)
          DecoratedBox(
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(t.FoxRadius.md),
            ),
            child: Padding(
              padding: const EdgeInsets.all(t.FoxSpace.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (effectTitle != null) ...[
                    Text(effectTitle, style: strong),
                    const SizedBox(height: t.FoxSpace.xs),
                  ],
                  effect,
                ],
              ),
            ),
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.notifiedTitle, style: strong),
            const SizedBox(height: t.FoxSpace.xs),
            Wrap(
              spacing: t.FoxSpace.xs,
              runSpacing: t.FoxSpace.xs,
              children: [for (final who in widget.notified) _Notified(who)],
            ),
          ],
        ),
      ],
      actions: [
        FoxButton(
          label: widget.confirmLabel,
          onPressed: _confirm,
          variant: FoxButtonVariant.danger,
        ),
        FoxButton(
          label: widget.cancelLabel,
          onPressed:
              widget.onCancel ?? () => Navigator.maybeOf(context)?.maybePop(),
          variant: FoxButtonVariant.secondary,
        ),
      ],
    );
  }
}

/// One name in the notified list: a bell and the name on the info tint.
class _Notified extends StatelessWidget {
  const _Notified(this.name);

  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final c = theme.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.infoSubtle,
        borderRadius: BorderRadius.circular(t.FoxRadius.full),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: t.FoxSpace.sm,
          vertical: t.FoxSpace.xxs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FoxIcon(t.FoxIcons.bell, size: FoxIconSize.sm, color: c.info),
            const SizedBox(width: t.FoxSpace.xxs),
            Flexible(
              child: Text(
                name,
                style: theme.text.secondary.copyWith(
                  color: c.info,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The raised panel shared by the dialogs: the title with the ×, the body
/// and the actions, scrolling as a whole when the screen is short. Not
/// exported.
class DialogPanel extends StatelessWidget {
  const DialogPanel({
    super.key,
    required this.title,
    required this.closeLabel,
    required this.sections,
    required this.actions,
    this.onClose,
  });

  final String title;
  final String closeLabel;
  final List<Widget> sections;
  final List<Widget> actions;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final c = theme.colors;
    final column = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Semantics(
                header: true,
                namesRoute: true,
                child: Text(
                  title,
                  style: theme.text.title.copyWith(
                    color: c.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: t.FoxSpace.xs),
            FoxButton.icon(
              icon: t.FoxIcons.close,
              label: closeLabel,
              variant: FoxButtonVariant.ghost,
              onPressed:
                  onClose ?? () => Navigator.maybeOf(context)?.maybePop(),
            ),
          ],
        ),
        for (final child in sections) ...[
          const SizedBox(height: t.FoxSpace.md),
          child,
        ],
        const SizedBox(height: t.FoxSpace.lg),
        Wrap(
          spacing: t.FoxSpace.sm,
          runSpacing: t.FoxSpace.sm,
          children: actions,
        ),
      ],
    );
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: t.FoxSize.dialog),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: c.surfaceRaised,
            borderRadius: BorderRadius.circular(t.FoxRadius.lg),
            boxShadow: [theme.shadows.high],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(t.FoxRadius.lg),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final padded = Padding(
                  padding: const EdgeInsets.all(t.FoxSpace.lg),
                  child: column,
                );
                return constraints.hasBoundedHeight
                    ? SingleChildScrollView(child: padded)
                    : padded;
              },
            ),
          ),
        ),
      ),
    );
  }
}
