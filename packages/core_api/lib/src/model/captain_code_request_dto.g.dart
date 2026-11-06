// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_code_request_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainCodeRequestDto extends CaptainCodeRequestDto {
  @override
  final String phone;
  @override
  final String deviceId;

  factory _$CaptainCodeRequestDto([
    void Function(CaptainCodeRequestDtoBuilder)? updates,
  ]) => (CaptainCodeRequestDtoBuilder()..update(updates))._build();

  _$CaptainCodeRequestDto._({required this.phone, required this.deviceId})
    : super._();
  @override
  CaptainCodeRequestDto rebuild(
    void Function(CaptainCodeRequestDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainCodeRequestDtoBuilder toBuilder() =>
      CaptainCodeRequestDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainCodeRequestDto &&
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
    return (newBuiltValueToStringHelper(r'CaptainCodeRequestDto')
          ..add('phone', phone)
          ..add('deviceId', deviceId))
        .toString();
  }
}

class CaptainCodeRequestDtoBuilder
    implements Builder<CaptainCodeRequestDto, CaptainCodeRequestDtoBuilder> {
  _$CaptainCodeRequestDto? _$v;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  CaptainCodeRequestDtoBuilder() {
    CaptainCodeRequestDto._defaults(this);
  }

  CaptainCodeRequestDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _phone = $v.phone;
      _deviceId = $v.deviceId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainCodeRequestDto other) {
    _$v = other as _$CaptainCodeRequestDto;
  }

  @override
  void update(void Function(CaptainCodeRequestDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainCodeRequestDto build() => _build();

  _$CaptainCodeRequestDto _build() {
    final _$result =
        _$v ??
        _$CaptainCodeRequestDto._(
          phone: BuiltValueNullFieldError.checkNotNull(
            phone,
            r'CaptainCodeRequestDto',
            'phone',
          ),
          deviceId: BuiltValueNullFieldError.checkNotNull(
            deviceId,
            r'CaptainCodeRequestDto',
            'deviceId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
