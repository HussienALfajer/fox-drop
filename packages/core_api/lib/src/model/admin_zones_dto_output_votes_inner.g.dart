// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_zones_dto_output_votes_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminZonesDtoOutputVotesInner extends AdminZonesDtoOutputVotesInner {
  @override
  final num latitude;
  @override
  final num longitude;
  @override
  final int votes;

  factory _$AdminZonesDtoOutputVotesInner([
    void Function(AdminZonesDtoOutputVotesInnerBuilder)? updates,
  ]) => (AdminZonesDtoOutputVotesInnerBuilder()..update(updates))._build();

  _$AdminZonesDtoOutputVotesInner._({
    required this.latitude,
    required this.longitude,
    required this.votes,
  }) : super._();
  @override
  AdminZonesDtoOutputVotesInner rebuild(
    void Function(AdminZonesDtoOutputVotesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminZonesDtoOutputVotesInnerBuilder toBuilder() =>
      AdminZonesDtoOutputVotesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminZonesDtoOutputVotesInner &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        votes == other.votes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, votes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminZonesDtoOutputVotesInner')
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('votes', votes))
        .toString();
  }
}

class AdminZonesDtoOutputVotesInnerBuilder
    implements
        Builder<
          AdminZonesDtoOutputVotesInner,
          AdminZonesDtoOutputVotesInnerBuilder
        > {
  _$AdminZonesDtoOutputVotesInner? _$v;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  int? _votes;
  int? get votes => _$this._votes;
  set votes(int? votes) => _$this._votes = votes;

  AdminZonesDtoOutputVotesInnerBuilder() {
    AdminZonesDtoOutputVotesInner._defaults(this);
  }

  AdminZonesDtoOutputVotesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _votes = $v.votes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminZonesDtoOutputVotesInner other) {
    _$v = other as _$AdminZonesDtoOutputVotesInner;
  }

  @override
  void update(void Function(AdminZonesDtoOutputVotesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminZonesDtoOutputVotesInner build() => _build();

  _$AdminZonesDtoOutputVotesInner _build() {
    final _$result =
        _$v ??
        _$AdminZonesDtoOutputVotesInner._(
          latitude: BuiltValueNullFieldError.checkNotNull(
            latitude,
            r'AdminZonesDtoOutputVotesInner',
            'latitude',
          ),
          longitude: BuiltValueNullFieldError.checkNotNull(
            longitude,
            r'AdminZonesDtoOutputVotesInner',
            'longitude',
          ),
          votes: BuiltValueNullFieldError.checkNotNull(
            votes,
            r'AdminZonesDtoOutputVotesInner',
            'votes',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
