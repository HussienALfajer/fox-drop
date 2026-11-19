// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_search_results_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSearchResultsDtoOutput extends AdminSearchResultsDtoOutput {
  @override
  final BuiltList<AdminSearchResultsDtoOutputOrdersInner> orders;
  @override
  final BuiltList<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?>
  restaurants;
  @override
  final BuiltList<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?>
  captains;
  @override
  final BuiltList<AdminSearchResultsDtoOutputTicketsInner> tickets;
  @override
  final BuiltList<AdminSearchResultsDtoOutputCustomersInner> customers;

  factory _$AdminSearchResultsDtoOutput([
    void Function(AdminSearchResultsDtoOutputBuilder)? updates,
  ]) => (AdminSearchResultsDtoOutputBuilder()..update(updates))._build();

  _$AdminSearchResultsDtoOutput._({
    required this.orders,
    required this.restaurants,
    required this.captains,
    required this.tickets,
    required this.customers,
  }) : super._();
  @override
  AdminSearchResultsDtoOutput rebuild(
    void Function(AdminSearchResultsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSearchResultsDtoOutputBuilder toBuilder() =>
      AdminSearchResultsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSearchResultsDtoOutput &&
        orders == other.orders &&
        restaurants == other.restaurants &&
        captains == other.captains &&
        tickets == other.tickets &&
        customers == other.customers;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, restaurants.hashCode);
    _$hash = $jc(_$hash, captains.hashCode);
    _$hash = $jc(_$hash, tickets.hashCode);
    _$hash = $jc(_$hash, customers.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSearchResultsDtoOutput')
          ..add('orders', orders)
          ..add('restaurants', restaurants)
          ..add('captains', captains)
          ..add('tickets', tickets)
          ..add('customers', customers))
        .toString();
  }
}

class AdminSearchResultsDtoOutputBuilder
    implements
        Builder<
          AdminSearchResultsDtoOutput,
          AdminSearchResultsDtoOutputBuilder
        > {
  _$AdminSearchResultsDtoOutput? _$v;

  ListBuilder<AdminSearchResultsDtoOutputOrdersInner>? _orders;
  ListBuilder<AdminSearchResultsDtoOutputOrdersInner> get orders =>
      _$this._orders ??= ListBuilder<AdminSearchResultsDtoOutputOrdersInner>();
  set orders(ListBuilder<AdminSearchResultsDtoOutputOrdersInner>? orders) =>
      _$this._orders = orders;

  ListBuilder<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?>?
  _restaurants;
  ListBuilder<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?>
  get restaurants => _$this._restaurants ??=
      ListBuilder<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?>();
  set restaurants(
    ListBuilder<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?>?
    restaurants,
  ) => _$this._restaurants = restaurants;

  ListBuilder<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?>? _captains;
  ListBuilder<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?>
  get captains => _$this._captains ??=
      ListBuilder<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?>();
  set captains(
    ListBuilder<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?>?
    captains,
  ) => _$this._captains = captains;

  ListBuilder<AdminSearchResultsDtoOutputTicketsInner>? _tickets;
  ListBuilder<AdminSearchResultsDtoOutputTicketsInner> get tickets =>
      _$this._tickets ??=
          ListBuilder<AdminSearchResultsDtoOutputTicketsInner>();
  set tickets(ListBuilder<AdminSearchResultsDtoOutputTicketsInner>? tickets) =>
      _$this._tickets = tickets;

  ListBuilder<AdminSearchResultsDtoOutputCustomersInner>? _customers;
  ListBuilder<AdminSearchResultsDtoOutputCustomersInner> get customers =>
      _$this._customers ??=
          ListBuilder<AdminSearchResultsDtoOutputCustomersInner>();
  set customers(
    ListBuilder<AdminSearchResultsDtoOutputCustomersInner>? customers,
  ) => _$this._customers = customers;

  AdminSearchResultsDtoOutputBuilder() {
    AdminSearchResultsDtoOutput._defaults(this);
  }

  AdminSearchResultsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orders = $v.orders.toBuilder();
      _restaurants = $v.restaurants.toBuilder();
      _captains = $v.captains.toBuilder();
      _tickets = $v.tickets.toBuilder();
      _customers = $v.customers.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSearchResultsDtoOutput other) {
    _$v = other as _$AdminSearchResultsDtoOutput;
  }

  @override
  void update(void Function(AdminSearchResultsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSearchResultsDtoOutput build() => _build();

  _$AdminSearchResultsDtoOutput _build() {
    _$AdminSearchResultsDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminSearchResultsDtoOutput._(
            orders: orders.build(),
            restaurants: restaurants.build(),
            captains: captains.build(),
            tickets: tickets.build(),
            customers: customers.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'orders';
        orders.build();
        _$failedField = 'restaurants';
        restaurants.build();
        _$failedField = 'captains';
        captains.build();
        _$failedField = 'tickets';
        tickets.build();
        _$failedField = 'customers';
        customers.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminSearchResultsDtoOutput',
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
