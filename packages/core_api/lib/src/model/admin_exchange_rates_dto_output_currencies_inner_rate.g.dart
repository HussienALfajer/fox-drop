// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_exchange_rates_dto_output_currencies_inner_rate.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminExchangeRatesDtoOutputCurrenciesInnerRate
    extends AdminExchangeRatesDtoOutputCurrenciesInnerRate {
  @override
  final String versionId;
  @override
  final String baseCurrency;
  @override
  final String numerator;
  @override
  final String denominator;
  @override
  final String editorId;
  @override
  final String? editorName;
  @override
  final String? reason;
  @override
  final DateTime setAt;

  factory _$AdminExchangeRatesDtoOutputCurrenciesInnerRate([
    void Function(AdminExchangeRatesDtoOutputCurrenciesInnerRateBuilder)?
    updates,
  ]) =>
      (AdminExchangeRatesDtoOutputCurrenciesInnerRateBuilder()..update(updates))
          ._build();

  _$AdminExchangeRatesDtoOutputCurrenciesInnerRate._({
    required this.versionId,
    required this.baseCurrency,
    required this.numerator,
    required this.denominator,
    required this.editorId,
    this.editorName,
    this.reason,
    required this.setAt,
  }) : super._();
  @override
  AdminExchangeRatesDtoOutputCurrenciesInnerRate rebuild(
    void Function(AdminExchangeRatesDtoOutputCurrenciesInnerRateBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminExchangeRatesDtoOutputCurrenciesInnerRateBuilder toBuilder() =>
      AdminExchangeRatesDtoOutputCurrenciesInnerRateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminExchangeRatesDtoOutputCurrenciesInnerRate &&
        versionId == other.versionId &&
        baseCurrency == other.baseCurrency &&
        numerator == other.numerator &&
        denominator == other.denominator &&
        editorId == other.editorId &&
        editorName == other.editorName &&
        reason == other.reason &&
        setAt == other.setAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, versionId.hashCode);
    _$hash = $jc(_$hash, baseCurrency.hashCode);
    _$hash = $jc(_$hash, numerator.hashCode);
    _$hash = $jc(_$hash, denominator.hashCode);
    _$hash = $jc(_$hash, editorId.hashCode);
    _$hash = $jc(_$hash, editorName.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, setAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminExchangeRatesDtoOutputCurrenciesInnerRate',
          )
          ..add('versionId', versionId)
          ..add('baseCurrency', baseCurrency)
          ..add('numerator', numerator)
          ..add('denominator', denominator)
          ..add('editorId', editorId)
          ..add('editorName', editorName)
          ..add('reason', reason)
          ..add('setAt', setAt))
        .toString();
  }
}

class AdminExchangeRatesDtoOutputCurrenciesInnerRateBuilder
    implements
        Builder<
          AdminExchangeRatesDtoOutputCurrenciesInnerRate,
          AdminExchangeRatesDtoOutputCurrenciesInnerRateBuilder
        > {
  _$AdminExchangeRatesDtoOutputCurrenciesInnerRate? _$v;

  String? _versionId;
  String? get versionId => _$this._versionId;
  set versionId(String? versionId) => _$this._versionId = versionId;

  String? _baseCurrency;
  String? get baseCurrency => _$this._baseCurrency;
  set baseCurrency(String? baseCurrency) => _$this._baseCurrency = baseCurrency;

  String? _numerator;
  String? get numerator => _$this._numerator;
  set numerator(String? numerator) => _$this._numerator = numerator;

  String? _denominator;
  String? get denominator => _$this._denominator;
  set denominator(String? denominator) => _$this._denominator = denominator;

  String? _editorId;
  String? get editorId => _$this._editorId;
  set editorId(String? editorId) => _$this._editorId = editorId;

  String? _editorName;
  String? get editorName => _$this._editorName;
  set editorName(String? editorName) => _$this._editorName = editorName;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DateTime? _setAt;
  DateTime? get setAt => _$this._setAt;
  set setAt(DateTime? setAt) => _$this._setAt = setAt;

  AdminExchangeRatesDtoOutputCurrenciesInnerRateBuilder() {
    AdminExchangeRatesDtoOutputCurrenciesInnerRate._defaults(this);
  }

  AdminExchangeRatesDtoOutputCurrenciesInnerRateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _versionId = $v.versionId;
      _baseCurrency = $v.baseCurrency;
      _numerator = $v.numerator;
      _denominator = $v.denominator;
      _editorId = $v.editorId;
      _editorName = $v.editorName;
      _reason = $v.reason;
      _setAt = $v.setAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminExchangeRatesDtoOutputCurrenciesInnerRate other) {
    _$v = other as _$AdminExchangeRatesDtoOutputCurrenciesInnerRate;
  }

  @override
  void update(
    void Function(AdminExchangeRatesDtoOutputCurrenciesInnerRateBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminExchangeRatesDtoOutputCurrenciesInnerRate build() => _build();

  _$AdminExchangeRatesDtoOutputCurrenciesInnerRate _build() {
    final _$result =
        _$v ??
        _$AdminExchangeRatesDtoOutputCurrenciesInnerRate._(
          versionId: BuiltValueNullFieldError.checkNotNull(
            versionId,
            r'AdminExchangeRatesDtoOutputCurrenciesInnerRate',
            'versionId',
          ),
          baseCurrency: BuiltValueNullFieldError.checkNotNull(
            baseCurrency,
            r'AdminExchangeRatesDtoOutputCurrenciesInnerRate',
            'baseCurrency',
          ),
          numerator: BuiltValueNullFieldError.checkNotNull(
            numerator,
            r'AdminExchangeRatesDtoOutputCurrenciesInnerRate',
            'numerator',
          ),
          denominator: BuiltValueNullFieldError.checkNotNull(
            denominator,
            r'AdminExchangeRatesDtoOutputCurrenciesInnerRate',
            'denominator',
          ),
          editorId: BuiltValueNullFieldError.checkNotNull(
            editorId,
            r'AdminExchangeRatesDtoOutputCurrenciesInnerRate',
            'editorId',
          ),
          editorName: editorName,
          reason: reason,
          setAt: BuiltValueNullFieldError.checkNotNull(
            setAt,
            r'AdminExchangeRatesDtoOutputCurrenciesInnerRate',
            'setAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
