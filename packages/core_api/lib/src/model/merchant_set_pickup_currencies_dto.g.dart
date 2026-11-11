// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_set_pickup_currencies_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantSetPickupCurrenciesDto extends MerchantSetPickupCurrenciesDto {
  @override
  final BuiltList<String> currencies;

  factory _$MerchantSetPickupCurrenciesDto([
    void Function(MerchantSetPickupCurrenciesDtoBuilder)? updates,
  ]) => (MerchantSetPickupCurrenciesDtoBuilder()..update(updates))._build();

  _$MerchantSetPickupCurrenciesDto._({required this.currencies}) : super._();
  @override
  MerchantSetPickupCurrenciesDto rebuild(
    void Function(MerchantSetPickupCurrenciesDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantSetPickupCurrenciesDtoBuilder toBuilder() =>
      MerchantSetPickupCurrenciesDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantSetPickupCurrenciesDto &&
        currencies == other.currencies;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currencies.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'MerchantSetPickupCurrenciesDto',
    )..add('currencies', currencies)).toString();
  }
}

class MerchantSetPickupCurrenciesDtoBuilder
    implements
        Builder<
          MerchantSetPickupCurrenciesDto,
          MerchantSetPickupCurrenciesDtoBuilder
        > {
  _$MerchantSetPickupCurrenciesDto? _$v;

  ListBuilder<String>? _currencies;
  ListBuilder<String> get currencies =>
      _$this._currencies ??= ListBuilder<String>();
  set currencies(ListBuilder<String>? currencies) =>
      _$this._currencies = currencies;

  MerchantSetPickupCurrenciesDtoBuilder() {
    MerchantSetPickupCurrenciesDto._defaults(this);
  }

  MerchantSetPickupCurrenciesDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currencies = $v.currencies.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantSetPickupCurrenciesDto other) {
    _$v = other as _$MerchantSetPickupCurrenciesDto;
  }

  @override
  void update(void Function(MerchantSetPickupCurrenciesDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantSetPickupCurrenciesDto build() => _build();

  _$MerchantSetPickupCurrenciesDto _build() {
    _$MerchantSetPickupCurrenciesDto _$result;
    try {
      _$result =
          _$v ??
          _$MerchantSetPickupCurrenciesDto._(currencies: currencies.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'currencies';
        currencies.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantSetPickupCurrenciesDto',
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
