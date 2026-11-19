// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_request_option_price_delta.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantRequestOptionPriceDelta
    extends MerchantRequestOptionPriceDelta {
  @override
  final String amount;
  @override
  final String currency;

  factory _$MerchantRequestOptionPriceDelta([
    void Function(MerchantRequestOptionPriceDeltaBuilder)? updates,
  ]) => (MerchantRequestOptionPriceDeltaBuilder()..update(updates))._build();

  _$MerchantRequestOptionPriceDelta._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  MerchantRequestOptionPriceDelta rebuild(
    void Function(MerchantRequestOptionPriceDeltaBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantRequestOptionPriceDeltaBuilder toBuilder() =>
      MerchantRequestOptionPriceDeltaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantRequestOptionPriceDelta &&
        amount == other.amount &&
        currency == other.currency;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantRequestOptionPriceDelta')
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class MerchantRequestOptionPriceDeltaBuilder
    implements
        Builder<
          MerchantRequestOptionPriceDelta,
          MerchantRequestOptionPriceDeltaBuilder
        > {
  _$MerchantRequestOptionPriceDelta? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  MerchantRequestOptionPriceDeltaBuilder() {
    MerchantRequestOptionPriceDelta._defaults(this);
  }

  MerchantRequestOptionPriceDeltaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantRequestOptionPriceDelta other) {
    _$v = other as _$MerchantRequestOptionPriceDelta;
  }

  @override
  void update(void Function(MerchantRequestOptionPriceDeltaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantRequestOptionPriceDelta build() => _build();

  _$MerchantRequestOptionPriceDelta _build() {
    final _$result =
        _$v ??
        _$MerchantRequestOptionPriceDelta._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'MerchantRequestOptionPriceDelta',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'MerchantRequestOptionPriceDelta',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
