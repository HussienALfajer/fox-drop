// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_pause_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantPauseDto extends MerchantPauseDto {
  @override
  final int? minutes;

  factory _$MerchantPauseDto([
    void Function(MerchantPauseDtoBuilder)? updates,
  ]) => (MerchantPauseDtoBuilder()..update(updates))._build();

  _$MerchantPauseDto._({this.minutes}) : super._();
  @override
  MerchantPauseDto rebuild(void Function(MerchantPauseDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MerchantPauseDtoBuilder toBuilder() =>
      MerchantPauseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantPauseDto && minutes == other.minutes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, minutes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'MerchantPauseDto',
    )..add('minutes', minutes)).toString();
  }
}

class MerchantPauseDtoBuilder
    implements Builder<MerchantPauseDto, MerchantPauseDtoBuilder> {
  _$MerchantPauseDto? _$v;

  int? _minutes;
  int? get minutes => _$this._minutes;
  set minutes(int? minutes) => _$this._minutes = minutes;

  MerchantPauseDtoBuilder() {
    MerchantPauseDto._defaults(this);
  }

  MerchantPauseDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _minutes = $v.minutes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantPauseDto other) {
    _$v = other as _$MerchantPauseDto;
  }

  @override
  void update(void Function(MerchantPauseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantPauseDto build() => _build();

  _$MerchantPauseDto _build() {
    final _$result = _$v ?? _$MerchantPauseDto._(minutes: minutes);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
