// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_statement_list_dto_output_statements_inner_payout.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainStatementListDtoOutputStatementsInnerPayout
    extends CaptainStatementListDtoOutputStatementsInnerPayout {
  @override
  final String currency;
  @override
  final String amount;

  factory _$CaptainStatementListDtoOutputStatementsInnerPayout([
    void Function(CaptainStatementListDtoOutputStatementsInnerPayoutBuilder)?
    updates,
  ]) =>
      (CaptainStatementListDtoOutputStatementsInnerPayoutBuilder()
            ..update(updates))
          ._build();

  _$CaptainStatementListDtoOutputStatementsInnerPayout._({
    required this.currency,
    required this.amount,
  }) : super._();
  @override
  CaptainStatementListDtoOutputStatementsInnerPayout rebuild(
    void Function(CaptainStatementListDtoOutputStatementsInnerPayoutBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainStatementListDtoOutputStatementsInnerPayoutBuilder toBuilder() =>
      CaptainStatementListDtoOutputStatementsInnerPayoutBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainStatementListDtoOutputStatementsInnerPayout &&
        currency == other.currency &&
        amount == other.amount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainStatementListDtoOutputStatementsInnerPayout',
          )
          ..add('currency', currency)
          ..add('amount', amount))
        .toString();
  }
}

class CaptainStatementListDtoOutputStatementsInnerPayoutBuilder
    implements
        Builder<
          CaptainStatementListDtoOutputStatementsInnerPayout,
          CaptainStatementListDtoOutputStatementsInnerPayoutBuilder
        > {
  _$CaptainStatementListDtoOutputStatementsInnerPayout? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  CaptainStatementListDtoOutputStatementsInnerPayoutBuilder() {
    CaptainStatementListDtoOutputStatementsInnerPayout._defaults(this);
  }

  CaptainStatementListDtoOutputStatementsInnerPayoutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _amount = $v.amount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainStatementListDtoOutputStatementsInnerPayout other) {
    _$v = other as _$CaptainStatementListDtoOutputStatementsInnerPayout;
  }

  @override
  void update(
    void Function(CaptainStatementListDtoOutputStatementsInnerPayoutBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainStatementListDtoOutputStatementsInnerPayout build() => _build();

  _$CaptainStatementListDtoOutputStatementsInnerPayout _build() {
    final _$result =
        _$v ??
        _$CaptainStatementListDtoOutputStatementsInnerPayout._(
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CaptainStatementListDtoOutputStatementsInnerPayout',
            'currency',
          ),
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CaptainStatementListDtoOutputStatementsInnerPayout',
            'amount',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
