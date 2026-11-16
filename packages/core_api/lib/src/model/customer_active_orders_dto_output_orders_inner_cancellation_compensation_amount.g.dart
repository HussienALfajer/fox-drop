// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_active_orders_dto_output_orders_inner_cancellation_compensation_amount.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationAmount
    extends
        CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationAmount {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationAmount([
    void Function(
      CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationAmountBuilder,
    )?
    updates,
  ]) =>
      (CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationAmountBuilder()
            ..update(updates))
          ._build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationAmount._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationAmount
  rebuild(
    void Function(
      CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationAmountBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationAmountBuilder
  toBuilder() =>
      CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationAmountBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other
            is CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationAmount &&
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
            r'CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationAmount',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationAmountBuilder
    implements
        Builder<
          CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationAmount,
          CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationAmountBuilder
        > {
  _$CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationAmount? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationAmountBuilder() {
    CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationAmount._defaults(
      this,
    );
  }

  CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationAmountBuilder
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
    CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationAmount
    other,
  ) {
    _$v =
        other
            as _$CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationAmount;
  }

  @override
  void update(
    void Function(
      CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationAmountBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationAmount
  build() => _build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationAmount
  _build() {
    final _$result =
        _$v ??
        _$CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationAmount._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationAmount',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationAmount',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
