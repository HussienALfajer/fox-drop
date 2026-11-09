// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_busy_mode_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantBusyModeDto extends MerchantBusyModeDto {
  @override
  final int? extraMin;

  factory _$MerchantBusyModeDto([
    void Function(MerchantBusyModeDtoBuilder)? updates,
  ]) => (MerchantBusyModeDtoBuilder()..update(updates))._build();

  _$MerchantBusyModeDto._({this.extraMin}) : super._();
  @override
  MerchantBusyModeDto rebuild(
    void Function(MerchantBusyModeDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantBusyModeDtoBuilder toBuilder() =>
      MerchantBusyModeDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantBusyModeDto && extraMin == other.extraMin;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, extraMin.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'MerchantBusyModeDto',
    )..add('extraMin', extraMin)).toString();
  }
}

class MerchantBusyModeDtoBuilder
    implements Builder<MerchantBusyModeDto, MerchantBusyModeDtoBuilder> {
  _$MerchantBusyModeDto? _$v;

  int? _extraMin;
  int? get extraMin => _$this._extraMin;
  set extraMin(int? extraMin) => _$this._extraMin = extraMin;

  MerchantBusyModeDtoBuilder() {
    MerchantBusyModeDto._defaults(this);
  }

  MerchantBusyModeDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _extraMin = $v.extraMin;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantBusyModeDto other) {
    _$v = other as _$MerchantBusyModeDto;
  }

  @override
  void update(void Function(MerchantBusyModeDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantBusyModeDto build() => _build();

  _$MerchantBusyModeDto _build() {
    final _$result = _$v ?? _$MerchantBusyModeDto._(extraMin: extraMin);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
