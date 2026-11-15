// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_settle_dto_custody_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSettleDtoCustodyInner extends AdminSettleDtoCustodyInner {
  @override
  final String currency;
  @override
  final String balance;

  factory _$AdminSettleDtoCustodyInner([
    void Function(AdminSettleDtoCustodyInnerBuilder)? updates,
  ]) => (AdminSettleDtoCustodyInnerBuilder()..update(updates))._build();

  _$AdminSettleDtoCustodyInner._({
    required this.currency,
    required this.balance,
  }) : super._();
  @override
  AdminSettleDtoCustodyInner rebuild(
    void Function(AdminSettleDtoCustodyInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSettleDtoCustodyInnerBuilder toBuilder() =>
      AdminSettleDtoCustodyInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSettleDtoCustodyInner &&
        currency == other.currency &&
        balance == other.balance;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, balance.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSettleDtoCustodyInner')
          ..add('currency', currency)
          ..add('balance', balance))
        .toString();
  }
}

class AdminSettleDtoCustodyInnerBuilder
    implements
        Builder<AdminSettleDtoCustodyInner, AdminSettleDtoCustodyInnerBuilder> {
  _$AdminSettleDtoCustodyInner? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _balance;
  String? get balance => _$this._balance;
  set balance(String? balance) => _$this._balance = balance;

  AdminSettleDtoCustodyInnerBuilder() {
    AdminSettleDtoCustodyInner._defaults(this);
  }

  AdminSettleDtoCustodyInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _balance = $v.balance;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSettleDtoCustodyInner other) {
    _$v = other as _$AdminSettleDtoCustodyInner;
  }

  @override
  void update(void Function(AdminSettleDtoCustodyInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSettleDtoCustodyInner build() => _build();

  _$AdminSettleDtoCustodyInner _build() {
    final _$result =
        _$v ??
        _$AdminSettleDtoCustodyInner._(
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminSettleDtoCustodyInner',
            'currency',
          ),
          balance: BuiltValueNullFieldError.checkNotNull(
            balance,
            r'AdminSettleDtoCustodyInner',
            'balance',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
