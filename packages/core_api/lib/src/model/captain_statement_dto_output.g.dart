// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_statement_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainStatementDtoOutput extends CaptainStatementDtoOutput {
  @override
  final String id;
  @override
  final String captainName;
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
  final CaptainStatementListDtoOutputStatementsInnerPayout? payout;
  @override
  final String collected;
  @override
  final String carriedOut;

  factory _$CaptainStatementDtoOutput([
    void Function(CaptainStatementDtoOutputBuilder)? updates,
  ]) => (CaptainStatementDtoOutputBuilder()..update(updates))._build();

  _$CaptainStatementDtoOutput._({
    required this.id,
    required this.captainName,
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
  }) : super._();
  @override
  CaptainStatementDtoOutput rebuild(
    void Function(CaptainStatementDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainStatementDtoOutputBuilder toBuilder() =>
      CaptainStatementDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainStatementDtoOutput &&
        id == other.id &&
        captainName == other.captainName &&
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
        carriedOut == other.carriedOut;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, captainName.hashCode);
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
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainStatementDtoOutput')
          ..add('id', id)
          ..add('captainName', captainName)
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
          ..add('carriedOut', carriedOut))
        .toString();
  }
}

class CaptainStatementDtoOutputBuilder
    implements
        Builder<CaptainStatementDtoOutput, CaptainStatementDtoOutputBuilder> {
  _$CaptainStatementDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _captainName;
  String? get captainName => _$this._captainName;
  set captainName(String? captainName) => _$this._captainName = captainName;

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

  CaptainStatementListDtoOutputStatementsInnerPayoutBuilder? _payout;
  CaptainStatementListDtoOutputStatementsInnerPayoutBuilder get payout =>
      _$this._payout ??=
          CaptainStatementListDtoOutputStatementsInnerPayoutBuilder();
  set payout(
    CaptainStatementListDtoOutputStatementsInnerPayoutBuilder? payout,
  ) => _$this._payout = payout;

  String? _collected;
  String? get collected => _$this._collected;
  set collected(String? collected) => _$this._collected = collected;

  String? _carriedOut;
  String? get carriedOut => _$this._carriedOut;
  set carriedOut(String? carriedOut) => _$this._carriedOut = carriedOut;

  CaptainStatementDtoOutputBuilder() {
    CaptainStatementDtoOutput._defaults(this);
  }

  CaptainStatementDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _captainName = $v.captainName;
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
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainStatementDtoOutput other) {
    _$v = other as _$CaptainStatementDtoOutput;
  }

  @override
  void update(void Function(CaptainStatementDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainStatementDtoOutput build() => _build();

  _$CaptainStatementDtoOutput _build() {
    _$CaptainStatementDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$CaptainStatementDtoOutput._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'CaptainStatementDtoOutput',
              'id',
            ),
            captainName: BuiltValueNullFieldError.checkNotNull(
              captainName,
              r'CaptainStatementDtoOutput',
              'captainName',
            ),
            periodFrom: periodFrom,
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'CaptainStatementDtoOutput',
              'createdAt',
            ),
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'CaptainStatementDtoOutput',
              'currency',
            ),
            orders: BuiltValueNullFieldError.checkNotNull(
              orders,
              r'CaptainStatementDtoOutput',
              'orders',
            ),
            basePay: BuiltValueNullFieldError.checkNotNull(
              basePay,
              r'CaptainStatementDtoOutput',
              'basePay',
            ),
            distancePay: BuiltValueNullFieldError.checkNotNull(
              distancePay,
              r'CaptainStatementDtoOutput',
              'distancePay',
            ),
            waitingPay: BuiltValueNullFieldError.checkNotNull(
              waitingPay,
              r'CaptainStatementDtoOutput',
              'waitingPay',
            ),
            peakBonus: BuiltValueNullFieldError.checkNotNull(
              peakBonus,
              r'CaptainStatementDtoOutput',
              'peakBonus',
            ),
            bonuses: BuiltValueNullFieldError.checkNotNull(
              bonuses,
              r'CaptainStatementDtoOutput',
              'bonuses',
            ),
            charges: BuiltValueNullFieldError.checkNotNull(
              charges,
              r'CaptainStatementDtoOutput',
              'charges',
            ),
            instalments: BuiltValueNullFieldError.checkNotNull(
              instalments,
              r'CaptainStatementDtoOutput',
              'instalments',
            ),
            adjustments: BuiltValueNullFieldError.checkNotNull(
              adjustments,
              r'CaptainStatementDtoOutput',
              'adjustments',
            ),
            carriedIn: BuiltValueNullFieldError.checkNotNull(
              carriedIn,
              r'CaptainStatementDtoOutput',
              'carriedIn',
            ),
            balance: BuiltValueNullFieldError.checkNotNull(
              balance,
              r'CaptainStatementDtoOutput',
              'balance',
            ),
            paid: BuiltValueNullFieldError.checkNotNull(
              paid,
              r'CaptainStatementDtoOutput',
              'paid',
            ),
            payout: _payout?.build(),
            collected: BuiltValueNullFieldError.checkNotNull(
              collected,
              r'CaptainStatementDtoOutput',
              'collected',
            ),
            carriedOut: BuiltValueNullFieldError.checkNotNull(
              carriedOut,
              r'CaptainStatementDtoOutput',
              'carriedOut',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'payout';
        _payout?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainStatementDtoOutput',
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
