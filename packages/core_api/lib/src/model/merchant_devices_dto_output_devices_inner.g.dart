// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_devices_dto_output_devices_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantDevicesDtoOutputDevicesInnerPlatformEnum
_$merchantDevicesDtoOutputDevicesInnerPlatformEnum_android =
    const MerchantDevicesDtoOutputDevicesInnerPlatformEnum._('android');
const MerchantDevicesDtoOutputDevicesInnerPlatformEnum
_$merchantDevicesDtoOutputDevicesInnerPlatformEnum_ios =
    const MerchantDevicesDtoOutputDevicesInnerPlatformEnum._('ios');
const MerchantDevicesDtoOutputDevicesInnerPlatformEnum
_$merchantDevicesDtoOutputDevicesInnerPlatformEnum_windows =
    const MerchantDevicesDtoOutputDevicesInnerPlatformEnum._('windows');

MerchantDevicesDtoOutputDevicesInnerPlatformEnum
_$merchantDevicesDtoOutputDevicesInnerPlatformEnumValueOf(String name) {
  switch (name) {
    case 'android':
      return _$merchantDevicesDtoOutputDevicesInnerPlatformEnum_android;
    case 'ios':
      return _$merchantDevicesDtoOutputDevicesInnerPlatformEnum_ios;
    case 'windows':
      return _$merchantDevicesDtoOutputDevicesInnerPlatformEnum_windows;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantDevicesDtoOutputDevicesInnerPlatformEnum>
_$merchantDevicesDtoOutputDevicesInnerPlatformEnumValues =
    BuiltSet<MerchantDevicesDtoOutputDevicesInnerPlatformEnum>(
      const <MerchantDevicesDtoOutputDevicesInnerPlatformEnum>[
        _$merchantDevicesDtoOutputDevicesInnerPlatformEnum_android,
        _$merchantDevicesDtoOutputDevicesInnerPlatformEnum_ios,
        _$merchantDevicesDtoOutputDevicesInnerPlatformEnum_windows,
      ],
    );

Serializer<MerchantDevicesDtoOutputDevicesInnerPlatformEnum>
_$merchantDevicesDtoOutputDevicesInnerPlatformEnumSerializer =
    _$MerchantDevicesDtoOutputDevicesInnerPlatformEnumSerializer();

class _$MerchantDevicesDtoOutputDevicesInnerPlatformEnumSerializer
    implements
        PrimitiveSerializer<MerchantDevicesDtoOutputDevicesInnerPlatformEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'android': 'android',
    'ios': 'ios',
    'windows': 'windows',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'android': 'android',
    'ios': 'ios',
    'windows': 'windows',
  };

  @override
  final Iterable<Type> types = const <Type>[
    MerchantDevicesDtoOutputDevicesInnerPlatformEnum,
  ];
  @override
  final String wireName = 'MerchantDevicesDtoOutputDevicesInnerPlatformEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantDevicesDtoOutputDevicesInnerPlatformEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantDevicesDtoOutputDevicesInnerPlatformEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantDevicesDtoOutputDevicesInnerPlatformEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantDevicesDtoOutputDevicesInner
    extends MerchantDevicesDtoOutputDevicesInner {
  @override
  final String deviceId;
  @override
  final String name;
  @override
  final MerchantDevicesDtoOutputDevicesInnerPlatformEnum platform;
  @override
  final String appVersion;
  @override
  final AdminRestaurantDevicesDtoOutputDevicesInnerUser? user;
  @override
  final bool signedIn;
  @override
  final DateTime? lastSeenAt;
  @override
  final bool? ringing;
  @override
  final String? deviceCheck;
  @override
  final bool thisDevice;

  factory _$MerchantDevicesDtoOutputDevicesInner([
    void Function(MerchantDevicesDtoOutputDevicesInnerBuilder)? updates,
  ]) =>
      (MerchantDevicesDtoOutputDevicesInnerBuilder()..update(updates))._build();

  _$MerchantDevicesDtoOutputDevicesInner._({
    required this.deviceId,
    required this.name,
    required this.platform,
    required this.appVersion,
    this.user,
    required this.signedIn,
    this.lastSeenAt,
    this.ringing,
    this.deviceCheck,
    required this.thisDevice,
  }) : super._();
  @override
  MerchantDevicesDtoOutputDevicesInner rebuild(
    void Function(MerchantDevicesDtoOutputDevicesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantDevicesDtoOutputDevicesInnerBuilder toBuilder() =>
      MerchantDevicesDtoOutputDevicesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantDevicesDtoOutputDevicesInner &&
        deviceId == other.deviceId &&
        name == other.name &&
        platform == other.platform &&
        appVersion == other.appVersion &&
        user == other.user &&
        signedIn == other.signedIn &&
        lastSeenAt == other.lastSeenAt &&
        ringing == other.ringing &&
        deviceCheck == other.deviceCheck &&
        thisDevice == other.thisDevice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, platform.hashCode);
    _$hash = $jc(_$hash, appVersion.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jc(_$hash, signedIn.hashCode);
    _$hash = $jc(_$hash, lastSeenAt.hashCode);
    _$hash = $jc(_$hash, ringing.hashCode);
    _$hash = $jc(_$hash, deviceCheck.hashCode);
    _$hash = $jc(_$hash, thisDevice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantDevicesDtoOutputDevicesInner')
          ..add('deviceId', deviceId)
          ..add('name', name)
          ..add('platform', platform)
          ..add('appVersion', appVersion)
          ..add('user', user)
          ..add('signedIn', signedIn)
          ..add('lastSeenAt', lastSeenAt)
          ..add('ringing', ringing)
          ..add('deviceCheck', deviceCheck)
          ..add('thisDevice', thisDevice))
        .toString();
  }
}

class MerchantDevicesDtoOutputDevicesInnerBuilder
    implements
        Builder<
          MerchantDevicesDtoOutputDevicesInner,
          MerchantDevicesDtoOutputDevicesInnerBuilder
        > {
  _$MerchantDevicesDtoOutputDevicesInner? _$v;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  MerchantDevicesDtoOutputDevicesInnerPlatformEnum? _platform;
  MerchantDevicesDtoOutputDevicesInnerPlatformEnum? get platform =>
      _$this._platform;
  set platform(MerchantDevicesDtoOutputDevicesInnerPlatformEnum? platform) =>
      _$this._platform = platform;

  String? _appVersion;
  String? get appVersion => _$this._appVersion;
  set appVersion(String? appVersion) => _$this._appVersion = appVersion;

  AdminRestaurantDevicesDtoOutputDevicesInnerUserBuilder? _user;
  AdminRestaurantDevicesDtoOutputDevicesInnerUserBuilder get user =>
      _$this._user ??= AdminRestaurantDevicesDtoOutputDevicesInnerUserBuilder();
  set user(AdminRestaurantDevicesDtoOutputDevicesInnerUserBuilder? user) =>
      _$this._user = user;

  bool? _signedIn;
  bool? get signedIn => _$this._signedIn;
  set signedIn(bool? signedIn) => _$this._signedIn = signedIn;

  DateTime? _lastSeenAt;
  DateTime? get lastSeenAt => _$this._lastSeenAt;
  set lastSeenAt(DateTime? lastSeenAt) => _$this._lastSeenAt = lastSeenAt;

  bool? _ringing;
  bool? get ringing => _$this._ringing;
  set ringing(bool? ringing) => _$this._ringing = ringing;

  String? _deviceCheck;
  String? get deviceCheck => _$this._deviceCheck;
  set deviceCheck(String? deviceCheck) => _$this._deviceCheck = deviceCheck;

  bool? _thisDevice;
  bool? get thisDevice => _$this._thisDevice;
  set thisDevice(bool? thisDevice) => _$this._thisDevice = thisDevice;

  MerchantDevicesDtoOutputDevicesInnerBuilder() {
    MerchantDevicesDtoOutputDevicesInner._defaults(this);
  }

  MerchantDevicesDtoOutputDevicesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _deviceId = $v.deviceId;
      _name = $v.name;
      _platform = $v.platform;
      _appVersion = $v.appVersion;
      _user = $v.user?.toBuilder();
      _signedIn = $v.signedIn;
      _lastSeenAt = $v.lastSeenAt;
      _ringing = $v.ringing;
      _deviceCheck = $v.deviceCheck;
      _thisDevice = $v.thisDevice;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantDevicesDtoOutputDevicesInner other) {
    _$v = other as _$MerchantDevicesDtoOutputDevicesInner;
  }

  @override
  void update(
    void Function(MerchantDevicesDtoOutputDevicesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantDevicesDtoOutputDevicesInner build() => _build();

  _$MerchantDevicesDtoOutputDevicesInner _build() {
    _$MerchantDevicesDtoOutputDevicesInner _$result;
    try {
      _$result =
          _$v ??
          _$MerchantDevicesDtoOutputDevicesInner._(
            deviceId: BuiltValueNullFieldError.checkNotNull(
              deviceId,
              r'MerchantDevicesDtoOutputDevicesInner',
              'deviceId',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'MerchantDevicesDtoOutputDevicesInner',
              'name',
            ),
            platform: BuiltValueNullFieldError.checkNotNull(
              platform,
              r'MerchantDevicesDtoOutputDevicesInner',
              'platform',
            ),
            appVersion: BuiltValueNullFieldError.checkNotNull(
              appVersion,
              r'MerchantDevicesDtoOutputDevicesInner',
              'appVersion',
            ),
            user: _user?.build(),
            signedIn: BuiltValueNullFieldError.checkNotNull(
              signedIn,
              r'MerchantDevicesDtoOutputDevicesInner',
              'signedIn',
            ),
            lastSeenAt: lastSeenAt,
            ringing: ringing,
            deviceCheck: deviceCheck,
            thisDevice: BuiltValueNullFieldError.checkNotNull(
              thisDevice,
              r'MerchantDevicesDtoOutputDevicesInner',
              'thisDevice',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        _user?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantDevicesDtoOutputDevicesInner',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
