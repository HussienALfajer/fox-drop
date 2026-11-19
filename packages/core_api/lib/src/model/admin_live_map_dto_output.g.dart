// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_live_map_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminLiveMapDtoOutput extends AdminLiveMapDtoOutput {
  @override
  final BuiltList<AdminLiveMapDtoOutputZonesInner> zones;
  @override
  final BuiltList<AdminLiveMapDtoOutputRestaurantsInner> restaurants;
  @override
  final BuiltList<AdminLiveMapDtoOutputCaptainsInner> captains;
  @override
  final BuiltList<AdminLiveMapDtoOutputOrdersInner> orders;

  factory _$AdminLiveMapDtoOutput([
    void Function(AdminLiveMapDtoOutputBuilder)? updates,
  ]) => (AdminLiveMapDtoOutputBuilder()..update(updates))._build();

  _$AdminLiveMapDtoOutput._({
    required this.zones,
    required this.restaurants,
    required this.captains,
    required this.orders,
  }) : super._();
  @override
  AdminLiveMapDtoOutput rebuild(
    void Function(AdminLiveMapDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminLiveMapDtoOutputBuilder toBuilder() =>
      AdminLiveMapDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminLiveMapDtoOutput &&
        zones == other.zones &&
        restaurants == other.restaurants &&
        captains == other.captains &&
        orders == other.orders;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, zones.hashCode);
    _$hash = $jc(_$hash, restaurants.hashCode);
    _$hash = $jc(_$hash, captains.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminLiveMapDtoOutput')
          ..add('zones', zones)
          ..add('restaurants', restaurants)
          ..add('captains', captains)
          ..add('orders', orders))
        .toString();
  }
}

class AdminLiveMapDtoOutputBuilder
    implements Builder<AdminLiveMapDtoOutput, AdminLiveMapDtoOutputBuilder> {
  _$AdminLiveMapDtoOutput? _$v;

  ListBuilder<AdminLiveMapDtoOutputZonesInner>? _zones;
  ListBuilder<AdminLiveMapDtoOutputZonesInner> get zones =>
      _$this._zones ??= ListBuilder<AdminLiveMapDtoOutputZonesInner>();
  set zones(ListBuilder<AdminLiveMapDtoOutputZonesInner>? zones) =>
      _$this._zones = zones;

  ListBuilder<AdminLiveMapDtoOutputRestaurantsInner>? _restaurants;
  ListBuilder<AdminLiveMapDtoOutputRestaurantsInner> get restaurants =>
      _$this._restaurants ??=
          ListBuilder<AdminLiveMapDtoOutputRestaurantsInner>();
  set restaurants(
    ListBuilder<AdminLiveMapDtoOutputRestaurantsInner>? restaurants,
  ) => _$this._restaurants = restaurants;

  ListBuilder<AdminLiveMapDtoOutputCaptainsInner>? _captains;
  ListBuilder<AdminLiveMapDtoOutputCaptainsInner> get captains =>
      _$this._captains ??= ListBuilder<AdminLiveMapDtoOutputCaptainsInner>();
  set captains(ListBuilder<AdminLiveMapDtoOutputCaptainsInner>? captains) =>
      _$this._captains = captains;

  ListBuilder<AdminLiveMapDtoOutputOrdersInner>? _orders;
  ListBuilder<AdminLiveMapDtoOutputOrdersInner> get orders =>
      _$this._orders ??= ListBuilder<AdminLiveMapDtoOutputOrdersInner>();
  set orders(ListBuilder<AdminLiveMapDtoOutputOrdersInner>? orders) =>
      _$this._orders = orders;

  AdminLiveMapDtoOutputBuilder() {
    AdminLiveMapDtoOutput._defaults(this);
  }

  AdminLiveMapDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _zones = $v.zones.toBuilder();
      _restaurants = $v.restaurants.toBuilder();
      _captains = $v.captains.toBuilder();
      _orders = $v.orders.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminLiveMapDtoOutput other) {
    _$v = other as _$AdminLiveMapDtoOutput;
  }

  @override
  void update(void Function(AdminLiveMapDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminLiveMapDtoOutput build() => _build();

  _$AdminLiveMapDtoOutput _build() {
    _$AdminLiveMapDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminLiveMapDtoOutput._(
            zones: zones.build(),
            restaurants: restaurants.build(),
            captains: captains.build(),
            orders: orders.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'zones';
        zones.build();
        _$failedField = 'restaurants';
        restaurants.build();
        _$failedField = 'captains';
        captains.build();
        _$failedField = 'orders';
        orders.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminLiveMapDtoOutput',
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
