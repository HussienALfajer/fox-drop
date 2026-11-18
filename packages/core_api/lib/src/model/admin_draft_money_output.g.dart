// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_draft_money_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDraftMoneyOutput extends AdminDraftMoneyOutput {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminDraftMoneyOutput([
    void Function(AdminDraftMoneyOutputBuilder)? updates,
  ]) => (AdminDraftMoneyOutputBuilder()..update(updates))._build();

  _$AdminDraftMoneyOutput._({required this.amount, required this.currency})
    : super._();
  @override
  AdminDraftMoneyOutput rebuild(
    void Function(AdminDraftMoneyOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDraftMoneyOutputBuilder toBuilder() =>
      AdminDraftMoneyOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDraftMoneyOutput &&
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
    return (newBuiltValueToStringHelper(r'AdminDraftMoneyOutput')
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminDraftMoneyOutputBuilder
    implements Builder<AdminDraftMoneyOutput, AdminDraftMoneyOutputBuilder> {
  _$AdminDraftMoneyOutput? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminDraftMoneyOutputBuilder() {
    AdminDraftMoneyOutput._defaults(this);
  }

  AdminDraftMoneyOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDraftMoneyOutput other) {
    _$v = other as _$AdminDraftMoneyOutput;
  }

  @override
  void update(void Function(AdminDraftMoneyOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDraftMoneyOutput build() => _build();

  _$AdminDraftMoneyOutput _build() {
    final _$result =
        _$v ??
        _$AdminDraftMoneyOutput._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminDraftMoneyOutput',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminDraftMoneyOutput',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
