// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_promo_code_report_dto_output_report.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPromoCodeReportDtoOutputReport
    extends AdminPromoCodeReportDtoOutputReport {
  @override
  final int orders;
  @override
  final int returned;
  @override
  final int customers;
  @override
  final int newCustomers;
  @override
  final String? cost;
  @override
  final String? merchantShare;

  factory _$AdminPromoCodeReportDtoOutputReport([
    void Function(AdminPromoCodeReportDtoOutputReportBuilder)? updates,
  ]) =>
      (AdminPromoCodeReportDtoOutputReportBuilder()..update(updates))._build();

  _$AdminPromoCodeReportDtoOutputReport._({
    required this.orders,
    required this.returned,
    required this.customers,
    required this.newCustomers,
    this.cost,
    this.merchantShare,
  }) : super._();
  @override
  AdminPromoCodeReportDtoOutputReport rebuild(
    void Function(AdminPromoCodeReportDtoOutputReportBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminPromoCodeReportDtoOutputReportBuilder toBuilder() =>
      AdminPromoCodeReportDtoOutputReportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPromoCodeReportDtoOutputReport &&
        orders == other.orders &&
        returned == other.returned &&
        customers == other.customers &&
        newCustomers == other.newCustomers &&
        cost == other.cost &&
        merchantShare == other.merchantShare;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, returned.hashCode);
    _$hash = $jc(_$hash, customers.hashCode);
    _$hash = $jc(_$hash, newCustomers.hashCode);
    _$hash = $jc(_$hash, cost.hashCode);
    _$hash = $jc(_$hash, merchantShare.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminPromoCodeReportDtoOutputReport')
          ..add('orders', orders)
          ..add('returned', returned)
          ..add('customers', customers)
          ..add('newCustomers', newCustomers)
          ..add('cost', cost)
          ..add('merchantShare', merchantShare))
        .toString();
  }
}

class AdminPromoCodeReportDtoOutputReportBuilder
    implements
        Builder<
          AdminPromoCodeReportDtoOutputReport,
          AdminPromoCodeReportDtoOutputReportBuilder
        > {
  _$AdminPromoCodeReportDtoOutputReport? _$v;

  int? _orders;
  int? get orders => _$this._orders;
  set orders(int? orders) => _$this._orders = orders;

  int? _returned;
  int? get returned => _$this._returned;
  set returned(int? returned) => _$this._returned = returned;

  int? _customers;
  int? get customers => _$this._customers;
  set customers(int? customers) => _$this._customers = customers;

  int? _newCustomers;
  int? get newCustomers => _$this._newCustomers;
  set newCustomers(int? newCustomers) => _$this._newCustomers = newCustomers;

  String? _cost;
  String? get cost => _$this._cost;
  set cost(String? cost) => _$this._cost = cost;

  String? _merchantShare;
  String? get merchantShare => _$this._merchantShare;
  set merchantShare(String? merchantShare) =>
      _$this._merchantShare = merchantShare;

  AdminPromoCodeReportDtoOutputReportBuilder() {
    AdminPromoCodeReportDtoOutputReport._defaults(this);
  }

  AdminPromoCodeReportDtoOutputReportBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orders = $v.orders;
      _returned = $v.returned;
      _customers = $v.customers;
      _newCustomers = $v.newCustomers;
      _cost = $v.cost;
      _merchantShare = $v.merchantShare;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPromoCodeReportDtoOutputReport other) {
    _$v = other as _$AdminPromoCodeReportDtoOutputReport;
  }

  @override
  void update(
    void Function(AdminPromoCodeReportDtoOutputReportBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminPromoCodeReportDtoOutputReport build() => _build();

  _$AdminPromoCodeReportDtoOutputReport _build() {
    final _$result =
        _$v ??
        _$AdminPromoCodeReportDtoOutputReport._(
          orders: BuiltValueNullFieldError.checkNotNull(
            orders,
            r'AdminPromoCodeReportDtoOutputReport',
            'orders',
          ),
          returned: BuiltValueNullFieldError.checkNotNull(
            returned,
            r'AdminPromoCodeReportDtoOutputReport',
            'returned',
          ),
          customers: BuiltValueNullFieldError.checkNotNull(
            customers,
            r'AdminPromoCodeReportDtoOutputReport',
            'customers',
          ),
          newCustomers: BuiltValueNullFieldError.checkNotNull(
            newCustomers,
            r'AdminPromoCodeReportDtoOutputReport',
            'newCustomers',
          ),
          cost: cost,
          merchantShare: merchantShare,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
