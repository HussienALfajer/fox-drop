// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_code_request_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerCodeRequestDto extends CustomerCodeRequestDto {
  @override
  final String phone;
  @override
  final String deviceId;

  factory _$CustomerCodeRequestDto([
    void Function(CustomerCodeRequestDtoBuilder)? updates,
  ]) => (CustomerCodeRequestDtoBuilder()..update(updates))._build();

  _$CustomerCodeRequestDto._({required this.phone, required this.deviceId})
    : super._();
  @override
  CustomerCodeRequestDto rebuild(
    void Function(CustomerCodeRequestDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerCodeRequestDtoBuilder toBuilder() =>
      CustomerCodeRequestDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerCodeRequestDto &&
        phone == other.phone &&
        deviceId == other.deviceId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerCodeRequestDto')
          ..add('phone', phone)
          ..add('deviceId', deviceId))
        .toString();
  }
}

class CustomerCodeRequestDtoBuilder
    implements Builder<CustomerCodeRequestDto, CustomerCodeRequestDtoBuilder> {
  _$CustomerCodeRequestDto? _$v;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  CustomerCodeRequestDtoBuilder() {
    CustomerCodeRequestDto._defaults(this);
  }

  CustomerCodeRequestDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _phone = $v.phone;
      _deviceId = $v.deviceId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerCodeRequestDto other) {
    _$v = other as _$CustomerCodeRequestDto;
  }

  @override
  void update(void Function(CustomerCodeRequestDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerCodeRequestDto build() => _build();

  _$CustomerCodeRequestDto _build() {
    final _$result =
        _$v ??
        _$CustomerCodeRequestDto._(
          phone: BuiltValueNullFieldError.checkNotNull(
            phone,
            r'CustomerCodeRequestDto',
            'phone',
          ),
          deviceId: BuiltValueNullFieldError.checkNotNull(
            deviceId,
            r'CustomerCodeRequestDto',
            'deviceId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
