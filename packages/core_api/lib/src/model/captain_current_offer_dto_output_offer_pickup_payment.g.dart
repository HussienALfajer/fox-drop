// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_current_offer_dto_output_offer_pickup_payment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainCurrentOfferDtoOutputOfferPickupPayment
    extends CaptainCurrentOfferDtoOutputOfferPickupPayment {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CaptainCurrentOfferDtoOutputOfferPickupPayment([
    void Function(CaptainCurrentOfferDtoOutputOfferPickupPaymentBuilder)?
    updates,
  ]) =>
      (CaptainCurrentOfferDtoOutputOfferPickupPaymentBuilder()..update(updates))
          ._build();

  _$CaptainCurrentOfferDtoOutputOfferPickupPayment._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  CaptainCurrentOfferDtoOutputOfferPickupPayment rebuild(
    void Function(CaptainCurrentOfferDtoOutputOfferPickupPaymentBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainCurrentOfferDtoOutputOfferPickupPaymentBuilder toBuilder() =>
      CaptainCurrentOfferDtoOutputOfferPickupPaymentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainCurrentOfferDtoOutputOfferPickupPayment &&
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
            r'CaptainCurrentOfferDtoOutputOfferPickupPayment',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CaptainCurrentOfferDtoOutputOfferPickupPaymentBuilder
    implements
        Builder<
          CaptainCurrentOfferDtoOutputOfferPickupPayment,
          CaptainCurrentOfferDtoOutputOfferPickupPaymentBuilder
        > {
  _$CaptainCurrentOfferDtoOutputOfferPickupPayment? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CaptainCurrentOfferDtoOutputOfferPickupPaymentBuilder() {
    CaptainCurrentOfferDtoOutputOfferPickupPayment._defaults(this);
  }

  CaptainCurrentOfferDtoOutputOfferPickupPaymentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainCurrentOfferDtoOutputOfferPickupPayment other) {
    _$v = other as _$CaptainCurrentOfferDtoOutputOfferPickupPayment;
  }

  @override
  void update(
    void Function(CaptainCurrentOfferDtoOutputOfferPickupPaymentBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainCurrentOfferDtoOutputOfferPickupPayment build() => _build();

  _$CaptainCurrentOfferDtoOutputOfferPickupPayment _build() {
    final _$result =
        _$v ??
        _$CaptainCurrentOfferDtoOutputOfferPickupPayment._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CaptainCurrentOfferDtoOutputOfferPickupPayment',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CaptainCurrentOfferDtoOutputOfferPickupPayment',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
