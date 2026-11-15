// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_settlement_dto_output_statement_payout.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSettlementDtoOutputStatementPayout
    extends AdminSettlementDtoOutputStatementPayout {
  @override
  final String currency;
  @override
  final String amount;

  factory _$AdminSettlementDtoOutputStatementPayout([
    void Function(AdminSettlementDtoOutputStatementPayoutBuilder)? updates,
  ]) => (AdminSettlementDtoOutputStatementPayoutBuilder()..update(updates))
      ._build();

  _$AdminSettlementDtoOutputStatementPayout._({
    required this.currency,
    required this.amount,
  }) : super._();
  @override
  AdminSettlementDtoOutputStatementPayout rebuild(
    void Function(AdminSettlementDtoOutputStatementPayoutBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSettlementDtoOutputStatementPayoutBuilder toBuilder() =>
      AdminSettlementDtoOutputStatementPayoutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSettlementDtoOutputStatementPayout &&
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
            r'AdminSettlementDtoOutputStatementPayout',
          )
          ..add('currency', currency)
          ..add('amount', amount))
        .toString();
  }
}

class AdminSettlementDtoOutputStatementPayoutBuilder
    implements
        Builder<
          AdminSettlementDtoOutputStatementPayout,
          AdminSettlementDtoOutputStatementPayoutBuilder
        > {
  _$AdminSettlementDtoOutputStatementPayout? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  AdminSettlementDtoOutputStatementPayoutBuilder() {
    AdminSettlementDtoOutputStatementPayout._defaults(this);
  }

  AdminSettlementDtoOutputStatementPayoutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _amount = $v.amount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSettlementDtoOutputStatementPayout other) {
    _$v = other as _$AdminSettlementDtoOutputStatementPayout;
  }

  @override
  void update(
    void Function(AdminSettlementDtoOutputStatementPayoutBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminSettlementDtoOutputStatementPayout build() => _build();

  _$AdminSettlementDtoOutputStatementPayout _build() {
    final _$result =
        _$v ??
        _$AdminSettlementDtoOutputStatementPayout._(
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminSettlementDtoOutputStatementPayout',
            'currency',
          ),
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminSettlementDtoOutputStatementPayout',
            'amount',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
