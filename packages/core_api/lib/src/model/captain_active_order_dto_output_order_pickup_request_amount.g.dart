// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output_order_pickup_request_amount.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainActiveOrderDtoOutputOrderPickupRequestAmount
    extends CaptainActiveOrderDtoOutputOrderPickupRequestAmount {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CaptainActiveOrderDtoOutputOrderPickupRequestAmount([
    void Function(CaptainActiveOrderDtoOutputOrderPickupRequestAmountBuilder)?
    updates,
  ]) =>
      (CaptainActiveOrderDtoOutputOrderPickupRequestAmountBuilder()
            ..update(updates))
          ._build();

  _$CaptainActiveOrderDtoOutputOrderPickupRequestAmount._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  CaptainActiveOrderDtoOutputOrderPickupRequestAmount rebuild(
    void Function(CaptainActiveOrderDtoOutputOrderPickupRequestAmountBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputOrderPickupRequestAmountBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputOrderPickupRequestAmountBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutputOrderPickupRequestAmount &&
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
            r'CaptainActiveOrderDtoOutputOrderPickupRequestAmount',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CaptainActiveOrderDtoOutputOrderPickupRequestAmountBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutputOrderPickupRequestAmount,
          CaptainActiveOrderDtoOutputOrderPickupRequestAmountBuilder
        > {
  _$CaptainActiveOrderDtoOutputOrderPickupRequestAmount? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CaptainActiveOrderDtoOutputOrderPickupRequestAmountBuilder() {
    CaptainActiveOrderDtoOutputOrderPickupRequestAmount._defaults(this);
  }

  CaptainActiveOrderDtoOutputOrderPickupRequestAmountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainActiveOrderDtoOutputOrderPickupRequestAmount other) {
    _$v = other as _$CaptainActiveOrderDtoOutputOrderPickupRequestAmount;
  }

  @override
  void update(
    void Function(CaptainActiveOrderDtoOutputOrderPickupRequestAmountBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutputOrderPickupRequestAmount build() => _build();

  _$CaptainActiveOrderDtoOutputOrderPickupRequestAmount _build() {
    final _$result =
        _$v ??
        _$CaptainActiveOrderDtoOutputOrderPickupRequestAmount._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CaptainActiveOrderDtoOutputOrderPickupRequestAmount',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CaptainActiveOrderDtoOutputOrderPickupRequestAmount',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
