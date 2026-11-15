// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_settlement_preview_dto_output_payout.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSettlementPreviewDtoOutputPayout
    extends AdminSettlementPreviewDtoOutputPayout {
  @override
  final String currency;
  @override
  final String amount;
  @override
  final BuiltList<AdminSettlementPreviewDtoOutputPayoutRatesInner> rates;
  @override
  final AdminSettlementPreviewDtoOutputPayoutUnit? unit;

  factory _$AdminSettlementPreviewDtoOutputPayout([
    void Function(AdminSettlementPreviewDtoOutputPayoutBuilder)? updates,
  ]) => (AdminSettlementPreviewDtoOutputPayoutBuilder()..update(updates))
      ._build();

  _$AdminSettlementPreviewDtoOutputPayout._({
    required this.currency,
    required this.amount,
    required this.rates,
    this.unit,
  }) : super._();
  @override
  AdminSettlementPreviewDtoOutputPayout rebuild(
    void Function(AdminSettlementPreviewDtoOutputPayoutBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSettlementPreviewDtoOutputPayoutBuilder toBuilder() =>
      AdminSettlementPreviewDtoOutputPayoutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSettlementPreviewDtoOutputPayout &&
        currency == other.currency &&
        amount == other.amount &&
        rates == other.rates &&
        unit == other.unit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, rates.hashCode);
    _$hash = $jc(_$hash, unit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminSettlementPreviewDtoOutputPayout',
          )
          ..add('currency', currency)
          ..add('amount', amount)
          ..add('rates', rates)
          ..add('unit', unit))
        .toString();
  }
}

class AdminSettlementPreviewDtoOutputPayoutBuilder
    implements
        Builder<
          AdminSettlementPreviewDtoOutputPayout,
          AdminSettlementPreviewDtoOutputPayoutBuilder
        > {
  _$AdminSettlementPreviewDtoOutputPayout? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  ListBuilder<AdminSettlementPreviewDtoOutputPayoutRatesInner>? _rates;
  ListBuilder<AdminSettlementPreviewDtoOutputPayoutRatesInner> get rates =>
      _$this._rates ??=
          ListBuilder<AdminSettlementPreviewDtoOutputPayoutRatesInner>();
  set rates(
    ListBuilder<AdminSettlementPreviewDtoOutputPayoutRatesInner>? rates,
  ) => _$this._rates = rates;

  AdminSettlementPreviewDtoOutputPayoutUnitBuilder? _unit;
  AdminSettlementPreviewDtoOutputPayoutUnitBuilder get unit =>
      _$this._unit ??= AdminSettlementPreviewDtoOutputPayoutUnitBuilder();
  set unit(AdminSettlementPreviewDtoOutputPayoutUnitBuilder? unit) =>
      _$this._unit = unit;

  AdminSettlementPreviewDtoOutputPayoutBuilder() {
    AdminSettlementPreviewDtoOutputPayout._defaults(this);
  }

  AdminSettlementPreviewDtoOutputPayoutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _amount = $v.amount;
      _rates = $v.rates.toBuilder();
      _unit = $v.unit?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSettlementPreviewDtoOutputPayout other) {
    _$v = other as _$AdminSettlementPreviewDtoOutputPayout;
  }

  @override
  void update(
    void Function(AdminSettlementPreviewDtoOutputPayoutBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminSettlementPreviewDtoOutputPayout build() => _build();

  _$AdminSettlementPreviewDtoOutputPayout _build() {
    _$AdminSettlementPreviewDtoOutputPayout _$result;
    try {
      _$result =
          _$v ??
          _$AdminSettlementPreviewDtoOutputPayout._(
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminSettlementPreviewDtoOutputPayout',
              'currency',
            ),
            amount: BuiltValueNullFieldError.checkNotNull(
              amount,
              r'AdminSettlementPreviewDtoOutputPayout',
              'amount',
            ),
            rates: rates.build(),
            unit: _unit?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rates';
        rates.build();
        _$failedField = 'unit';
        _unit?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminSettlementPreviewDtoOutputPayout',
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
