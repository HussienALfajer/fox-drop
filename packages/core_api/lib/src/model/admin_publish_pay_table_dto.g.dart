// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_publish_pay_table_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPublishPayTableDto extends AdminPublishPayTableDto {
  @override
  final String cityId;
  @override
  final String currency;
  @override
  final DateTime effectiveFrom;
  @override
  final BuiltList<AdminPublishPayTableDtoRatesInner> rates;
  @override
  final String reason;

  factory _$AdminPublishPayTableDto([
    void Function(AdminPublishPayTableDtoBuilder)? updates,
  ]) => (AdminPublishPayTableDtoBuilder()..update(updates))._build();

  _$AdminPublishPayTableDto._({
    required this.cityId,
    required this.currency,
    required this.effectiveFrom,
    required this.rates,
    required this.reason,
  }) : super._();
  @override
  AdminPublishPayTableDto rebuild(
    void Function(AdminPublishPayTableDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminPublishPayTableDtoBuilder toBuilder() =>
      AdminPublishPayTableDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPublishPayTableDto &&
        cityId == other.cityId &&
        currency == other.currency &&
        effectiveFrom == other.effectiveFrom &&
        rates == other.rates &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, effectiveFrom.hashCode);
    _$hash = $jc(_$hash, rates.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminPublishPayTableDto')
          ..add('cityId', cityId)
          ..add('currency', currency)
          ..add('effectiveFrom', effectiveFrom)
          ..add('rates', rates)
          ..add('reason', reason))
        .toString();
  }
}

class AdminPublishPayTableDtoBuilder
    implements
        Builder<AdminPublishPayTableDto, AdminPublishPayTableDtoBuilder> {
  _$AdminPublishPayTableDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  DateTime? _effectiveFrom;
  DateTime? get effectiveFrom => _$this._effectiveFrom;
  set effectiveFrom(DateTime? effectiveFrom) =>
      _$this._effectiveFrom = effectiveFrom;

  ListBuilder<AdminPublishPayTableDtoRatesInner>? _rates;
  ListBuilder<AdminPublishPayTableDtoRatesInner> get rates =>
      _$this._rates ??= ListBuilder<AdminPublishPayTableDtoRatesInner>();
  set rates(ListBuilder<AdminPublishPayTableDtoRatesInner>? rates) =>
      _$this._rates = rates;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminPublishPayTableDtoBuilder() {
    AdminPublishPayTableDto._defaults(this);
  }

  AdminPublishPayTableDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _currency = $v.currency;
      _effectiveFrom = $v.effectiveFrom;
      _rates = $v.rates.toBuilder();
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPublishPayTableDto other) {
    _$v = other as _$AdminPublishPayTableDto;
  }

  @override
  void update(void Function(AdminPublishPayTableDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPublishPayTableDto build() => _build();

  _$AdminPublishPayTableDto _build() {
    _$AdminPublishPayTableDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminPublishPayTableDto._(
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminPublishPayTableDto',
              'cityId',
            ),
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminPublishPayTableDto',
              'currency',
            ),
            effectiveFrom: BuiltValueNullFieldError.checkNotNull(
              effectiveFrom,
              r'AdminPublishPayTableDto',
              'effectiveFrom',
            ),
            rates: rates.build(),
            reason: BuiltValueNullFieldError.checkNotNull(
              reason,
              r'AdminPublishPayTableDto',
              'reason',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rates';
        rates.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminPublishPayTableDto',
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
