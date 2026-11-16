// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_settle_dto_lines_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantSettleDtoLinesInner
    extends AdminRestaurantSettleDtoLinesInner {
  @override
  final String currency;
  @override
  final String amount;
  @override
  final String base_;
  @override
  final BuiltList<AdminSettleDtoPayoutRatesInner> rates;

  factory _$AdminRestaurantSettleDtoLinesInner([
    void Function(AdminRestaurantSettleDtoLinesInnerBuilder)? updates,
  ]) => (AdminRestaurantSettleDtoLinesInnerBuilder()..update(updates))._build();

  _$AdminRestaurantSettleDtoLinesInner._({
    required this.currency,
    required this.amount,
    required this.base_,
    required this.rates,
  }) : super._();
  @override
  AdminRestaurantSettleDtoLinesInner rebuild(
    void Function(AdminRestaurantSettleDtoLinesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantSettleDtoLinesInnerBuilder toBuilder() =>
      AdminRestaurantSettleDtoLinesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantSettleDtoLinesInner &&
        currency == other.currency &&
        amount == other.amount &&
        base_ == other.base_ &&
        rates == other.rates;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, base_.hashCode);
    _$hash = $jc(_$hash, rates.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminRestaurantSettleDtoLinesInner')
          ..add('currency', currency)
          ..add('amount', amount)
          ..add('base_', base_)
          ..add('rates', rates))
        .toString();
  }
}

class AdminRestaurantSettleDtoLinesInnerBuilder
    implements
        Builder<
          AdminRestaurantSettleDtoLinesInner,
          AdminRestaurantSettleDtoLinesInnerBuilder
        > {
  _$AdminRestaurantSettleDtoLinesInner? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _base_;
  String? get base_ => _$this._base_;
  set base_(String? base_) => _$this._base_ = base_;

  ListBuilder<AdminSettleDtoPayoutRatesInner>? _rates;
  ListBuilder<AdminSettleDtoPayoutRatesInner> get rates =>
      _$this._rates ??= ListBuilder<AdminSettleDtoPayoutRatesInner>();
  set rates(ListBuilder<AdminSettleDtoPayoutRatesInner>? rates) =>
      _$this._rates = rates;

  AdminRestaurantSettleDtoLinesInnerBuilder() {
    AdminRestaurantSettleDtoLinesInner._defaults(this);
  }

  AdminRestaurantSettleDtoLinesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _amount = $v.amount;
      _base_ = $v.base_;
      _rates = $v.rates.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantSettleDtoLinesInner other) {
    _$v = other as _$AdminRestaurantSettleDtoLinesInner;
  }

  @override
  void update(
    void Function(AdminRestaurantSettleDtoLinesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantSettleDtoLinesInner build() => _build();

  _$AdminRestaurantSettleDtoLinesInner _build() {
    _$AdminRestaurantSettleDtoLinesInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantSettleDtoLinesInner._(
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminRestaurantSettleDtoLinesInner',
              'currency',
            ),
            amount: BuiltValueNullFieldError.checkNotNull(
              amount,
              r'AdminRestaurantSettleDtoLinesInner',
              'amount',
            ),
            base_: BuiltValueNullFieldError.checkNotNull(
              base_,
              r'AdminRestaurantSettleDtoLinesInner',
              'base_',
            ),
            rates: rates.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rates';
        rates.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantSettleDtoLinesInner',
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
