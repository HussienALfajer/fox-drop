// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_pickup_currencies_dto_output_base_currency.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantPickupCurrenciesDtoOutputBaseCurrency
    extends MerchantPickupCurrenciesDtoOutputBaseCurrency {
  @override
  final String currency;
  @override
  final String name;

  factory _$MerchantPickupCurrenciesDtoOutputBaseCurrency([
    void Function(MerchantPickupCurrenciesDtoOutputBaseCurrencyBuilder)?
    updates,
  ]) =>
      (MerchantPickupCurrenciesDtoOutputBaseCurrencyBuilder()..update(updates))
          ._build();

  _$MerchantPickupCurrenciesDtoOutputBaseCurrency._({
    required this.currency,
    required this.name,
  }) : super._();
  @override
  MerchantPickupCurrenciesDtoOutputBaseCurrency rebuild(
    void Function(MerchantPickupCurrenciesDtoOutputBaseCurrencyBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantPickupCurrenciesDtoOutputBaseCurrencyBuilder toBuilder() =>
      MerchantPickupCurrenciesDtoOutputBaseCurrencyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantPickupCurrenciesDtoOutputBaseCurrency &&
        currency == other.currency &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantPickupCurrenciesDtoOutputBaseCurrency',
          )
          ..add('currency', currency)
          ..add('name', name))
        .toString();
  }
}

class MerchantPickupCurrenciesDtoOutputBaseCurrencyBuilder
    implements
        Builder<
          MerchantPickupCurrenciesDtoOutputBaseCurrency,
          MerchantPickupCurrenciesDtoOutputBaseCurrencyBuilder
        > {
  _$MerchantPickupCurrenciesDtoOutputBaseCurrency? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  MerchantPickupCurrenciesDtoOutputBaseCurrencyBuilder() {
    MerchantPickupCurrenciesDtoOutputBaseCurrency._defaults(this);
  }

  MerchantPickupCurrenciesDtoOutputBaseCurrencyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantPickupCurrenciesDtoOutputBaseCurrency other) {
    _$v = other as _$MerchantPickupCurrenciesDtoOutputBaseCurrency;
  }

  @override
  void update(
    void Function(MerchantPickupCurrenciesDtoOutputBaseCurrencyBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantPickupCurrenciesDtoOutputBaseCurrency build() => _build();

  _$MerchantPickupCurrenciesDtoOutputBaseCurrency _build() {
    final _$result =
        _$v ??
        _$MerchantPickupCurrenciesDtoOutputBaseCurrency._(
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'MerchantPickupCurrenciesDtoOutputBaseCurrency',
            'currency',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'MerchantPickupCurrenciesDtoOutputBaseCurrency',
            'name',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
