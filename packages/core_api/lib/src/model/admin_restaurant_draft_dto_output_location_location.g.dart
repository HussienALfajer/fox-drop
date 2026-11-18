// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_draft_dto_output_location_location.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantDraftDtoOutputLocationLocation
    extends AdminRestaurantDraftDtoOutputLocationLocation {
  @override
  final num latitude;
  @override
  final num longitude;

  factory _$AdminRestaurantDraftDtoOutputLocationLocation([
    void Function(AdminRestaurantDraftDtoOutputLocationLocationBuilder)?
    updates,
  ]) =>
      (AdminRestaurantDraftDtoOutputLocationLocationBuilder()..update(updates))
          ._build();

  _$AdminRestaurantDraftDtoOutputLocationLocation._({
    required this.latitude,
    required this.longitude,
  }) : super._();
  @override
  AdminRestaurantDraftDtoOutputLocationLocation rebuild(
    void Function(AdminRestaurantDraftDtoOutputLocationLocationBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantDraftDtoOutputLocationLocationBuilder toBuilder() =>
      AdminRestaurantDraftDtoOutputLocationLocationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantDraftDtoOutputLocationLocation &&
        latitude == other.latitude &&
        longitude == other.longitude;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantDraftDtoOutputLocationLocation',
          )
          ..add('latitude', latitude)
          ..add('longitude', longitude))
        .toString();
  }
}

class AdminRestaurantDraftDtoOutputLocationLocationBuilder
    implements
        Builder<
          AdminRestaurantDraftDtoOutputLocationLocation,
          AdminRestaurantDraftDtoOutputLocationLocationBuilder
        > {
  _$AdminRestaurantDraftDtoOutputLocationLocation? _$v;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  AdminRestaurantDraftDtoOutputLocationLocationBuilder() {
    AdminRestaurantDraftDtoOutputLocationLocation._defaults(this);
  }

  AdminRestaurantDraftDtoOutputLocationLocationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantDraftDtoOutputLocationLocation other) {
    _$v = other as _$AdminRestaurantDraftDtoOutputLocationLocation;
  }

  @override
  void update(
    void Function(AdminRestaurantDraftDtoOutputLocationLocationBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantDraftDtoOutputLocationLocation build() => _build();

  _$AdminRestaurantDraftDtoOutputLocationLocation _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantDraftDtoOutputLocationLocation._(
          latitude: BuiltValueNullFieldError.checkNotNull(
            latitude,
            r'AdminRestaurantDraftDtoOutputLocationLocation',
            'latitude',
          ),
          longitude: BuiltValueNullFieldError.checkNotNull(
            longitude,
            r'AdminRestaurantDraftDtoOutputLocationLocation',
            'longitude',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
