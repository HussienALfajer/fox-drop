// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_setting_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ResetSettingDto extends ResetSettingDto {
  @override
  final String? cityId;
  @override
  final String? reason;

  factory _$ResetSettingDto([void Function(ResetSettingDtoBuilder)? updates]) =>
      (ResetSettingDtoBuilder()..update(updates))._build();

  _$ResetSettingDto._({this.cityId, this.reason}) : super._();
  @override
  ResetSettingDto rebuild(void Function(ResetSettingDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ResetSettingDtoBuilder toBuilder() => ResetSettingDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ResetSettingDto &&
        cityId == other.cityId &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ResetSettingDto')
          ..add('cityId', cityId)
          ..add('reason', reason))
        .toString();
  }
}

class ResetSettingDtoBuilder
    implements Builder<ResetSettingDto, ResetSettingDtoBuilder> {
  _$ResetSettingDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  ResetSettingDtoBuilder() {
    ResetSettingDto._defaults(this);
  }

  ResetSettingDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ResetSettingDto other) {
    _$v = other as _$ResetSettingDto;
  }

  @override
  void update(void Function(ResetSettingDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ResetSettingDto build() => _build();

  _$ResetSettingDto _build() {
    final _$result = _$v ?? _$ResetSettingDto._(cityId: cityId, reason: reason);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
