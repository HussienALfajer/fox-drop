// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_statement_list_dto_output_statements_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainStatementListDtoOutputStatementsInner
    extends CaptainStatementListDtoOutputStatementsInner {
  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final DateTime? periodFrom;
  @override
  final String currency;
  @override
  final int orders;
  @override
  final String paid;
  @override
  final CaptainStatementListDtoOutputStatementsInnerPayout? payout;
  @override
  final String carriedOut;

  factory _$CaptainStatementListDtoOutputStatementsInner([
    void Function(CaptainStatementListDtoOutputStatementsInnerBuilder)? updates,
  ]) => (CaptainStatementListDtoOutputStatementsInnerBuilder()..update(updates))
      ._build();

  _$CaptainStatementListDtoOutputStatementsInner._({
    required this.id,
    required this.createdAt,
    this.periodFrom,
    required this.currency,
    required this.orders,
    required this.paid,
    this.payout,
    required this.carriedOut,
  }) : super._();
  @override
  CaptainStatementListDtoOutputStatementsInner rebuild(
    void Function(CaptainStatementListDtoOutputStatementsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainStatementListDtoOutputStatementsInnerBuilder toBuilder() =>
      CaptainStatementListDtoOutputStatementsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainStatementListDtoOutputStatementsInner &&
        id == other.id &&
        createdAt == other.createdAt &&
        periodFrom == other.periodFrom &&
        currency == other.currency &&
        orders == other.orders &&
        paid == other.paid &&
        payout == other.payout &&
        carriedOut == other.carriedOut;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, periodFrom.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, paid.hashCode);
    _$hash = $jc(_$hash, payout.hashCode);
    _$hash = $jc(_$hash, carriedOut.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainStatementListDtoOutputStatementsInner',
          )
          ..add('id', id)
          ..add('createdAt', createdAt)
          ..add('periodFrom', periodFrom)
          ..add('currency', currency)
          ..add('orders', orders)
          ..add('paid', paid)
          ..add('payout', payout)
          ..add('carriedOut', carriedOut))
        .toString();
  }
}

class CaptainStatementListDtoOutputStatementsInnerBuilder
    implements
        Builder<
          CaptainStatementListDtoOutputStatementsInner,
          CaptainStatementListDtoOutputStatementsInnerBuilder
        > {
  _$CaptainStatementListDtoOutputStatementsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _periodFrom;
  DateTime? get periodFrom => _$this._periodFrom;
  set periodFrom(DateTime? periodFrom) => _$this._periodFrom = periodFrom;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  int? _orders;
  int? get orders => _$this._orders;
  set orders(int? orders) => _$this._orders = orders;

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

  String? _carriedOut;
  String? get carriedOut => _$this._carriedOut;
  set carriedOut(String? carriedOut) => _$this._carriedOut = carriedOut;

  CaptainStatementListDtoOutputStatementsInnerBuilder() {
    CaptainStatementListDtoOutputStatementsInner._defaults(this);
  }

  CaptainStatementListDtoOutputStatementsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _createdAt = $v.createdAt;
      _periodFrom = $v.periodFrom;
      _currency = $v.currency;
      _orders = $v.orders;
      _paid = $v.paid;
      _payout = $v.payout?.toBuilder();
      _carriedOut = $v.carriedOut;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainStatementListDtoOutputStatementsInner other) {
    _$v = other as _$CaptainStatementListDtoOutputStatementsInner;
  }

  @override
  void update(
    void Function(CaptainStatementListDtoOutputStatementsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainStatementListDtoOutputStatementsInner build() => _build();

  _$CaptainStatementListDtoOutputStatementsInner _build() {
    _$CaptainStatementListDtoOutputStatementsInner _$result;
    try {
      _$result =
          _$v ??
          _$CaptainStatementListDtoOutputStatementsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'CaptainStatementListDtoOutputStatementsInner',
              'id',
            ),
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'CaptainStatementListDtoOutputStatementsInner',
              'createdAt',
            ),
            periodFrom: periodFrom,
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'CaptainStatementListDtoOutputStatementsInner',
              'currency',
            ),
            orders: BuiltValueNullFieldError.checkNotNull(
              orders,
              r'CaptainStatementListDtoOutputStatementsInner',
              'orders',
            ),
            paid: BuiltValueNullFieldError.checkNotNull(
              paid,
              r'CaptainStatementListDtoOutputStatementsInner',
              'paid',
            ),
            payout: _payout?.build(),
            carriedOut: BuiltValueNullFieldError.checkNotNull(
              carriedOut,
              r'CaptainStatementListDtoOutputStatementsInner',
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
          r'CaptainStatementListDtoOutputStatementsInner',
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
