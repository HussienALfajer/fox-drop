// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_daily_report_dto_output_previous_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDailyReportDtoOutputPreviousInner
    extends AdminDailyReportDtoOutputPreviousInner {
  @override
  final String day;
  @override
  final DateTime from;
  @override
  final DateTime to;
  @override
  final String currency;
  @override
  final AdminDailyReportDtoOutputOrders orders;
  @override
  final String deliveryFees;
  @override
  final AdminDailyReportDtoOutputDiscounts discounts;
  @override
  final String commission;
  @override
  final AdminDailyReportDtoOutputCaptainPay captainPay;
  @override
  final String compensation;
  @override
  final String operatingCost;
  @override
  final String testCost;
  @override
  final String fxRounding;
  @override
  final String adjustments;
  @override
  final String margin;
  @override
  final BuiltList<AdminDailyReportDtoOutputCashInner> cash;
  @override
  final AdminDailyReportDtoOutputRestaurants restaurants;

  factory _$AdminDailyReportDtoOutputPreviousInner([
    void Function(AdminDailyReportDtoOutputPreviousInnerBuilder)? updates,
  ]) => (AdminDailyReportDtoOutputPreviousInnerBuilder()..update(updates))
      ._build();

  _$AdminDailyReportDtoOutputPreviousInner._({
    required this.day,
    required this.from,
    required this.to,
    required this.currency,
    required this.orders,
    required this.deliveryFees,
    required this.discounts,
    required this.commission,
    required this.captainPay,
    required this.compensation,
    required this.operatingCost,
    required this.testCost,
    required this.fxRounding,
    required this.adjustments,
    required this.margin,
    required this.cash,
    required this.restaurants,
  }) : super._();
  @override
  AdminDailyReportDtoOutputPreviousInner rebuild(
    void Function(AdminDailyReportDtoOutputPreviousInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDailyReportDtoOutputPreviousInnerBuilder toBuilder() =>
      AdminDailyReportDtoOutputPreviousInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDailyReportDtoOutputPreviousInner &&
        day == other.day &&
        from == other.from &&
        to == other.to &&
        currency == other.currency &&
        orders == other.orders &&
        deliveryFees == other.deliveryFees &&
        discounts == other.discounts &&
        commission == other.commission &&
        captainPay == other.captainPay &&
        compensation == other.compensation &&
        operatingCost == other.operatingCost &&
        testCost == other.testCost &&
        fxRounding == other.fxRounding &&
        adjustments == other.adjustments &&
        margin == other.margin &&
        cash == other.cash &&
        restaurants == other.restaurants;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, day.hashCode);
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, deliveryFees.hashCode);
    _$hash = $jc(_$hash, discounts.hashCode);
    _$hash = $jc(_$hash, commission.hashCode);
    _$hash = $jc(_$hash, captainPay.hashCode);
    _$hash = $jc(_$hash, compensation.hashCode);
    _$hash = $jc(_$hash, operatingCost.hashCode);
    _$hash = $jc(_$hash, testCost.hashCode);
    _$hash = $jc(_$hash, fxRounding.hashCode);
    _$hash = $jc(_$hash, adjustments.hashCode);
    _$hash = $jc(_$hash, margin.hashCode);
    _$hash = $jc(_$hash, cash.hashCode);
    _$hash = $jc(_$hash, restaurants.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminDailyReportDtoOutputPreviousInner',
          )
          ..add('day', day)
          ..add('from', from)
          ..add('to', to)
          ..add('currency', currency)
          ..add('orders', orders)
          ..add('deliveryFees', deliveryFees)
          ..add('discounts', discounts)
          ..add('commission', commission)
          ..add('captainPay', captainPay)
          ..add('compensation', compensation)
          ..add('operatingCost', operatingCost)
          ..add('testCost', testCost)
          ..add('fxRounding', fxRounding)
          ..add('adjustments', adjustments)
          ..add('margin', margin)
          ..add('cash', cash)
          ..add('restaurants', restaurants))
        .toString();
  }
}

class AdminDailyReportDtoOutputPreviousInnerBuilder
    implements
        Builder<
          AdminDailyReportDtoOutputPreviousInner,
          AdminDailyReportDtoOutputPreviousInnerBuilder
        > {
  _$AdminDailyReportDtoOutputPreviousInner? _$v;

  String? _day;
  String? get day => _$this._day;
  set day(String? day) => _$this._day = day;

  DateTime? _from;
  DateTime? get from => _$this._from;
  set from(DateTime? from) => _$this._from = from;

  DateTime? _to;
  DateTime? get to => _$this._to;
  set to(DateTime? to) => _$this._to = to;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminDailyReportDtoOutputOrdersBuilder? _orders;
  AdminDailyReportDtoOutputOrdersBuilder get orders =>
      _$this._orders ??= AdminDailyReportDtoOutputOrdersBuilder();
  set orders(AdminDailyReportDtoOutputOrdersBuilder? orders) =>
      _$this._orders = orders;

  String? _deliveryFees;
  String? get deliveryFees => _$this._deliveryFees;
  set deliveryFees(String? deliveryFees) => _$this._deliveryFees = deliveryFees;

  AdminDailyReportDtoOutputDiscountsBuilder? _discounts;
  AdminDailyReportDtoOutputDiscountsBuilder get discounts =>
      _$this._discounts ??= AdminDailyReportDtoOutputDiscountsBuilder();
  set discounts(AdminDailyReportDtoOutputDiscountsBuilder? discounts) =>
      _$this._discounts = discounts;

  String? _commission;
  String? get commission => _$this._commission;
  set commission(String? commission) => _$this._commission = commission;

  AdminDailyReportDtoOutputCaptainPayBuilder? _captainPay;
  AdminDailyReportDtoOutputCaptainPayBuilder get captainPay =>
      _$this._captainPay ??= AdminDailyReportDtoOutputCaptainPayBuilder();
  set captainPay(AdminDailyReportDtoOutputCaptainPayBuilder? captainPay) =>
      _$this._captainPay = captainPay;

  String? _compensation;
  String? get compensation => _$this._compensation;
  set compensation(String? compensation) => _$this._compensation = compensation;

  String? _operatingCost;
  String? get operatingCost => _$this._operatingCost;
  set operatingCost(String? operatingCost) =>
      _$this._operatingCost = operatingCost;

  String? _testCost;
  String? get testCost => _$this._testCost;
  set testCost(String? testCost) => _$this._testCost = testCost;

  String? _fxRounding;
  String? get fxRounding => _$this._fxRounding;
  set fxRounding(String? fxRounding) => _$this._fxRounding = fxRounding;

  String? _adjustments;
  String? get adjustments => _$this._adjustments;
  set adjustments(String? adjustments) => _$this._adjustments = adjustments;

  String? _margin;
  String? get margin => _$this._margin;
  set margin(String? margin) => _$this._margin = margin;

  ListBuilder<AdminDailyReportDtoOutputCashInner>? _cash;
  ListBuilder<AdminDailyReportDtoOutputCashInner> get cash =>
      _$this._cash ??= ListBuilder<AdminDailyReportDtoOutputCashInner>();
  set cash(ListBuilder<AdminDailyReportDtoOutputCashInner>? cash) =>
      _$this._cash = cash;

  AdminDailyReportDtoOutputRestaurantsBuilder? _restaurants;
  AdminDailyReportDtoOutputRestaurantsBuilder get restaurants =>
      _$this._restaurants ??= AdminDailyReportDtoOutputRestaurantsBuilder();
  set restaurants(AdminDailyReportDtoOutputRestaurantsBuilder? restaurants) =>
      _$this._restaurants = restaurants;

  AdminDailyReportDtoOutputPreviousInnerBuilder() {
    AdminDailyReportDtoOutputPreviousInner._defaults(this);
  }

  AdminDailyReportDtoOutputPreviousInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _day = $v.day;
      _from = $v.from;
      _to = $v.to;
      _currency = $v.currency;
      _orders = $v.orders.toBuilder();
      _deliveryFees = $v.deliveryFees;
      _discounts = $v.discounts.toBuilder();
      _commission = $v.commission;
      _captainPay = $v.captainPay.toBuilder();
      _compensation = $v.compensation;
      _operatingCost = $v.operatingCost;
      _testCost = $v.testCost;
      _fxRounding = $v.fxRounding;
      _adjustments = $v.adjustments;
      _margin = $v.margin;
      _cash = $v.cash.toBuilder();
      _restaurants = $v.restaurants.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDailyReportDtoOutputPreviousInner other) {
    _$v = other as _$AdminDailyReportDtoOutputPreviousInner;
  }

  @override
  void update(
    void Function(AdminDailyReportDtoOutputPreviousInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDailyReportDtoOutputPreviousInner build() => _build();

  _$AdminDailyReportDtoOutputPreviousInner _build() {
    _$AdminDailyReportDtoOutputPreviousInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminDailyReportDtoOutputPreviousInner._(
            day: BuiltValueNullFieldError.checkNotNull(
              day,
              r'AdminDailyReportDtoOutputPreviousInner',
              'day',
            ),
            from: BuiltValueNullFieldError.checkNotNull(
              from,
              r'AdminDailyReportDtoOutputPreviousInner',
              'from',
            ),
            to: BuiltValueNullFieldError.checkNotNull(
              to,
              r'AdminDailyReportDtoOutputPreviousInner',
              'to',
            ),
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminDailyReportDtoOutputPreviousInner',
              'currency',
            ),
            orders: orders.build(),
            deliveryFees: BuiltValueNullFieldError.checkNotNull(
              deliveryFees,
              r'AdminDailyReportDtoOutputPreviousInner',
              'deliveryFees',
            ),
            discounts: discounts.build(),
            commission: BuiltValueNullFieldError.checkNotNull(
              commission,
              r'AdminDailyReportDtoOutputPreviousInner',
              'commission',
            ),
            captainPay: captainPay.build(),
            compensation: BuiltValueNullFieldError.checkNotNull(
              compensation,
              r'AdminDailyReportDtoOutputPreviousInner',
              'compensation',
            ),
            operatingCost: BuiltValueNullFieldError.checkNotNull(
              operatingCost,
              r'AdminDailyReportDtoOutputPreviousInner',
              'operatingCost',
            ),
            testCost: BuiltValueNullFieldError.checkNotNull(
              testCost,
              r'AdminDailyReportDtoOutputPreviousInner',
              'testCost',
            ),
            fxRounding: BuiltValueNullFieldError.checkNotNull(
              fxRounding,
              r'AdminDailyReportDtoOutputPreviousInner',
              'fxRounding',
            ),
            adjustments: BuiltValueNullFieldError.checkNotNull(
              adjustments,
              r'AdminDailyReportDtoOutputPreviousInner',
              'adjustments',
            ),
            margin: BuiltValueNullFieldError.checkNotNull(
              margin,
              r'AdminDailyReportDtoOutputPreviousInner',
              'margin',
            ),
            cash: cash.build(),
            restaurants: restaurants.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'orders';
        orders.build();

        _$failedField = 'discounts';
        discounts.build();

        _$failedField = 'captainPay';
        captainPay.build();

        _$failedField = 'cash';
        cash.build();
        _$failedField = 'restaurants';
        restaurants.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminDailyReportDtoOutputPreviousInner',
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
