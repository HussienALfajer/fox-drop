import 'package:core_tokens/core_tokens.dart' as t;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../card/fox_card.dart';
import '../icon/fox_icon.dart';
import '../money/fox_money.dart';
import '../status_chip/fox_status_chip.dart';
import '../status_chip/fox_tone.dart';
import '../theme/fox_theme.dart';
import '../tracking_steps/fox_tracking_steps.dart';

/// The states every SignInHero use case and golden shows (R3).
const signInHeroStates = ['checkout', 'orders', 'account', 'short', 'keyboard'];

/// What the sign-in screen shows above the number, by where the guest came
/// from (D.11 screen 2): the saved cart, the way an order is followed, or
/// what an account keeps. The screen picks the origin from the route; the
/// words and amounts come in here.
sealed class FoxSignInOrigin {
  const FoxSignInOrigin();

  /// From the cart: the restaurant, the items and the total, saved as is.
  const factory FoxSignInOrigin.checkout({
    required String restaurant,
    required String details,
    required String amount,
    required String symbol,
    required String savedLabel,
    int decimals,
  }) = FoxSignInCheckout;

  /// From «طلباتي»: the tracking steps on a sample order.
  const factory FoxSignInOrigin.orders({
    required String title,
    required String statusLabel,
    required List<FoxTrackingStep> steps,
    required int current,
    required String doneLabel,
    required String nowLabel,
  }) = FoxSignInOrders;

  /// From «حسابي» and the rest: what an account keeps.
  const factory FoxSignInOrigin.account({required List<FoxSignInPerk> perks}) =
      FoxSignInAccount;
}

final class FoxSignInCheckout extends FoxSignInOrigin {
  const FoxSignInCheckout({
    required this.restaurant,
    required this.details,
    required this.amount,
    required this.symbol,
    required this.savedLabel,
    this.decimals = 2,
  });

  final String restaurant;

  /// «3 أصناف · إلى حي الجلاء».
  final String details;

  /// The total in minor units, shown by [FoxMoney].
  final String amount;
  final String symbol;
  final int decimals;

  /// «سلّتك محفوظة كما هي».
  final String savedLabel;
}

final class FoxSignInOrders extends FoxSignInOrigin {
  const FoxSignInOrders({
    required this.title,
    required this.statusLabel,
    required this.steps,
    required this.current,
    required this.doneLabel,
    required this.nowLabel,
  });

  final String title;
  final String statusLabel;
  final List<FoxTrackingStep> steps;
  final int current;
  final String doneLabel;
  final String nowLabel;
}

final class FoxSignInAccount extends FoxSignInOrigin {
  const FoxSignInAccount({required this.perks});

  final List<FoxSignInPerk> perks;
}

/// One thing an account keeps: «عناوينك», «أكوادك», «مفضّلتك».
@immutable
final class FoxSignInPerk {
  const FoxSignInPerk({required this.icon, required this.label});

  final t.FoxIconData icon;
  final String label;
}

/// The sign-in screen's head (D.11 screen 2): the origin's illustration, the
/// title and the lead line. It gives way by its own height: first the lead,
/// then the illustration, never the title; while the keyboard is up it is
/// the title alone. The illustration is decoration: the title and lead say
/// it in words.
class FoxSignInHero extends StatelessWidget {
  const FoxSignInHero({
    super.key,
    required this.origin,
    required this.title,
    this.lead,
  });

  final FoxSignInOrigin origin;
  final String title;
  final String? lead;

  @override
  Widget build(BuildContext context) => _KeyboardWatch(builder: _build);

  Widget _build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final signInHero = theme.components.signInHero;
    final heading = Color(signInHero.colorTitle);
    final padding = EdgeInsetsDirectional.symmetric(
      horizontal: signInHero.paddingInline,
      vertical: signInHero.paddingBlock,
    );
    // The view's own insets too: a resizing Scaffold removes the keyboard
    // from its body's MediaQuery, so the body alone never sees it.
    final keyboardUp =
        MediaQuery.viewInsetsOf(context).bottom > 0 ||
        (View.maybeOf(context)?.viewInsets.bottom ?? 0) > 0;
    if (keyboardUp) {
      return Padding(
        padding: padding,
        child: Align(
          alignment: AlignmentDirectional.bottomStart,
          child: Semantics(
            header: true,
            child: Text(
              title,
              style: theme.text.title.copyWith(color: heading),
            ),
          ),
        ),
      );
    }
    final lead = this.lead;
    return ClipRect(
      child: Padding(
        padding: padding,
        child: _GiveWay(
          artGap: signInHero.artGap,
          leadGap: signInHero.leadGap,
          children: [
            ExcludeSemantics(child: _art(context)),
            Semantics(
              header: true,
              child: Text(
                title,
                style: theme.text.largeTitle.copyWith(color: heading),
              ),
            ),
            if (lead != null)
              Text(
                lead,
                style: theme.text.body.copyWith(
                  color: Color(signInHero.colorLead),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _art(BuildContext context) => switch (origin) {
    final FoxSignInCheckout o => _Cart(origin: o),
    final FoxSignInOrders o => FoxCard(
      elevation: FoxCardElevation.offset,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  o.title,
                  style: FoxTheme.of(
                    context,
                  ).text.secondary.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(width: _hero(context).detailGap),
              FoxStatusChip(
                label: o.statusLabel,
                status: FoxOrderStatus.pickedUp,
              ),
            ],
          ),
          SizedBox(height: _hero(context).rowGap),
          FoxTrackingSteps(
            steps: o.steps,
            current: o.current,
            doneLabel: o.doneLabel,
            nowLabel: o.nowLabel,
          ),
        ],
      ),
    ),
    final FoxSignInAccount o => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var n = 0; n < o.perks.length; n++) ...[
          if (n > 0) SizedBox(width: _hero(context).rowGap),
          Expanded(child: _Perk(perk: o.perks[n])),
        ],
      ],
    ),
  };
}

/// The hero's component tokens (`sign-in-hero.json`).
t.SignInHeroTokens _hero(BuildContext context) =>
    FoxTheme.of(context).components.signInHero;

/// Rebuilds [builder] when the view's metrics change (the keyboard rising
/// or falling): the `View` it reads does not notify on its own.
class _KeyboardWatch extends StatefulWidget {
  const _KeyboardWatch({required this.builder});

  final WidgetBuilder builder;

  @override
  State<_KeyboardWatch> createState() => _KeyboardWatchState();
}

class _KeyboardWatchState extends State<_KeyboardWatch>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() => setState(() {});

  @override
  Widget build(BuildContext context) => widget.builder(context);
}

/// A round tinted badge with a Bold icon in the brand colour.
class _Badge extends StatelessWidget {
  const _Badge({required this.icon});

  final t.FoxIconData icon;

  @override
  Widget build(BuildContext context) {
    final signInHero = _hero(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Color(signInHero.colorBadge),
        shape: BoxShape.circle,
      ),
      child: SizedBox.square(
        dimension: signInHero.badgeSize,
        child: Center(
          child: FoxIcon(
            icon,
            color: Color(signInHero.colorBadgeIcon),
            style: FoxIconStyle.bold,
          ),
        ),
      ),
    );
  }
}

class _Cart extends StatelessWidget {
  const _Cart({required this.origin});

  final FoxSignInCheckout origin;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    final signInHero = theme.components.signInHero;
    final dishes = [
      signInHero.colorDish1,
      signInHero.colorDish2,
      signInHero.colorDish3,
    ];
    return FoxCard(
      elevation: FoxCardElevation.offset,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const _Badge(icon: t.FoxIcons.restaurant),
              SizedBox(width: signInHero.rowGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      origin.restaurant,
                      style: theme.text.subtitle.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      origin.details,
                      style: theme.text.caption.copyWith(
                        color: Color(signInHero.colorDetails),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: signInHero.detailGap),
              FoxMoney(
                amount: origin.amount,
                symbol: origin.symbol,
                decimals: origin.decimals,
                role: FoxMoneyRole.subtitle,
                bold: true,
              ),
            ],
          ),
          SizedBox(height: signInHero.rowGap),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: signInHero.detailGap,
            runSpacing: signInHero.detailGap,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var n = 0; n < dishes.length; n++)
                    Align(
                      widthFactor: n == 0
                          ? 1
                          : 1 - signInHero.dishOverlap / signInHero.badgeSize,
                      alignment: AlignmentDirectional.centerEnd,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(dishes[n]),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(signInHero.colorDishRing),
                            width: signInHero.dishRingWidth,
                          ),
                        ),
                        child: SizedBox.square(
                          dimension: signInHero.badgeSize,
                          child: Center(
                            child: FoxIcon(
                              t.FoxIcons.plate,
                              size: FoxIconSize.sm,
                              color: Color(signInHero.colorBadgeIcon),
                              style: FoxIconStyle.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              FoxStatusChip(
                label: origin.savedLabel,
                tone: FoxTone.success,
                icon: t.FoxIcons.success,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Perk extends StatelessWidget {
  const _Perk({required this.perk});

  final FoxSignInPerk perk;

  @override
  Widget build(BuildContext context) {
    final theme = FoxTheme.of(context);
    return FoxCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Badge(icon: perk.icon),
          SizedBox(height: _hero(context).detailGap),
          Text(
            perk.label,
            textAlign: TextAlign.center,
            style: theme.text.secondary.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

/// The illustration, the title and the lead, centred in the height given:
/// when they do not fit, the lead goes, then the illustration. A part that
/// gave way is not painted, hit or read.
class _GiveWay extends MultiChildRenderObjectWidget {
  const _GiveWay({
    required this.artGap,
    required this.leadGap,
    required super.children,
  });

  /// The illustration to the title, and the title to the lead.
  final double artGap;
  final double leadGap;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderGiveWay(artGap: artGap, leadGap: leadGap);

  @override
  void updateRenderObject(BuildContext context, _RenderGiveWay renderObject) {
    renderObject
      ..artGap = artGap
      ..leadGap = leadGap;
  }
}

class _GiveWayData extends ContainerBoxParentData<RenderBox> {
  bool shown = true;
}

class _RenderGiveWay extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _GiveWayData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _GiveWayData> {
  _RenderGiveWay({required double artGap, required double leadGap})
    : _artGap = artGap,
      _leadGap = leadGap;

  double _artGap;
  double get artGap => _artGap;
  set artGap(double value) {
    if (value == _artGap) return;
    _artGap = value;
    markNeedsLayout();
  }

  double _leadGap;
  double get leadGap => _leadGap;
  set leadGap(double value) {
    if (value == _leadGap) return;
    _leadGap = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _GiveWayData) child.parentData = _GiveWayData();
  }

  List<RenderBox> get _children {
    final list = <RenderBox>[];
    var child = firstChild;
    while (child != null) {
      list.add(child);
      child = childAfter(child);
    }
    return list;
  }

  @override
  void performLayout() {
    final children = _children;
    final width = constraints.maxWidth;
    // The illustration takes the width; the words too, so their own
    // alignment puts them at the start side.
    for (final child in children) {
      child.layout(BoxConstraints.tightFor(width: width), parentUsesSize: true);
    }
    final art = children[0];
    final title = children[1];
    final lead = children.length > 2 ? children[2] : null;
    final available = constraints.maxHeight;
    double heightOf({required bool withArt, required bool withLead}) =>
        (withArt ? art.size.height + artGap : 0) +
        title.size.height +
        (withLead && lead != null ? leadGap + lead.size.height : 0);
    var withArt = true;
    var withLead = lead != null;
    if (heightOf(withArt: true, withLead: withLead) > available) {
      withLead = false;
      if (heightOf(withArt: true, withLead: false) > available) {
        withArt = false;
      }
    }
    final used = heightOf(withArt: withArt, withLead: withLead);
    size = constraints.constrain(
      Size(width, available.isFinite ? available : used),
    );
    var y = (size.height - used) / 2;
    if (y < 0) y = 0;
    void place(RenderBox child, bool shown, double gapAfter) {
      final data = child.parentData! as _GiveWayData;
      // A part that comes or goes changes what is read, not only what is drawn.
      if (data.shown != shown) {
        data.shown = shown;
        markNeedsSemanticsUpdate();
      }
      if (!shown) return;
      data.offset = Offset(0, y);
      y += child.size.height + gapAfter;
    }

    place(art, withArt, artGap);
    place(title, true, leadGap);
    if (lead != null) place(lead, withLead, 0);
  }

  bool _shown(RenderBox child) => (child.parentData! as _GiveWayData).shown;

  @override
  void paint(PaintingContext context, Offset offset) {
    for (final child in _children) {
      if (!_shown(child)) continue;
      final data = child.parentData! as _GiveWayData;
      context.paintChild(child, data.offset + offset);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    for (final child in _children.reversed) {
      if (!_shown(child)) continue;
      final data = child.parentData! as _GiveWayData;
      final hit = result.addWithPaintOffset(
        offset: data.offset,
        position: position,
        hitTest: (result, transformed) =>
            child.hitTest(result, position: transformed),
      );
      if (hit) return true;
    }
    return false;
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    for (final child in _children) {
      if (_shown(child)) visitor(child);
    }
  }
}
