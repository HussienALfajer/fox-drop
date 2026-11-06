// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_quote_dto_output_money.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerQuoteDtoOutputMoney extends CustomerQuoteDtoOutputMoney {
  @override
  final String itemsValue;
  @override
  final String deliveryFee;
  @override
  final bool deliveryFree;
  @override
  final String discount;
  @override
  final String rounding;
  @override
  final String total;

  factory _$CustomerQuoteDtoOutputMoney([
    void Function(CustomerQuoteDtoOutputMoneyBuilder)? updates,
  ]) => (CustomerQuoteDtoOutputMoneyBuilder()..update(updates))._build();

  _$CustomerQuoteDtoOutputMoney._({
    required this.itemsValue,
    required this.deliveryFee,
    required this.deliveryFree,
    required this.discount,
    required this.rounding,
    required this.total,
  }) : super._();
  @override
  CustomerQuoteDtoOutputMoney rebuild(
    void Function(CustomerQuoteDtoOutputMoneyBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerQuoteDtoOutputMoneyBuilder toBuilder() =>
      CustomerQuoteDtoOutputMoneyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerQuoteDtoOutputMoney &&
        itemsValue == other.itemsValue &&
        deliveryFee == other.deliveryFee &&
        deliveryFree == other.deliveryFree &&
        discount == other.discount &&
        rounding == other.rounding &&
        total == other.total;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, itemsValue.hashCode);
    _$hash = $jc(_$hash, deliveryFee.hashCode);
    _$hash = $jc(_$hash, deliveryFree.hashCode);
    _$hash = $jc(_$hash, discount.hashCode);
    _$hash = $jc(_$hash, rounding.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerQuoteDtoOutputMoney')
          ..add('itemsValue', itemsValue)
          ..add('deliveryFee', deliveryFee)
          ..add('deliveryFree', deliveryFree)
          ..add('discount', discount)
          ..add('rounding', rounding)
          ..add('total', total))
        .toString();
  }
}

class CustomerQuoteDtoOutputMoneyBuilder
    implements
        Builder<
          CustomerQuoteDtoOutputMoney,
          CustomerQuoteDtoOutputMoneyBuilder
        > {
  _$CustomerQuoteDtoOutputMoney? _$v;

  String? _itemsValue;
  String? get itemsValue => _$this._itemsValue;
  set itemsValue(String? itemsValue) => _$this._itemsValue = itemsValue;

  String? _deliveryFee;
  String? get deliveryFee => _$this._deliveryFee;
  set deliveryFee(String? deliveryFee) => _$this._deliveryFee = deliveryFee;

  bool? _deliveryFree;
  bool? get deliveryFree => _$this._deliveryFree;
  set deliveryFree(bool? deliveryFree) => _$this._deliveryFree = deliveryFree;

  String? _discount;
  String? get discount => _$this._discount;
  set discount(String? discount) => _$this._discount = discount;

  String? _rounding;
  String? get rounding => _$this._rounding;
  set rounding(String? rounding) => _$this._rounding = rounding;

  String? _total;
  String? get total => _$this._total;
  set total(String? total) => _$this._total = total;

  CustomerQuoteDtoOutputMoneyBuilder() {
    CustomerQuoteDtoOutputMoney._defaults(this);
  }

  CustomerQuoteDtoOutputMoneyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _itemsValue = $v.itemsValue;
      _deliveryFee = $v.deliveryFee;
      _deliveryFree = $v.deliveryFree;
      _discount = $v.discount;
      _rounding = $v.rounding;
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerQuoteDtoOutputMoney other) {
    _$v = other as _$CustomerQuoteDtoOutputMoney;
  }

  @override
  void update(void Function(CustomerQuoteDtoOutputMoneyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerQuoteDtoOutputMoney build() => _build();

  _$CustomerQuoteDtoOutputMoney _build() {
    final _$result =
        _$v ??
        _$CustomerQuoteDtoOutputMoney._(
          itemsValue: BuiltValueNullFieldError.checkNotNull(
            itemsValue,
            r'CustomerQuoteDtoOutputMoney',
            'itemsValue',
          ),
          deliveryFee: BuiltValueNullFieldError.checkNotNull(
            deliveryFee,
            r'CustomerQuoteDtoOutputMoney',
            'deliveryFee',
          ),
          deliveryFree: BuiltValueNullFieldError.checkNotNull(
            deliveryFree,
            r'CustomerQuoteDtoOutputMoney',
            'deliveryFree',
          ),
          discount: BuiltValueNullFieldError.checkNotNull(
            discount,
            r'CustomerQuoteDtoOutputMoney',
            'discount',
          ),
          rounding: BuiltValueNullFieldError.checkNotNull(
            rounding,
            r'CustomerQuoteDtoOutputMoney',
            'rounding',
          ),
          total: BuiltValueNullFieldError.checkNotNull(
            total,
            r'CustomerQuoteDtoOutputMoney',
            'total',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
