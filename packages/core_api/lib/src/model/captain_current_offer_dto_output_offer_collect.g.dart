// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_current_offer_dto_output_offer_collect.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainCurrentOfferDtoOutputOfferCollect
    extends CaptainCurrentOfferDtoOutputOfferCollect {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CaptainCurrentOfferDtoOutputOfferCollect([
    void Function(CaptainCurrentOfferDtoOutputOfferCollectBuilder)? updates,
  ]) => (CaptainCurrentOfferDtoOutputOfferCollectBuilder()..update(updates))
      ._build();

  _$CaptainCurrentOfferDtoOutputOfferCollect._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  CaptainCurrentOfferDtoOutputOfferCollect rebuild(
    void Function(CaptainCurrentOfferDtoOutputOfferCollectBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainCurrentOfferDtoOutputOfferCollectBuilder toBuilder() =>
      CaptainCurrentOfferDtoOutputOfferCollectBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainCurrentOfferDtoOutputOfferCollect &&
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
            r'CaptainCurrentOfferDtoOutputOfferCollect',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CaptainCurrentOfferDtoOutputOfferCollectBuilder
    implements
        Builder<
          CaptainCurrentOfferDtoOutputOfferCollect,
          CaptainCurrentOfferDtoOutputOfferCollectBuilder
        > {
  _$CaptainCurrentOfferDtoOutputOfferCollect? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CaptainCurrentOfferDtoOutputOfferCollectBuilder() {
    CaptainCurrentOfferDtoOutputOfferCollect._defaults(this);
  }

  CaptainCurrentOfferDtoOutputOfferCollectBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainCurrentOfferDtoOutputOfferCollect other) {
    _$v = other as _$CaptainCurrentOfferDtoOutputOfferCollect;
  }

  @override
  void update(
    void Function(CaptainCurrentOfferDtoOutputOfferCollectBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainCurrentOfferDtoOutputOfferCollect build() => _build();

  _$CaptainCurrentOfferDtoOutputOfferCollect _build() {
    final _$result =
        _$v ??
        _$CaptainCurrentOfferDtoOutputOfferCollect._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CaptainCurrentOfferDtoOutputOfferCollect',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CaptainCurrentOfferDtoOutputOfferCollect',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
