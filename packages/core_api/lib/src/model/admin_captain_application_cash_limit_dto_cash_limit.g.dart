// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_application_cash_limit_dto_cash_limit.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainApplicationCashLimitDtoCashLimit
    extends AdminCaptainApplicationCashLimitDtoCashLimit {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminCaptainApplicationCashLimitDtoCashLimit([
    void Function(AdminCaptainApplicationCashLimitDtoCashLimitBuilder)? updates,
  ]) => (AdminCaptainApplicationCashLimitDtoCashLimitBuilder()..update(updates))
      ._build();

  _$AdminCaptainApplicationCashLimitDtoCashLimit._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminCaptainApplicationCashLimitDtoCashLimit rebuild(
    void Function(AdminCaptainApplicationCashLimitDtoCashLimitBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainApplicationCashLimitDtoCashLimitBuilder toBuilder() =>
      AdminCaptainApplicationCashLimitDtoCashLimitBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainApplicationCashLimitDtoCashLimit &&
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
    return (newBuiltValueToStringHelper(
            r'AdminCaptainApplicationCashLimitDtoCashLimit',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminCaptainApplicationCashLimitDtoCashLimitBuilder
    implements
        Builder<
          AdminCaptainApplicationCashLimitDtoCashLimit,
          AdminCaptainApplicationCashLimitDtoCashLimitBuilder
        > {
  _$AdminCaptainApplicationCashLimitDtoCashLimit? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminCaptainApplicationCashLimitDtoCashLimitBuilder() {
    AdminCaptainApplicationCashLimitDtoCashLimit._defaults(this);
  }

  AdminCaptainApplicationCashLimitDtoCashLimitBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainApplicationCashLimitDtoCashLimit other) {
    _$v = other as _$AdminCaptainApplicationCashLimitDtoCashLimit;
  }

  @override
  void update(
    void Function(AdminCaptainApplicationCashLimitDtoCashLimitBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainApplicationCashLimitDtoCashLimit build() => _build();

  _$AdminCaptainApplicationCashLimitDtoCashLimit _build() {
    final _$result =
        _$v ??
        _$AdminCaptainApplicationCashLimitDtoCashLimit._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminCaptainApplicationCashLimitDtoCashLimit',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminCaptainApplicationCashLimitDtoCashLimit',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
