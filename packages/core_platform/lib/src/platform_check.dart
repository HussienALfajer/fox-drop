import 'kept_read.dart';
import 'platform_status.dart';

/// The app's update and maintenance kept current (CU §4.2, RA §4.2, CA §4.2:
/// "at launch and on every reconnect", `KeptRead`). Its value is the latest
/// answer, [PlatformStatus.clear] until one comes.
class PlatformCheck extends KeptRead<PlatformStatus> {
  PlatformCheck(
    Future<PlatformStatus> Function() read, {
    super.firstRetry,
    super.lastRetry,
  }) : super(read, PlatformStatus.clear);

  bool _dismissed = false;

  PlatformStatus get status => value;

  /// The dismissible banner of a suggested update, until dismissed for the
  /// app's run.
  bool get showsBanner => status.update == UpdateNeed.suggested && !_dismissed;

  void dismissBanner() {
    _dismissed = true;
    notifyListeners();
  }
}
