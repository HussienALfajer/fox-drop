// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_daily_report_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDailyReportDtoOutput extends AdminDailyReportDtoOutput {
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
  final String withheldDeposits;
  @override
  final String margin;
  @override
  final BuiltList<AdminDailyReportDtoOutputCashInner> cash;
  @override
  final AdminDailyReportDtoOutputRestaurants restaurants;
  @override
  final String cityId;
  @override
  final bool today;
  @override
  final AdminDailyReportDtoOutputNow? now;
  @override
  final BuiltList<AdminDailyReportDtoOutputPreviousInner> previous;

  factory _$AdminDailyReportDtoOutput([
    void Function(AdminDailyReportDtoOutputBuilder)? updates,
  ]) => (AdminDailyReportDtoOutputBuilder()..update(updates))._build();

  _$AdminDailyReportDtoOutput._({
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
    required this.withheldDeposits,
    required this.margin,
    required this.cash,
    required this.restaurants,
    required this.cityId,
    required this.today,
    this.now,
    required this.previous,
  }) : super._();
  @override
  AdminDailyReportDtoOutput rebuild(
    void Function(AdminDailyReportDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDailyReportDtoOutputBuilder toBuilder() =>
      AdminDailyReportDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDailyReportDtoOutput &&
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
        withheldDeposits == other.withheldDeposits &&
        margin == other.margin &&
        cash == other.cash &&
        restaurants == other.restaurants &&
        cityId == other.cityId &&
        today == other.today &&
        now == other.now &&
        previous == other.previous;
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
    _$hash = $jc(_$hash, withheldDeposits.hashCode);
    _$hash = $jc(_$hash, margin.hashCode);
    _$hash = $jc(_$hash, cash.hashCode);
    _$hash = $jc(_$hash, restaurants.hashCode);
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, today.hashCode);
    _$hash = $jc(_$hash, now.hashCode);
    _$hash = $jc(_$hash, previous.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDailyReportDtoOutput')
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
          ..add('withheldDeposits', withheldDeposits)
          ..add('margin', margin)
          ..add('cash', cash)
          ..add('restaurants', restaurants)
          ..add('cityId', cityId)
          ..add('today', today)
          ..add('now', now)
          ..add('previous', previous))
        .toString();
  }
}

class AdminDailyReportDtoOutputBuilder
    implements
        Builder<AdminDailyReportDtoOutput, AdminDailyReportDtoOutputBuilder> {
  _$AdminDailyReportDtoOutput? _$v;

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

  String? _withheldDeposits;
  String? get withheldDeposits => _$this._withheldDeposits;
  set withheldDeposits(String? withheldDeposits) =>
      _$this._withheldDeposits = withheldDeposits;

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

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  bool? _today;
  bool? get today => _$this._today;
  set today(bool? today) => _$this._today = today;

  AdminDailyReportDtoOutputNowBuilder? _now;
  AdminDailyReportDtoOutputNowBuilder get now =>
      _$this._now ??= AdminDailyReportDtoOutputNowBuilder();
  set now(AdminDailyReportDtoOutputNowBuilder? now) => _$this._now = now;

  ListBuilder<AdminDailyReportDtoOutputPreviousInner>? _previous;
  ListBuilder<AdminDailyReportDtoOutputPreviousInner> get previous =>
      _$this._previous ??=
          ListBuilder<AdminDailyReportDtoOutputPreviousInner>();
  set previous(ListBuilder<AdminDailyReportDtoOutputPreviousInner>? previous) =>
      _$this._previous = previous;

  AdminDailyReportDtoOutputBuilder() {
    AdminDailyReportDtoOutput._defaults(this);
  }

  AdminDailyReportDtoOutputBuilder get _$this {
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
      _withheldDeposits = $v.withheldDeposits;
      _margin = $v.margin;
      _cash = $v.cash.toBuilder();
      _restaurants = $v.restaurants.toBuilder();
      _cityId = $v.cityId;
      _today = $v.today;
      _now = $v.now?.toBuilder();
      _previous = $v.previous.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDailyReportDtoOutput other) {
    _$v = other as _$AdminDailyReportDtoOutput;
  }

  @override
  void update(void Function(AdminDailyReportDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDailyReportDtoOutput build() => _build();

  _$AdminDailyReportDtoOutput _build() {
    _$AdminDailyReportDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminDailyReportDtoOutput._(
            day: BuiltValueNullFieldError.checkNotNull(
              day,
              r'AdminDailyReportDtoOutput',
              'day',
            ),
            from: BuiltValueNullFieldError.checkNotNull(
              from,
              r'AdminDailyReportDtoOutput',
              'from',
            ),
            to: BuiltValueNullFieldError.checkNotNull(
              to,
              r'AdminDailyReportDtoOutput',
              'to',
            ),
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminDailyReportDtoOutput',
              'currency',
            ),
            orders: orders.build(),
            deliveryFees: BuiltValueNullFieldError.checkNotNull(
              deliveryFees,
              r'AdminDailyReportDtoOutput',
              'deliveryFees',
            ),
            discounts: discounts.build(),
            commission: BuiltValueNullFieldError.checkNotNull(
              commission,
              r'AdminDailyReportDtoOutput',
              'commission',
            ),
            captainPay: captainPay.build(),
            compensation: BuiltValueNullFieldError.checkNotNull(
              compensation,
              r'AdminDailyReportDtoOutput',
              'compensation',
            ),
            operatingCost: BuiltValueNullFieldError.checkNotNull(
              operatingCost,
              r'AdminDailyReportDtoOutput',
              'operatingCost',
            ),
            testCost: BuiltValueNullFieldError.checkNotNull(
              testCost,
              r'AdminDailyReportDtoOutput',
              'testCost',
            ),
            fxRounding: BuiltValueNullFieldError.checkNotNull(
              fxRounding,
              r'AdminDailyReportDtoOutput',
              'fxRounding',
            ),
            adjustments: BuiltValueNullFieldError.checkNotNull(
              adjustments,
              r'AdminDailyReportDtoOutput',
              'adjustments',
            ),
            withheldDeposits: BuiltValueNullFieldError.checkNotNull(
              withheldDeposits,
              r'AdminDailyReportDtoOutput',
              'withheldDeposits',
            ),
            margin: BuiltValueNullFieldError.checkNotNull(
              margin,
              r'AdminDailyReportDtoOutput',
              'margin',
            ),
            cash: cash.build(),
            restaurants: restaurants.build(),
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminDailyReportDtoOutput',
              'cityId',
            ),
            today: BuiltValueNullFieldError.checkNotNull(
              today,
              r'AdminDailyReportDtoOutput',
              'today',
            ),
            now: _now?.build(),
            previous: previous.build(),
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

        _$failedField = 'now';
        _now?.build();
        _$failedField = 'previous';
        previous.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminDailyReportDtoOutput',
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
