// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_pending_money_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantPendingMoneyOutput extends MerchantPendingMoneyOutput {
  @override
  final String amount;
  @override
  final String currency;

  factory _$MerchantPendingMoneyOutput([
    void Function(MerchantPendingMoneyOutputBuilder)? updates,
  ]) => (MerchantPendingMoneyOutputBuilder()..update(updates))._build();

  _$MerchantPendingMoneyOutput._({required this.amount, required this.currency})
    : super._();
  @override
  MerchantPendingMoneyOutput rebuild(
    void Function(MerchantPendingMoneyOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantPendingMoneyOutputBuilder toBuilder() =>
      MerchantPendingMoneyOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantPendingMoneyOutput &&
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
    return (newBuiltValueToStringHelper(r'MerchantPendingMoneyOutput')
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class MerchantPendingMoneyOutputBuilder
    implements
        Builder<MerchantPendingMoneyOutput, MerchantPendingMoneyOutputBuilder> {
  _$MerchantPendingMoneyOutput? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  MerchantPendingMoneyOutputBuilder() {
    MerchantPendingMoneyOutput._defaults(this);
  }

  MerchantPendingMoneyOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantPendingMoneyOutput other) {
    _$v = other as _$MerchantPendingMoneyOutput;
  }

  @override
  void update(void Function(MerchantPendingMoneyOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantPendingMoneyOutput build() => _build();

  _$MerchantPendingMoneyOutput _build() {
    final _$result =
        _$v ??
        _$MerchantPendingMoneyOutput._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'MerchantPendingMoneyOutput',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'MerchantPendingMoneyOutput',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
