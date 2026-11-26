import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../icon/fox_icon.dart';
import '../theme/fox_theme.dart';
import 'interaction.dart';

/// One row of a menu: a value and its text.
@immutable
final class MenuItem<T> {
  const MenuItem({required this.value, required this.label});

  final T value;
  final String label;
}

/// A menu that opens under [child] (the select and the phone's country
/// chip, D.8): as wide as [child], on the overlay, closed by a tap outside,
/// Escape or a choice. Arrow keys move through the rows, Enter or Space
/// picks; it stays a menu on phones too (owner, D.10). Not exported.
class AnchoredMenu<T> extends StatefulWidget {
  const AnchoredMenu({
    super.key,
    required this.controller,
    required this.child,
    required this.items,
    required this.selected,
    required this.onSelected,
    required this.onClosed,
    this.label,
  });

  final OverlayPortalController controller;
  final Widget child;
  final List<MenuItem<T>> items;
  final T? selected;
  final ValueChanged<T> onSelected;

  /// The menu left without a choice (a tap outside, Escape or back).
  final VoidCallback onClosed;

  /// The list's accessible name.
  final String? label;

  @override
  State<AnchoredMenu<T>> createState() => _AnchoredMenuState<T>();
}

class _AnchoredMenuState<T> extends State<AnchoredMenu<T>> {
  final LayerLink _link = LayerLink();

  @override
  Widget build(BuildContext context) => PopScope(
    // Android back closes an open menu before it leaves the page (D.10).
    canPop: !widget.controller.isShowing,
    onPopInvokedWithResult: (didPop, _) {
      if (!didPop && widget.controller.isShowing) widget.onClosed();
    },
    child: CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: widget.controller,
        overlayChildBuilder: _overlay,
        child: widget.child,
      ),
    ),
  );

  Widget _overlay(BuildContext overlayContext) {
    final box = context.findRenderObject() as RenderBox?;
    final width = box?.size.width;
    final direction = Directionality.of(context);
    final theme = FoxTheme.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onClosed,
          ),
        ),
        // Loose constraints for the follower (the stack gives tight ones);
        // the link, not this alignment, places it.
        Align(
          alignment: AlignmentDirectional.topStart,
          child: CompositedTransformFollower(
            link: _link,
            showWhenUnlinked: false,
            targetAnchor: AlignmentDirectional.bottomStart.resolve(direction),
            followerAnchor: AlignmentDirectional.topStart.resolve(direction),
            offset: const Offset(0, t.FoxSpace.xxs),
            child: Directionality(
              textDirection: direction,
              child: FoxTheme(
                data: theme,
                child: SizedBox(
                  width: width,
                  child: _MenuList<T>(
                    items: widget.items,
                    selected: widget.selected,
                    label: widget.label,
                    onSelected: widget.onSelected,
                    onClosed: widget.onClosed,
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

class _MenuList<T> extends StatefulWidget {
  const _MenuList({
    required this.items,
    required this.selected,
    required this.label,
    required this.onSelected,
    required this.onClosed,
  });

  final List<MenuItem<T>> items;
  final T? selected;
  final String? label;
  final ValueChanged<T> onSelected;
  final VoidCallback onClosed;

  @override
  State<_MenuList<T>> createState() => _MenuListState<T>();
}

class _MenuListState<T> extends State<_MenuList<T>> {
  final FocusScopeNode _scope = FocusScopeNode(debugLabel: 'FoxMenu');
  late final List<FocusNode> _nodes = [
    for (final _ in widget.items) FocusNode(debugLabel: 'FoxMenuItem'),
  ];

  @override
  void initState() {
    super.initState();
    // Focus goes to the chosen row, or the first, as the menu opens.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _nodes.isEmpty) return;
      final at = widget.items.indexWhere((e) => e.value == widget.selected);
      _nodes[at < 0 ? 0 : at].requestFocus();
    });
  }

  @override
  void dispose() {
    for (final node in _nodes) {
      node.dispose();
    }
    _scope.dispose();
    super.dispose();
  }

  void _move(int by) {
    final at = _nodes.indexWhere((n) => n.hasFocus);
    final next = (at + by).clamp(0, _nodes.length - 1);
    _focus(next);
  }

  void _focus(int at) {
    _nodes[at].requestFocus();
    final row = _nodes[at].context;
    if (row != null) Scrollable.ensureVisible(row);
  }

  /// The letters typed in the last second, for type-ahead.
  String _typed = '';
  DateTime _lastKey = DateTime.fromMillisecondsSinceEpoch(0);

  /// Typing letters moves focus to the first option that starts with them
  /// (a pause of a second starts a new word). Space and the keys with
  /// modifiers are left to the rows and the shortcuts.
  KeyEventResult _typeAhead(FocusNode _, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final character = event.character;
    final keyboard = HardwareKeyboard.instance;
    if (character == null ||
        character.trim().isEmpty ||
        character.runes.any((r) => r < 0x20 || r == 0x7f) ||
        keyboard.isControlPressed ||
        keyboard.isMetaPressed ||
        keyboard.isAltPressed) {
      return KeyEventResult.ignored;
    }
    final now = DateTime.now();
    if (now.difference(_lastKey) > const Duration(seconds: 1)) _typed = '';
    _lastKey = now;
    int find(String prefix) => widget.items.indexWhere(
      (e) => e.label.toLowerCase().startsWith(prefix.toLowerCase()),
    );
    _typed += character;
    var at = find(_typed);
    if (at < 0 && _typed.length > 1) {
      // No match for the word: try the new letter alone.
      _typed = character;
      at = find(_typed);
    }
    if (at >= 0) _focus(at);
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final input = theme.input;
    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.arrowDown): NextFocusIntent(),
        SingleActivator(LogicalKeyboardKey.arrowUp): PreviousFocusIntent(),
        SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
      },
      child: Actions(
        actions: {
          NextFocusIntent: CallbackAction<NextFocusIntent>(
            onInvoke: (_) {
              _move(1);
              return null;
            },
          ),
          PreviousFocusIntent: CallbackAction<PreviousFocusIntent>(
            onInvoke: (_) {
              _move(-1);
              return null;
            },
          ),
          DismissIntent: CallbackAction<DismissIntent>(
            onInvoke: (_) {
              widget.onClosed();
              return null;
            },
          ),
        },
        child: FocusScope(
          node: _scope,
          onKeyEvent: _typeAhead,
          child: Semantics(
            container: true,
            scopesRoute: true,
            explicitChildNodes: true,
            label: widget.label,
            // The web select's list and the D.8 sheet's: the field's
            // background and long radius, 2xs inside, no outline (parity,
            // D.W3c; it had an outline and square rows).
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: input.background,
                borderRadius: BorderRadius.circular(input.areaRadius),
                boxShadow: [theme.shadows.medium],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(input.areaRadius),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: t.FoxSize.menuMaxHeight,
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(t.FoxSpace.xxs),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var n = 0; n < widget.items.length; n++)
                          _MenuRow(
                            label: widget.items[n].label,
                            selected: widget.items[n].value == widget.selected,
                            node: _nodes[n],
                            onTap: () =>
                                widget.onSelected(widget.items[n].value),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.label,
    required this.selected,
    required this.node,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final FocusNode node;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final c = theme.colors;
    final input = theme.input;
    // The web's row: rounded, sm inside, the highlight on `surface-hover`,
    // the chosen one in medium weight with a small check (parity, D.W3c).
    return Interaction(
      focusNode: node,
      onTap: onTap,
      label: label,
      checked: selected,
      inGroup: true,
      builder: (context, state) => AnimatedContainer(
        duration: t.FoxDuration.base,
        curve: theme.easing,
        constraints: BoxConstraints(minHeight: input.checkTarget),
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: t.FoxSpace.sm,
          vertical: t.FoxSpace.xs,
        ),
        decoration: BoxDecoration(
          color: state.pressed
              ? c.surfacePressed
              : (state.hovered || state.focused
                    ? c.surfaceHover
                    : c.surface.withValues(alpha: 0)),
          borderRadius: BorderRadius.circular(t.FoxRadius.md),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: theme.text.body.copyWith(
                  color: input.text,
                  fontWeight: FoxTextTheme.fontWeight(selected ? 500 : 400),
                ),
              ),
            ),
            if (selected) ...[
              SizedBox(width: input.gap),
              FoxIcon(
                t.FoxIcons.confirm,
                size: FoxIconSize.sm,
                color: input.accent,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
