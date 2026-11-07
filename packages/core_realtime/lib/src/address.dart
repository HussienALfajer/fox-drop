/// Centrifugo's WebSocket for the API at [apiBaseUrl]: the same host with
/// `ws`/`wss` and `/connection/websocket`, which nginx forwards to
/// Centrifugo on staging and production. The local API listens on port 3000
/// and the local Centrifugo on 8000 (`compose.yaml`), so a development
/// address on port 3000 takes 8000.
String realtimeUrl(String apiBaseUrl) {
  final api = Uri.parse(apiBaseUrl);
  final secure = api.scheme == 'https';
  return api
      .replace(
        scheme: secure ? 'wss' : 'ws',
        port: api.hasPort && api.port == 3000 ? 8000 : null,
        path: '/connection/websocket',
        query: null,
      )
      .toString()
      .replaceFirst('?', '');
}
