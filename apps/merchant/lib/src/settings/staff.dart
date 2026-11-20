import 'package:core_api/core_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';

/// A restaurant user on «الموظفون» (RA §14.1).
class StaffMember {
  const StaffMember({
    required this.accountId,
    required this.owner,
    required this.name,
    required this.phone,
    required this.devices,
    required this.lastActiveAt,
  });

  final String accountId;

  /// Owners are read-only in the app (RA §5.1, S5).
  final bool owner;
  final String name;
  final String phone;

  /// The devices the user is signed in on now.
  final int devices;

  /// Null before any sign-in.
  final DateTime? lastActiveAt;
}

List<StaffMember> _staffOf(MerchantStaffDtoOutput dto) => [
  for (final each in dto.staff)
    StaffMember(
      accountId: each.accountId,
      owner: each.role == MerchantStaffDtoOutputStaffInnerRoleEnum.owner,
      name: each.name,
      phone: each.phone,
      devices: each.devices,
      lastActiveAt: each.lastActiveAt,
    ),
];

/// Why a staff or device command was not taken.
enum StaffRefusal {
  /// The number belongs to another account (S6).
  phoneTaken,

  /// Anything else (no answer, a target gone since): the list is read again.
  failed,
}

/// `GET /v1/merchant/staff` and its commands, the owners' (a cashier gets
/// `403 owner_only`); read on opening «الموظفون». Each command's answer is
/// the list.
class StaffNotifier extends AsyncNotifier<List<StaffMember>> {
  MerchantApi get _api => ref.read(coreApiProvider).getMerchantApi();

  @override
  Future<List<StaffMember>> build() async =>
      _staffOf((await _api.merchantStaffStaff()).data!);

  /// Adds a cashier with a name and an E.164 number (RA §14.1); null once
  /// added.
  Future<StaffRefusal?> addCashier(String name, String phone) => _run(
    () => _api.merchantStaffAddCashier(
      merchantNewCashierDto: MerchantNewCashierDto(
        (b) => b
          ..name = name
          ..phone = phone,
      ),
    ),
  );

  /// Removes a cashier; their devices are signed out at once (RA §14.1).
  Future<StaffRefusal?> remove(String accountId) =>
      _run(() => _api.merchantStaffRemoveCashier(accountId: accountId));

  Future<StaffRefusal?> _run(
    Future<Response<MerchantStaffDtoOutput>> Function() command,
  ) async {
    try {
      state = AsyncData(_staffOf((await command()).data!));
      return null;
    } on DioException catch (error) {
      final answer = error.response;
      if (answer?.statusCode == 409 &&
          answer?.data is Map &&
          (answer!.data as Map)['error'] == 'phone_taken') {
        return StaffRefusal.phoneTaken;
      }
      ref.invalidateSelf();
      return StaffRefusal.failed;
    }
  }
}

final staffProvider =
    AsyncNotifierProvider.autoDispose<StaffNotifier, List<StaffMember>>(
      StaffNotifier.new,
    );

/// A device of the restaurant on «الأجهزة» (RA §14.2).
class RestaurantDevice {
  const RestaurantDevice({
    required this.deviceId,
    required this.name,
    required this.platform,
    required this.appVersion,
    required this.user,
    required this.userIsOwner,
    required this.signedIn,
    required this.lastSeenAt,
    required this.thisDevice,
    required this.ringing,
    required this.connected,
    required this.checkPassed,
  });

  final String deviceId;
  final String name;
  final MerchantDevicesDtoOutputDevicesInnerPlatformEnum platform;
  final String appVersion;

  /// Signed in on it now, else the latest who was; null before any sign-in.
  final String? user;
  final bool userIsOwner;
  final bool signedIn;
  final DateTime? lastSeenAt;

  /// The device this app runs on.
  final bool thisDevice;

  /// RA §14.2 (slice 2.42): whether ring events ring on it, whether it is
  /// connected now, and its last device check (null before any).
  final bool ringing;
  final bool connected;
  final bool? checkPassed;
}

List<RestaurantDevice> _devicesOf(MerchantDevicesDtoOutput dto) => [
  for (final each in dto.devices)
    RestaurantDevice(
      deviceId: each.deviceId,
      name: each.name,
      platform: each.platform,
      appVersion: each.appVersion,
      user: each.user?.name,
      userIsOwner:
          each.user?.role ==
          AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum.owner,
      signedIn: each.signedIn,
      lastSeenAt: each.lastSeenAt,
      thisDevice: each.thisDevice,
      ringing: each.ringing,
      connected: each.connected,
      checkPassed: each.deviceCheck?.passed,
    ),
];

/// `GET /v1/merchant/devices` and its commands, the owners'; read on
/// opening «الأجهزة».
class DevicesNotifier extends AsyncNotifier<List<RestaurantDevice>> {
  MerchantApi get _api => ref.read(coreApiProvider).getMerchantApi();

  @override
  Future<List<RestaurantDevice>> build() async =>
      _devicesOf((await _api.merchantStaffListDevices()).data!);

  /// False when the server did not take it: the list is read again.
  Future<bool> rename(String deviceId, String name) => _run(
    () => _api.merchantStaffRenameDevice(
      deviceId: deviceId,
      merchantDeviceNameDto: MerchantDeviceNameDto((b) => b..name = name),
    ),
  );

  /// Signs the device out; its user stays (RA §14.2).
  Future<bool> signOut(String deviceId) =>
      _run(() => _api.merchantStaffSignOutDevice(deviceId: deviceId));

  Future<bool> _run(
    Future<Response<MerchantDevicesDtoOutput>> Function() command,
  ) async {
    try {
      state = AsyncData(_devicesOf((await command()).data!));
      return true;
    } on DioException {
      ref.invalidateSelf();
      return false;
    }
  }
}

final devicesProvider =
    AsyncNotifierProvider.autoDispose<DevicesNotifier, List<RestaurantDevice>>(
      DevicesNotifier.new,
    );
