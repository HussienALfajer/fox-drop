// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_devices_dto_output_devices_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum
_$adminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum_android =
    const AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum._('android');
const AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum
_$adminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum_ios =
    const AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum._('ios');
const AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum
_$adminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum_windows =
    const AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum._('windows');

AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum
_$adminRestaurantDevicesDtoOutputDevicesInnerPlatformEnumValueOf(String name) {
  switch (name) {
    case 'android':
      return _$adminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum_android;
    case 'ios':
      return _$adminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum_ios;
    case 'windows':
      return _$adminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum_windows;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum>
_$adminRestaurantDevicesDtoOutputDevicesInnerPlatformEnumValues =
    BuiltSet<AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum>(
      const <AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum>[
        _$adminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum_android,
        _$adminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum_ios,
        _$adminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum_windows,
      ],
    );

Serializer<AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum>
_$adminRestaurantDevicesDtoOutputDevicesInnerPlatformEnumSerializer =
    _$AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnumSerializer();

class _$AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnumSerializer
    implements
        PrimitiveSerializer<
          AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum
        > {
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
    AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum,
  ];
  @override
  final String wireName =
      'AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminRestaurantDevicesDtoOutputDevicesInner
    extends AdminRestaurantDevicesDtoOutputDevicesInner {
  @override
  final String deviceId;
  @override
  final String name;
  @override
  final AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum platform;
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

  factory _$AdminRestaurantDevicesDtoOutputDevicesInner([
    void Function(AdminRestaurantDevicesDtoOutputDevicesInnerBuilder)? updates,
  ]) => (AdminRestaurantDevicesDtoOutputDevicesInnerBuilder()..update(updates))
      ._build();

  _$AdminRestaurantDevicesDtoOutputDevicesInner._({
    required this.deviceId,
    required this.name,
    required this.platform,
    required this.appVersion,
    this.user,
    required this.signedIn,
    this.lastSeenAt,
    this.ringing,
    this.deviceCheck,
  }) : super._();
  @override
  AdminRestaurantDevicesDtoOutputDevicesInner rebuild(
    void Function(AdminRestaurantDevicesDtoOutputDevicesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantDevicesDtoOutputDevicesInnerBuilder toBuilder() =>
      AdminRestaurantDevicesDtoOutputDevicesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantDevicesDtoOutputDevicesInner &&
        deviceId == other.deviceId &&
        name == other.name &&
        platform == other.platform &&
        appVersion == other.appVersion &&
        user == other.user &&
        signedIn == other.signedIn &&
        lastSeenAt == other.lastSeenAt &&
        ringing == other.ringing &&
        deviceCheck == other.deviceCheck;
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
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantDevicesDtoOutputDevicesInner',
          )
          ..add('deviceId', deviceId)
          ..add('name', name)
          ..add('platform', platform)
          ..add('appVersion', appVersion)
          ..add('user', user)
          ..add('signedIn', signedIn)
          ..add('lastSeenAt', lastSeenAt)
          ..add('ringing', ringing)
          ..add('deviceCheck', deviceCheck))
        .toString();
  }
}

class AdminRestaurantDevicesDtoOutputDevicesInnerBuilder
    implements
        Builder<
          AdminRestaurantDevicesDtoOutputDevicesInner,
          AdminRestaurantDevicesDtoOutputDevicesInnerBuilder
        > {
  _$AdminRestaurantDevicesDtoOutputDevicesInner? _$v;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum? _platform;
  AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum? get platform =>
      _$this._platform;
  set platform(
    AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum? platform,
  ) => _$this._platform = platform;

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

  AdminRestaurantDevicesDtoOutputDevicesInnerBuilder() {
    AdminRestaurantDevicesDtoOutputDevicesInner._defaults(this);
  }

  AdminRestaurantDevicesDtoOutputDevicesInnerBuilder get _$this {
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
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantDevicesDtoOutputDevicesInner other) {
    _$v = other as _$AdminRestaurantDevicesDtoOutputDevicesInner;
  }

  @override
  void update(
    void Function(AdminRestaurantDevicesDtoOutputDevicesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantDevicesDtoOutputDevicesInner build() => _build();

  _$AdminRestaurantDevicesDtoOutputDevicesInner _build() {
    _$AdminRestaurantDevicesDtoOutputDevicesInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantDevicesDtoOutputDevicesInner._(
            deviceId: BuiltValueNullFieldError.checkNotNull(
              deviceId,
              r'AdminRestaurantDevicesDtoOutputDevicesInner',
              'deviceId',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AdminRestaurantDevicesDtoOutputDevicesInner',
              'name',
            ),
            platform: BuiltValueNullFieldError.checkNotNull(
              platform,
              r'AdminRestaurantDevicesDtoOutputDevicesInner',
              'platform',
            ),
            appVersion: BuiltValueNullFieldError.checkNotNull(
              appVersion,
              r'AdminRestaurantDevicesDtoOutputDevicesInner',
              'appVersion',
            ),
            user: _user?.build(),
            signedIn: BuiltValueNullFieldError.checkNotNull(
              signedIn,
              r'AdminRestaurantDevicesDtoOutputDevicesInner',
              'signedIn',
            ),
            lastSeenAt: lastSeenAt,
            ringing: ringing,
            deviceCheck: deviceCheck,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        _user?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantDevicesDtoOutputDevicesInner',
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
