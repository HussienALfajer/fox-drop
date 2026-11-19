// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_menu_option_price_dto_price_delta.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantMenuOptionPriceDtoPriceDelta
    extends MerchantMenuOptionPriceDtoPriceDelta {
  @override
  final String amount;
  @override
  final String currency;

  factory _$MerchantMenuOptionPriceDtoPriceDelta([
    void Function(MerchantMenuOptionPriceDtoPriceDeltaBuilder)? updates,
  ]) =>
      (MerchantMenuOptionPriceDtoPriceDeltaBuilder()..update(updates))._build();

  _$MerchantMenuOptionPriceDtoPriceDelta._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  MerchantMenuOptionPriceDtoPriceDelta rebuild(
    void Function(MerchantMenuOptionPriceDtoPriceDeltaBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantMenuOptionPriceDtoPriceDeltaBuilder toBuilder() =>
      MerchantMenuOptionPriceDtoPriceDeltaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantMenuOptionPriceDtoPriceDelta &&
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
    return (newBuiltValueToStringHelper(r'MerchantMenuOptionPriceDtoPriceDelta')
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class MerchantMenuOptionPriceDtoPriceDeltaBuilder
    implements
        Builder<
          MerchantMenuOptionPriceDtoPriceDelta,
          MerchantMenuOptionPriceDtoPriceDeltaBuilder
        > {
  _$MerchantMenuOptionPriceDtoPriceDelta? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  MerchantMenuOptionPriceDtoPriceDeltaBuilder() {
    MerchantMenuOptionPriceDtoPriceDelta._defaults(this);
  }

  MerchantMenuOptionPriceDtoPriceDeltaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantMenuOptionPriceDtoPriceDelta other) {
    _$v = other as _$MerchantMenuOptionPriceDtoPriceDelta;
  }

  @override
  void update(
    void Function(MerchantMenuOptionPriceDtoPriceDeltaBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantMenuOptionPriceDtoPriceDelta build() => _build();

  _$MerchantMenuOptionPriceDtoPriceDelta _build() {
    final _$result =
        _$v ??
        _$MerchantMenuOptionPriceDtoPriceDelta._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'MerchantMenuOptionPriceDtoPriceDelta',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'MerchantMenuOptionPriceDtoPriceDelta',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
