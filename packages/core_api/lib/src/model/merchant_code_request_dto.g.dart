// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_code_request_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantCodeRequestDtoPlatformEnum
_$merchantCodeRequestDtoPlatformEnum_android =
    const MerchantCodeRequestDtoPlatformEnum._('android');
const MerchantCodeRequestDtoPlatformEnum
_$merchantCodeRequestDtoPlatformEnum_ios =
    const MerchantCodeRequestDtoPlatformEnum._('ios');
const MerchantCodeRequestDtoPlatformEnum
_$merchantCodeRequestDtoPlatformEnum_windows =
    const MerchantCodeRequestDtoPlatformEnum._('windows');

MerchantCodeRequestDtoPlatformEnum _$merchantCodeRequestDtoPlatformEnumValueOf(
  String name,
) {
  switch (name) {
    case 'android':
      return _$merchantCodeRequestDtoPlatformEnum_android;
    case 'ios':
      return _$merchantCodeRequestDtoPlatformEnum_ios;
    case 'windows':
      return _$merchantCodeRequestDtoPlatformEnum_windows;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantCodeRequestDtoPlatformEnum>
_$merchantCodeRequestDtoPlatformEnumValues =
    BuiltSet<MerchantCodeRequestDtoPlatformEnum>(
      const <MerchantCodeRequestDtoPlatformEnum>[
        _$merchantCodeRequestDtoPlatformEnum_android,
        _$merchantCodeRequestDtoPlatformEnum_ios,
        _$merchantCodeRequestDtoPlatformEnum_windows,
      ],
    );

Serializer<MerchantCodeRequestDtoPlatformEnum>
_$merchantCodeRequestDtoPlatformEnumSerializer =
    _$MerchantCodeRequestDtoPlatformEnumSerializer();

class _$MerchantCodeRequestDtoPlatformEnumSerializer
    implements PrimitiveSerializer<MerchantCodeRequestDtoPlatformEnum> {
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
  final Iterable<Type> types = const <Type>[MerchantCodeRequestDtoPlatformEnum];
  @override
  final String wireName = 'MerchantCodeRequestDtoPlatformEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantCodeRequestDtoPlatformEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantCodeRequestDtoPlatformEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantCodeRequestDtoPlatformEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantCodeRequestDto extends MerchantCodeRequestDto {
  @override
  final String phone;
  @override
  final String deviceId;
  @override
  final MerchantCodeRequestDtoPlatformEnum? platform;

  factory _$MerchantCodeRequestDto([
    void Function(MerchantCodeRequestDtoBuilder)? updates,
  ]) => (MerchantCodeRequestDtoBuilder()..update(updates))._build();

  _$MerchantCodeRequestDto._({
    required this.phone,
    required this.deviceId,
    this.platform,
  }) : super._();
  @override
  MerchantCodeRequestDto rebuild(
    void Function(MerchantCodeRequestDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantCodeRequestDtoBuilder toBuilder() =>
      MerchantCodeRequestDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantCodeRequestDto &&
        phone == other.phone &&
        deviceId == other.deviceId &&
        platform == other.platform;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, platform.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantCodeRequestDto')
          ..add('phone', phone)
          ..add('deviceId', deviceId)
          ..add('platform', platform))
        .toString();
  }
}

class MerchantCodeRequestDtoBuilder
    implements Builder<MerchantCodeRequestDto, MerchantCodeRequestDtoBuilder> {
  _$MerchantCodeRequestDto? _$v;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  MerchantCodeRequestDtoPlatformEnum? _platform;
  MerchantCodeRequestDtoPlatformEnum? get platform => _$this._platform;
  set platform(MerchantCodeRequestDtoPlatformEnum? platform) =>
      _$this._platform = platform;

  MerchantCodeRequestDtoBuilder() {
    MerchantCodeRequestDto._defaults(this);
  }

  MerchantCodeRequestDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _phone = $v.phone;
      _deviceId = $v.deviceId;
      _platform = $v.platform;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantCodeRequestDto other) {
    _$v = other as _$MerchantCodeRequestDto;
  }

  @override
  void update(void Function(MerchantCodeRequestDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantCodeRequestDto build() => _build();

  _$MerchantCodeRequestDto _build() {
    final _$result =
        _$v ??
        _$MerchantCodeRequestDto._(
          phone: BuiltValueNullFieldError.checkNotNull(
            phone,
            r'MerchantCodeRequestDto',
            'phone',
          ),
          deviceId: BuiltValueNullFieldError.checkNotNull(
            deviceId,
            r'MerchantCodeRequestDto',
            'deviceId',
          ),
          platform: platform,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
