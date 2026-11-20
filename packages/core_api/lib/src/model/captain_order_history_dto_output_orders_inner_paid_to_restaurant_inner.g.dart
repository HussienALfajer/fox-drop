// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_order_history_dto_output_orders_inner_paid_to_restaurant_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInner
    extends CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInner {
  @override
  final String currency;
  @override
  final String amount;

  factory _$CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInner([
    void Function(
      CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInnerBuilder,
    )?
    updates,
  ]) =>
      (CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInnerBuilder()
            ..update(updates))
          ._build();

  _$CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInner._({
    required this.currency,
    required this.amount,
  }) : super._();
  @override
  CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInner rebuild(
    void Function(
      CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInnerBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInnerBuilder
  toBuilder() =>
      CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other
            is CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInner &&
        currency == other.currency &&
        amount == other.amount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInner',
          )
          ..add('currency', currency)
          ..add('amount', amount))
        .toString();
  }
}

class CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInnerBuilder
    implements
        Builder<
          CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInner,
          CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInnerBuilder
        > {
  _$CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInner? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInnerBuilder() {
    CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInner._defaults(
      this,
    );
  }

  CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInnerBuilder
  get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _amount = $v.amount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
    CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInner other,
  ) {
    _$v =
        other as _$CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInner;
  }

  @override
  void update(
    void Function(
      CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInnerBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInner build() =>
      _build();

  _$CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInner _build() {
    final _$result =
        _$v ??
        _$CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInner._(
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInner',
            'currency',
          ),
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInner',
            'amount',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
