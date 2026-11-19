// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_device_name_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantDeviceNameDto extends MerchantDeviceNameDto {
  @override
  final String name;

  factory _$MerchantDeviceNameDto([
    void Function(MerchantDeviceNameDtoBuilder)? updates,
  ]) => (MerchantDeviceNameDtoBuilder()..update(updates))._build();

  _$MerchantDeviceNameDto._({required this.name}) : super._();
  @override
  MerchantDeviceNameDto rebuild(
    void Function(MerchantDeviceNameDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantDeviceNameDtoBuilder toBuilder() =>
      MerchantDeviceNameDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantDeviceNameDto && name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'MerchantDeviceNameDto',
    )..add('name', name)).toString();
  }
}

class MerchantDeviceNameDtoBuilder
    implements Builder<MerchantDeviceNameDto, MerchantDeviceNameDtoBuilder> {
  _$MerchantDeviceNameDto? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  MerchantDeviceNameDtoBuilder() {
    MerchantDeviceNameDto._defaults(this);
  }

  MerchantDeviceNameDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantDeviceNameDto other) {
    _$v = other as _$MerchantDeviceNameDto;
  }

  @override
  void update(void Function(MerchantDeviceNameDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantDeviceNameDto build() => _build();

  _$MerchantDeviceNameDto _build() {
    final _$result =
        _$v ??
        _$MerchantDeviceNameDto._(
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'MerchantDeviceNameDto',
            'name',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
