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
    final blockingHeads = theme.components.blockingHeads;
    final label = Color(blockingHeads.colorLabel);
    final muted = theme.text.secondary.copyWith(color: label);
    final padding = EdgeInsetsDirectional.all(blockingHeads.ticketPadding);
    return Semantics(
      container: true,
      image: true,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: ConstrainedBox(
          // Wider as the text grows, so the words keep their lines.
          constraints: BoxConstraints(
            maxWidth: _scaled(context, blockingHeads.ticketMaxWidth),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color(blockingHeads.colorTicket),
              borderRadius: BorderRadius.circular(blockingHeads.ticketRadius),
              boxShadow: [theme.shadows.offset],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: padding,
                  // A wrap: at large text the version moves under its label.
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: blockingHeads.ticketGap,
                    children: [
                      Text(installedLabel, style: muted),
                      _Ltr(
                        installed,
                        theme.text.title.copyWith(
                          color: label,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: label,
                        ),
                      ),
                    ],
                  ),
                ),
                const _Perforation(),
                Padding(
                  padding: padding,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(requiredLabel, style: muted),
                            SizedBox(height: blockingHeads.ticketLineGap),
                            _Ltr(
                              required,
                              theme.text.number.copyWith(
                                color: Color(blockingHeads.colorRequired),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: blockingHeads.ticketGap),
                      BrandMark(size: blockingHeads.ticketMarkSize),
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
    final blockingHeads = FoxTheme.of(context).components.blockingHeads;
    return SizedBox(
      height: blockingHeads.ticketPerforationHeight,
      child: CustomPaint(
        painter: _PerforationPainter(
          line: Color(blockingHeads.colorPerforation),
          ground: Color(blockingHeads.colorCut),
          width: blockingHeads.ticketPerforationWidth,
          dash: blockingHeads.ticketDash,
          inset: blockingHeads.ticketPadding,
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
    required this.dash,
    required this.inset,
  });

  final Color line;
  final Color ground;
  final double width;

  /// A dash and the gap after it.
  final double dash;

  /// How far the dashes stay from each edge.
  final double inset;

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;
    final paint = Paint()
      ..color = line
      ..strokeWidth = width;
    for (var x = inset; x < size.width - inset; x += 2 * dash) {
      canvas.drawLine(Offset(x, y), Offset(x + dash, y), paint);
    }
    final cut = Paint()..color = ground;
    canvas
      ..drawCircle(Offset(0, y), size.height / 2, cut)
      ..drawCircle(Offset(size.width, y), size.height / 2, cut);
  }

  @override
  bool shouldRepaint(_PerforationPainter old) =>
      old.line != line ||
      old.ground != ground ||
      old.width != width ||
      old.dash != dash ||
      old.inset != inset;
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
    final blockingHeads = theme.components.blockingHeads;
    final ink = Color(blockingHeads.colorBoardInk);
    final string = Color(blockingHeads.colorPerforation);
    final returnTime = this.returnTime;
    final width = _scaled(context, blockingHeads.signWidth);
    final lineGap = SizedBox(height: blockingHeads.signLineGap);
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
                  color: string,
                  shape: BoxShape.circle,
                ),
                child: SizedBox.square(dimension: blockingHeads.signNailSize),
              ),
              Transform.translate(
                offset: Offset(0, -blockingHeads.signNailSize / 2),
                child: SizedBox(
                  height: blockingHeads.signStringsHeight,
                  width: width,
                  child: CustomPaint(
                    painter: _Strings(
                      colour: string,
                      width: blockingHeads.signStringWidth,
                    ),
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(blockingHeads.colorBoard),
                  borderRadius: BorderRadius.circular(blockingHeads.signRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Color(blockingHeads.colorBoardEdge),
                      offset: Offset(0, blockingHeads.signEdge),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    for (final start in [true, false])
                      PositionedDirectional(
                        top: blockingHeads.signHoleInsetBlock,
                        start: start ? blockingHeads.signHoleInsetInline : null,
                        end: start ? null : blockingHeads.signHoleInsetInline,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color(blockingHeads.colorCut),
                            shape: BoxShape.circle,
                          ),
                          child: SizedBox.square(
                            dimension: blockingHeads.signHoleSize,
                          ),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                        blockingHeads.signPaddingInline,
                        blockingHeads.signPaddingTop,
                        blockingHeads.signPaddingInline,
                        blockingHeads.signPaddingBottom,
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
                          lineGap,
                          Text(
                            subtitle,
                            textAlign: TextAlign.center,
                            style: theme.text.secondary.copyWith(color: ink),
                          ),
                          if (returnTime != null) ...[
                            lineGap,
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
  _Strings({required this.colour, required this.width});

  final Color colour;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colour
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;
    final top = Offset(size.width / 2, size.height * 2 / 40);
    final y = size.height * 38 / 40;
    canvas
      ..drawLine(top, Offset(size.width * 20 / 192, y), paint)
      ..drawLine(top, Offset(size.width * 172 / 192, y), paint);
  }

  @override
  bool shouldRepaint(_Strings old) =>
      old.colour != colour || old.width != width;
}
