import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../count_badge/fox_count_badge.dart';
import '../theme/fox_theme.dart';

/// The states every Tabs use case and golden shows (R3).
const tabsStates = ['underline', 'pill', 'count', 'overflow'];

/// Underline (the panel, restaurant and captain) or pill (the customer's
/// menu sections, the active one orange with the offset shadow).
enum FoxTabsStyle { underline, pill }

/// One tab: its words and an optional count read with it.
@immutable
final class FoxTab {
  const FoxTab({required this.label, this.count, this.countLabel});

  final String label;
  final int? count;

  /// «3 طلبات»: read after the label, as «جديدة، 3 طلبات».
  final String? countLabel;
}

/// A row of tabs (D.10): one tab stop, the selected tab. The arrows follow
/// reading order (← is the next tab in RTL), Home and End go to the ends,
/// and the selection follows focus. The selected tab is announced as
/// selected with its count. A row wider than the screen scrolls and keeps
/// the selected tab in view.
class FoxTabs extends StatefulWidget {
  const FoxTabs({
    super.key,
    required this.tabs,
    required this.selected,
    required this.onChanged,
    this.style = FoxTabsStyle.underline,
  });

  final List<FoxTab> tabs;
  final int selected;
  final ValueChanged<int> onChanged;
  final FoxTabsStyle style;

  @override
  State<FoxTabs> createState() => _FoxTabsState();
}

class _FoxTabsState extends State<FoxTabs> {
  late List<FocusNode> _nodes = _make();
  late List<GlobalKey> _keys = _makeKeys();

  List<FocusNode> _make() => [
    for (final _ in widget.tabs) FocusNode(debugLabel: 'FoxTab'),
  ];

  List<GlobalKey> _makeKeys() => [for (final _ in widget.tabs) GlobalKey()];

  @override
  void didUpdateWidget(FoxTabs old) {
    super.didUpdateWidget(old);
    if (old.tabs.length != widget.tabs.length) {
      for (final node in _nodes) {
        node.dispose();
      }
      _nodes = _make();
      _keys = _makeKeys();
    }
    if (old.selected != widget.selected) _reveal(widget.selected);
  }

  @override
  void initState() {
    super.initState();
    _reveal(widget.selected);
  }

  @override
  void dispose() {
    for (final node in _nodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _reveal(int at) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final target = _keys[at].currentContext;
      if (!mounted || target == null) return;
      Scrollable.ensureVisible(
        target,
        alignment: 0.5,
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : t.FoxDuration.base,
      );
    });
  }

  void _select(int at) {
    final next = at.clamp(0, widget.tabs.length - 1);
    _nodes[next].requestFocus();
    if (next != widget.selected) widget.onChanged(next);
  }

  KeyEventResult _key(int at, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowLeft) {
      _select(rtl ? at + 1 : at - 1);
    } else if (key == LogicalKeyboardKey.arrowRight) {
      _select(rtl ? at - 1 : at + 1);
    } else if (key == LogicalKeyboardKey.home) {
      _select(0);
    } else if (key == LogicalKeyboardKey.end) {
      _select(widget.tabs.length - 1);
    } else if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.space) {
      _select(at);
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final tabs = theme.components.tabs;
    final pill = widget.style == FoxTabsStyle.pill;
    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var n = 0; n < widget.tabs.length; n++) ...[
          // Underline tabs stand 2xs apart, as the web's (parity, D.W3c).
          if (n > 0) SizedBox(width: pill ? tabs.pillGap : tabs.gap),
          KeyedSubtree(
            key: _keys[n],
            child: _Tab(
              tab: widget.tabs[n],
              selected: n == widget.selected,
              pill: pill,
              node: _nodes[n],
              onKey: (event) => _key(n, event),
              onTap: () => _select(n),
            ),
          ),
        ],
      ],
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        border: pill
            ? null
            : Border(
                bottom: BorderSide(
                  color: Color(tabs.colorBorder),
                  width: tabs.borderWidth,
                ),
              ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: row,
      ),
    );
  }
}

class _Tab extends StatefulWidget {
  const _Tab({
    required this.tab,
    required this.selected,
    required this.pill,
    required this.node,
    required this.onKey,
    required this.onTap,
  });

  final FoxTab tab;
  final bool selected;
  final bool pill;
  final FocusNode node;
  final KeyEventResult Function(KeyEvent event) onKey;
  final VoidCallback onTap;

  @override
  State<_Tab> createState() => _TabState();
}

class _TabState extends State<_Tab> {
  bool _hovered = false;
  bool _focusRing = false;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final tabs = theme.components.tabs;
    final tab = widget.tab;
    final on = widget.selected;
    final count = tab.count;
    final countLabel = tab.countLabel;
    final name = countLabel == null ? tab.label : '${tab.label}، $countLabel';
    // Hover darkens an underline tab's words, as on the web (parity, D.W3c;
    // it tinted the tab).
    final ink = Color(
      widget.pill
          ? (on ? tabs.pillColorTextSelected : tabs.pillColorText)
          : (on
                ? tabs.colorTextSelected
                : (_hovered ? tabs.colorTextHover : tabs.colorText)),
    );
    final label = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          tab.label,
          style: (widget.pill ? theme.text.secondary : theme.text.body)
              .copyWith(
                color: ink,
                fontWeight: on ? FontWeight.w700 : FontWeight.w500,
              ),
        ),
        if (count != null) ...[
          SizedBox(width: tabs.labelGap),
          FoxCountBadge(
            count: count,
            semanticLabel: countLabel ?? '$count',
            tone: on ? FoxBadgeTone.danger : FoxBadgeTone.accent,
          ),
        ],
      ],
    );
    final Decoration decoration;
    if (widget.pill) {
      decoration = BoxDecoration(
        color: Color(
          on
              ? tabs.pillColorBackgroundSelected
              : (_hovered
                    ? tabs.pillColorBackgroundHover
                    : tabs.pillColorBackground),
        ),
        borderRadius: BorderRadius.circular(t.FoxRadius.full),
        border: on
            ? null
            : Border.all(
                color: Color(tabs.colorBorder),
                width: tabs.borderWidth,
              ),
        boxShadow: on ? [theme.shadows.offset] : null,
      );
    } else {
      final line = Color(tabs.colorIndicator);
      decoration = BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: on ? line : line.withValues(alpha: 0),
            width: tabs.indicator,
          ),
        ),
      );
    }
    // A pill is drawn 40 high (the sheet's) inside its 48 target; an
    // underline tab is the target (parity, D.W3c).
    final body = AnimatedContainer(
      duration: t.FoxDuration.fast,
      curve: theme.easing,
      constraints: BoxConstraints(
        minHeight: widget.pill ? tabs.pillHeight : tabs.height,
      ),
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: widget.pill ? tabs.pillPaddingInline : tabs.paddingInline,
      ),
      decoration: decoration,
      child: Align(widthFactor: 1, heightFactor: 1, child: label),
    );
    return Semantics(
      container: true,
      button: true,
      selected: on,
      inMutuallyExclusiveGroup: true,
      focusable: true,
      focused: widget.node.hasFocus,
      label: name,
      onTap: widget.onTap,
      onFocus: widget.node.requestFocus,
      child: ExcludeSemantics(
        child: Focus(
          focusNode: widget.node,
          skipTraversal: !on,
          onKeyEvent: (_, event) => widget.onKey(event),
          onFocusChange: (_) => setState(() {}),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _hovered = true),
            onExit: (_) => setState(() => _hovered = false),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onTap,
              child: _Ring(
                show: widget.node.hasFocus && _focusRing,
                pill: widget.pill,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: tabs.height),
                  child: Align(widthFactor: 1, heightFactor: 1, child: body),
                ),
              ),
              onTapDown: (_) => _focusRing = false,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    FocusManager.instance.addHighlightModeListener(_mode);
    _focusRing =
        FocusManager.instance.highlightMode == FocusHighlightMode.traditional;
  }

  void _mode(FocusHighlightMode mode) {
    if (mounted) {
      setState(() => _focusRing = mode == FocusHighlightMode.traditional);
    }
  }

  @override
  void dispose() {
    FocusManager.instance.removeHighlightModeListener(_mode);
    super.dispose();
  }
}

/// The keyboard focus ring around a tab.
class _Ring extends StatelessWidget {
  const _Ring({required this.show, required this.pill, required this.child});

  final bool show;
  final bool pill;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    return DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          pill ? t.FoxRadius.full : t.FoxRadius.sm,
        ),
        border: show
            ? Border.all(
                color: theme.colors.focusRing,
                width: theme.input.focusWidth,
              )
            : null,
      ),
      child: child,
    );
  }
}
