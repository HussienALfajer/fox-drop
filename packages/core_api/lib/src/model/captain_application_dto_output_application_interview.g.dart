// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_application_dto_output_application_interview.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainApplicationDtoOutputApplicationInterview
    extends CaptainApplicationDtoOutputApplicationInterview {
  @override
  final DateTime at;
  @override
  final String place;
  @override
  final num latitude;
  @override
  final num longitude;

  factory _$CaptainApplicationDtoOutputApplicationInterview([
    void Function(CaptainApplicationDtoOutputApplicationInterviewBuilder)?
    updates,
  ]) =>
      (CaptainApplicationDtoOutputApplicationInterviewBuilder()
            ..update(updates))
          ._build();

  _$CaptainApplicationDtoOutputApplicationInterview._({
    required this.at,
    required this.place,
    required this.latitude,
    required this.longitude,
  }) : super._();
  @override
  CaptainApplicationDtoOutputApplicationInterview rebuild(
    void Function(CaptainApplicationDtoOutputApplicationInterviewBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainApplicationDtoOutputApplicationInterviewBuilder toBuilder() =>
      CaptainApplicationDtoOutputApplicationInterviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainApplicationDtoOutputApplicationInterview &&
        at == other.at &&
        place == other.place &&
        latitude == other.latitude &&
        longitude == other.longitude;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, place.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainApplicationDtoOutputApplicationInterview',
          )
          ..add('at', at)
          ..add('place', place)
          ..add('latitude', latitude)
          ..add('longitude', longitude))
        .toString();
  }
}

class CaptainApplicationDtoOutputApplicationInterviewBuilder
    implements
        Builder<
          CaptainApplicationDtoOutputApplicationInterview,
          CaptainApplicationDtoOutputApplicationInterviewBuilder
        > {
  _$CaptainApplicationDtoOutputApplicationInterview? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  String? _place;
  String? get place => _$this._place;
  set place(String? place) => _$this._place = place;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  CaptainApplicationDtoOutputApplicationInterviewBuilder() {
    CaptainApplicationDtoOutputApplicationInterview._defaults(this);
  }

  CaptainApplicationDtoOutputApplicationInterviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _place = $v.place;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainApplicationDtoOutputApplicationInterview other) {
    _$v = other as _$CaptainApplicationDtoOutputApplicationInterview;
  }

  @override
  void update(
    void Function(CaptainApplicationDtoOutputApplicationInterviewBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainApplicationDtoOutputApplicationInterview build() => _build();

  _$CaptainApplicationDtoOutputApplicationInterview _build() {
    final _$result =
        _$v ??
        _$CaptainApplicationDtoOutputApplicationInterview._(
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'CaptainApplicationDtoOutputApplicationInterview',
            'at',
          ),
          place: BuiltValueNullFieldError.checkNotNull(
            place,
            r'CaptainApplicationDtoOutputApplicationInterview',
            'place',
          ),
          latitude: BuiltValueNullFieldError.checkNotNull(
            latitude,
            r'CaptainApplicationDtoOutputApplicationInterview',
            'latitude',
          ),
          longitude: BuiltValueNullFieldError.checkNotNull(
            longitude,
            r'CaptainApplicationDtoOutputApplicationInterview',
            'longitude',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
