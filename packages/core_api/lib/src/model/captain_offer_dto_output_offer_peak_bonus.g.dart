// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_offer_dto_output_offer_peak_bonus.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainOfferDtoOutputOfferPeakBonus
    extends CaptainOfferDtoOutputOfferPeakBonus {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CaptainOfferDtoOutputOfferPeakBonus([
    void Function(CaptainOfferDtoOutputOfferPeakBonusBuilder)? updates,
  ]) =>
      (CaptainOfferDtoOutputOfferPeakBonusBuilder()..update(updates))._build();

  _$CaptainOfferDtoOutputOfferPeakBonus._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  CaptainOfferDtoOutputOfferPeakBonus rebuild(
    void Function(CaptainOfferDtoOutputOfferPeakBonusBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainOfferDtoOutputOfferPeakBonusBuilder toBuilder() =>
      CaptainOfferDtoOutputOfferPeakBonusBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainOfferDtoOutputOfferPeakBonus &&
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
    return (newBuiltValueToStringHelper(r'CaptainOfferDtoOutputOfferPeakBonus')
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CaptainOfferDtoOutputOfferPeakBonusBuilder
    implements
        Builder<
          CaptainOfferDtoOutputOfferPeakBonus,
          CaptainOfferDtoOutputOfferPeakBonusBuilder
        > {
  _$CaptainOfferDtoOutputOfferPeakBonus? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CaptainOfferDtoOutputOfferPeakBonusBuilder() {
    CaptainOfferDtoOutputOfferPeakBonus._defaults(this);
  }

  CaptainOfferDtoOutputOfferPeakBonusBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainOfferDtoOutputOfferPeakBonus other) {
    _$v = other as _$CaptainOfferDtoOutputOfferPeakBonus;
  }

  @override
  void update(
    void Function(CaptainOfferDtoOutputOfferPeakBonusBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainOfferDtoOutputOfferPeakBonus build() => _build();

  _$CaptainOfferDtoOutputOfferPeakBonus _build() {
    final _$result =
        _$v ??
        _$CaptainOfferDtoOutputOfferPeakBonus._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CaptainOfferDtoOutputOfferPeakBonus',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CaptainOfferDtoOutputOfferPeakBonus',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
