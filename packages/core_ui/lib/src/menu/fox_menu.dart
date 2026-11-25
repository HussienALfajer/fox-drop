import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../icon/fox_icon.dart';
import '../internal/interaction.dart';
import '../theme/fox_theme.dart';

/// The states every Menu use case and golden shows (R3).
const menuStates = ['closed', 'open', 'destructive'];

/// One row of a [FoxMenu], or a separator.
@immutable
final class FoxMenuItem {
  const FoxMenuItem({
    required this.label,
    required this.onSelected,
    this.icon,
    this.hint,
    this.destructive = false,
  }) : separator = false;

  /// A thin line between groups of items.
  const FoxMenuItem.separator()
    : label = '',
      onSelected = null,
      icon = null,
      hint = null,
      destructive = false,
      separator = true;

  final String label;
  final VoidCallback? onSelected;
  final t.FoxIconData? icon;

  /// Muted words at the end, such as a shortcut.
  final String? hint;

  /// In danger, after a separator: «تسجيل الخروج», «حذف».
  final bool destructive;
  final bool separator;
}

/// A menu of actions under its trigger (D.10): rows of 48 with an icon, a
/// destructive row in danger, separators. It opens under the trigger,
/// aligned to its start, above it when there is no room below. Arrows, Home,
/// End and type-ahead move along it; Enter or Space picks; Escape, a tap
/// outside or a pick closes it and gives focus back to the trigger.
class FoxMenu extends StatefulWidget {
  const FoxMenu({
    super.key,
    required this.items,
    required this.label,
    required this.builder,
    this.initiallyOpen = false,
  });

  final List<FoxMenuItem> items;

  /// The menu's accessible name.
  final String label;

  /// The trigger; call `open` from its press.
  final Widget Function(BuildContext context, VoidCallback open) builder;

  /// For the catalogue and goldens: open after the first frame.
  final bool initiallyOpen;

  /// The key of the open list, for tests.
  static const panelKey = ValueKey('FoxMenu.panel');

  @override
  State<FoxMenu> createState() => _FoxMenuState();
}

class _FoxMenuState extends State<FoxMenu> {
  final OverlayPortalController _portal = OverlayPortalController();
  final LayerLink _link = LayerLink();
  FocusNode? _returnTo;

  @override
  void initState() {
    super.initState();
    if (widget.initiallyOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _open();
      });
    }
  }

  void _open() {
    _returnTo = FocusManager.instance.primaryFocus;
    setState(_portal.show);
  }

  void _close() {
    if (!_portal.isShowing) return;
    setState(_portal.hide);
    final back = _returnTo;
    _returnTo = null;
    if (back != null && back.context != null) back.requestFocus();
  }

  @override
  Widget build(BuildContext context) => PopScope(
    // Android back closes an open menu before it leaves the page.
    canPop: !_portal.isShowing,
    onPopInvokedWithResult: (didPop, _) {
      if (!didPop) _close();
    },
    child: CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _portal,
        overlayChildBuilder: _overlay,
        child: widget.builder(context, _open),
      ),
    ),
  );

  Widget _overlay(BuildContext overlayContext) {
    final direction = Directionality.of(context);
    final theme = FoxTheme.of(context);
    final box = context.findRenderObject() as RenderBox?;
    final screen = MediaQuery.sizeOf(context).height;
    final below = box == null
        ? 0.0
        : screen - box.localToGlobal(Offset(0, box.size.height)).dy;
    final rows = widget.items.where((i) => !i.separator).length;
    final needed = rows * t.FoxSize.touchTarget + t.FoxSpace.lg;
    final above =
        box != null &&
        below < needed &&
        box.localToGlobal(Offset.zero).dy > below;
    final start = above
        ? AlignmentDirectional.topStart
        : AlignmentDirectional.bottomStart;
    final follower = above
        ? AlignmentDirectional.bottomStart
        : AlignmentDirectional.topStart;
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _close,
          ),
        ),
        Align(
          alignment: AlignmentDirectional.topStart,
          child: CompositedTransformFollower(
            link: _link,
            showWhenUnlinked: false,
            targetAnchor: start.resolve(direction),
            followerAnchor: follower.resolve(direction),
            offset: Offset(0, above ? -t.FoxSpace.xxs : t.FoxSpace.xxs),
            child: Directionality(
              textDirection: direction,
              child: FoxTheme(
                data: theme,
                child: _MenuPanel(
                  key: FoxMenu.panelKey,
                  items: widget.items,
                  label: widget.label,
                  onPicked: (item) {
                    _close();
                    item.onSelected?.call();
                  },
                  onClosed: _close,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuPanel extends StatefulWidget {
  const _MenuPanel({
    super.key,
    required this.items,
    required this.label,
    required this.onPicked,
    required this.onClosed,
  });

  final List<FoxMenuItem> items;
  final String label;
  final ValueChanged<FoxMenuItem> onPicked;
  final VoidCallback onClosed;

  @override
  State<_MenuPanel> createState() => _MenuPanelState();
}

class _MenuPanelState extends State<_MenuPanel> {
  final FocusScopeNode _scope = FocusScopeNode(debugLabel: 'FoxMenu');
  late final List<FoxMenuItem> _rows = [
    for (final item in widget.items)
      if (!item.separator) item,
  ];
  late final List<FocusNode> _nodes = [
    for (final _ in _rows) FocusNode(debugLabel: 'FoxMenuItem'),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _nodes.isNotEmpty) _nodes.first.requestFocus();
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

  int get _at => _nodes.indexWhere((n) => n.hasFocus);

  void _focus(int at) => _nodes[at.clamp(0, _nodes.length - 1)].requestFocus();

  String _typed = '';
  DateTime _lastKey = DateTime.fromMillisecondsSinceEpoch(0);

  KeyEventResult _key(FocusNode _, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowDown) {
      _focus(_at + 1);
    } else if (key == LogicalKeyboardKey.arrowUp) {
      _focus(_at - 1);
    } else if (key == LogicalKeyboardKey.home) {
      _focus(0);
    } else if (key == LogicalKeyboardKey.end) {
      _focus(_nodes.length - 1);
    } else if (key == LogicalKeyboardKey.escape) {
      widget.onClosed();
    } else if (key == LogicalKeyboardKey.tab) {
      // Tab leaves the menu, as on the web.
      widget.onClosed();
    } else {
      return _typeAhead(event);
    }
    return KeyEventResult.handled;
  }

  /// Letters move to the first row that starts with them; a pause of a
  /// second starts a new word.
  KeyEventResult _typeAhead(KeyEvent event) {
    final character = event.character;
    final keyboard = HardwareKeyboard.instance;
    if (character == null ||
        character.trim().isEmpty ||
        keyboard.isControlPressed ||
        keyboard.isMetaPressed ||
        keyboard.isAltPressed) {
      return KeyEventResult.ignored;
    }
    final now = DateTime.now();
    if (now.difference(_lastKey) > const Duration(seconds: 1)) _typed = '';
    _lastKey = now;
    int find(String prefix) =>
        _rows.indexWhere((r) => r.label.startsWith(prefix));
    _typed += character;
    var at = find(_typed);
    if (at < 0 && _typed.length > 1) {
      _typed = character;
      at = find(_typed);
    }
    if (at >= 0) _focus(at);
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final c = theme.colors;
    var row = 0;
    return FocusScope(
      node: _scope,
      onKeyEvent: _key,
      child: Semantics(
        container: true,
        scopesRoute: true,
        explicitChildNodes: true,
        label: widget.label,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: t.FoxSize.menuMinWidth,
            maxWidth: t.FoxSize.menuMaxWidth,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: c.surfaceRaised,
              borderRadius: BorderRadius.circular(t.FoxRadius.md),
              border: Border.all(color: c.border),
              boxShadow: [theme.shadows.medium],
            ),
            child: Padding(
              padding: const EdgeInsets.all(t.FoxSpace.xxs),
              child: IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final item in widget.items)
                      if (item.separator)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: t.FoxSpace.xxs,
                            horizontal: t.FoxSpace.xs,
                          ),
                          child: Container(
                            height: t.FoxBorderWidth.thin,
                            color: c.border,
                          ),
                        )
                      else
                        _MenuRow(
                          item: item,
                          node: _nodes[row++],
                          onTap: () => widget.onPicked(item),
                        ),
                  ],
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
  const _MenuRow({required this.item, required this.node, required this.onTap});

  final FoxMenuItem item;
  final FocusNode node;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final c = theme.colors;
    final ink = item.destructive ? c.danger : c.onSurface;
    final icon = item.icon;
    final hint = item.hint;
    return Interaction(
      focusNode: node,
      onTap: onTap,
      label: item.label,
      isButton: true,
      builder: (context, state) => AnimatedContainer(
        duration: t.FoxDuration.fast,
        curve: theme.easing,
        constraints: const BoxConstraints(minHeight: t.FoxSize.touchTarget),
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: t.FoxSpace.sm,
        ),
        decoration: BoxDecoration(
          color: state.pressed
              ? c.surfaceRaisedPressed
              : (state.hovered || state.focused
                    ? c.surfaceRaisedHover
                    : c.surfaceRaised),
          borderRadius: BorderRadius.circular(t.FoxRadius.sm),
        ),
        child: Row(
          children: [
            if (icon != null)
              FoxIcon(icon, color: ink)
            else
              const SizedBox(width: t.FoxSize.iconMd),
            const SizedBox(width: t.FoxSpace.sm),
            Expanded(
              child: Text(
                item.label,
                style: theme.text.body.copyWith(
                  color: ink,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (hint != null) ...[
              const SizedBox(width: t.FoxSpace.sm),
              Text(
                hint,
                style: theme.text.secondary.copyWith(color: c.onSurfaceMuted),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
