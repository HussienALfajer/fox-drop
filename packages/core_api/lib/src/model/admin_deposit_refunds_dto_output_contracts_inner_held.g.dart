// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_deposit_refunds_dto_output_contracts_inner_held.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDepositRefundsDtoOutputContractsInnerHeld
    extends AdminDepositRefundsDtoOutputContractsInnerHeld {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminDepositRefundsDtoOutputContractsInnerHeld([
    void Function(AdminDepositRefundsDtoOutputContractsInnerHeldBuilder)?
    updates,
  ]) =>
      (AdminDepositRefundsDtoOutputContractsInnerHeldBuilder()..update(updates))
          ._build();

  _$AdminDepositRefundsDtoOutputContractsInnerHeld._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminDepositRefundsDtoOutputContractsInnerHeld rebuild(
    void Function(AdminDepositRefundsDtoOutputContractsInnerHeldBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDepositRefundsDtoOutputContractsInnerHeldBuilder toBuilder() =>
      AdminDepositRefundsDtoOutputContractsInnerHeldBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDepositRefundsDtoOutputContractsInnerHeld &&
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
            r'AdminDepositRefundsDtoOutputContractsInnerHeld',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminDepositRefundsDtoOutputContractsInnerHeldBuilder
    implements
        Builder<
          AdminDepositRefundsDtoOutputContractsInnerHeld,
          AdminDepositRefundsDtoOutputContractsInnerHeldBuilder
        > {
  _$AdminDepositRefundsDtoOutputContractsInnerHeld? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminDepositRefundsDtoOutputContractsInnerHeldBuilder() {
    AdminDepositRefundsDtoOutputContractsInnerHeld._defaults(this);
  }

  AdminDepositRefundsDtoOutputContractsInnerHeldBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDepositRefundsDtoOutputContractsInnerHeld other) {
    _$v = other as _$AdminDepositRefundsDtoOutputContractsInnerHeld;
  }

  @override
  void update(
    void Function(AdminDepositRefundsDtoOutputContractsInnerHeldBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDepositRefundsDtoOutputContractsInnerHeld build() => _build();

  _$AdminDepositRefundsDtoOutputContractsInnerHeld _build() {
    final _$result =
        _$v ??
        _$AdminDepositRefundsDtoOutputContractsInnerHeld._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminDepositRefundsDtoOutputContractsInnerHeld',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminDepositRefundsDtoOutputContractsInnerHeld',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
