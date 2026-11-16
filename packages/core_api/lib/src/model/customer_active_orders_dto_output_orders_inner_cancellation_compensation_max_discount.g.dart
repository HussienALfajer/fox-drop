// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_active_orders_dto_output_orders_inner_cancellation_compensation_max_discount.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationMaxDiscount
    extends
        CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationMaxDiscount {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationMaxDiscount([
    void Function(
      CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationMaxDiscountBuilder,
    )?
    updates,
  ]) =>
      (CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationMaxDiscountBuilder()
            ..update(updates))
          ._build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationMaxDiscount._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationMaxDiscount
  rebuild(
    void Function(
      CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationMaxDiscountBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationMaxDiscountBuilder
  toBuilder() =>
      CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationMaxDiscountBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other
            is CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationMaxDiscount &&
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
            r'CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationMaxDiscount',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationMaxDiscountBuilder
    implements
        Builder<
          CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationMaxDiscount,
          CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationMaxDiscountBuilder
        > {
  _$CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationMaxDiscount?
  _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationMaxDiscountBuilder() {
    CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationMaxDiscount._defaults(
      this,
    );
  }

  CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationMaxDiscountBuilder
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
    CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationMaxDiscount
    other,
  ) {
    _$v =
        other
            as _$CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationMaxDiscount;
  }

  @override
  void update(
    void Function(
      CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationMaxDiscountBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationMaxDiscount
  build() => _build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationMaxDiscount
  _build() {
    final _$result =
        _$v ??
        _$CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationMaxDiscount._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationMaxDiscount',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationMaxDiscount',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
