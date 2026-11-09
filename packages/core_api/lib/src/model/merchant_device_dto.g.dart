// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_device_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantDeviceDtoPlatformEnum _$merchantDeviceDtoPlatformEnum_android =
    const MerchantDeviceDtoPlatformEnum._('android');
const MerchantDeviceDtoPlatformEnum _$merchantDeviceDtoPlatformEnum_ios =
    const MerchantDeviceDtoPlatformEnum._('ios');
const MerchantDeviceDtoPlatformEnum _$merchantDeviceDtoPlatformEnum_windows =
    const MerchantDeviceDtoPlatformEnum._('windows');

MerchantDeviceDtoPlatformEnum _$merchantDeviceDtoPlatformEnumValueOf(
  String name,
) {
  switch (name) {
    case 'android':
      return _$merchantDeviceDtoPlatformEnum_android;
    case 'ios':
      return _$merchantDeviceDtoPlatformEnum_ios;
    case 'windows':
      return _$merchantDeviceDtoPlatformEnum_windows;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantDeviceDtoPlatformEnum>
_$merchantDeviceDtoPlatformEnumValues = BuiltSet<MerchantDeviceDtoPlatformEnum>(
  const <MerchantDeviceDtoPlatformEnum>[
    _$merchantDeviceDtoPlatformEnum_android,
    _$merchantDeviceDtoPlatformEnum_ios,
    _$merchantDeviceDtoPlatformEnum_windows,
  ],
);

Serializer<MerchantDeviceDtoPlatformEnum>
_$merchantDeviceDtoPlatformEnumSerializer =
    _$MerchantDeviceDtoPlatformEnumSerializer();

class _$MerchantDeviceDtoPlatformEnumSerializer
    implements PrimitiveSerializer<MerchantDeviceDtoPlatformEnum> {
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
  final Iterable<Type> types = const <Type>[MerchantDeviceDtoPlatformEnum];
  @override
  final String wireName = 'MerchantDeviceDtoPlatformEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantDeviceDtoPlatformEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantDeviceDtoPlatformEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantDeviceDtoPlatformEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantDeviceDto extends MerchantDeviceDto {
  @override
  final String name;
  @override
  final MerchantDeviceDtoPlatformEnum platform;
  @override
  final String appVersion;

  factory _$MerchantDeviceDto([
    void Function(MerchantDeviceDtoBuilder)? updates,
  ]) => (MerchantDeviceDtoBuilder()..update(updates))._build();

  _$MerchantDeviceDto._({
    required this.name,
    required this.platform,
    required this.appVersion,
  }) : super._();
  @override
  MerchantDeviceDto rebuild(void Function(MerchantDeviceDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MerchantDeviceDtoBuilder toBuilder() =>
      MerchantDeviceDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantDeviceDto &&
        name == other.name &&
        platform == other.platform &&
        appVersion == other.appVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, platform.hashCode);
    _$hash = $jc(_$hash, appVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantDeviceDto')
          ..add('name', name)
          ..add('platform', platform)
          ..add('appVersion', appVersion))
        .toString();
  }
}

class MerchantDeviceDtoBuilder
    implements Builder<MerchantDeviceDto, MerchantDeviceDtoBuilder> {
  _$MerchantDeviceDto? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  MerchantDeviceDtoPlatformEnum? _platform;
  MerchantDeviceDtoPlatformEnum? get platform => _$this._platform;
  set platform(MerchantDeviceDtoPlatformEnum? platform) =>
      _$this._platform = platform;

  String? _appVersion;
  String? get appVersion => _$this._appVersion;
  set appVersion(String? appVersion) => _$this._appVersion = appVersion;

  MerchantDeviceDtoBuilder() {
    MerchantDeviceDto._defaults(this);
  }

  MerchantDeviceDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _platform = $v.platform;
      _appVersion = $v.appVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantDeviceDto other) {
    _$v = other as _$MerchantDeviceDto;
  }

  @override
  void update(void Function(MerchantDeviceDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantDeviceDto build() => _build();

  _$MerchantDeviceDto _build() {
    final _$result =
        _$v ??
        _$MerchantDeviceDto._(
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'MerchantDeviceDto',
            'name',
          ),
          platform: BuiltValueNullFieldError.checkNotNull(
            platform,
            r'MerchantDeviceDto',
            'platform',
          ),
          appVersion: BuiltValueNullFieldError.checkNotNull(
            appVersion,
            r'MerchantDeviceDto',
            'appVersion',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
