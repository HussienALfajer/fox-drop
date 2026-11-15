// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_settle_dto_payout.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSettleDtoPayout extends AdminSettleDtoPayout {
  @override
  final String currency;
  @override
  final String amount;
  @override
  final BuiltList<AdminSettleDtoPayoutRatesInner> rates;

  factory _$AdminSettleDtoPayout([
    void Function(AdminSettleDtoPayoutBuilder)? updates,
  ]) => (AdminSettleDtoPayoutBuilder()..update(updates))._build();

  _$AdminSettleDtoPayout._({
    required this.currency,
    required this.amount,
    required this.rates,
  }) : super._();
  @override
  AdminSettleDtoPayout rebuild(
    void Function(AdminSettleDtoPayoutBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSettleDtoPayoutBuilder toBuilder() =>
      AdminSettleDtoPayoutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSettleDtoPayout &&
        currency == other.currency &&
        amount == other.amount &&
        rates == other.rates;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, rates.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSettleDtoPayout')
          ..add('currency', currency)
          ..add('amount', amount)
          ..add('rates', rates))
        .toString();
  }
}

class AdminSettleDtoPayoutBuilder
    implements Builder<AdminSettleDtoPayout, AdminSettleDtoPayoutBuilder> {
  _$AdminSettleDtoPayout? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  ListBuilder<AdminSettleDtoPayoutRatesInner>? _rates;
  ListBuilder<AdminSettleDtoPayoutRatesInner> get rates =>
      _$this._rates ??= ListBuilder<AdminSettleDtoPayoutRatesInner>();
  set rates(ListBuilder<AdminSettleDtoPayoutRatesInner>? rates) =>
      _$this._rates = rates;

  AdminSettleDtoPayoutBuilder() {
    AdminSettleDtoPayout._defaults(this);
  }

  AdminSettleDtoPayoutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _amount = $v.amount;
      _rates = $v.rates.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSettleDtoPayout other) {
    _$v = other as _$AdminSettleDtoPayout;
  }

  @override
  void update(void Function(AdminSettleDtoPayoutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSettleDtoPayout build() => _build();

  _$AdminSettleDtoPayout _build() {
    _$AdminSettleDtoPayout _$result;
    try {
      _$result =
          _$v ??
          _$AdminSettleDtoPayout._(
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminSettleDtoPayout',
              'currency',
            ),
            amount: BuiltValueNullFieldError.checkNotNull(
              amount,
              r'AdminSettleDtoPayout',
              'amount',
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
          r'AdminSettleDtoPayout',
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
