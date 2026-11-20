// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_dto_output_today.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDashboardDtoOutputToday extends AdminDashboardDtoOutputToday {
  @override
  final DateTime from;
  @override
  final DateTime until;
  @override
  final AdminDashboardDtoOutputTodayOrders orders;
  @override
  final AdminDashboardDtoOutputTodayMoney? money;
  @override
  final int newCustomers;

  factory _$AdminDashboardDtoOutputToday([
    void Function(AdminDashboardDtoOutputTodayBuilder)? updates,
  ]) => (AdminDashboardDtoOutputTodayBuilder()..update(updates))._build();

  _$AdminDashboardDtoOutputToday._({
    required this.from,
    required this.until,
    required this.orders,
    this.money,
    required this.newCustomers,
  }) : super._();
  @override
  AdminDashboardDtoOutputToday rebuild(
    void Function(AdminDashboardDtoOutputTodayBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDashboardDtoOutputTodayBuilder toBuilder() =>
      AdminDashboardDtoOutputTodayBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardDtoOutputToday &&
        from == other.from &&
        until == other.until &&
        orders == other.orders &&
        money == other.money &&
        newCustomers == other.newCustomers;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, until.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, money.hashCode);
    _$hash = $jc(_$hash, newCustomers.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDashboardDtoOutputToday')
          ..add('from', from)
          ..add('until', until)
          ..add('orders', orders)
          ..add('money', money)
          ..add('newCustomers', newCustomers))
        .toString();
  }
}

class AdminDashboardDtoOutputTodayBuilder
    implements
        Builder<
          AdminDashboardDtoOutputToday,
          AdminDashboardDtoOutputTodayBuilder
        > {
  _$AdminDashboardDtoOutputToday? _$v;

  DateTime? _from;
  DateTime? get from => _$this._from;
  set from(DateTime? from) => _$this._from = from;

  DateTime? _until;
  DateTime? get until => _$this._until;
  set until(DateTime? until) => _$this._until = until;

  AdminDashboardDtoOutputTodayOrdersBuilder? _orders;
  AdminDashboardDtoOutputTodayOrdersBuilder get orders =>
      _$this._orders ??= AdminDashboardDtoOutputTodayOrdersBuilder();
  set orders(AdminDashboardDtoOutputTodayOrdersBuilder? orders) =>
      _$this._orders = orders;

  AdminDashboardDtoOutputTodayMoneyBuilder? _money;
  AdminDashboardDtoOutputTodayMoneyBuilder get money =>
      _$this._money ??= AdminDashboardDtoOutputTodayMoneyBuilder();
  set money(AdminDashboardDtoOutputTodayMoneyBuilder? money) =>
      _$this._money = money;

  int? _newCustomers;
  int? get newCustomers => _$this._newCustomers;
  set newCustomers(int? newCustomers) => _$this._newCustomers = newCustomers;

  AdminDashboardDtoOutputTodayBuilder() {
    AdminDashboardDtoOutputToday._defaults(this);
  }

  AdminDashboardDtoOutputTodayBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _from = $v.from;
      _until = $v.until;
      _orders = $v.orders.toBuilder();
      _money = $v.money?.toBuilder();
      _newCustomers = $v.newCustomers;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardDtoOutputToday other) {
    _$v = other as _$AdminDashboardDtoOutputToday;
  }

  @override
  void update(void Function(AdminDashboardDtoOutputTodayBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardDtoOutputToday build() => _build();

  _$AdminDashboardDtoOutputToday _build() {
    _$AdminDashboardDtoOutputToday _$result;
    try {
      _$result =
          _$v ??
          _$AdminDashboardDtoOutputToday._(
            from: BuiltValueNullFieldError.checkNotNull(
              from,
              r'AdminDashboardDtoOutputToday',
              'from',
            ),
            until: BuiltValueNullFieldError.checkNotNull(
              until,
              r'AdminDashboardDtoOutputToday',
              'until',
            ),
            orders: orders.build(),
            money: _money?.build(),
            newCustomers: BuiltValueNullFieldError.checkNotNull(
              newCustomers,
              r'AdminDashboardDtoOutputToday',
              'newCustomers',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'orders';
        orders.build();
        _$failedField = 'money';
        _money?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminDashboardDtoOutputToday',
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
