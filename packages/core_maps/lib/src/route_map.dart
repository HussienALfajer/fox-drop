import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import 'route_view.dart';

/// Draws a map of a route: its markers and its line (CA §9.2, §9.5, CU
/// §11.3), fitted to [RouteView.bounds] when the style loads and once more
/// when the captain first appears (a phone may have no fix yet). A new
/// [RouteView] (the captain moved) redraws the markers and the line without
/// moving the camera again. An app holds one in a provider, so its widget tests draw a fake
/// instead of the platform view.
typedef RouteMapBuilder = Widget Function({required RouteView view});

/// The [RouteMapBuilder] on MapLibre, drawing the style at [styleUrl]
/// ([mapStyleUrl]).
RouteMapBuilder maplibreRouteMap(String styleUrl) =>
    ({required view}) => _MapLibreRouteMap(styleUrl: styleUrl, view: view);

class _MapLibreRouteMap extends StatefulWidget {
  const _MapLibreRouteMap({required this.styleUrl, required this.view});

  final String styleUrl;
  final RouteView view;

  @override
  State<_MapLibreRouteMap> createState() => _MapLibreRouteMapState();
}

class _MapLibreRouteMapState extends State<_MapLibreRouteMap> {
  MapLibreMapController? _controller;
  bool _styleLoaded = false;
  // Fitted to a view that had the captain: never moved again after it.
  bool _fittedWithCaptain = false;
  // Draws run one after another, so a quick second view never mixes with
  // the first.
  Future<void> _drawing = Future.value();

  // Keeps the markers off the map's edges.
  static const _fitPadding = 48.0;

  @override
  void didUpdateWidget(_MapLibreRouteMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.view == widget.view) return;
    if (_styleLoaded && !_fittedWithCaptain && _hasCaptain(widget.view)) {
      unawaited(_fit());
    }
    _draw();
  }

  static bool _hasCaptain(RouteView view) =>
      view.markers.any((marker) => marker.kind == MapMarkerKind.captain);

  Future<void> _onStyleLoaded() async {
    _styleLoaded = true;
    await _fit();
    if (!mounted) return;
    _draw();
  }

  Future<void> _fit() async {
    final view = widget.view;
    _fittedWithCaptain = _hasCaptain(view);
    final bounds = view.bounds;
    await _controller?.moveCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
            bounds.southwest.latitude,
            bounds.southwest.longitude,
          ),
          northeast: LatLng(
            bounds.northeast.latitude,
            bounds.northeast.longitude,
          ),
        ),
        left: _fitPadding,
        top: _fitPadding,
        right: _fitPadding,
        bottom: _fitPadding,
      ),
    );
  }

  void _draw() {
    final controller = _controller;
    if (controller == null || !_styleLoaded || !mounted) return;
    final view = widget.view;
    // Unstyled until the design (owner decision 2026-11-18): MapLibre's
    // default line and circles; only the captain takes the theme's primary
    // colour, so it reads apart from the restaurant and the pin.
    final captainColour = _hex(Theme.of(context).colorScheme.primary);
    _drawing = _drawing.then((_) async {
      await controller.clearLines();
      await controller.clearCircles();
      final line = view.line;
      if (line != null && line.length >= 2) {
        await controller.addLine(
          LineOptions(
            geometry: [
              for (final point in line) LatLng(point.latitude, point.longitude),
            ],
          ),
        );
      }
      for (final marker in view.markers) {
        await controller.addCircle(
          CircleOptions(
            geometry: LatLng(marker.point.latitude, marker.point.longitude),
            circleColor: marker.kind == MapMarkerKind.captain
                ? captainColour
                : null,
          ),
        );
      }
    });
  }

  static String _hex(Color colour) =>
      '#${(colour.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

  @override
  Widget build(BuildContext context) {
    final centre = widget.view.bounds.centre;
    return MapLibreMap(
      styleString: widget.styleUrl,
      initialCameraPosition: CameraPosition(
        target: LatLng(centre.latitude, centre.longitude),
        zoom: 14,
      ),
      rotateGesturesEnabled: false,
      tiltGesturesEnabled: false,
      onMapCreated: (controller) => _controller = controller,
      onStyleLoadedCallback: _onStyleLoaded,
    );
  }
}
