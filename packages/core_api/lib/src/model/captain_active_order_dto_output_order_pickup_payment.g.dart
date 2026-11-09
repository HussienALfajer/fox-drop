// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output_order_pickup_payment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainActiveOrderDtoOutputOrderPickupPayment
    extends CaptainActiveOrderDtoOutputOrderPickupPayment {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CaptainActiveOrderDtoOutputOrderPickupPayment([
    void Function(CaptainActiveOrderDtoOutputOrderPickupPaymentBuilder)?
    updates,
  ]) =>
      (CaptainActiveOrderDtoOutputOrderPickupPaymentBuilder()..update(updates))
          ._build();

  _$CaptainActiveOrderDtoOutputOrderPickupPayment._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  CaptainActiveOrderDtoOutputOrderPickupPayment rebuild(
    void Function(CaptainActiveOrderDtoOutputOrderPickupPaymentBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputOrderPickupPaymentBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputOrderPickupPaymentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutputOrderPickupPayment &&
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
            r'CaptainActiveOrderDtoOutputOrderPickupPayment',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CaptainActiveOrderDtoOutputOrderPickupPaymentBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutputOrderPickupPayment,
          CaptainActiveOrderDtoOutputOrderPickupPaymentBuilder
        > {
  _$CaptainActiveOrderDtoOutputOrderPickupPayment? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CaptainActiveOrderDtoOutputOrderPickupPaymentBuilder() {
    CaptainActiveOrderDtoOutputOrderPickupPayment._defaults(this);
  }

  CaptainActiveOrderDtoOutputOrderPickupPaymentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainActiveOrderDtoOutputOrderPickupPayment other) {
    _$v = other as _$CaptainActiveOrderDtoOutputOrderPickupPayment;
  }

  @override
  void update(
    void Function(CaptainActiveOrderDtoOutputOrderPickupPaymentBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutputOrderPickupPayment build() => _build();

  _$CaptainActiveOrderDtoOutputOrderPickupPayment _build() {
    final _$result =
        _$v ??
        _$CaptainActiveOrderDtoOutputOrderPickupPayment._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CaptainActiveOrderDtoOutputOrderPickupPayment',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CaptainActiveOrderDtoOutputOrderPickupPayment',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
