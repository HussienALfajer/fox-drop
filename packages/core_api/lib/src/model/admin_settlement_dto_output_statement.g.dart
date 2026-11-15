// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_settlement_dto_output_statement.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSettlementDtoOutputStatement
    extends AdminSettlementDtoOutputStatement {
  @override
  final String id;
  @override
  final String cityId;
  @override
  final String captainId;
  @override
  final String captainName;
  @override
  final String sessionId;
  @override
  final String cashierId;
  @override
  final DateTime? periodFrom;
  @override
  final DateTime createdAt;
  @override
  final String currency;
  @override
  final int orders;
  @override
  final String basePay;
  @override
  final String distancePay;
  @override
  final String waitingPay;
  @override
  final String peakBonus;
  @override
  final String bonuses;
  @override
  final String charges;
  @override
  final String instalments;
  @override
  final String adjustments;
  @override
  final String carriedIn;
  @override
  final String balance;
  @override
  final String paid;
  @override
  final AdminSettlementDtoOutputStatementPayout? payout;
  @override
  final String collected;
  @override
  final String carriedOut;
  @override
  final bool offCycle;
  @override
  final String? reason;
  @override
  final BuiltList<String> receiptIds;

  factory _$AdminSettlementDtoOutputStatement([
    void Function(AdminSettlementDtoOutputStatementBuilder)? updates,
  ]) => (AdminSettlementDtoOutputStatementBuilder()..update(updates))._build();

  _$AdminSettlementDtoOutputStatement._({
    required this.id,
    required this.cityId,
    required this.captainId,
    required this.captainName,
    required this.sessionId,
    required this.cashierId,
    this.periodFrom,
    required this.createdAt,
    required this.currency,
    required this.orders,
    required this.basePay,
    required this.distancePay,
    required this.waitingPay,
    required this.peakBonus,
    required this.bonuses,
    required this.charges,
    required this.instalments,
    required this.adjustments,
    required this.carriedIn,
    required this.balance,
    required this.paid,
    this.payout,
    required this.collected,
    required this.carriedOut,
    required this.offCycle,
    this.reason,
    required this.receiptIds,
  }) : super._();
  @override
  AdminSettlementDtoOutputStatement rebuild(
    void Function(AdminSettlementDtoOutputStatementBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSettlementDtoOutputStatementBuilder toBuilder() =>
      AdminSettlementDtoOutputStatementBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSettlementDtoOutputStatement &&
        id == other.id &&
        cityId == other.cityId &&
        captainId == other.captainId &&
        captainName == other.captainName &&
        sessionId == other.sessionId &&
        cashierId == other.cashierId &&
        periodFrom == other.periodFrom &&
        createdAt == other.createdAt &&
        currency == other.currency &&
        orders == other.orders &&
        basePay == other.basePay &&
        distancePay == other.distancePay &&
        waitingPay == other.waitingPay &&
        peakBonus == other.peakBonus &&
        bonuses == other.bonuses &&
        charges == other.charges &&
        instalments == other.instalments &&
        adjustments == other.adjustments &&
        carriedIn == other.carriedIn &&
        balance == other.balance &&
        paid == other.paid &&
        payout == other.payout &&
        collected == other.collected &&
        carriedOut == other.carriedOut &&
        offCycle == other.offCycle &&
        reason == other.reason &&
        receiptIds == other.receiptIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, captainId.hashCode);
    _$hash = $jc(_$hash, captainName.hashCode);
    _$hash = $jc(_$hash, sessionId.hashCode);
    _$hash = $jc(_$hash, cashierId.hashCode);
    _$hash = $jc(_$hash, periodFrom.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, basePay.hashCode);
    _$hash = $jc(_$hash, distancePay.hashCode);
    _$hash = $jc(_$hash, waitingPay.hashCode);
    _$hash = $jc(_$hash, peakBonus.hashCode);
    _$hash = $jc(_$hash, bonuses.hashCode);
    _$hash = $jc(_$hash, charges.hashCode);
    _$hash = $jc(_$hash, instalments.hashCode);
    _$hash = $jc(_$hash, adjustments.hashCode);
    _$hash = $jc(_$hash, carriedIn.hashCode);
    _$hash = $jc(_$hash, balance.hashCode);
    _$hash = $jc(_$hash, paid.hashCode);
    _$hash = $jc(_$hash, payout.hashCode);
    _$hash = $jc(_$hash, collected.hashCode);
    _$hash = $jc(_$hash, carriedOut.hashCode);
    _$hash = $jc(_$hash, offCycle.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, receiptIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSettlementDtoOutputStatement')
          ..add('id', id)
          ..add('cityId', cityId)
          ..add('captainId', captainId)
          ..add('captainName', captainName)
          ..add('sessionId', sessionId)
          ..add('cashierId', cashierId)
          ..add('periodFrom', periodFrom)
          ..add('createdAt', createdAt)
          ..add('currency', currency)
          ..add('orders', orders)
          ..add('basePay', basePay)
          ..add('distancePay', distancePay)
          ..add('waitingPay', waitingPay)
          ..add('peakBonus', peakBonus)
          ..add('bonuses', bonuses)
          ..add('charges', charges)
          ..add('instalments', instalments)
          ..add('adjustments', adjustments)
          ..add('carriedIn', carriedIn)
          ..add('balance', balance)
          ..add('paid', paid)
          ..add('payout', payout)
          ..add('collected', collected)
          ..add('carriedOut', carriedOut)
          ..add('offCycle', offCycle)
          ..add('reason', reason)
          ..add('receiptIds', receiptIds))
        .toString();
  }
}

class AdminSettlementDtoOutputStatementBuilder
    implements
        Builder<
          AdminSettlementDtoOutputStatement,
          AdminSettlementDtoOutputStatementBuilder
        > {
  _$AdminSettlementDtoOutputStatement? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _captainId;
  String? get captainId => _$this._captainId;
  set captainId(String? captainId) => _$this._captainId = captainId;

  String? _captainName;
  String? get captainName => _$this._captainName;
  set captainName(String? captainName) => _$this._captainName = captainName;

  String? _sessionId;
  String? get sessionId => _$this._sessionId;
  set sessionId(String? sessionId) => _$this._sessionId = sessionId;

  String? _cashierId;
  String? get cashierId => _$this._cashierId;
  set cashierId(String? cashierId) => _$this._cashierId = cashierId;

  DateTime? _periodFrom;
  DateTime? get periodFrom => _$this._periodFrom;
  set periodFrom(DateTime? periodFrom) => _$this._periodFrom = periodFrom;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  int? _orders;
  int? get orders => _$this._orders;
  set orders(int? orders) => _$this._orders = orders;

  String? _basePay;
  String? get basePay => _$this._basePay;
  set basePay(String? basePay) => _$this._basePay = basePay;

  String? _distancePay;
  String? get distancePay => _$this._distancePay;
  set distancePay(String? distancePay) => _$this._distancePay = distancePay;

  String? _waitingPay;
  String? get waitingPay => _$this._waitingPay;
  set waitingPay(String? waitingPay) => _$this._waitingPay = waitingPay;

  String? _peakBonus;
  String? get peakBonus => _$this._peakBonus;
  set peakBonus(String? peakBonus) => _$this._peakBonus = peakBonus;

  String? _bonuses;
  String? get bonuses => _$this._bonuses;
  set bonuses(String? bonuses) => _$this._bonuses = bonuses;

  String? _charges;
  String? get charges => _$this._charges;
  set charges(String? charges) => _$this._charges = charges;

  String? _instalments;
  String? get instalments => _$this._instalments;
  set instalments(String? instalments) => _$this._instalments = instalments;

  String? _adjustments;
  String? get adjustments => _$this._adjustments;
  set adjustments(String? adjustments) => _$this._adjustments = adjustments;

  String? _carriedIn;
  String? get carriedIn => _$this._carriedIn;
  set carriedIn(String? carriedIn) => _$this._carriedIn = carriedIn;

  String? _balance;
  String? get balance => _$this._balance;
  set balance(String? balance) => _$this._balance = balance;

  String? _paid;
  String? get paid => _$this._paid;
  set paid(String? paid) => _$this._paid = paid;

  AdminSettlementDtoOutputStatementPayoutBuilder? _payout;
  AdminSettlementDtoOutputStatementPayoutBuilder get payout =>
      _$this._payout ??= AdminSettlementDtoOutputStatementPayoutBuilder();
  set payout(AdminSettlementDtoOutputStatementPayoutBuilder? payout) =>
      _$this._payout = payout;

  String? _collected;
  String? get collected => _$this._collected;
  set collected(String? collected) => _$this._collected = collected;

  String? _carriedOut;
  String? get carriedOut => _$this._carriedOut;
  set carriedOut(String? carriedOut) => _$this._carriedOut = carriedOut;

  bool? _offCycle;
  bool? get offCycle => _$this._offCycle;
  set offCycle(bool? offCycle) => _$this._offCycle = offCycle;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  ListBuilder<String>? _receiptIds;
  ListBuilder<String> get receiptIds =>
      _$this._receiptIds ??= ListBuilder<String>();
  set receiptIds(ListBuilder<String>? receiptIds) =>
      _$this._receiptIds = receiptIds;

  AdminSettlementDtoOutputStatementBuilder() {
    AdminSettlementDtoOutputStatement._defaults(this);
  }

  AdminSettlementDtoOutputStatementBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _cityId = $v.cityId;
      _captainId = $v.captainId;
      _captainName = $v.captainName;
      _sessionId = $v.sessionId;
      _cashierId = $v.cashierId;
      _periodFrom = $v.periodFrom;
      _createdAt = $v.createdAt;
      _currency = $v.currency;
      _orders = $v.orders;
      _basePay = $v.basePay;
      _distancePay = $v.distancePay;
      _waitingPay = $v.waitingPay;
      _peakBonus = $v.peakBonus;
      _bonuses = $v.bonuses;
      _charges = $v.charges;
      _instalments = $v.instalments;
      _adjustments = $v.adjustments;
      _carriedIn = $v.carriedIn;
      _balance = $v.balance;
      _paid = $v.paid;
      _payout = $v.payout?.toBuilder();
      _collected = $v.collected;
      _carriedOut = $v.carriedOut;
      _offCycle = $v.offCycle;
      _reason = $v.reason;
      _receiptIds = $v.receiptIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSettlementDtoOutputStatement other) {
    _$v = other as _$AdminSettlementDtoOutputStatement;
  }

  @override
  void update(
    void Function(AdminSettlementDtoOutputStatementBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminSettlementDtoOutputStatement build() => _build();

  _$AdminSettlementDtoOutputStatement _build() {
    _$AdminSettlementDtoOutputStatement _$result;
    try {
      _$result =
          _$v ??
          _$AdminSettlementDtoOutputStatement._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminSettlementDtoOutputStatement',
              'id',
            ),
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminSettlementDtoOutputStatement',
              'cityId',
            ),
            captainId: BuiltValueNullFieldError.checkNotNull(
              captainId,
              r'AdminSettlementDtoOutputStatement',
              'captainId',
            ),
            captainName: BuiltValueNullFieldError.checkNotNull(
              captainName,
              r'AdminSettlementDtoOutputStatement',
              'captainName',
            ),
            sessionId: BuiltValueNullFieldError.checkNotNull(
              sessionId,
              r'AdminSettlementDtoOutputStatement',
              'sessionId',
            ),
            cashierId: BuiltValueNullFieldError.checkNotNull(
              cashierId,
              r'AdminSettlementDtoOutputStatement',
              'cashierId',
            ),
            periodFrom: periodFrom,
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'AdminSettlementDtoOutputStatement',
              'createdAt',
            ),
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminSettlementDtoOutputStatement',
              'currency',
            ),
            orders: BuiltValueNullFieldError.checkNotNull(
              orders,
              r'AdminSettlementDtoOutputStatement',
              'orders',
            ),
            basePay: BuiltValueNullFieldError.checkNotNull(
              basePay,
              r'AdminSettlementDtoOutputStatement',
              'basePay',
            ),
            distancePay: BuiltValueNullFieldError.checkNotNull(
              distancePay,
              r'AdminSettlementDtoOutputStatement',
              'distancePay',
            ),
            waitingPay: BuiltValueNullFieldError.checkNotNull(
              waitingPay,
              r'AdminSettlementDtoOutputStatement',
              'waitingPay',
            ),
            peakBonus: BuiltValueNullFieldError.checkNotNull(
              peakBonus,
              r'AdminSettlementDtoOutputStatement',
              'peakBonus',
            ),
            bonuses: BuiltValueNullFieldError.checkNotNull(
              bonuses,
              r'AdminSettlementDtoOutputStatement',
              'bonuses',
            ),
            charges: BuiltValueNullFieldError.checkNotNull(
              charges,
              r'AdminSettlementDtoOutputStatement',
              'charges',
            ),
            instalments: BuiltValueNullFieldError.checkNotNull(
              instalments,
              r'AdminSettlementDtoOutputStatement',
              'instalments',
            ),
            adjustments: BuiltValueNullFieldError.checkNotNull(
              adjustments,
              r'AdminSettlementDtoOutputStatement',
              'adjustments',
            ),
            carriedIn: BuiltValueNullFieldError.checkNotNull(
              carriedIn,
              r'AdminSettlementDtoOutputStatement',
              'carriedIn',
            ),
            balance: BuiltValueNullFieldError.checkNotNull(
              balance,
              r'AdminSettlementDtoOutputStatement',
              'balance',
            ),
            paid: BuiltValueNullFieldError.checkNotNull(
              paid,
              r'AdminSettlementDtoOutputStatement',
              'paid',
            ),
            payout: _payout?.build(),
            collected: BuiltValueNullFieldError.checkNotNull(
              collected,
              r'AdminSettlementDtoOutputStatement',
              'collected',
            ),
            carriedOut: BuiltValueNullFieldError.checkNotNull(
              carriedOut,
              r'AdminSettlementDtoOutputStatement',
              'carriedOut',
            ),
            offCycle: BuiltValueNullFieldError.checkNotNull(
              offCycle,
              r'AdminSettlementDtoOutputStatement',
              'offCycle',
            ),
            reason: reason,
            receiptIds: receiptIds.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'payout';
        _payout?.build();

        _$failedField = 'receiptIds';
        receiptIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminSettlementDtoOutputStatement',
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
