// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_set_carried_currencies_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainSetCarriedCurrenciesDto extends CaptainSetCarriedCurrenciesDto {
  @override
  final BuiltList<String> currencies;

  factory _$CaptainSetCarriedCurrenciesDto([
    void Function(CaptainSetCarriedCurrenciesDtoBuilder)? updates,
  ]) => (CaptainSetCarriedCurrenciesDtoBuilder()..update(updates))._build();

  _$CaptainSetCarriedCurrenciesDto._({required this.currencies}) : super._();
  @override
  CaptainSetCarriedCurrenciesDto rebuild(
    void Function(CaptainSetCarriedCurrenciesDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainSetCarriedCurrenciesDtoBuilder toBuilder() =>
      CaptainSetCarriedCurrenciesDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainSetCarriedCurrenciesDto &&
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
      r'CaptainSetCarriedCurrenciesDto',
    )..add('currencies', currencies)).toString();
  }
}

class CaptainSetCarriedCurrenciesDtoBuilder
    implements
        Builder<
          CaptainSetCarriedCurrenciesDto,
          CaptainSetCarriedCurrenciesDtoBuilder
        > {
  _$CaptainSetCarriedCurrenciesDto? _$v;

  ListBuilder<String>? _currencies;
  ListBuilder<String> get currencies =>
      _$this._currencies ??= ListBuilder<String>();
  set currencies(ListBuilder<String>? currencies) =>
      _$this._currencies = currencies;

  CaptainSetCarriedCurrenciesDtoBuilder() {
    CaptainSetCarriedCurrenciesDto._defaults(this);
  }

  CaptainSetCarriedCurrenciesDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currencies = $v.currencies.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainSetCarriedCurrenciesDto other) {
    _$v = other as _$CaptainSetCarriedCurrenciesDto;
  }

  @override
  void update(void Function(CaptainSetCarriedCurrenciesDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainSetCarriedCurrenciesDto build() => _build();

  _$CaptainSetCarriedCurrenciesDto _build() {
    _$CaptainSetCarriedCurrenciesDto _$result;
    try {
      _$result =
          _$v ??
          _$CaptainSetCarriedCurrenciesDto._(currencies: currencies.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'currencies';
        currencies.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainSetCarriedCurrenciesDto',
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
