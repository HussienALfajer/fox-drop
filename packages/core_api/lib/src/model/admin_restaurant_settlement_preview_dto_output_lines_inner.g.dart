// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_settlement_preview_dto_output_lines_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantSettlementPreviewDtoOutputLinesInner
    extends AdminRestaurantSettlementPreviewDtoOutputLinesInner {
  @override
  final String currency;
  @override
  final String amount;
  @override
  final String base_;
  @override
  final BuiltList<AdminSettlementPreviewDtoOutputPayoutRatesInner> rates;
  @override
  final AdminSettlementPreviewDtoOutputPayoutUnit? unit;

  factory _$AdminRestaurantSettlementPreviewDtoOutputLinesInner([
    void Function(AdminRestaurantSettlementPreviewDtoOutputLinesInnerBuilder)?
    updates,
  ]) =>
      (AdminRestaurantSettlementPreviewDtoOutputLinesInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminRestaurantSettlementPreviewDtoOutputLinesInner._({
    required this.currency,
    required this.amount,
    required this.base_,
    required this.rates,
    this.unit,
  }) : super._();
  @override
  AdminRestaurantSettlementPreviewDtoOutputLinesInner rebuild(
    void Function(AdminRestaurantSettlementPreviewDtoOutputLinesInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantSettlementPreviewDtoOutputLinesInnerBuilder toBuilder() =>
      AdminRestaurantSettlementPreviewDtoOutputLinesInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantSettlementPreviewDtoOutputLinesInner &&
        currency == other.currency &&
        amount == other.amount &&
        base_ == other.base_ &&
        rates == other.rates &&
        unit == other.unit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, base_.hashCode);
    _$hash = $jc(_$hash, rates.hashCode);
    _$hash = $jc(_$hash, unit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantSettlementPreviewDtoOutputLinesInner',
          )
          ..add('currency', currency)
          ..add('amount', amount)
          ..add('base_', base_)
          ..add('rates', rates)
          ..add('unit', unit))
        .toString();
  }
}

class AdminRestaurantSettlementPreviewDtoOutputLinesInnerBuilder
    implements
        Builder<
          AdminRestaurantSettlementPreviewDtoOutputLinesInner,
          AdminRestaurantSettlementPreviewDtoOutputLinesInnerBuilder
        > {
  _$AdminRestaurantSettlementPreviewDtoOutputLinesInner? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _base_;
  String? get base_ => _$this._base_;
  set base_(String? base_) => _$this._base_ = base_;

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

  AdminRestaurantSettlementPreviewDtoOutputLinesInnerBuilder() {
    AdminRestaurantSettlementPreviewDtoOutputLinesInner._defaults(this);
  }

  AdminRestaurantSettlementPreviewDtoOutputLinesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _amount = $v.amount;
      _base_ = $v.base_;
      _rates = $v.rates.toBuilder();
      _unit = $v.unit?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantSettlementPreviewDtoOutputLinesInner other) {
    _$v = other as _$AdminRestaurantSettlementPreviewDtoOutputLinesInner;
  }

  @override
  void update(
    void Function(AdminRestaurantSettlementPreviewDtoOutputLinesInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantSettlementPreviewDtoOutputLinesInner build() => _build();

  _$AdminRestaurantSettlementPreviewDtoOutputLinesInner _build() {
    _$AdminRestaurantSettlementPreviewDtoOutputLinesInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantSettlementPreviewDtoOutputLinesInner._(
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminRestaurantSettlementPreviewDtoOutputLinesInner',
              'currency',
            ),
            amount: BuiltValueNullFieldError.checkNotNull(
              amount,
              r'AdminRestaurantSettlementPreviewDtoOutputLinesInner',
              'amount',
            ),
            base_: BuiltValueNullFieldError.checkNotNull(
              base_,
              r'AdminRestaurantSettlementPreviewDtoOutputLinesInner',
              'base_',
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
          r'AdminRestaurantSettlementPreviewDtoOutputLinesInner',
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
