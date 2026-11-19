// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_menu_item_price_dto_price.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantMenuItemPriceDtoPrice extends MerchantMenuItemPriceDtoPrice {
  @override
  final String amount;
  @override
  final String currency;

  factory _$MerchantMenuItemPriceDtoPrice([
    void Function(MerchantMenuItemPriceDtoPriceBuilder)? updates,
  ]) => (MerchantMenuItemPriceDtoPriceBuilder()..update(updates))._build();

  _$MerchantMenuItemPriceDtoPrice._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  MerchantMenuItemPriceDtoPrice rebuild(
    void Function(MerchantMenuItemPriceDtoPriceBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantMenuItemPriceDtoPriceBuilder toBuilder() =>
      MerchantMenuItemPriceDtoPriceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantMenuItemPriceDtoPrice &&
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
    return (newBuiltValueToStringHelper(r'MerchantMenuItemPriceDtoPrice')
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class MerchantMenuItemPriceDtoPriceBuilder
    implements
        Builder<
          MerchantMenuItemPriceDtoPrice,
          MerchantMenuItemPriceDtoPriceBuilder
        > {
  _$MerchantMenuItemPriceDtoPrice? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  MerchantMenuItemPriceDtoPriceBuilder() {
    MerchantMenuItemPriceDtoPrice._defaults(this);
  }

  MerchantMenuItemPriceDtoPriceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantMenuItemPriceDtoPrice other) {
    _$v = other as _$MerchantMenuItemPriceDtoPrice;
  }

  @override
  void update(void Function(MerchantMenuItemPriceDtoPriceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantMenuItemPriceDtoPrice build() => _build();

  _$MerchantMenuItemPriceDtoPrice _build() {
    final _$result =
        _$v ??
        _$MerchantMenuItemPriceDtoPrice._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'MerchantMenuItemPriceDtoPrice',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'MerchantMenuItemPriceDtoPrice',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
