// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_locations_dto_points_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainLocationsDtoPointsInner extends CaptainLocationsDtoPointsInner {
  @override
  final num latitude;
  @override
  final num longitude;
  @override
  final num accuracyMetres;
  @override
  final DateTime recordedAt;
  @override
  final bool simulated;

  factory _$CaptainLocationsDtoPointsInner([
    void Function(CaptainLocationsDtoPointsInnerBuilder)? updates,
  ]) => (CaptainLocationsDtoPointsInnerBuilder()..update(updates))._build();

  _$CaptainLocationsDtoPointsInner._({
    required this.latitude,
    required this.longitude,
    required this.accuracyMetres,
    required this.recordedAt,
    required this.simulated,
  }) : super._();
  @override
  CaptainLocationsDtoPointsInner rebuild(
    void Function(CaptainLocationsDtoPointsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainLocationsDtoPointsInnerBuilder toBuilder() =>
      CaptainLocationsDtoPointsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainLocationsDtoPointsInner &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        accuracyMetres == other.accuracyMetres &&
        recordedAt == other.recordedAt &&
        simulated == other.simulated;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, accuracyMetres.hashCode);
    _$hash = $jc(_$hash, recordedAt.hashCode);
    _$hash = $jc(_$hash, simulated.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainLocationsDtoPointsInner')
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('accuracyMetres', accuracyMetres)
          ..add('recordedAt', recordedAt)
          ..add('simulated', simulated))
        .toString();
  }
}

class CaptainLocationsDtoPointsInnerBuilder
    implements
        Builder<
          CaptainLocationsDtoPointsInner,
          CaptainLocationsDtoPointsInnerBuilder
        > {
  _$CaptainLocationsDtoPointsInner? _$v;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  num? _accuracyMetres;
  num? get accuracyMetres => _$this._accuracyMetres;
  set accuracyMetres(num? accuracyMetres) =>
      _$this._accuracyMetres = accuracyMetres;

  DateTime? _recordedAt;
  DateTime? get recordedAt => _$this._recordedAt;
  set recordedAt(DateTime? recordedAt) => _$this._recordedAt = recordedAt;

  bool? _simulated;
  bool? get simulated => _$this._simulated;
  set simulated(bool? simulated) => _$this._simulated = simulated;

  CaptainLocationsDtoPointsInnerBuilder() {
    CaptainLocationsDtoPointsInner._defaults(this);
  }

  CaptainLocationsDtoPointsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _accuracyMetres = $v.accuracyMetres;
      _recordedAt = $v.recordedAt;
      _simulated = $v.simulated;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainLocationsDtoPointsInner other) {
    _$v = other as _$CaptainLocationsDtoPointsInner;
  }

  @override
  void update(void Function(CaptainLocationsDtoPointsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainLocationsDtoPointsInner build() => _build();

  _$CaptainLocationsDtoPointsInner _build() {
    final _$result =
        _$v ??
        _$CaptainLocationsDtoPointsInner._(
          latitude: BuiltValueNullFieldError.checkNotNull(
            latitude,
            r'CaptainLocationsDtoPointsInner',
            'latitude',
          ),
          longitude: BuiltValueNullFieldError.checkNotNull(
            longitude,
            r'CaptainLocationsDtoPointsInner',
            'longitude',
          ),
          accuracyMetres: BuiltValueNullFieldError.checkNotNull(
            accuracyMetres,
            r'CaptainLocationsDtoPointsInner',
            'accuracyMetres',
          ),
          recordedAt: BuiltValueNullFieldError.checkNotNull(
            recordedAt,
            r'CaptainLocationsDtoPointsInner',
            'recordedAt',
          ),
          simulated: BuiltValueNullFieldError.checkNotNull(
            simulated,
            r'CaptainLocationsDtoPointsInner',
            'simulated',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
