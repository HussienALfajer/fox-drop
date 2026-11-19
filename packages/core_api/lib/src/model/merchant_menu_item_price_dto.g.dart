// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_menu_item_price_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantMenuItemPriceDto extends MerchantMenuItemPriceDto {
  @override
  final MerchantMenuItemPriceDtoPrice price;

  factory _$MerchantMenuItemPriceDto([
    void Function(MerchantMenuItemPriceDtoBuilder)? updates,
  ]) => (MerchantMenuItemPriceDtoBuilder()..update(updates))._build();

  _$MerchantMenuItemPriceDto._({required this.price}) : super._();
  @override
  MerchantMenuItemPriceDto rebuild(
    void Function(MerchantMenuItemPriceDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantMenuItemPriceDtoBuilder toBuilder() =>
      MerchantMenuItemPriceDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantMenuItemPriceDto && price == other.price;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'MerchantMenuItemPriceDto',
    )..add('price', price)).toString();
  }
}

class MerchantMenuItemPriceDtoBuilder
    implements
        Builder<MerchantMenuItemPriceDto, MerchantMenuItemPriceDtoBuilder> {
  _$MerchantMenuItemPriceDto? _$v;

  MerchantMenuItemPriceDtoPriceBuilder? _price;
  MerchantMenuItemPriceDtoPriceBuilder get price =>
      _$this._price ??= MerchantMenuItemPriceDtoPriceBuilder();
  set price(MerchantMenuItemPriceDtoPriceBuilder? price) =>
      _$this._price = price;

  MerchantMenuItemPriceDtoBuilder() {
    MerchantMenuItemPriceDto._defaults(this);
  }

  MerchantMenuItemPriceDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _price = $v.price.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantMenuItemPriceDto other) {
    _$v = other as _$MerchantMenuItemPriceDto;
  }

  @override
  void update(void Function(MerchantMenuItemPriceDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantMenuItemPriceDto build() => _build();

  _$MerchantMenuItemPriceDto _build() {
    _$MerchantMenuItemPriceDto _$result;
    try {
      _$result = _$v ?? _$MerchantMenuItemPriceDto._(price: price.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'price';
        price.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantMenuItemPriceDto',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
