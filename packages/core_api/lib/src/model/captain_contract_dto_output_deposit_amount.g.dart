// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_contract_dto_output_deposit_amount.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainContractDtoOutputDepositAmount
    extends CaptainContractDtoOutputDepositAmount {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CaptainContractDtoOutputDepositAmount([
    void Function(CaptainContractDtoOutputDepositAmountBuilder)? updates,
  ]) => (CaptainContractDtoOutputDepositAmountBuilder()..update(updates))
      ._build();

  _$CaptainContractDtoOutputDepositAmount._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  CaptainContractDtoOutputDepositAmount rebuild(
    void Function(CaptainContractDtoOutputDepositAmountBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainContractDtoOutputDepositAmountBuilder toBuilder() =>
      CaptainContractDtoOutputDepositAmountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainContractDtoOutputDepositAmount &&
        amount == other.amount &&
        currency == other.currency;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainContractDtoOutputDepositAmount',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CaptainContractDtoOutputDepositAmountBuilder
    implements
        Builder<
          CaptainContractDtoOutputDepositAmount,
          CaptainContractDtoOutputDepositAmountBuilder
        > {
  _$CaptainContractDtoOutputDepositAmount? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CaptainContractDtoOutputDepositAmountBuilder() {
    CaptainContractDtoOutputDepositAmount._defaults(this);
  }

  CaptainContractDtoOutputDepositAmountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainContractDtoOutputDepositAmount other) {
    _$v = other as _$CaptainContractDtoOutputDepositAmount;
  }

  @override
  void update(
    void Function(CaptainContractDtoOutputDepositAmountBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainContractDtoOutputDepositAmount build() => _build();

  _$CaptainContractDtoOutputDepositAmount _build() {
    final _$result =
        _$v ??
        _$CaptainContractDtoOutputDepositAmount._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CaptainContractDtoOutputDepositAmount',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CaptainContractDtoOutputDepositAmount',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
