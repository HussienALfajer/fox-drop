// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_active_orders_dto_output_orders_inner_outcome_amount_to_collect.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect
    extends CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect([
    void Function(
      CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollectBuilder,
    )?
    updates,
  ]) =>
      (CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollectBuilder()
            ..update(updates))
          ._build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect rebuild(
    void Function(
      CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollectBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollectBuilder
  toBuilder() =>
      CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollectBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other
            is CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect &&
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
            r'CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollectBuilder
    implements
        Builder<
          CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect,
          CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollectBuilder
        > {
  _$CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollectBuilder() {
    CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect._defaults(
      this,
    );
  }

  CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollectBuilder
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
    CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect other,
  ) {
    _$v =
        other
            as _$CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect;
  }

  @override
  void update(
    void Function(
      CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollectBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect build() =>
      _build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect _build() {
    final _$result =
        _$v ??
        _$CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
