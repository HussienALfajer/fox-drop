// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_pay_money_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainPayMoneyOutput extends CaptainPayMoneyOutput {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CaptainPayMoneyOutput([
    void Function(CaptainPayMoneyOutputBuilder)? updates,
  ]) => (CaptainPayMoneyOutputBuilder()..update(updates))._build();

  _$CaptainPayMoneyOutput._({required this.amount, required this.currency})
    : super._();
  @override
  CaptainPayMoneyOutput rebuild(
    void Function(CaptainPayMoneyOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainPayMoneyOutputBuilder toBuilder() =>
      CaptainPayMoneyOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainPayMoneyOutput &&
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
    return (newBuiltValueToStringHelper(r'CaptainPayMoneyOutput')
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CaptainPayMoneyOutputBuilder
    implements Builder<CaptainPayMoneyOutput, CaptainPayMoneyOutputBuilder> {
  _$CaptainPayMoneyOutput? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CaptainPayMoneyOutputBuilder() {
    CaptainPayMoneyOutput._defaults(this);
  }

  CaptainPayMoneyOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainPayMoneyOutput other) {
    _$v = other as _$CaptainPayMoneyOutput;
  }

  @override
  void update(void Function(CaptainPayMoneyOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainPayMoneyOutput build() => _build();

  _$CaptainPayMoneyOutput _build() {
    final _$result =
        _$v ??
        _$CaptainPayMoneyOutput._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CaptainPayMoneyOutput',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CaptainPayMoneyOutput',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
