// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_balances_dto_output_captains_inner_earnings.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainBalancesDtoOutputCaptainsInnerEarnings
    extends AdminCaptainBalancesDtoOutputCaptainsInnerEarnings {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminCaptainBalancesDtoOutputCaptainsInnerEarnings([
    void Function(AdminCaptainBalancesDtoOutputCaptainsInnerEarningsBuilder)?
    updates,
  ]) =>
      (AdminCaptainBalancesDtoOutputCaptainsInnerEarningsBuilder()
            ..update(updates))
          ._build();

  _$AdminCaptainBalancesDtoOutputCaptainsInnerEarnings._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminCaptainBalancesDtoOutputCaptainsInnerEarnings rebuild(
    void Function(AdminCaptainBalancesDtoOutputCaptainsInnerEarningsBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainBalancesDtoOutputCaptainsInnerEarningsBuilder toBuilder() =>
      AdminCaptainBalancesDtoOutputCaptainsInnerEarningsBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainBalancesDtoOutputCaptainsInnerEarnings &&
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
            r'AdminCaptainBalancesDtoOutputCaptainsInnerEarnings',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminCaptainBalancesDtoOutputCaptainsInnerEarningsBuilder
    implements
        Builder<
          AdminCaptainBalancesDtoOutputCaptainsInnerEarnings,
          AdminCaptainBalancesDtoOutputCaptainsInnerEarningsBuilder
        > {
  _$AdminCaptainBalancesDtoOutputCaptainsInnerEarnings? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminCaptainBalancesDtoOutputCaptainsInnerEarningsBuilder() {
    AdminCaptainBalancesDtoOutputCaptainsInnerEarnings._defaults(this);
  }

  AdminCaptainBalancesDtoOutputCaptainsInnerEarningsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainBalancesDtoOutputCaptainsInnerEarnings other) {
    _$v = other as _$AdminCaptainBalancesDtoOutputCaptainsInnerEarnings;
  }

  @override
  void update(
    void Function(AdminCaptainBalancesDtoOutputCaptainsInnerEarningsBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainBalancesDtoOutputCaptainsInnerEarnings build() => _build();

  _$AdminCaptainBalancesDtoOutputCaptainsInnerEarnings _build() {
    final _$result =
        _$v ??
        _$AdminCaptainBalancesDtoOutputCaptainsInnerEarnings._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminCaptainBalancesDtoOutputCaptainsInnerEarnings',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminCaptainBalancesDtoOutputCaptainsInnerEarnings',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
