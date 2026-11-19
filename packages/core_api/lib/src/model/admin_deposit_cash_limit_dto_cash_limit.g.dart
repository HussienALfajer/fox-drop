// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_deposit_cash_limit_dto_cash_limit.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDepositCashLimitDtoCashLimit
    extends AdminDepositCashLimitDtoCashLimit {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminDepositCashLimitDtoCashLimit([
    void Function(AdminDepositCashLimitDtoCashLimitBuilder)? updates,
  ]) => (AdminDepositCashLimitDtoCashLimitBuilder()..update(updates))._build();

  _$AdminDepositCashLimitDtoCashLimit._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminDepositCashLimitDtoCashLimit rebuild(
    void Function(AdminDepositCashLimitDtoCashLimitBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDepositCashLimitDtoCashLimitBuilder toBuilder() =>
      AdminDepositCashLimitDtoCashLimitBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDepositCashLimitDtoCashLimit &&
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
    return (newBuiltValueToStringHelper(r'AdminDepositCashLimitDtoCashLimit')
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminDepositCashLimitDtoCashLimitBuilder
    implements
        Builder<
          AdminDepositCashLimitDtoCashLimit,
          AdminDepositCashLimitDtoCashLimitBuilder
        > {
  _$AdminDepositCashLimitDtoCashLimit? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminDepositCashLimitDtoCashLimitBuilder() {
    AdminDepositCashLimitDtoCashLimit._defaults(this);
  }

  AdminDepositCashLimitDtoCashLimitBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDepositCashLimitDtoCashLimit other) {
    _$v = other as _$AdminDepositCashLimitDtoCashLimit;
  }

  @override
  void update(
    void Function(AdminDepositCashLimitDtoCashLimitBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDepositCashLimitDtoCashLimit build() => _build();

  _$AdminDepositCashLimitDtoCashLimit _build() {
    final _$result =
        _$v ??
        _$AdminDepositCashLimitDtoCashLimit._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminDepositCashLimitDtoCashLimit',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminDepositCashLimitDtoCashLimit',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
