// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_menu_dto_output_categories_inner_items_inner_price.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice
    extends MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice {
  @override
  final String amount;
  @override
  final String currency;

  factory _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice([
    void Function(MerchantMenuDtoOutputCategoriesInnerItemsInnerPriceBuilder)?
    updates,
  ]) =>
      (MerchantMenuDtoOutputCategoriesInnerItemsInnerPriceBuilder()
            ..update(updates))
          ._build();

  _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice rebuild(
    void Function(MerchantMenuDtoOutputCategoriesInnerItemsInnerPriceBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantMenuDtoOutputCategoriesInnerItemsInnerPriceBuilder toBuilder() =>
      MerchantMenuDtoOutputCategoriesInnerItemsInnerPriceBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice &&
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
            r'MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class MerchantMenuDtoOutputCategoriesInnerItemsInnerPriceBuilder
    implements
        Builder<
          MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice,
          MerchantMenuDtoOutputCategoriesInnerItemsInnerPriceBuilder
        > {
  _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  MerchantMenuDtoOutputCategoriesInnerItemsInnerPriceBuilder() {
    MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice._defaults(this);
  }

  MerchantMenuDtoOutputCategoriesInnerItemsInnerPriceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice other) {
    _$v = other as _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice;
  }

  @override
  void update(
    void Function(MerchantMenuDtoOutputCategoriesInnerItemsInnerPriceBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice build() => _build();

  _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice _build() {
    final _$result =
        _$v ??
        _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
