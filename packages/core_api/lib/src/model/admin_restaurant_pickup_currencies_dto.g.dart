// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_pickup_currencies_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantPickupCurrenciesDto
    extends AdminRestaurantPickupCurrenciesDto {
  @override
  final BuiltList<String> currencies;

  factory _$AdminRestaurantPickupCurrenciesDto([
    void Function(AdminRestaurantPickupCurrenciesDtoBuilder)? updates,
  ]) => (AdminRestaurantPickupCurrenciesDtoBuilder()..update(updates))._build();

  _$AdminRestaurantPickupCurrenciesDto._({required this.currencies})
    : super._();
  @override
  AdminRestaurantPickupCurrenciesDto rebuild(
    void Function(AdminRestaurantPickupCurrenciesDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantPickupCurrenciesDtoBuilder toBuilder() =>
      AdminRestaurantPickupCurrenciesDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantPickupCurrenciesDto &&
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
      r'AdminRestaurantPickupCurrenciesDto',
    )..add('currencies', currencies)).toString();
  }
}

class AdminRestaurantPickupCurrenciesDtoBuilder
    implements
        Builder<
          AdminRestaurantPickupCurrenciesDto,
          AdminRestaurantPickupCurrenciesDtoBuilder
        > {
  _$AdminRestaurantPickupCurrenciesDto? _$v;

  ListBuilder<String>? _currencies;
  ListBuilder<String> get currencies =>
      _$this._currencies ??= ListBuilder<String>();
  set currencies(ListBuilder<String>? currencies) =>
      _$this._currencies = currencies;

  AdminRestaurantPickupCurrenciesDtoBuilder() {
    AdminRestaurantPickupCurrenciesDto._defaults(this);
  }

  AdminRestaurantPickupCurrenciesDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currencies = $v.currencies.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantPickupCurrenciesDto other) {
    _$v = other as _$AdminRestaurantPickupCurrenciesDto;
  }

  @override
  void update(
    void Function(AdminRestaurantPickupCurrenciesDtoBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantPickupCurrenciesDto build() => _build();

  _$AdminRestaurantPickupCurrenciesDto _build() {
    _$AdminRestaurantPickupCurrenciesDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantPickupCurrenciesDto._(
            currencies: currencies.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'currencies';
        currencies.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantPickupCurrenciesDto',
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
