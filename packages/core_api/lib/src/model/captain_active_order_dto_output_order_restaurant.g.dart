// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output_order_restaurant.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainActiveOrderDtoOutputOrderRestaurant
    extends CaptainActiveOrderDtoOutputOrderRestaurant {
  @override
  final String name;
  @override
  final String? address;
  @override
  final CaptainActiveOrderDtoOutputOrderRestaurantLocation location;

  factory _$CaptainActiveOrderDtoOutputOrderRestaurant([
    void Function(CaptainActiveOrderDtoOutputOrderRestaurantBuilder)? updates,
  ]) => (CaptainActiveOrderDtoOutputOrderRestaurantBuilder()..update(updates))
      ._build();

  _$CaptainActiveOrderDtoOutputOrderRestaurant._({
    required this.name,
    this.address,
    required this.location,
  }) : super._();
  @override
  CaptainActiveOrderDtoOutputOrderRestaurant rebuild(
    void Function(CaptainActiveOrderDtoOutputOrderRestaurantBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputOrderRestaurantBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputOrderRestaurantBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutputOrderRestaurant &&
        name == other.name &&
        address == other.address &&
        location == other.location;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainActiveOrderDtoOutputOrderRestaurant',
          )
          ..add('name', name)
          ..add('address', address)
          ..add('location', location))
        .toString();
  }
}

class CaptainActiveOrderDtoOutputOrderRestaurantBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutputOrderRestaurant,
          CaptainActiveOrderDtoOutputOrderRestaurantBuilder
        > {
  _$CaptainActiveOrderDtoOutputOrderRestaurant? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  CaptainActiveOrderDtoOutputOrderRestaurantLocationBuilder? _location;
  CaptainActiveOrderDtoOutputOrderRestaurantLocationBuilder get location =>
      _$this._location ??=
          CaptainActiveOrderDtoOutputOrderRestaurantLocationBuilder();
  set location(
    CaptainActiveOrderDtoOutputOrderRestaurantLocationBuilder? location,
  ) => _$this._location = location;

  CaptainActiveOrderDtoOutputOrderRestaurantBuilder() {
    CaptainActiveOrderDtoOutputOrderRestaurant._defaults(this);
  }

  CaptainActiveOrderDtoOutputOrderRestaurantBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _address = $v.address;
      _location = $v.location.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainActiveOrderDtoOutputOrderRestaurant other) {
    _$v = other as _$CaptainActiveOrderDtoOutputOrderRestaurant;
  }

  @override
  void update(
    void Function(CaptainActiveOrderDtoOutputOrderRestaurantBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutputOrderRestaurant build() => _build();

  _$CaptainActiveOrderDtoOutputOrderRestaurant _build() {
    _$CaptainActiveOrderDtoOutputOrderRestaurant _$result;
    try {
      _$result =
          _$v ??
          _$CaptainActiveOrderDtoOutputOrderRestaurant._(
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'CaptainActiveOrderDtoOutputOrderRestaurant',
              'name',
            ),
            address: address,
            location: location.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'location';
        location.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainActiveOrderDtoOutputOrderRestaurant',
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
