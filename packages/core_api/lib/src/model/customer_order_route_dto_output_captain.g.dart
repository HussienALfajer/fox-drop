// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_order_route_dto_output_captain.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerOrderRouteDtoOutputCaptain
    extends CustomerOrderRouteDtoOutputCaptain {
  @override
  final num latitude;
  @override
  final num longitude;
  @override
  final DateTime recordedAt;

  factory _$CustomerOrderRouteDtoOutputCaptain([
    void Function(CustomerOrderRouteDtoOutputCaptainBuilder)? updates,
  ]) => (CustomerOrderRouteDtoOutputCaptainBuilder()..update(updates))._build();

  _$CustomerOrderRouteDtoOutputCaptain._({
    required this.latitude,
    required this.longitude,
    required this.recordedAt,
  }) : super._();
  @override
  CustomerOrderRouteDtoOutputCaptain rebuild(
    void Function(CustomerOrderRouteDtoOutputCaptainBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerOrderRouteDtoOutputCaptainBuilder toBuilder() =>
      CustomerOrderRouteDtoOutputCaptainBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerOrderRouteDtoOutputCaptain &&
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
    return (newBuiltValueToStringHelper(r'CustomerOrderRouteDtoOutputCaptain')
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('recordedAt', recordedAt))
        .toString();
  }
}

class CustomerOrderRouteDtoOutputCaptainBuilder
    implements
        Builder<
          CustomerOrderRouteDtoOutputCaptain,
          CustomerOrderRouteDtoOutputCaptainBuilder
        > {
  _$CustomerOrderRouteDtoOutputCaptain? _$v;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  DateTime? _recordedAt;
  DateTime? get recordedAt => _$this._recordedAt;
  set recordedAt(DateTime? recordedAt) => _$this._recordedAt = recordedAt;

  CustomerOrderRouteDtoOutputCaptainBuilder() {
    CustomerOrderRouteDtoOutputCaptain._defaults(this);
  }

  CustomerOrderRouteDtoOutputCaptainBuilder get _$this {
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
  void replace(CustomerOrderRouteDtoOutputCaptain other) {
    _$v = other as _$CustomerOrderRouteDtoOutputCaptain;
  }

  @override
  void update(
    void Function(CustomerOrderRouteDtoOutputCaptainBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerOrderRouteDtoOutputCaptain build() => _build();

  _$CustomerOrderRouteDtoOutputCaptain _build() {
    final _$result =
        _$v ??
        _$CustomerOrderRouteDtoOutputCaptain._(
          latitude: BuiltValueNullFieldError.checkNotNull(
            latitude,
            r'CustomerOrderRouteDtoOutputCaptain',
            'latitude',
          ),
          longitude: BuiltValueNullFieldError.checkNotNull(
            longitude,
            r'CustomerOrderRouteDtoOutputCaptain',
            'longitude',
          ),
          recordedAt: BuiltValueNullFieldError.checkNotNull(
            recordedAt,
            r'CustomerOrderRouteDtoOutputCaptain',
            'recordedAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
