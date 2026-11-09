// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_sign_in_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerSignInDto extends CustomerSignInDto {
  @override
  final String phone;
  @override
  final String deviceId;
  @override
  final String code;

  factory _$CustomerSignInDto([
    void Function(CustomerSignInDtoBuilder)? updates,
  ]) => (CustomerSignInDtoBuilder()..update(updates))._build();

  _$CustomerSignInDto._({
    required this.phone,
    required this.deviceId,
    required this.code,
  }) : super._();
  @override
  CustomerSignInDto rebuild(void Function(CustomerSignInDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CustomerSignInDtoBuilder toBuilder() =>
      CustomerSignInDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerSignInDto &&
        phone == other.phone &&
        deviceId == other.deviceId &&
        code == other.code;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerSignInDto')
          ..add('phone', phone)
          ..add('deviceId', deviceId)
          ..add('code', code))
        .toString();
  }
}

class CustomerSignInDtoBuilder
    implements Builder<CustomerSignInDto, CustomerSignInDtoBuilder> {
  _$CustomerSignInDto? _$v;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  CustomerSignInDtoBuilder() {
    CustomerSignInDto._defaults(this);
  }

  CustomerSignInDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _phone = $v.phone;
      _deviceId = $v.deviceId;
      _code = $v.code;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerSignInDto other) {
    _$v = other as _$CustomerSignInDto;
  }

  @override
  void update(void Function(CustomerSignInDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerSignInDto build() => _build();

  _$CustomerSignInDto _build() {
    final _$result =
        _$v ??
        _$CustomerSignInDto._(
          phone: BuiltValueNullFieldError.checkNotNull(
            phone,
            r'CustomerSignInDto',
            'phone',
          ),
          deviceId: BuiltValueNullFieldError.checkNotNull(
            deviceId,
            r'CustomerSignInDto',
            'deviceId',
          ),
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'CustomerSignInDto',
            'code',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
