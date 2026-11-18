import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import 'geo_point.dart';
import 'map_camera.dart';

/// Draws a map the customer moves under a fixed centre pin (CU §7.1),
/// starting at [initial] and reporting each camera as it moves. An app holds
/// one in a provider, so its widget tests draw a fake instead of the
/// platform view.
typedef PinMapBuilder =
    Widget Function({
      required MapCamera initial,
      required ValueChanged<MapCamera> onCamera,
    });

/// The [PinMapBuilder] on MapLibre, drawing the style at [styleUrl]
/// ([mapStyleUrl]). MapLibre keeps the tiles, glyphs and sprite it reads in
/// its ambient cache on the phone, for as long as their `Cache-Control`
/// says (a year for a build's files, 5 minutes for the style).
PinMapBuilder maplibrePinMap(String styleUrl) =>
    ({required initial, required onCamera}) => _MapLibrePinMap(
      styleUrl: styleUrl,
      initial: initial,
      onCamera: onCamera,
    );

class _MapLibrePinMap extends StatelessWidget {
  const _MapLibrePinMap({
    required this.styleUrl,
    required this.initial,
    required this.onCamera,
  });

  final String styleUrl;
  final MapCamera initial;
  final ValueChanged<MapCamera> onCamera;

  static const _pinSize = 48.0;

  void _report(CameraPosition position) => onCamera(
    MapCamera(
      GeoPoint(position.target.latitude, position.target.longitude),
      position.zoom,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MapLibreMap(
          styleString: styleUrl,
          initialCameraPosition: CameraPosition(
            target: LatLng(initial.centre.latitude, initial.centre.longitude),
            zoom: initial.zoom,
          ),
          // A flat, north-up map: the pin reads the centre only.
          rotateGesturesEnabled: false,
          tiltGesturesEnabled: false,
          trackCameraPosition: true,
          onCameraMove: _report,
        ),
        // The pin's tip on the map's centre.
        const IgnorePointer(
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: _pinSize),
              child: Icon(Icons.location_pin, size: _pinSize),
            ),
          ),
        ),
      ],
    );
  }
}
