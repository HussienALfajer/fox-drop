// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_locations_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainLocationsDto extends CaptainLocationsDto {
  @override
  final BuiltList<CaptainLocationsDtoPointsInner> points;

  factory _$CaptainLocationsDto([
    void Function(CaptainLocationsDtoBuilder)? updates,
  ]) => (CaptainLocationsDtoBuilder()..update(updates))._build();

  _$CaptainLocationsDto._({required this.points}) : super._();
  @override
  CaptainLocationsDto rebuild(
    void Function(CaptainLocationsDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainLocationsDtoBuilder toBuilder() =>
      CaptainLocationsDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainLocationsDto && points == other.points;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, points.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CaptainLocationsDto',
    )..add('points', points)).toString();
  }
}

class CaptainLocationsDtoBuilder
    implements Builder<CaptainLocationsDto, CaptainLocationsDtoBuilder> {
  _$CaptainLocationsDto? _$v;

  ListBuilder<CaptainLocationsDtoPointsInner>? _points;
  ListBuilder<CaptainLocationsDtoPointsInner> get points =>
      _$this._points ??= ListBuilder<CaptainLocationsDtoPointsInner>();
  set points(ListBuilder<CaptainLocationsDtoPointsInner>? points) =>
      _$this._points = points;

  CaptainLocationsDtoBuilder() {
    CaptainLocationsDto._defaults(this);
  }

  CaptainLocationsDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _points = $v.points.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainLocationsDto other) {
    _$v = other as _$CaptainLocationsDto;
  }

  @override
  void update(void Function(CaptainLocationsDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainLocationsDto build() => _build();

  _$CaptainLocationsDto _build() {
    _$CaptainLocationsDto _$result;
    try {
      _$result = _$v ?? _$CaptainLocationsDto._(points: points.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'points';
        points.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainLocationsDto',
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
