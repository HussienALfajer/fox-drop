// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_accept_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantAcceptDto extends MerchantAcceptDto {
  @override
  final num prepMin;

  factory _$MerchantAcceptDto([
    void Function(MerchantAcceptDtoBuilder)? updates,
  ]) => (MerchantAcceptDtoBuilder()..update(updates))._build();

  _$MerchantAcceptDto._({required this.prepMin}) : super._();
  @override
  MerchantAcceptDto rebuild(void Function(MerchantAcceptDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MerchantAcceptDtoBuilder toBuilder() =>
      MerchantAcceptDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantAcceptDto && prepMin == other.prepMin;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, prepMin.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'MerchantAcceptDto',
    )..add('prepMin', prepMin)).toString();
  }
}

class MerchantAcceptDtoBuilder
    implements Builder<MerchantAcceptDto, MerchantAcceptDtoBuilder> {
  _$MerchantAcceptDto? _$v;

  num? _prepMin;
  num? get prepMin => _$this._prepMin;
  set prepMin(num? prepMin) => _$this._prepMin = prepMin;

  MerchantAcceptDtoBuilder() {
    MerchantAcceptDto._defaults(this);
  }

  MerchantAcceptDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _prepMin = $v.prepMin;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantAcceptDto other) {
    _$v = other as _$MerchantAcceptDto;
  }

  @override
  void update(void Function(MerchantAcceptDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantAcceptDto build() => _build();

  _$MerchantAcceptDto _build() {
    final _$result =
        _$v ??
        _$MerchantAcceptDto._(
          prepMin: BuiltValueNullFieldError.checkNotNull(
            prepMin,
            r'MerchantAcceptDto',
            'prepMin',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
