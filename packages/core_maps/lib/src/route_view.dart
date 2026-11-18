import 'dart:math';

import 'geo_point.dart';

/// What a marker on a route map stands for (CA §9.2, §9.5, CU §11.3).
enum MapMarkerKind { captain, restaurant, destination }

/// A marker at a point.
class MapMarker {
  const MapMarker(this.kind, this.point);

  final MapMarkerKind kind;
  final GeoPoint point;

  @override
  bool operator ==(Object other) =>
      other is MapMarker && other.kind == kind && other.point == point;

  @override
  int get hashCode => Object.hash(kind, point);
}

/// The corners of the smallest box around some points.
class GeoBounds {
  const GeoBounds(this.southwest, this.northeast);

  final GeoPoint southwest;
  final GeoPoint northeast;

  /// The smallest box around [points], at least [minSpan] degrees on each
  /// side around its centre, so one point or two close ones still show their
  /// streets.
  factory GeoBounds.around(
    Iterable<GeoPoint> points, {
    double minSpan = 0.004,
  }) {
    final list = points.toList();
    if (list.isEmpty) throw ArgumentError('no points to fit');
    var south = list.first.latitude, north = south;
    var west = list.first.longitude, east = west;
    for (final point in list.skip(1)) {
      south = min(south, point.latitude);
      north = max(north, point.latitude);
      west = min(west, point.longitude);
      east = max(east, point.longitude);
    }
    final latitudePad = max(0.0, minSpan - (north - south)) / 2;
    final longitudePad = max(0.0, minSpan - (east - west)) / 2;
    return GeoBounds(
      GeoPoint(south - latitudePad, west - longitudePad),
      GeoPoint(north + latitudePad, east + longitudePad),
    );
  }

  GeoPoint get centre => GeoPoint(
    (southwest.latitude + northeast.latitude) / 2,
    (southwest.longitude + northeast.longitude) / 2,
  );

  @override
  bool operator ==(Object other) =>
      other is GeoBounds &&
      other.southwest == southwest &&
      other.northeast == northeast;

  @override
  int get hashCode => Object.hash(southwest, northeast);

  @override
  String toString() => 'GeoBounds($southwest, $northeast)';
}

/// What a route map shows: its markers and, when the routing service
/// answered, the route line from the start to the end (architecture §7.1:
/// none on the straight-line fallback).
class RouteView {
  const RouteView({required this.markers, this.line});

  final List<MapMarker> markers;
  final List<GeoPoint>? line;

  /// The box the map first fits: every marker and the whole line.
  GeoBounds get bounds =>
      GeoBounds.around([...markers.map((marker) => marker.point), ...?line]);

  @override
  bool operator ==(Object other) =>
      other is RouteView &&
      _listEquals(other.markers, markers) &&
      _listEquals(other.line, line);

  @override
  int get hashCode => Object.hash(
    Object.hashAll(markers),
    line == null ? null : Object.hashAll(line!),
  );
}

bool _listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null || b == null) return a == b;
  if (a.length != b.length) return false;
  for (var index = 0; index < a.length; index++) {
    if (a[index] != b[index]) return false;
  }
  return true;
}
