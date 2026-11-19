// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_price_log_money_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPriceLogMoneyOutput extends AdminPriceLogMoneyOutput {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminPriceLogMoneyOutput([
    void Function(AdminPriceLogMoneyOutputBuilder)? updates,
  ]) => (AdminPriceLogMoneyOutputBuilder()..update(updates))._build();

  _$AdminPriceLogMoneyOutput._({required this.amount, required this.currency})
    : super._();
  @override
  AdminPriceLogMoneyOutput rebuild(
    void Function(AdminPriceLogMoneyOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminPriceLogMoneyOutputBuilder toBuilder() =>
      AdminPriceLogMoneyOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPriceLogMoneyOutput &&
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
    return (newBuiltValueToStringHelper(r'AdminPriceLogMoneyOutput')
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminPriceLogMoneyOutputBuilder
    implements
        Builder<AdminPriceLogMoneyOutput, AdminPriceLogMoneyOutputBuilder> {
  _$AdminPriceLogMoneyOutput? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminPriceLogMoneyOutputBuilder() {
    AdminPriceLogMoneyOutput._defaults(this);
  }

  AdminPriceLogMoneyOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPriceLogMoneyOutput other) {
    _$v = other as _$AdminPriceLogMoneyOutput;
  }

  @override
  void update(void Function(AdminPriceLogMoneyOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPriceLogMoneyOutput build() => _build();

  _$AdminPriceLogMoneyOutput _build() {
    final _$result =
        _$v ??
        _$AdminPriceLogMoneyOutput._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminPriceLogMoneyOutput',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminPriceLogMoneyOutput',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
