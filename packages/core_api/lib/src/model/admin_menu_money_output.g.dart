// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_money_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMenuMoneyOutput extends AdminMenuMoneyOutput {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminMenuMoneyOutput([
    void Function(AdminMenuMoneyOutputBuilder)? updates,
  ]) => (AdminMenuMoneyOutputBuilder()..update(updates))._build();

  _$AdminMenuMoneyOutput._({required this.amount, required this.currency})
    : super._();
  @override
  AdminMenuMoneyOutput rebuild(
    void Function(AdminMenuMoneyOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMenuMoneyOutputBuilder toBuilder() =>
      AdminMenuMoneyOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuMoneyOutput &&
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
    return (newBuiltValueToStringHelper(r'AdminMenuMoneyOutput')
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminMenuMoneyOutputBuilder
    implements Builder<AdminMenuMoneyOutput, AdminMenuMoneyOutputBuilder> {
  _$AdminMenuMoneyOutput? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminMenuMoneyOutputBuilder() {
    AdminMenuMoneyOutput._defaults(this);
  }

  AdminMenuMoneyOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMenuMoneyOutput other) {
    _$v = other as _$AdminMenuMoneyOutput;
  }

  @override
  void update(void Function(AdminMenuMoneyOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuMoneyOutput build() => _build();

  _$AdminMenuMoneyOutput _build() {
    final _$result =
        _$v ??
        _$AdminMenuMoneyOutput._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminMenuMoneyOutput',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminMenuMoneyOutput',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
