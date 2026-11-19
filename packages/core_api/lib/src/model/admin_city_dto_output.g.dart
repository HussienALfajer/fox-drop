// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_city_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCityDtoOutput extends AdminCityDtoOutput {
  @override
  final AdminAllCitiesDtoOutputCitiesInner city;
  @override
  final BuiltList<AdminCityDtoOutputCurrenciesInner> currencies;
  @override
  final BuiltList<AdminCityDtoOutputOtherCurrenciesInner> otherCurrencies;
  @override
  final bool baseLocked;

  factory _$AdminCityDtoOutput([
    void Function(AdminCityDtoOutputBuilder)? updates,
  ]) => (AdminCityDtoOutputBuilder()..update(updates))._build();

  _$AdminCityDtoOutput._({
    required this.city,
    required this.currencies,
    required this.otherCurrencies,
    required this.baseLocked,
  }) : super._();
  @override
  AdminCityDtoOutput rebuild(
    void Function(AdminCityDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCityDtoOutputBuilder toBuilder() =>
      AdminCityDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCityDtoOutput &&
        city == other.city &&
        currencies == other.currencies &&
        otherCurrencies == other.otherCurrencies &&
        baseLocked == other.baseLocked;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, currencies.hashCode);
    _$hash = $jc(_$hash, otherCurrencies.hashCode);
    _$hash = $jc(_$hash, baseLocked.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCityDtoOutput')
          ..add('city', city)
          ..add('currencies', currencies)
          ..add('otherCurrencies', otherCurrencies)
          ..add('baseLocked', baseLocked))
        .toString();
  }
}

class AdminCityDtoOutputBuilder
    implements Builder<AdminCityDtoOutput, AdminCityDtoOutputBuilder> {
  _$AdminCityDtoOutput? _$v;

  AdminAllCitiesDtoOutputCitiesInnerBuilder? _city;
  AdminAllCitiesDtoOutputCitiesInnerBuilder get city =>
      _$this._city ??= AdminAllCitiesDtoOutputCitiesInnerBuilder();
  set city(AdminAllCitiesDtoOutputCitiesInnerBuilder? city) =>
      _$this._city = city;

  ListBuilder<AdminCityDtoOutputCurrenciesInner>? _currencies;
  ListBuilder<AdminCityDtoOutputCurrenciesInner> get currencies =>
      _$this._currencies ??= ListBuilder<AdminCityDtoOutputCurrenciesInner>();
  set currencies(ListBuilder<AdminCityDtoOutputCurrenciesInner>? currencies) =>
      _$this._currencies = currencies;

  ListBuilder<AdminCityDtoOutputOtherCurrenciesInner>? _otherCurrencies;
  ListBuilder<AdminCityDtoOutputOtherCurrenciesInner> get otherCurrencies =>
      _$this._otherCurrencies ??=
          ListBuilder<AdminCityDtoOutputOtherCurrenciesInner>();
  set otherCurrencies(
    ListBuilder<AdminCityDtoOutputOtherCurrenciesInner>? otherCurrencies,
  ) => _$this._otherCurrencies = otherCurrencies;

  bool? _baseLocked;
  bool? get baseLocked => _$this._baseLocked;
  set baseLocked(bool? baseLocked) => _$this._baseLocked = baseLocked;

  AdminCityDtoOutputBuilder() {
    AdminCityDtoOutput._defaults(this);
  }

  AdminCityDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _city = $v.city.toBuilder();
      _currencies = $v.currencies.toBuilder();
      _otherCurrencies = $v.otherCurrencies.toBuilder();
      _baseLocked = $v.baseLocked;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCityDtoOutput other) {
    _$v = other as _$AdminCityDtoOutput;
  }

  @override
  void update(void Function(AdminCityDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCityDtoOutput build() => _build();

  _$AdminCityDtoOutput _build() {
    _$AdminCityDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminCityDtoOutput._(
            city: city.build(),
            currencies: currencies.build(),
            otherCurrencies: otherCurrencies.build(),
            baseLocked: BuiltValueNullFieldError.checkNotNull(
              baseLocked,
              r'AdminCityDtoOutput',
              'baseLocked',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'city';
        city.build();
        _$failedField = 'currencies';
        currencies.build();
        _$failedField = 'otherCurrencies';
        otherCurrencies.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCityDtoOutput',
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
