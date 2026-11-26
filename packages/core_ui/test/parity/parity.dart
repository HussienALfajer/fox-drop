import 'dart:io';
import 'dart:ui' as ui;

import 'package:core_ui/core_ui.dart';
import 'package:core_ui/testing.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// The parity sheet's Flutter side (architecture §9.7, `pnpm parity`): each
/// case shoots the twin of one web story so `scripts/parity.mjs` can put the
/// two side by side. A review tool, never a baseline.

/// The phone width of the screen goldens (§9.9 step 8), in logical pixels.
const parityWidth = 360.0;

/// The space around the widget, so a focus ring is not cut; the web side
/// pads the story's root by the same 16 pixels.
const parityInset = FoxSpace.md;
const _ratio = 2.0;
const _frame = ValueKey('parity');

/// CoFo, loaded once by the first case that runs.
var _fontsLoaded = false;

const _themes = {'phone': FoxThemeData.phone, 'captain': FoxThemeData.captain};

/// One parity case per surface, keyed by its web story's id
/// (`button--primary-hover`), tagged `parity` so only `pnpm parity` runs it
/// (`dart_test.yaml`). The widget sits at the start of a [parityWidth] frame
/// on the theme's surface, RTL, pixel ratio 2, animations off; its height
/// follows its content. A story id ending in `-hover`, `-focus` or `-pressed`
/// drives the frame's first control as `e2e/parity.spec.ts` drives the
/// story: a mouse over it, keyboard focus, a held touch.
void parityCase(
  String storyId,
  Widget Function() builder, {
  List<String> surfaces = const ['phone', 'captain'],
}) {
  group(storyId, () {
    tearDown(() {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.automatic;
    });
    for (final surface in surfaces) {
      testWidgets(surface, tags: ['parity'], (tester) async {
        // In the test, not a setUpAll: a group's setUpAll runs even when the
        // tag skips its tests, and CI has no .fonts/ (loadFoxFonts throws).
        if (!_fontsLoaded) {
          await tester.runAsync(loadFoxFonts);
          _fontsLoaded = true;
        }
        final theme = _themes[surface]!();
        const size = Size(parityWidth, 2000);
        tester.view.devicePixelRatio = _ratio;
        tester.view.physicalSize = size * _ratio;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(
              size: size,
              devicePixelRatio: _ratio,
              disableAnimations: true,
            ),
            child: FoxTheme(
              data: theme,
              child: Directionality(
                textDirection: TextDirection.rtl,
                // A focused text field needs an Overlay (its selection
                // handles); a popup it opens lands outside the shot.
                child: Overlay(
                  initialEntries: [
                    OverlayEntry(
                      builder: (_) => Align(
                        alignment: AlignmentDirectional.topStart,
                        child: RepaintBoundary(
                          key: _frame,
                          child: SizedBox(
                            width: parityWidth,
                            child: ColoredBox(
                              color: theme.colors.surface,
                              child: DefaultTextStyle(
                                style: theme.text.body.copyWith(
                                  color: theme.colors.onSurface,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(parityInset),
                                  child: Align(
                                    alignment: AlignmentDirectional.topStart,
                                    heightFactor: 1,
                                    child: builder(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        final control = find
            .descendant(
              of: find.byKey(_frame),
              matching: find.byType(GestureDetector),
            )
            .first;
        TestGesture? mouse;
        TestGesture? touch;
        if (storyId.endsWith('-hover')) {
          mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
          await mouse.addPointer(location: Offset.zero);
          await mouse.moveTo(tester.getCenter(control));
        }
        if (storyId.endsWith('-pressed')) {
          touch = await tester.startGesture(tester.getCenter(control));
        }
        if (storyId.endsWith('-focus')) {
          FocusManager.instance.highlightStrategy =
              FocusHighlightStrategy.alwaysTraditional;
          // A text field's focus sits below its gesture detector (slice
          // D.W3a), and the code field has no gesture detector at all: take
          // the editable text's node when no Focus is above one.
          ((find
                          .descendant(
                            of: find.byKey(_frame),
                            matching: find.byType(GestureDetector),
                          )
                          .evaluate()
                          .isEmpty
                      ? null
                      : Focus.maybeOf(tester.element(control))) ??
                  tester
                      .widget<EditableText>(
                        find
                            .descendant(
                              of: find.byKey(_frame),
                              matching: find.byType(EditableText),
                            )
                            .first,
                      )
                      .focusNode)
              .requestFocus();
        }
        // Past every state's fade (duration.base), as the goldens wait.
        await tester.pump(const Duration(milliseconds: 200));
        await tester.pump(const Duration(milliseconds: 400));

        final boundary = tester.renderObject<RenderRepaintBoundary>(
          find.byKey(_frame),
        );
        final bytes = await tester.runAsync(() async {
          final image = await boundary.toImage(pixelRatio: _ratio);
          final data = await image.toByteData(format: ui.ImageByteFormat.png);
          image.dispose();
          return data!.buffer.asUint8List();
        });
        final file = File(
          '${_repository().path}/.parity/flutter/$storyId-$surface.png',
        );
        file.parent.createSync(recursive: true);
        file.writeAsBytesSync(bytes!);

        await touch?.up();
        await mouse?.removePointer();
      });
    }
  });
}

/// The repository root: the folder above the test that holds
/// `pnpm-workspace.yaml`.
Directory _repository() {
  var dir = Directory.current.absolute;
  while (!File('${dir.path}/pnpm-workspace.yaml').existsSync()) {
    final parent = dir.parent;
    if (parent.path == dir.path) {
      throw StateError(
        'No pnpm-workspace.yaml above ${Directory.current.path}',
      );
    }
    dir = parent;
  }
  return dir;
}
