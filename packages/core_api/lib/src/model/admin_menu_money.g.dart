// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_money.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMenuMoney extends AdminMenuMoney {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminMenuMoney([void Function(AdminMenuMoneyBuilder)? updates]) =>
      (AdminMenuMoneyBuilder()..update(updates))._build();

  _$AdminMenuMoney._({required this.amount, required this.currency})
    : super._();
  @override
  AdminMenuMoney rebuild(void Function(AdminMenuMoneyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminMenuMoneyBuilder toBuilder() => AdminMenuMoneyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuMoney &&
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
    return (newBuiltValueToStringHelper(r'AdminMenuMoney')
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminMenuMoneyBuilder
    implements Builder<AdminMenuMoney, AdminMenuMoneyBuilder> {
  _$AdminMenuMoney? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminMenuMoneyBuilder() {
    AdminMenuMoney._defaults(this);
  }

  AdminMenuMoneyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMenuMoney other) {
    _$v = other as _$AdminMenuMoney;
  }

  @override
  void update(void Function(AdminMenuMoneyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuMoney build() => _build();

  _$AdminMenuMoney _build() {
    final _$result =
        _$v ??
        _$AdminMenuMoney._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminMenuMoney',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminMenuMoney',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
