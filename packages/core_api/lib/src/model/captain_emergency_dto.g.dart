// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_emergency_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainEmergencyDto extends CaptainEmergencyDto {
  @override
  final CaptainEmergencyDtoLocation? location;

  factory _$CaptainEmergencyDto([
    void Function(CaptainEmergencyDtoBuilder)? updates,
  ]) => (CaptainEmergencyDtoBuilder()..update(updates))._build();

  _$CaptainEmergencyDto._({this.location}) : super._();
  @override
  CaptainEmergencyDto rebuild(
    void Function(CaptainEmergencyDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainEmergencyDtoBuilder toBuilder() =>
      CaptainEmergencyDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainEmergencyDto && location == other.location;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CaptainEmergencyDto',
    )..add('location', location)).toString();
  }
}

class CaptainEmergencyDtoBuilder
    implements Builder<CaptainEmergencyDto, CaptainEmergencyDtoBuilder> {
  _$CaptainEmergencyDto? _$v;

  CaptainEmergencyDtoLocationBuilder? _location;
  CaptainEmergencyDtoLocationBuilder get location =>
      _$this._location ??= CaptainEmergencyDtoLocationBuilder();
  set location(CaptainEmergencyDtoLocationBuilder? location) =>
      _$this._location = location;

  CaptainEmergencyDtoBuilder() {
    CaptainEmergencyDto._defaults(this);
  }

  CaptainEmergencyDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _location = $v.location?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainEmergencyDto other) {
    _$v = other as _$CaptainEmergencyDto;
  }

  @override
  void update(void Function(CaptainEmergencyDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainEmergencyDto build() => _build();

  _$CaptainEmergencyDto _build() {
    _$CaptainEmergencyDto _$result;
    try {
      _$result = _$v ?? _$CaptainEmergencyDto._(location: _location?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'location';
        _location?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainEmergencyDto',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
