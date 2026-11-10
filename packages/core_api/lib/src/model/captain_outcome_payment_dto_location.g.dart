// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_outcome_payment_dto_location.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainOutcomePaymentDtoLocation
    extends CaptainOutcomePaymentDtoLocation {
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

  factory _$CaptainOutcomePaymentDtoLocation([
    void Function(CaptainOutcomePaymentDtoLocationBuilder)? updates,
  ]) => (CaptainOutcomePaymentDtoLocationBuilder()..update(updates))._build();

  _$CaptainOutcomePaymentDtoLocation._({
    required this.latitude,
    required this.longitude,
    required this.accuracyMetres,
    required this.recordedAt,
    required this.simulated,
  }) : super._();
  @override
  CaptainOutcomePaymentDtoLocation rebuild(
    void Function(CaptainOutcomePaymentDtoLocationBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainOutcomePaymentDtoLocationBuilder toBuilder() =>
      CaptainOutcomePaymentDtoLocationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainOutcomePaymentDtoLocation &&
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
    return (newBuiltValueToStringHelper(r'CaptainOutcomePaymentDtoLocation')
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('accuracyMetres', accuracyMetres)
          ..add('recordedAt', recordedAt)
          ..add('simulated', simulated))
        .toString();
  }
}

class CaptainOutcomePaymentDtoLocationBuilder
    implements
        Builder<
          CaptainOutcomePaymentDtoLocation,
          CaptainOutcomePaymentDtoLocationBuilder
        > {
  _$CaptainOutcomePaymentDtoLocation? _$v;

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

  CaptainOutcomePaymentDtoLocationBuilder() {
    CaptainOutcomePaymentDtoLocation._defaults(this);
  }

  CaptainOutcomePaymentDtoLocationBuilder get _$this {
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
  void replace(CaptainOutcomePaymentDtoLocation other) {
    _$v = other as _$CaptainOutcomePaymentDtoLocation;
  }

  @override
  void update(void Function(CaptainOutcomePaymentDtoLocationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainOutcomePaymentDtoLocation build() => _build();

  _$CaptainOutcomePaymentDtoLocation _build() {
    final _$result =
        _$v ??
        _$CaptainOutcomePaymentDtoLocation._(
          latitude: BuiltValueNullFieldError.checkNotNull(
            latitude,
            r'CaptainOutcomePaymentDtoLocation',
            'latitude',
          ),
          longitude: BuiltValueNullFieldError.checkNotNull(
            longitude,
            r'CaptainOutcomePaymentDtoLocation',
            'longitude',
          ),
          accuracyMetres: BuiltValueNullFieldError.checkNotNull(
            accuracyMetres,
            r'CaptainOutcomePaymentDtoLocation',
            'accuracyMetres',
          ),
          recordedAt: BuiltValueNullFieldError.checkNotNull(
            recordedAt,
            r'CaptainOutcomePaymentDtoLocation',
            'recordedAt',
          ),
          simulated: BuiltValueNullFieldError.checkNotNull(
            simulated,
            r'CaptainOutcomePaymentDtoLocation',
            'simulated',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
