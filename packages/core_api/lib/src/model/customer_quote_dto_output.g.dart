// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_quote_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerQuoteDtoOutput extends CustomerQuoteDtoOutput {
  @override
  final String version;
  @override
  final CustomerQuoteDtoOutputRestaurant restaurant;
  @override
  final BuiltList<CustomerQuoteDtoOutputLinesInner> lines;
  @override
  final String currency;
  @override
  final CustomerQuoteDtoOutputMoney money;
  @override
  final BuiltList<CaptainWentOfflineDtoOutputHandIn?> equivalents;
  @override
  final CaptainWentOfflineDtoOutputHandIn? payIn;
  @override
  final CustomerQuoteDtoOutputEstimate estimate;
  @override
  final CustomerQuoteDtoOutputMinimumOrder minimumOrder;
  @override
  final CustomerQuoteDtoOutputFreeDelivery? freeDelivery;
  @override
  final BuiltList<CustomerQuoteDtoOutputRatesInner> rates;
  @override
  final BuiltList<CustomerQuoteDtoOutputProblemsInner> problems;

  factory _$CustomerQuoteDtoOutput([
    void Function(CustomerQuoteDtoOutputBuilder)? updates,
  ]) => (CustomerQuoteDtoOutputBuilder()..update(updates))._build();

  _$CustomerQuoteDtoOutput._({
    required this.version,
    required this.restaurant,
    required this.lines,
    required this.currency,
    required this.money,
    required this.equivalents,
    this.payIn,
    required this.estimate,
    required this.minimumOrder,
    this.freeDelivery,
    required this.rates,
    required this.problems,
  }) : super._();
  @override
  CustomerQuoteDtoOutput rebuild(
    void Function(CustomerQuoteDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerQuoteDtoOutputBuilder toBuilder() =>
      CustomerQuoteDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerQuoteDtoOutput &&
        version == other.version &&
        restaurant == other.restaurant &&
        lines == other.lines &&
        currency == other.currency &&
        money == other.money &&
        equivalents == other.equivalents &&
        payIn == other.payIn &&
        estimate == other.estimate &&
        minimumOrder == other.minimumOrder &&
        freeDelivery == other.freeDelivery &&
        rates == other.rates &&
        problems == other.problems;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, restaurant.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, money.hashCode);
    _$hash = $jc(_$hash, equivalents.hashCode);
    _$hash = $jc(_$hash, payIn.hashCode);
    _$hash = $jc(_$hash, estimate.hashCode);
    _$hash = $jc(_$hash, minimumOrder.hashCode);
    _$hash = $jc(_$hash, freeDelivery.hashCode);
    _$hash = $jc(_$hash, rates.hashCode);
    _$hash = $jc(_$hash, problems.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerQuoteDtoOutput')
          ..add('version', version)
          ..add('restaurant', restaurant)
          ..add('lines', lines)
          ..add('currency', currency)
          ..add('money', money)
          ..add('equivalents', equivalents)
          ..add('payIn', payIn)
          ..add('estimate', estimate)
          ..add('minimumOrder', minimumOrder)
          ..add('freeDelivery', freeDelivery)
          ..add('rates', rates)
          ..add('problems', problems))
        .toString();
  }
}

class CustomerQuoteDtoOutputBuilder
    implements Builder<CustomerQuoteDtoOutput, CustomerQuoteDtoOutputBuilder> {
  _$CustomerQuoteDtoOutput? _$v;

  String? _version;
  String? get version => _$this._version;
  set version(String? version) => _$this._version = version;

  CustomerQuoteDtoOutputRestaurantBuilder? _restaurant;
  CustomerQuoteDtoOutputRestaurantBuilder get restaurant =>
      _$this._restaurant ??= CustomerQuoteDtoOutputRestaurantBuilder();
  set restaurant(CustomerQuoteDtoOutputRestaurantBuilder? restaurant) =>
      _$this._restaurant = restaurant;

  ListBuilder<CustomerQuoteDtoOutputLinesInner>? _lines;
  ListBuilder<CustomerQuoteDtoOutputLinesInner> get lines =>
      _$this._lines ??= ListBuilder<CustomerQuoteDtoOutputLinesInner>();
  set lines(ListBuilder<CustomerQuoteDtoOutputLinesInner>? lines) =>
      _$this._lines = lines;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CustomerQuoteDtoOutputMoneyBuilder? _money;
  CustomerQuoteDtoOutputMoneyBuilder get money =>
      _$this._money ??= CustomerQuoteDtoOutputMoneyBuilder();
  set money(CustomerQuoteDtoOutputMoneyBuilder? money) => _$this._money = money;

  ListBuilder<CaptainWentOfflineDtoOutputHandIn?>? _equivalents;
  ListBuilder<CaptainWentOfflineDtoOutputHandIn?> get equivalents =>
      _$this._equivalents ??= ListBuilder<CaptainWentOfflineDtoOutputHandIn?>();
  set equivalents(
    ListBuilder<CaptainWentOfflineDtoOutputHandIn?>? equivalents,
  ) => _$this._equivalents = equivalents;

  CaptainWentOfflineDtoOutputHandInBuilder? _payIn;
  CaptainWentOfflineDtoOutputHandInBuilder get payIn =>
      _$this._payIn ??= CaptainWentOfflineDtoOutputHandInBuilder();
  set payIn(CaptainWentOfflineDtoOutputHandInBuilder? payIn) =>
      _$this._payIn = payIn;

  CustomerQuoteDtoOutputEstimateBuilder? _estimate;
  CustomerQuoteDtoOutputEstimateBuilder get estimate =>
      _$this._estimate ??= CustomerQuoteDtoOutputEstimateBuilder();
  set estimate(CustomerQuoteDtoOutputEstimateBuilder? estimate) =>
      _$this._estimate = estimate;

  CustomerQuoteDtoOutputMinimumOrderBuilder? _minimumOrder;
  CustomerQuoteDtoOutputMinimumOrderBuilder get minimumOrder =>
      _$this._minimumOrder ??= CustomerQuoteDtoOutputMinimumOrderBuilder();
  set minimumOrder(CustomerQuoteDtoOutputMinimumOrderBuilder? minimumOrder) =>
      _$this._minimumOrder = minimumOrder;

  CustomerQuoteDtoOutputFreeDeliveryBuilder? _freeDelivery;
  CustomerQuoteDtoOutputFreeDeliveryBuilder get freeDelivery =>
      _$this._freeDelivery ??= CustomerQuoteDtoOutputFreeDeliveryBuilder();
  set freeDelivery(CustomerQuoteDtoOutputFreeDeliveryBuilder? freeDelivery) =>
      _$this._freeDelivery = freeDelivery;

  ListBuilder<CustomerQuoteDtoOutputRatesInner>? _rates;
  ListBuilder<CustomerQuoteDtoOutputRatesInner> get rates =>
      _$this._rates ??= ListBuilder<CustomerQuoteDtoOutputRatesInner>();
  set rates(ListBuilder<CustomerQuoteDtoOutputRatesInner>? rates) =>
      _$this._rates = rates;

  ListBuilder<CustomerQuoteDtoOutputProblemsInner>? _problems;
  ListBuilder<CustomerQuoteDtoOutputProblemsInner> get problems =>
      _$this._problems ??= ListBuilder<CustomerQuoteDtoOutputProblemsInner>();
  set problems(ListBuilder<CustomerQuoteDtoOutputProblemsInner>? problems) =>
      _$this._problems = problems;

  CustomerQuoteDtoOutputBuilder() {
    CustomerQuoteDtoOutput._defaults(this);
  }

  CustomerQuoteDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _version = $v.version;
      _restaurant = $v.restaurant.toBuilder();
      _lines = $v.lines.toBuilder();
      _currency = $v.currency;
      _money = $v.money.toBuilder();
      _equivalents = $v.equivalents.toBuilder();
      _payIn = $v.payIn?.toBuilder();
      _estimate = $v.estimate.toBuilder();
      _minimumOrder = $v.minimumOrder.toBuilder();
      _freeDelivery = $v.freeDelivery?.toBuilder();
      _rates = $v.rates.toBuilder();
      _problems = $v.problems.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerQuoteDtoOutput other) {
    _$v = other as _$CustomerQuoteDtoOutput;
  }

  @override
  void update(void Function(CustomerQuoteDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerQuoteDtoOutput build() => _build();

  _$CustomerQuoteDtoOutput _build() {
    _$CustomerQuoteDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$CustomerQuoteDtoOutput._(
            version: BuiltValueNullFieldError.checkNotNull(
              version,
              r'CustomerQuoteDtoOutput',
              'version',
            ),
            restaurant: restaurant.build(),
            lines: lines.build(),
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'CustomerQuoteDtoOutput',
              'currency',
            ),
            money: money.build(),
            equivalents: equivalents.build(),
            payIn: _payIn?.build(),
            estimate: estimate.build(),
            minimumOrder: minimumOrder.build(),
            freeDelivery: _freeDelivery?.build(),
            rates: rates.build(),
            problems: problems.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'restaurant';
        restaurant.build();
        _$failedField = 'lines';
        lines.build();

        _$failedField = 'money';
        money.build();
        _$failedField = 'equivalents';
        equivalents.build();
        _$failedField = 'payIn';
        _payIn?.build();
        _$failedField = 'estimate';
        estimate.build();
        _$failedField = 'minimumOrder';
        minimumOrder.build();
        _$failedField = 'freeDelivery';
        _freeDelivery?.build();
        _$failedField = 'rates';
        rates.build();
        _$failedField = 'problems';
        problems.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerQuoteDtoOutput',
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
