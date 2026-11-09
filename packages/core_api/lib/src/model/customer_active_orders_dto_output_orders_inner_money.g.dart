// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_active_orders_dto_output_orders_inner_money.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerActiveOrdersDtoOutputOrdersInnerMoney
    extends CustomerActiveOrdersDtoOutputOrdersInnerMoney {
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

  factory _$CustomerActiveOrdersDtoOutputOrdersInnerMoney([
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerMoneyBuilder)?
    updates,
  ]) =>
      (CustomerActiveOrdersDtoOutputOrdersInnerMoneyBuilder()..update(updates))
          ._build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerMoney._({
    required this.itemsValue,
    required this.deliveryFee,
    required this.deliveryFree,
    required this.discount,
    required this.rounding,
    required this.total,
  }) : super._();
  @override
  CustomerActiveOrdersDtoOutputOrdersInnerMoney rebuild(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerMoneyBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerMoneyBuilder toBuilder() =>
      CustomerActiveOrdersDtoOutputOrdersInnerMoneyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerActiveOrdersDtoOutputOrdersInnerMoney &&
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
    return (newBuiltValueToStringHelper(
            r'CustomerActiveOrdersDtoOutputOrdersInnerMoney',
          )
          ..add('itemsValue', itemsValue)
          ..add('deliveryFee', deliveryFee)
          ..add('deliveryFree', deliveryFree)
          ..add('discount', discount)
          ..add('rounding', rounding)
          ..add('total', total))
        .toString();
  }
}

class CustomerActiveOrdersDtoOutputOrdersInnerMoneyBuilder
    implements
        Builder<
          CustomerActiveOrdersDtoOutputOrdersInnerMoney,
          CustomerActiveOrdersDtoOutputOrdersInnerMoneyBuilder
        > {
  _$CustomerActiveOrdersDtoOutputOrdersInnerMoney? _$v;

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

  CustomerActiveOrdersDtoOutputOrdersInnerMoneyBuilder() {
    CustomerActiveOrdersDtoOutputOrdersInnerMoney._defaults(this);
  }

  CustomerActiveOrdersDtoOutputOrdersInnerMoneyBuilder get _$this {
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
  void replace(CustomerActiveOrdersDtoOutputOrdersInnerMoney other) {
    _$v = other as _$CustomerActiveOrdersDtoOutputOrdersInnerMoney;
  }

  @override
  void update(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerMoneyBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerMoney build() => _build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerMoney _build() {
    final _$result =
        _$v ??
        _$CustomerActiveOrdersDtoOutputOrdersInnerMoney._(
          itemsValue: BuiltValueNullFieldError.checkNotNull(
            itemsValue,
            r'CustomerActiveOrdersDtoOutputOrdersInnerMoney',
            'itemsValue',
          ),
          deliveryFee: BuiltValueNullFieldError.checkNotNull(
            deliveryFee,
            r'CustomerActiveOrdersDtoOutputOrdersInnerMoney',
            'deliveryFee',
          ),
          deliveryFree: BuiltValueNullFieldError.checkNotNull(
            deliveryFree,
            r'CustomerActiveOrdersDtoOutputOrdersInnerMoney',
            'deliveryFree',
          ),
          discount: BuiltValueNullFieldError.checkNotNull(
            discount,
            r'CustomerActiveOrdersDtoOutputOrdersInnerMoney',
            'discount',
          ),
          rounding: BuiltValueNullFieldError.checkNotNull(
            rounding,
            r'CustomerActiveOrdersDtoOutputOrdersInnerMoney',
            'rounding',
          ),
          total: BuiltValueNullFieldError.checkNotNull(
            total,
            r'CustomerActiveOrdersDtoOutputOrdersInnerMoney',
            'total',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
