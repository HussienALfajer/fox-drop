// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_quote_dto_output_rates_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerQuoteDtoOutputRatesInner
    extends CustomerQuoteDtoOutputRatesInner {
  @override
  final String currency;
  @override
  final String? rateVersionId;

  factory _$CustomerQuoteDtoOutputRatesInner([
    void Function(CustomerQuoteDtoOutputRatesInnerBuilder)? updates,
  ]) => (CustomerQuoteDtoOutputRatesInnerBuilder()..update(updates))._build();

  _$CustomerQuoteDtoOutputRatesInner._({
    required this.currency,
    this.rateVersionId,
  }) : super._();
  @override
  CustomerQuoteDtoOutputRatesInner rebuild(
    void Function(CustomerQuoteDtoOutputRatesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerQuoteDtoOutputRatesInnerBuilder toBuilder() =>
      CustomerQuoteDtoOutputRatesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerQuoteDtoOutputRatesInner &&
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
    return (newBuiltValueToStringHelper(r'CustomerQuoteDtoOutputRatesInner')
          ..add('currency', currency)
          ..add('rateVersionId', rateVersionId))
        .toString();
  }
}

class CustomerQuoteDtoOutputRatesInnerBuilder
    implements
        Builder<
          CustomerQuoteDtoOutputRatesInner,
          CustomerQuoteDtoOutputRatesInnerBuilder
        > {
  _$CustomerQuoteDtoOutputRatesInner? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _rateVersionId;
  String? get rateVersionId => _$this._rateVersionId;
  set rateVersionId(String? rateVersionId) =>
      _$this._rateVersionId = rateVersionId;

  CustomerQuoteDtoOutputRatesInnerBuilder() {
    CustomerQuoteDtoOutputRatesInner._defaults(this);
  }

  CustomerQuoteDtoOutputRatesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _rateVersionId = $v.rateVersionId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerQuoteDtoOutputRatesInner other) {
    _$v = other as _$CustomerQuoteDtoOutputRatesInner;
  }

  @override
  void update(void Function(CustomerQuoteDtoOutputRatesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerQuoteDtoOutputRatesInner build() => _build();

  _$CustomerQuoteDtoOutputRatesInner _build() {
    final _$result =
        _$v ??
        _$CustomerQuoteDtoOutputRatesInner._(
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CustomerQuoteDtoOutputRatesInner',
            'currency',
          ),
          rateVersionId: rateVersionId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
