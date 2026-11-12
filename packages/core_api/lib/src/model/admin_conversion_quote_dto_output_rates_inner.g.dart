// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_conversion_quote_dto_output_rates_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminConversionQuoteDtoOutputRatesInner
    extends AdminConversionQuoteDtoOutputRatesInner {
  @override
  final String currency;
  @override
  final String rateVersionId;

  factory _$AdminConversionQuoteDtoOutputRatesInner([
    void Function(AdminConversionQuoteDtoOutputRatesInnerBuilder)? updates,
  ]) => (AdminConversionQuoteDtoOutputRatesInnerBuilder()..update(updates))
      ._build();

  _$AdminConversionQuoteDtoOutputRatesInner._({
    required this.currency,
    required this.rateVersionId,
  }) : super._();
  @override
  AdminConversionQuoteDtoOutputRatesInner rebuild(
    void Function(AdminConversionQuoteDtoOutputRatesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminConversionQuoteDtoOutputRatesInnerBuilder toBuilder() =>
      AdminConversionQuoteDtoOutputRatesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminConversionQuoteDtoOutputRatesInner &&
        currency == other.currency &&
        rateVersionId == other.rateVersionId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, rateVersionId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminConversionQuoteDtoOutputRatesInner',
          )
          ..add('currency', currency)
          ..add('rateVersionId', rateVersionId))
        .toString();
  }
}

class AdminConversionQuoteDtoOutputRatesInnerBuilder
    implements
        Builder<
          AdminConversionQuoteDtoOutputRatesInner,
          AdminConversionQuoteDtoOutputRatesInnerBuilder
        > {
  _$AdminConversionQuoteDtoOutputRatesInner? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _rateVersionId;
  String? get rateVersionId => _$this._rateVersionId;
  set rateVersionId(String? rateVersionId) =>
      _$this._rateVersionId = rateVersionId;

  AdminConversionQuoteDtoOutputRatesInnerBuilder() {
    AdminConversionQuoteDtoOutputRatesInner._defaults(this);
  }

  AdminConversionQuoteDtoOutputRatesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _rateVersionId = $v.rateVersionId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminConversionQuoteDtoOutputRatesInner other) {
    _$v = other as _$AdminConversionQuoteDtoOutputRatesInner;
  }

  @override
  void update(
    void Function(AdminConversionQuoteDtoOutputRatesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminConversionQuoteDtoOutputRatesInner build() => _build();

  _$AdminConversionQuoteDtoOutputRatesInner _build() {
    final _$result =
        _$v ??
        _$AdminConversionQuoteDtoOutputRatesInner._(
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminConversionQuoteDtoOutputRatesInner',
            'currency',
          ),
          rateVersionId: BuiltValueNullFieldError.checkNotNull(
            rateVersionId,
            r'AdminConversionQuoteDtoOutputRatesInner',
            'rateVersionId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
