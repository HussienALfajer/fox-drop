// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_rate_order_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerRateOrderDto extends CustomerRateOrderDto {
  @override
  final CustomerRateOrderDtoRestaurant? restaurant;
  @override
  final CustomerRateOrderDtoCaptain? captain;

  factory _$CustomerRateOrderDto([
    void Function(CustomerRateOrderDtoBuilder)? updates,
  ]) => (CustomerRateOrderDtoBuilder()..update(updates))._build();

  _$CustomerRateOrderDto._({this.restaurant, this.captain}) : super._();
  @override
  CustomerRateOrderDto rebuild(
    void Function(CustomerRateOrderDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerRateOrderDtoBuilder toBuilder() =>
      CustomerRateOrderDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerRateOrderDto &&
        restaurant == other.restaurant &&
        captain == other.captain;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, restaurant.hashCode);
    _$hash = $jc(_$hash, captain.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerRateOrderDto')
          ..add('restaurant', restaurant)
          ..add('captain', captain))
        .toString();
  }
}

class CustomerRateOrderDtoBuilder
    implements Builder<CustomerRateOrderDto, CustomerRateOrderDtoBuilder> {
  _$CustomerRateOrderDto? _$v;

  CustomerRateOrderDtoRestaurantBuilder? _restaurant;
  CustomerRateOrderDtoRestaurantBuilder get restaurant =>
      _$this._restaurant ??= CustomerRateOrderDtoRestaurantBuilder();
  set restaurant(CustomerRateOrderDtoRestaurantBuilder? restaurant) =>
      _$this._restaurant = restaurant;

  CustomerRateOrderDtoCaptainBuilder? _captain;
  CustomerRateOrderDtoCaptainBuilder get captain =>
      _$this._captain ??= CustomerRateOrderDtoCaptainBuilder();
  set captain(CustomerRateOrderDtoCaptainBuilder? captain) =>
      _$this._captain = captain;

  CustomerRateOrderDtoBuilder() {
    CustomerRateOrderDto._defaults(this);
  }

  CustomerRateOrderDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _restaurant = $v.restaurant?.toBuilder();
      _captain = $v.captain?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerRateOrderDto other) {
    _$v = other as _$CustomerRateOrderDto;
  }

  @override
  void update(void Function(CustomerRateOrderDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerRateOrderDto build() => _build();

  _$CustomerRateOrderDto _build() {
    _$CustomerRateOrderDto _$result;
    try {
      _$result =
          _$v ??
          _$CustomerRateOrderDto._(
            restaurant: _restaurant?.build(),
            captain: _captain?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'restaurant';
        _restaurant?.build();
        _$failedField = 'captain';
        _captain?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerRateOrderDto',
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
