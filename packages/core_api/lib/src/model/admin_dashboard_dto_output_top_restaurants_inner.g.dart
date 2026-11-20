// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_dto_output_top_restaurants_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDashboardDtoOutputTopRestaurantsInner
    extends AdminDashboardDtoOutputTopRestaurantsInner {
  @override
  final String restaurantId;
  @override
  final String name;
  @override
  final int orders;

  factory _$AdminDashboardDtoOutputTopRestaurantsInner([
    void Function(AdminDashboardDtoOutputTopRestaurantsInnerBuilder)? updates,
  ]) => (AdminDashboardDtoOutputTopRestaurantsInnerBuilder()..update(updates))
      ._build();

  _$AdminDashboardDtoOutputTopRestaurantsInner._({
    required this.restaurantId,
    required this.name,
    required this.orders,
  }) : super._();
  @override
  AdminDashboardDtoOutputTopRestaurantsInner rebuild(
    void Function(AdminDashboardDtoOutputTopRestaurantsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDashboardDtoOutputTopRestaurantsInnerBuilder toBuilder() =>
      AdminDashboardDtoOutputTopRestaurantsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardDtoOutputTopRestaurantsInner &&
        restaurantId == other.restaurantId &&
        name == other.name &&
        orders == other.orders;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, restaurantId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminDashboardDtoOutputTopRestaurantsInner',
          )
          ..add('restaurantId', restaurantId)
          ..add('name', name)
          ..add('orders', orders))
        .toString();
  }
}

class AdminDashboardDtoOutputTopRestaurantsInnerBuilder
    implements
        Builder<
          AdminDashboardDtoOutputTopRestaurantsInner,
          AdminDashboardDtoOutputTopRestaurantsInnerBuilder
        > {
  _$AdminDashboardDtoOutputTopRestaurantsInner? _$v;

  String? _restaurantId;
  String? get restaurantId => _$this._restaurantId;
  set restaurantId(String? restaurantId) => _$this._restaurantId = restaurantId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _orders;
  int? get orders => _$this._orders;
  set orders(int? orders) => _$this._orders = orders;

  AdminDashboardDtoOutputTopRestaurantsInnerBuilder() {
    AdminDashboardDtoOutputTopRestaurantsInner._defaults(this);
  }

  AdminDashboardDtoOutputTopRestaurantsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _restaurantId = $v.restaurantId;
      _name = $v.name;
      _orders = $v.orders;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardDtoOutputTopRestaurantsInner other) {
    _$v = other as _$AdminDashboardDtoOutputTopRestaurantsInner;
  }

  @override
  void update(
    void Function(AdminDashboardDtoOutputTopRestaurantsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardDtoOutputTopRestaurantsInner build() => _build();

  _$AdminDashboardDtoOutputTopRestaurantsInner _build() {
    final _$result =
        _$v ??
        _$AdminDashboardDtoOutputTopRestaurantsInner._(
          restaurantId: BuiltValueNullFieldError.checkNotNull(
            restaurantId,
            r'AdminDashboardDtoOutputTopRestaurantsInner',
            'restaurantId',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminDashboardDtoOutputTopRestaurantsInner',
            'name',
          ),
          orders: BuiltValueNullFieldError.checkNotNull(
            orders,
            r'AdminDashboardDtoOutputTopRestaurantsInner',
            'orders',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
