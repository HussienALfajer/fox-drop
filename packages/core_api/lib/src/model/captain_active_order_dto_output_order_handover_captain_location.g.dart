// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output_order_handover_captain_location.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation
    extends CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation {
  @override
  final num latitude;
  @override
  final num longitude;
  @override
  final DateTime recordedAt;

  factory _$CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation([
    void Function(
      CaptainActiveOrderDtoOutputOrderHandoverCaptainLocationBuilder,
    )?
    updates,
  ]) =>
      (CaptainActiveOrderDtoOutputOrderHandoverCaptainLocationBuilder()
            ..update(updates))
          ._build();

  _$CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation._({
    required this.latitude,
    required this.longitude,
    required this.recordedAt,
  }) : super._();
  @override
  CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation rebuild(
    void Function(
      CaptainActiveOrderDtoOutputOrderHandoverCaptainLocationBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputOrderHandoverCaptainLocationBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputOrderHandoverCaptainLocationBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation &&
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
            r'CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation',
          )
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('recordedAt', recordedAt))
        .toString();
  }
}

class CaptainActiveOrderDtoOutputOrderHandoverCaptainLocationBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation,
          CaptainActiveOrderDtoOutputOrderHandoverCaptainLocationBuilder
        > {
  _$CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation? _$v;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  DateTime? _recordedAt;
  DateTime? get recordedAt => _$this._recordedAt;
  set recordedAt(DateTime? recordedAt) => _$this._recordedAt = recordedAt;

  CaptainActiveOrderDtoOutputOrderHandoverCaptainLocationBuilder() {
    CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation._defaults(this);
  }

  CaptainActiveOrderDtoOutputOrderHandoverCaptainLocationBuilder get _$this {
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
  void replace(CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation other) {
    _$v = other as _$CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation;
  }

  @override
  void update(
    void Function(
      CaptainActiveOrderDtoOutputOrderHandoverCaptainLocationBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation build() => _build();

  _$CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation _build() {
    final _$result =
        _$v ??
        _$CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation._(
          latitude: BuiltValueNullFieldError.checkNotNull(
            latitude,
            r'CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation',
            'latitude',
          ),
          longitude: BuiltValueNullFieldError.checkNotNull(
            longitude,
            r'CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation',
            'longitude',
          ),
          recordedAt: BuiltValueNullFieldError.checkNotNull(
            recordedAt,
            r'CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation',
            'recordedAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
