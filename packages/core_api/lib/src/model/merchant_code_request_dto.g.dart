// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_code_request_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantCodeRequestDto extends MerchantCodeRequestDto {
  @override
  final String phone;
  @override
  final String deviceId;

  factory _$MerchantCodeRequestDto([
    void Function(MerchantCodeRequestDtoBuilder)? updates,
  ]) => (MerchantCodeRequestDtoBuilder()..update(updates))._build();

  _$MerchantCodeRequestDto._({required this.phone, required this.deviceId})
    : super._();
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
    return (newBuiltValueToStringHelper(r'MerchantCodeRequestDto')
          ..add('phone', phone)
          ..add('deviceId', deviceId))
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

  MerchantCodeRequestDtoBuilder() {
    MerchantCodeRequestDto._defaults(this);
  }

  MerchantCodeRequestDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _phone = $v.phone;
      _deviceId = $v.deviceId;
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
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
