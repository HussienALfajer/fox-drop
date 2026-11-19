// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_change_money_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminChangeMoneyOutput extends AdminChangeMoneyOutput {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminChangeMoneyOutput([
    void Function(AdminChangeMoneyOutputBuilder)? updates,
  ]) => (AdminChangeMoneyOutputBuilder()..update(updates))._build();

  _$AdminChangeMoneyOutput._({required this.amount, required this.currency})
    : super._();
  @override
  AdminChangeMoneyOutput rebuild(
    void Function(AdminChangeMoneyOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminChangeMoneyOutputBuilder toBuilder() =>
      AdminChangeMoneyOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminChangeMoneyOutput &&
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
    return (newBuiltValueToStringHelper(r'AdminChangeMoneyOutput')
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminChangeMoneyOutputBuilder
    implements Builder<AdminChangeMoneyOutput, AdminChangeMoneyOutputBuilder> {
  _$AdminChangeMoneyOutput? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminChangeMoneyOutputBuilder() {
    AdminChangeMoneyOutput._defaults(this);
  }

  AdminChangeMoneyOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminChangeMoneyOutput other) {
    _$v = other as _$AdminChangeMoneyOutput;
  }

  @override
  void update(void Function(AdminChangeMoneyOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminChangeMoneyOutput build() => _build();

  _$AdminChangeMoneyOutput _build() {
    final _$result =
        _$v ??
        _$AdminChangeMoneyOutput._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminChangeMoneyOutput',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminChangeMoneyOutput',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
