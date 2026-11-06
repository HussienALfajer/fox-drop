// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_quote_dto_output_minimum_order.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerQuoteDtoOutputMinimumOrder
    extends CustomerQuoteDtoOutputMinimumOrder {
  @override
  final String amount;
  @override
  final String currency;
  @override
  final bool reached;
  @override
  final String missing;

  factory _$CustomerQuoteDtoOutputMinimumOrder([
    void Function(CustomerQuoteDtoOutputMinimumOrderBuilder)? updates,
  ]) => (CustomerQuoteDtoOutputMinimumOrderBuilder()..update(updates))._build();

  _$CustomerQuoteDtoOutputMinimumOrder._({
    required this.amount,
    required this.currency,
    required this.reached,
    required this.missing,
  }) : super._();
  @override
  CustomerQuoteDtoOutputMinimumOrder rebuild(
    void Function(CustomerQuoteDtoOutputMinimumOrderBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerQuoteDtoOutputMinimumOrderBuilder toBuilder() =>
      CustomerQuoteDtoOutputMinimumOrderBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerQuoteDtoOutputMinimumOrder &&
        amount == other.amount &&
        currency == other.currency &&
        reached == other.reached &&
        missing == other.missing;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, reached.hashCode);
    _$hash = $jc(_$hash, missing.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerQuoteDtoOutputMinimumOrder')
          ..add('amount', amount)
          ..add('currency', currency)
          ..add('reached', reached)
          ..add('missing', missing))
        .toString();
  }
}

class CustomerQuoteDtoOutputMinimumOrderBuilder
    implements
        Builder<
          CustomerQuoteDtoOutputMinimumOrder,
          CustomerQuoteDtoOutputMinimumOrderBuilder
        > {
  _$CustomerQuoteDtoOutputMinimumOrder? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  bool? _reached;
  bool? get reached => _$this._reached;
  set reached(bool? reached) => _$this._reached = reached;

  String? _missing;
  String? get missing => _$this._missing;
  set missing(String? missing) => _$this._missing = missing;

  CustomerQuoteDtoOutputMinimumOrderBuilder() {
    CustomerQuoteDtoOutputMinimumOrder._defaults(this);
  }

  CustomerQuoteDtoOutputMinimumOrderBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _reached = $v.reached;
      _missing = $v.missing;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerQuoteDtoOutputMinimumOrder other) {
    _$v = other as _$CustomerQuoteDtoOutputMinimumOrder;
  }

  @override
  void update(
    void Function(CustomerQuoteDtoOutputMinimumOrderBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerQuoteDtoOutputMinimumOrder build() => _build();

  _$CustomerQuoteDtoOutputMinimumOrder _build() {
    final _$result =
        _$v ??
        _$CustomerQuoteDtoOutputMinimumOrder._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CustomerQuoteDtoOutputMinimumOrder',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CustomerQuoteDtoOutputMinimumOrder',
            'currency',
          ),
          reached: BuiltValueNullFieldError.checkNotNull(
            reached,
            r'CustomerQuoteDtoOutputMinimumOrder',
            'reached',
          ),
          missing: BuiltValueNullFieldError.checkNotNull(
            missing,
            r'CustomerQuoteDtoOutputMinimumOrder',
            'missing',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
