// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_setting_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateSettingDto extends UpdateSettingDto {
  @override
  final String? cityId;
  @override
  final JsonObject? value;
  @override
  final String? reason;

  factory _$UpdateSettingDto([
    void Function(UpdateSettingDtoBuilder)? updates,
  ]) => (UpdateSettingDtoBuilder()..update(updates))._build();

  _$UpdateSettingDto._({this.cityId, this.value, this.reason}) : super._();
  @override
  UpdateSettingDto rebuild(void Function(UpdateSettingDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateSettingDtoBuilder toBuilder() =>
      UpdateSettingDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateSettingDto &&
        cityId == other.cityId &&
        value == other.value &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateSettingDto')
          ..add('cityId', cityId)
          ..add('value', value)
          ..add('reason', reason))
        .toString();
  }
}

class UpdateSettingDtoBuilder
    implements Builder<UpdateSettingDto, UpdateSettingDtoBuilder> {
  _$UpdateSettingDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  JsonObject? _value;
  JsonObject? get value => _$this._value;
  set value(JsonObject? value) => _$this._value = value;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  UpdateSettingDtoBuilder() {
    UpdateSettingDto._defaults(this);
  }

  UpdateSettingDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _value = $v.value;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateSettingDto other) {
    _$v = other as _$UpdateSettingDto;
  }

  @override
  void update(void Function(UpdateSettingDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateSettingDto build() => _build();

  _$UpdateSettingDto _build() {
    final _$result =
        _$v ??
        _$UpdateSettingDto._(cityId: cityId, value: value, reason: reason);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
