// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_category_request_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantCategoryRequestDto extends MerchantCategoryRequestDto {
  @override
  final String name;

  factory _$MerchantCategoryRequestDto([
    void Function(MerchantCategoryRequestDtoBuilder)? updates,
  ]) => (MerchantCategoryRequestDtoBuilder()..update(updates))._build();

  _$MerchantCategoryRequestDto._({required this.name}) : super._();
  @override
  MerchantCategoryRequestDto rebuild(
    void Function(MerchantCategoryRequestDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantCategoryRequestDtoBuilder toBuilder() =>
      MerchantCategoryRequestDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantCategoryRequestDto && name == other.name;
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
      r'MerchantCategoryRequestDto',
    )..add('name', name)).toString();
  }
}

class MerchantCategoryRequestDtoBuilder
    implements
        Builder<MerchantCategoryRequestDto, MerchantCategoryRequestDtoBuilder> {
  _$MerchantCategoryRequestDto? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  MerchantCategoryRequestDtoBuilder() {
    MerchantCategoryRequestDto._defaults(this);
  }

  MerchantCategoryRequestDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantCategoryRequestDto other) {
    _$v = other as _$MerchantCategoryRequestDto;
  }

  @override
  void update(void Function(MerchantCategoryRequestDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantCategoryRequestDto build() => _build();

  _$MerchantCategoryRequestDto _build() {
    final _$result =
        _$v ??
        _$MerchantCategoryRequestDto._(
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'MerchantCategoryRequestDto',
            'name',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
