// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_active_orders_dto_output_orders_inner_late_code_max_discount.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount
    extends CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount([
    void Function(
      CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscountBuilder,
    )?
    updates,
  ]) =>
      (CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscountBuilder()
            ..update(updates))
          ._build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount rebuild(
    void Function(
      CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscountBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscountBuilder
  toBuilder() =>
      CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscountBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other
            is CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount &&
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
            r'CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscountBuilder
    implements
        Builder<
          CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount,
          CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscountBuilder
        > {
  _$CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscountBuilder() {
    CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount._defaults(this);
  }

  CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscountBuilder
  get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
    CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount other,
  ) {
    _$v =
        other as _$CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount;
  }

  @override
  void update(
    void Function(
      CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscountBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount build() =>
      _build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount _build() {
    final _$result =
        _$v ??
        _$CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
