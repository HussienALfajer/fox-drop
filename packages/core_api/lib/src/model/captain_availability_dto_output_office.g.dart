// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_availability_dto_output_office.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainAvailabilityDtoOutputOffice
    extends CaptainAvailabilityDtoOutputOffice {
  @override
  final num latitude;
  @override
  final num longitude;
  @override
  final BuiltList<CaptainAvailabilityDtoOutputOfficeHoursInner> hours;
  @override
  final String timeZone;
  @override
  final bool open;
  @override
  final DateTime? closesAt;
  @override
  final DateTime? opensAt;

  factory _$CaptainAvailabilityDtoOutputOffice([
    void Function(CaptainAvailabilityDtoOutputOfficeBuilder)? updates,
  ]) => (CaptainAvailabilityDtoOutputOfficeBuilder()..update(updates))._build();

  _$CaptainAvailabilityDtoOutputOffice._({
    required this.latitude,
    required this.longitude,
    required this.hours,
    required this.timeZone,
    required this.open,
    this.closesAt,
    this.opensAt,
  }) : super._();
  @override
  CaptainAvailabilityDtoOutputOffice rebuild(
    void Function(CaptainAvailabilityDtoOutputOfficeBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainAvailabilityDtoOutputOfficeBuilder toBuilder() =>
      CaptainAvailabilityDtoOutputOfficeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainAvailabilityDtoOutputOffice &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        hours == other.hours &&
        timeZone == other.timeZone &&
        open == other.open &&
        closesAt == other.closesAt &&
        opensAt == other.opensAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, hours.hashCode);
    _$hash = $jc(_$hash, timeZone.hashCode);
    _$hash = $jc(_$hash, open.hashCode);
    _$hash = $jc(_$hash, closesAt.hashCode);
    _$hash = $jc(_$hash, opensAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainAvailabilityDtoOutputOffice')
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('hours', hours)
          ..add('timeZone', timeZone)
          ..add('open', open)
          ..add('closesAt', closesAt)
          ..add('opensAt', opensAt))
        .toString();
  }
}

class CaptainAvailabilityDtoOutputOfficeBuilder
    implements
        Builder<
          CaptainAvailabilityDtoOutputOffice,
          CaptainAvailabilityDtoOutputOfficeBuilder
        > {
  _$CaptainAvailabilityDtoOutputOffice? _$v;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  ListBuilder<CaptainAvailabilityDtoOutputOfficeHoursInner>? _hours;
  ListBuilder<CaptainAvailabilityDtoOutputOfficeHoursInner> get hours =>
      _$this._hours ??=
          ListBuilder<CaptainAvailabilityDtoOutputOfficeHoursInner>();
  set hours(ListBuilder<CaptainAvailabilityDtoOutputOfficeHoursInner>? hours) =>
      _$this._hours = hours;

  String? _timeZone;
  String? get timeZone => _$this._timeZone;
  set timeZone(String? timeZone) => _$this._timeZone = timeZone;

  bool? _open;
  bool? get open => _$this._open;
  set open(bool? open) => _$this._open = open;

  DateTime? _closesAt;
  DateTime? get closesAt => _$this._closesAt;
  set closesAt(DateTime? closesAt) => _$this._closesAt = closesAt;

  DateTime? _opensAt;
  DateTime? get opensAt => _$this._opensAt;
  set opensAt(DateTime? opensAt) => _$this._opensAt = opensAt;

  CaptainAvailabilityDtoOutputOfficeBuilder() {
    CaptainAvailabilityDtoOutputOffice._defaults(this);
  }

  CaptainAvailabilityDtoOutputOfficeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _hours = $v.hours.toBuilder();
      _timeZone = $v.timeZone;
      _open = $v.open;
      _closesAt = $v.closesAt;
      _opensAt = $v.opensAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainAvailabilityDtoOutputOffice other) {
    _$v = other as _$CaptainAvailabilityDtoOutputOffice;
  }

  @override
  void update(
    void Function(CaptainAvailabilityDtoOutputOfficeBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainAvailabilityDtoOutputOffice build() => _build();

  _$CaptainAvailabilityDtoOutputOffice _build() {
    _$CaptainAvailabilityDtoOutputOffice _$result;
    try {
      _$result =
          _$v ??
          _$CaptainAvailabilityDtoOutputOffice._(
            latitude: BuiltValueNullFieldError.checkNotNull(
              latitude,
              r'CaptainAvailabilityDtoOutputOffice',
              'latitude',
            ),
            longitude: BuiltValueNullFieldError.checkNotNull(
              longitude,
              r'CaptainAvailabilityDtoOutputOffice',
              'longitude',
            ),
            hours: hours.build(),
            timeZone: BuiltValueNullFieldError.checkNotNull(
              timeZone,
              r'CaptainAvailabilityDtoOutputOffice',
              'timeZone',
            ),
            open: BuiltValueNullFieldError.checkNotNull(
              open,
              r'CaptainAvailabilityDtoOutputOffice',
              'open',
            ),
            closesAt: closesAt,
            opensAt: opensAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'hours';
        hours.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainAvailabilityDtoOutputOffice',
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
