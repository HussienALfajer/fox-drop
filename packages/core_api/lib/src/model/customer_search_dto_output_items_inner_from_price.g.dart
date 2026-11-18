// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_search_dto_output_items_inner_from_price.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerSearchDtoOutputItemsInnerFromPrice
    extends CustomerSearchDtoOutputItemsInnerFromPrice {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CustomerSearchDtoOutputItemsInnerFromPrice([
    void Function(CustomerSearchDtoOutputItemsInnerFromPriceBuilder)? updates,
  ]) => (CustomerSearchDtoOutputItemsInnerFromPriceBuilder()..update(updates))
      ._build();

  _$CustomerSearchDtoOutputItemsInnerFromPrice._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  CustomerSearchDtoOutputItemsInnerFromPrice rebuild(
    void Function(CustomerSearchDtoOutputItemsInnerFromPriceBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerSearchDtoOutputItemsInnerFromPriceBuilder toBuilder() =>
      CustomerSearchDtoOutputItemsInnerFromPriceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerSearchDtoOutputItemsInnerFromPrice &&
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
            r'CustomerSearchDtoOutputItemsInnerFromPrice',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CustomerSearchDtoOutputItemsInnerFromPriceBuilder
    implements
        Builder<
          CustomerSearchDtoOutputItemsInnerFromPrice,
          CustomerSearchDtoOutputItemsInnerFromPriceBuilder
        > {
  _$CustomerSearchDtoOutputItemsInnerFromPrice? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CustomerSearchDtoOutputItemsInnerFromPriceBuilder() {
    CustomerSearchDtoOutputItemsInnerFromPrice._defaults(this);
  }

  CustomerSearchDtoOutputItemsInnerFromPriceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerSearchDtoOutputItemsInnerFromPrice other) {
    _$v = other as _$CustomerSearchDtoOutputItemsInnerFromPrice;
  }

  @override
  void update(
    void Function(CustomerSearchDtoOutputItemsInnerFromPriceBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerSearchDtoOutputItemsInnerFromPrice build() => _build();

  _$CustomerSearchDtoOutputItemsInnerFromPrice _build() {
    final _$result =
        _$v ??
        _$CustomerSearchDtoOutputItemsInnerFromPrice._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CustomerSearchDtoOutputItemsInnerFromPrice',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CustomerSearchDtoOutputItemsInnerFromPrice',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
