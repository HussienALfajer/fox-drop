import 'geo_point.dart';

/// The closest zoom out at which a pin can be confirmed: street level (CU
/// §7.1, fixed).
const pinZoom = 16.0;

/// Where the map looks: its centre, under the fixed pin, and its zoom.
class MapCamera {
  const MapCamera(this.centre, this.zoom);

  final GeoPoint centre;
  final double zoom;

  /// The pin under the centre can be confirmed (CU §7.1); otherwise the
  /// screen asks to zoom in.
  bool get pinConfirmable => zoom >= pinZoom;

  @override
  bool operator ==(Object other) =>
      other is MapCamera && other.centre == centre && other.zoom == zoom;

  @override
  int get hashCode => Object.hash(centre, zoom);
}
