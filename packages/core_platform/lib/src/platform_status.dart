import 'package:core_api/core_api.dart';

/// What `GET /v1/{party}/platform` answers for the app's version (AP §9.14
/// «التطبيقات»): below the minimum the update is required, below the latest
/// it is suggested.
enum UpdateNeed { required, suggested, none }

/// The app's update and maintenance, as the server answered them.
class PlatformStatus {
  const PlatformStatus({
    required this.update,
    this.updateMessage,
    required this.maintenance,
    this.maintenanceMessage,
  });

  /// Before the first answer: nothing blocks, so a server out of reach never
  /// locks the app.
  static const clear = PlatformStatus(
    update: UpdateNeed.none,
    maintenance: false,
  );

  final UpdateNeed update;
  final String? updateMessage;
  final bool maintenance;
  final String? maintenanceMessage;

  /// The blocking update or maintenance screen.
  bool get blocks => maintenance || update == UpdateNeed.required;

  @override
  bool operator ==(Object other) =>
      other is PlatformStatus &&
      other.update == update &&
      other.updateMessage == updateMessage &&
      other.maintenance == maintenance &&
      other.maintenanceMessage == maintenanceMessage;

  @override
  int get hashCode =>
      Object.hash(update, updateMessage, maintenance, maintenanceMessage);
}

/// The server's answer as the status the apps keep.
PlatformStatus platformStatusOf(PlatformDtoOutput answer) => PlatformStatus(
  update: UpdateNeed.values.byName(answer.updateNeed.name),
  updateMessage: answer.updateMessage,
  maintenance: answer.maintenance,
  maintenanceMessage: answer.maintenanceMessage,
);
