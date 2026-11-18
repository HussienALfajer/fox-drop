// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_draft_money.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDraftMoney extends AdminDraftMoney {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminDraftMoney([void Function(AdminDraftMoneyBuilder)? updates]) =>
      (AdminDraftMoneyBuilder()..update(updates))._build();

  _$AdminDraftMoney._({required this.amount, required this.currency})
    : super._();
  @override
  AdminDraftMoney rebuild(void Function(AdminDraftMoneyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDraftMoneyBuilder toBuilder() => AdminDraftMoneyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDraftMoney &&
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
    return (newBuiltValueToStringHelper(r'AdminDraftMoney')
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminDraftMoneyBuilder
    implements Builder<AdminDraftMoney, AdminDraftMoneyBuilder> {
  _$AdminDraftMoney? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminDraftMoneyBuilder() {
    AdminDraftMoney._defaults(this);
  }

  AdminDraftMoneyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDraftMoney other) {
    _$v = other as _$AdminDraftMoney;
  }

  @override
  void update(void Function(AdminDraftMoneyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDraftMoney build() => _build();

  _$AdminDraftMoney _build() {
    final _$result =
        _$v ??
        _$AdminDraftMoney._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminDraftMoney',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminDraftMoney',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
