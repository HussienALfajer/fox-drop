/// The style's address, set with `--dart-define=MAP_STYLE_URL=...`.
const _mapStyleUrl = String.fromEnvironment('MAP_STYLE_URL');

/// The style every map draws (architecture §7.2): [_mapStyleUrl], else
/// `/maps/style.json` on the API's own host (nginx on staging and
/// production), or, in a [debug] build against the development machine's
/// API (plain HTTP), on its port 8089 (compose.yaml's `maps` service).
String mapStyleUrl(String apiBaseUrl, {required bool debug}) {
  if (_mapStyleUrl.isNotEmpty) return _mapStyleUrl;
  final api = Uri.parse(apiBaseUrl);
  final style = api.replace(path: '/maps/style.json', query: null);
  final development = debug && api.scheme == 'http';
  return (development ? style.replace(port: 8089) : style).toString();
}
