// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_application_interview_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainApplicationInterviewDto
    extends AdminCaptainApplicationInterviewDto {
  @override
  final DateTime at;
  @override
  final String place;
  @override
  final num latitude;
  @override
  final num longitude;

  factory _$AdminCaptainApplicationInterviewDto([
    void Function(AdminCaptainApplicationInterviewDtoBuilder)? updates,
  ]) =>
      (AdminCaptainApplicationInterviewDtoBuilder()..update(updates))._build();

  _$AdminCaptainApplicationInterviewDto._({
    required this.at,
    required this.place,
    required this.latitude,
    required this.longitude,
  }) : super._();
  @override
  AdminCaptainApplicationInterviewDto rebuild(
    void Function(AdminCaptainApplicationInterviewDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainApplicationInterviewDtoBuilder toBuilder() =>
      AdminCaptainApplicationInterviewDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainApplicationInterviewDto &&
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
    return (newBuiltValueToStringHelper(r'AdminCaptainApplicationInterviewDto')
          ..add('at', at)
          ..add('place', place)
          ..add('latitude', latitude)
          ..add('longitude', longitude))
        .toString();
  }
}

class AdminCaptainApplicationInterviewDtoBuilder
    implements
        Builder<
          AdminCaptainApplicationInterviewDto,
          AdminCaptainApplicationInterviewDtoBuilder
        > {
  _$AdminCaptainApplicationInterviewDto? _$v;

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

  AdminCaptainApplicationInterviewDtoBuilder() {
    AdminCaptainApplicationInterviewDto._defaults(this);
  }

  AdminCaptainApplicationInterviewDtoBuilder get _$this {
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
  void replace(AdminCaptainApplicationInterviewDto other) {
    _$v = other as _$AdminCaptainApplicationInterviewDto;
  }

  @override
  void update(
    void Function(AdminCaptainApplicationInterviewDtoBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainApplicationInterviewDto build() => _build();

  _$AdminCaptainApplicationInterviewDto _build() {
    final _$result =
        _$v ??
        _$AdminCaptainApplicationInterviewDto._(
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'AdminCaptainApplicationInterviewDto',
            'at',
          ),
          place: BuiltValueNullFieldError.checkNotNull(
            place,
            r'AdminCaptainApplicationInterviewDto',
            'place',
          ),
          latitude: BuiltValueNullFieldError.checkNotNull(
            latitude,
            r'AdminCaptainApplicationInterviewDto',
            'latitude',
          ),
          longitude: BuiltValueNullFieldError.checkNotNull(
            longitude,
            r'AdminCaptainApplicationInterviewDto',
            'longitude',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
