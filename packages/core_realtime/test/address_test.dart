import 'package:core_realtime/core_realtime.dart';
import 'package:test/test.dart';

void main() {
  test('the API host with wss on staging', () {
    expect(
      realtimeUrl('https://api.staging.example.test'),
      'wss://api.staging.example.test/connection/websocket',
    );
  });

  test("the local Centrifugo's port for the local API", () {
    expect(
      realtimeUrl('http://10.0.2.2:3000'),
      'ws://10.0.2.2:8000/connection/websocket',
    );
    expect(
      realtimeUrl('http://192.168.1.20:3000/'),
      'ws://192.168.1.20:8000/connection/websocket',
    );
  });

  test('keeps another port', () {
    expect(
      realtimeUrl('http://localhost:8080'),
      'ws://localhost:8080/connection/websocket',
    );
  });
}
