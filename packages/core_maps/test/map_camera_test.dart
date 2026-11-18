import 'package:core_maps/core_maps.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const azaz = GeoPoint(36.5866, 37.0463);

  group('MapCamera.pinConfirmable (CU §7.1)', () {
    test('confirms at zoom 16 and closer', () {
      expect(const MapCamera(azaz, 16).pinConfirmable, isTrue);
      expect(const MapCamera(azaz, 18.5).pinConfirmable, isTrue);
    });

    test('asks to zoom in below 16', () {
      expect(const MapCamera(azaz, 15.99).pinConfirmable, isFalse);
      expect(const MapCamera(azaz, 12).pinConfirmable, isFalse);
    });
  });

  test('GeoPoint measures great-circle metres', () {
    // 0.001 degrees of latitude is about 111 m.
    final metres = azaz.metresTo(const GeoPoint(36.5876, 37.0463));
    expect(metres, closeTo(111.2, 0.5));
  });

  group('mapStyleUrl (architecture §7.2)', () {
    test("is the API host's /maps/style.json", () {
      expect(
        mapStyleUrl('https://api.example.test', debug: false),
        'https://api.example.test/maps/style.json',
      );
    });

    test("is compose's maps service in a debug build", () {
      expect(
        mapStyleUrl('http://10.0.2.2:3000', debug: true),
        'http://10.0.2.2:8089/maps/style.json',
      );
    });
  });
}
