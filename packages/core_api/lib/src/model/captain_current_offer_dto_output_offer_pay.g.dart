// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_current_offer_dto_output_offer_pay.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainCurrentOfferDtoOutputOfferPay
    extends CaptainCurrentOfferDtoOutputOfferPay {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CaptainCurrentOfferDtoOutputOfferPay([
    void Function(CaptainCurrentOfferDtoOutputOfferPayBuilder)? updates,
  ]) =>
      (CaptainCurrentOfferDtoOutputOfferPayBuilder()..update(updates))._build();

  _$CaptainCurrentOfferDtoOutputOfferPay._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  CaptainCurrentOfferDtoOutputOfferPay rebuild(
    void Function(CaptainCurrentOfferDtoOutputOfferPayBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainCurrentOfferDtoOutputOfferPayBuilder toBuilder() =>
      CaptainCurrentOfferDtoOutputOfferPayBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainCurrentOfferDtoOutputOfferPay &&
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
    return (newBuiltValueToStringHelper(r'CaptainCurrentOfferDtoOutputOfferPay')
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CaptainCurrentOfferDtoOutputOfferPayBuilder
    implements
        Builder<
          CaptainCurrentOfferDtoOutputOfferPay,
          CaptainCurrentOfferDtoOutputOfferPayBuilder
        > {
  _$CaptainCurrentOfferDtoOutputOfferPay? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CaptainCurrentOfferDtoOutputOfferPayBuilder() {
    CaptainCurrentOfferDtoOutputOfferPay._defaults(this);
  }

  CaptainCurrentOfferDtoOutputOfferPayBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainCurrentOfferDtoOutputOfferPay other) {
    _$v = other as _$CaptainCurrentOfferDtoOutputOfferPay;
  }

  @override
  void update(
    void Function(CaptainCurrentOfferDtoOutputOfferPayBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainCurrentOfferDtoOutputOfferPay build() => _build();

  _$CaptainCurrentOfferDtoOutputOfferPay _build() {
    final _$result =
        _$v ??
        _$CaptainCurrentOfferDtoOutputOfferPay._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CaptainCurrentOfferDtoOutputOfferPay',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CaptainCurrentOfferDtoOutputOfferPay',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
