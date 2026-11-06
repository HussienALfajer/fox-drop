// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_arrive_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainArriveDto extends CaptainArriveDto {
  @override
  final CaptainArriveDtoLocation location;

  factory _$CaptainArriveDto([
    void Function(CaptainArriveDtoBuilder)? updates,
  ]) => (CaptainArriveDtoBuilder()..update(updates))._build();

  _$CaptainArriveDto._({required this.location}) : super._();
  @override
  CaptainArriveDto rebuild(void Function(CaptainArriveDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CaptainArriveDtoBuilder toBuilder() =>
      CaptainArriveDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainArriveDto && location == other.location;
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
      r'CaptainArriveDto',
    )..add('location', location)).toString();
  }
}

class CaptainArriveDtoBuilder
    implements Builder<CaptainArriveDto, CaptainArriveDtoBuilder> {
  _$CaptainArriveDto? _$v;

  CaptainArriveDtoLocationBuilder? _location;
  CaptainArriveDtoLocationBuilder get location =>
      _$this._location ??= CaptainArriveDtoLocationBuilder();
  set location(CaptainArriveDtoLocationBuilder? location) =>
      _$this._location = location;

  CaptainArriveDtoBuilder() {
    CaptainArriveDto._defaults(this);
  }

  CaptainArriveDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _location = $v.location.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainArriveDto other) {
    _$v = other as _$CaptainArriveDto;
  }

  @override
  void update(void Function(CaptainArriveDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainArriveDto build() => _build();

  _$CaptainArriveDto _build() {
    _$CaptainArriveDto _$result;
    try {
      _$result = _$v ?? _$CaptainArriveDto._(location: location.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'location';
        location.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainArriveDto',
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
