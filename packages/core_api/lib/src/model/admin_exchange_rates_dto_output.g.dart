// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_exchange_rates_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminExchangeRatesDtoOutput extends AdminExchangeRatesDtoOutput {
  @override
  final String? baseCurrency;
  @override
  final int staleAlertHours;
  @override
  final num largeChangePct;
  @override
  final BuiltList<AdminExchangeRatesDtoOutputCurrenciesInner> currencies;

  factory _$AdminExchangeRatesDtoOutput([
    void Function(AdminExchangeRatesDtoOutputBuilder)? updates,
  ]) => (AdminExchangeRatesDtoOutputBuilder()..update(updates))._build();

  _$AdminExchangeRatesDtoOutput._({
    this.baseCurrency,
    required this.staleAlertHours,
    required this.largeChangePct,
    required this.currencies,
  }) : super._();
  @override
  AdminExchangeRatesDtoOutput rebuild(
    void Function(AdminExchangeRatesDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminExchangeRatesDtoOutputBuilder toBuilder() =>
      AdminExchangeRatesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminExchangeRatesDtoOutput &&
        baseCurrency == other.baseCurrency &&
        staleAlertHours == other.staleAlertHours &&
        largeChangePct == other.largeChangePct &&
        currencies == other.currencies;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, baseCurrency.hashCode);
    _$hash = $jc(_$hash, staleAlertHours.hashCode);
    _$hash = $jc(_$hash, largeChangePct.hashCode);
    _$hash = $jc(_$hash, currencies.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminExchangeRatesDtoOutput')
          ..add('baseCurrency', baseCurrency)
          ..add('staleAlertHours', staleAlertHours)
          ..add('largeChangePct', largeChangePct)
          ..add('currencies', currencies))
        .toString();
  }
}

class AdminExchangeRatesDtoOutputBuilder
    implements
        Builder<
          AdminExchangeRatesDtoOutput,
          AdminExchangeRatesDtoOutputBuilder
        > {
  _$AdminExchangeRatesDtoOutput? _$v;

  String? _baseCurrency;
  String? get baseCurrency => _$this._baseCurrency;
  set baseCurrency(String? baseCurrency) => _$this._baseCurrency = baseCurrency;

  int? _staleAlertHours;
  int? get staleAlertHours => _$this._staleAlertHours;
  set staleAlertHours(int? staleAlertHours) =>
      _$this._staleAlertHours = staleAlertHours;

  num? _largeChangePct;
  num? get largeChangePct => _$this._largeChangePct;
  set largeChangePct(num? largeChangePct) =>
      _$this._largeChangePct = largeChangePct;

  ListBuilder<AdminExchangeRatesDtoOutputCurrenciesInner>? _currencies;
  ListBuilder<AdminExchangeRatesDtoOutputCurrenciesInner> get currencies =>
      _$this._currencies ??=
          ListBuilder<AdminExchangeRatesDtoOutputCurrenciesInner>();
  set currencies(
    ListBuilder<AdminExchangeRatesDtoOutputCurrenciesInner>? currencies,
  ) => _$this._currencies = currencies;

  AdminExchangeRatesDtoOutputBuilder() {
    AdminExchangeRatesDtoOutput._defaults(this);
  }

  AdminExchangeRatesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _baseCurrency = $v.baseCurrency;
      _staleAlertHours = $v.staleAlertHours;
      _largeChangePct = $v.largeChangePct;
      _currencies = $v.currencies.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminExchangeRatesDtoOutput other) {
    _$v = other as _$AdminExchangeRatesDtoOutput;
  }

  @override
  void update(void Function(AdminExchangeRatesDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminExchangeRatesDtoOutput build() => _build();

  _$AdminExchangeRatesDtoOutput _build() {
    _$AdminExchangeRatesDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminExchangeRatesDtoOutput._(
            baseCurrency: baseCurrency,
            staleAlertHours: BuiltValueNullFieldError.checkNotNull(
              staleAlertHours,
              r'AdminExchangeRatesDtoOutput',
              'staleAlertHours',
            ),
            largeChangePct: BuiltValueNullFieldError.checkNotNull(
              largeChangePct,
              r'AdminExchangeRatesDtoOutput',
              'largeChangePct',
            ),
            currencies: currencies.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'currencies';
        currencies.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminExchangeRatesDtoOutput',
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
