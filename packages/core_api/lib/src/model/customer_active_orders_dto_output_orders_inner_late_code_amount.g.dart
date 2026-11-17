// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_active_orders_dto_output_orders_inner_late_code_amount.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmount
    extends CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmount {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmount([
    void Function(
      CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmountBuilder,
    )?
    updates,
  ]) =>
      (CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmountBuilder()
            ..update(updates))
          ._build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmount._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmount rebuild(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmountBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmountBuilder toBuilder() =>
      CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmountBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmount &&
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
            r'CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmount',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmountBuilder
    implements
        Builder<
          CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmount,
          CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmountBuilder
        > {
  _$CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmount? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmountBuilder() {
    CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmount._defaults(this);
  }

  CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmount other) {
    _$v = other as _$CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmount;
  }

  @override
  void update(
    void Function(
      CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmountBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmount build() => _build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmount _build() {
    final _$result =
        _$v ??
        _$CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmount._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmount',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmount',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
