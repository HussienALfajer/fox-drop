// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_current_offer_dto_output_offer_restaurant.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainCurrentOfferDtoOutputOfferRestaurant
    extends CaptainCurrentOfferDtoOutputOfferRestaurant {
  @override
  final String name;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerAddressLocation location;
  @override
  final int distanceMetres;

  factory _$CaptainCurrentOfferDtoOutputOfferRestaurant([
    void Function(CaptainCurrentOfferDtoOutputOfferRestaurantBuilder)? updates,
  ]) => (CaptainCurrentOfferDtoOutputOfferRestaurantBuilder()..update(updates))
      ._build();

  _$CaptainCurrentOfferDtoOutputOfferRestaurant._({
    required this.name,
    required this.location,
    required this.distanceMetres,
  }) : super._();
  @override
  CaptainCurrentOfferDtoOutputOfferRestaurant rebuild(
    void Function(CaptainCurrentOfferDtoOutputOfferRestaurantBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainCurrentOfferDtoOutputOfferRestaurantBuilder toBuilder() =>
      CaptainCurrentOfferDtoOutputOfferRestaurantBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainCurrentOfferDtoOutputOfferRestaurant &&
        name == other.name &&
        location == other.location &&
        distanceMetres == other.distanceMetres;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, distanceMetres.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainCurrentOfferDtoOutputOfferRestaurant',
          )
          ..add('name', name)
          ..add('location', location)
          ..add('distanceMetres', distanceMetres))
        .toString();
  }
}

class CaptainCurrentOfferDtoOutputOfferRestaurantBuilder
    implements
        Builder<
          CaptainCurrentOfferDtoOutputOfferRestaurant,
          CaptainCurrentOfferDtoOutputOfferRestaurantBuilder
        > {
  _$CaptainCurrentOfferDtoOutputOfferRestaurant? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  CustomerActiveOrdersDtoOutputOrdersInnerAddressLocationBuilder? _location;
  CustomerActiveOrdersDtoOutputOrdersInnerAddressLocationBuilder get location =>
      _$this._location ??=
          CustomerActiveOrdersDtoOutputOrdersInnerAddressLocationBuilder();
  set location(
    CustomerActiveOrdersDtoOutputOrdersInnerAddressLocationBuilder? location,
  ) => _$this._location = location;

  int? _distanceMetres;
  int? get distanceMetres => _$this._distanceMetres;
  set distanceMetres(int? distanceMetres) =>
      _$this._distanceMetres = distanceMetres;

  CaptainCurrentOfferDtoOutputOfferRestaurantBuilder() {
    CaptainCurrentOfferDtoOutputOfferRestaurant._defaults(this);
  }

  CaptainCurrentOfferDtoOutputOfferRestaurantBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _location = $v.location.toBuilder();
      _distanceMetres = $v.distanceMetres;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainCurrentOfferDtoOutputOfferRestaurant other) {
    _$v = other as _$CaptainCurrentOfferDtoOutputOfferRestaurant;
  }

  @override
  void update(
    void Function(CaptainCurrentOfferDtoOutputOfferRestaurantBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainCurrentOfferDtoOutputOfferRestaurant build() => _build();

  _$CaptainCurrentOfferDtoOutputOfferRestaurant _build() {
    _$CaptainCurrentOfferDtoOutputOfferRestaurant _$result;
    try {
      _$result =
          _$v ??
          _$CaptainCurrentOfferDtoOutputOfferRestaurant._(
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'CaptainCurrentOfferDtoOutputOfferRestaurant',
              'name',
            ),
            location: location.build(),
            distanceMetres: BuiltValueNullFieldError.checkNotNull(
              distanceMetres,
              r'CaptainCurrentOfferDtoOutputOfferRestaurant',
              'distanceMetres',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'location';
        location.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainCurrentOfferDtoOutputOfferRestaurant',
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
