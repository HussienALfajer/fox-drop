// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_current_offer_dto_output_offer_handover_location.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainCurrentOfferDtoOutputOfferHandoverLocation
    extends CaptainCurrentOfferDtoOutputOfferHandoverLocation {
  @override
  final num latitude;
  @override
  final num longitude;
  @override
  final DateTime recordedAt;

  factory _$CaptainCurrentOfferDtoOutputOfferHandoverLocation([
    void Function(CaptainCurrentOfferDtoOutputOfferHandoverLocationBuilder)?
    updates,
  ]) =>
      (CaptainCurrentOfferDtoOutputOfferHandoverLocationBuilder()
            ..update(updates))
          ._build();

  _$CaptainCurrentOfferDtoOutputOfferHandoverLocation._({
    required this.latitude,
    required this.longitude,
    required this.recordedAt,
  }) : super._();
  @override
  CaptainCurrentOfferDtoOutputOfferHandoverLocation rebuild(
    void Function(CaptainCurrentOfferDtoOutputOfferHandoverLocationBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainCurrentOfferDtoOutputOfferHandoverLocationBuilder toBuilder() =>
      CaptainCurrentOfferDtoOutputOfferHandoverLocationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainCurrentOfferDtoOutputOfferHandoverLocation &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        recordedAt == other.recordedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, recordedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainCurrentOfferDtoOutputOfferHandoverLocation',
          )
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('recordedAt', recordedAt))
        .toString();
  }
}

class CaptainCurrentOfferDtoOutputOfferHandoverLocationBuilder
    implements
        Builder<
          CaptainCurrentOfferDtoOutputOfferHandoverLocation,
          CaptainCurrentOfferDtoOutputOfferHandoverLocationBuilder
        > {
  _$CaptainCurrentOfferDtoOutputOfferHandoverLocation? _$v;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  DateTime? _recordedAt;
  DateTime? get recordedAt => _$this._recordedAt;
  set recordedAt(DateTime? recordedAt) => _$this._recordedAt = recordedAt;

  CaptainCurrentOfferDtoOutputOfferHandoverLocationBuilder() {
    CaptainCurrentOfferDtoOutputOfferHandoverLocation._defaults(this);
  }

  CaptainCurrentOfferDtoOutputOfferHandoverLocationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _recordedAt = $v.recordedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainCurrentOfferDtoOutputOfferHandoverLocation other) {
    _$v = other as _$CaptainCurrentOfferDtoOutputOfferHandoverLocation;
  }

  @override
  void update(
    void Function(CaptainCurrentOfferDtoOutputOfferHandoverLocationBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainCurrentOfferDtoOutputOfferHandoverLocation build() => _build();

  _$CaptainCurrentOfferDtoOutputOfferHandoverLocation _build() {
    final _$result =
        _$v ??
        _$CaptainCurrentOfferDtoOutputOfferHandoverLocation._(
          latitude: BuiltValueNullFieldError.checkNotNull(
            latitude,
            r'CaptainCurrentOfferDtoOutputOfferHandoverLocation',
            'latitude',
          ),
          longitude: BuiltValueNullFieldError.checkNotNull(
            longitude,
            r'CaptainCurrentOfferDtoOutputOfferHandoverLocation',
            'longitude',
          ),
          recordedAt: BuiltValueNullFieldError.checkNotNull(
            recordedAt,
            r'CaptainCurrentOfferDtoOutputOfferHandoverLocation',
            'recordedAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
