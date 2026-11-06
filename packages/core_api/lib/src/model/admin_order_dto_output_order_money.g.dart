// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_money.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderMoney extends AdminOrderDtoOutputOrderMoney {
  @override
  final String currency;
  @override
  final String itemsValue;
  @override
  final String deliveryFee;
  @override
  final String discount;
  @override
  final String rounding;
  @override
  final String total;
  @override
  final String pickupPayment;

  factory _$AdminOrderDtoOutputOrderMoney([
    void Function(AdminOrderDtoOutputOrderMoneyBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderMoneyBuilder()..update(updates))._build();

  _$AdminOrderDtoOutputOrderMoney._({
    required this.currency,
    required this.itemsValue,
    required this.deliveryFee,
    required this.discount,
    required this.rounding,
    required this.total,
    required this.pickupPayment,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderMoney rebuild(
    void Function(AdminOrderDtoOutputOrderMoneyBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderMoneyBuilder toBuilder() =>
      AdminOrderDtoOutputOrderMoneyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderMoney &&
        currency == other.currency &&
        itemsValue == other.itemsValue &&
        deliveryFee == other.deliveryFee &&
        discount == other.discount &&
        rounding == other.rounding &&
        total == other.total &&
        pickupPayment == other.pickupPayment;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, itemsValue.hashCode);
    _$hash = $jc(_$hash, deliveryFee.hashCode);
    _$hash = $jc(_$hash, discount.hashCode);
    _$hash = $jc(_$hash, rounding.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, pickupPayment.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOrderDtoOutputOrderMoney')
          ..add('currency', currency)
          ..add('itemsValue', itemsValue)
          ..add('deliveryFee', deliveryFee)
          ..add('discount', discount)
          ..add('rounding', rounding)
          ..add('total', total)
          ..add('pickupPayment', pickupPayment))
        .toString();
  }
}

class AdminOrderDtoOutputOrderMoneyBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderMoney,
          AdminOrderDtoOutputOrderMoneyBuilder
        > {
  _$AdminOrderDtoOutputOrderMoney? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _itemsValue;
  String? get itemsValue => _$this._itemsValue;
  set itemsValue(String? itemsValue) => _$this._itemsValue = itemsValue;

  String? _deliveryFee;
  String? get deliveryFee => _$this._deliveryFee;
  set deliveryFee(String? deliveryFee) => _$this._deliveryFee = deliveryFee;

  String? _discount;
  String? get discount => _$this._discount;
  set discount(String? discount) => _$this._discount = discount;

  String? _rounding;
  String? get rounding => _$this._rounding;
  set rounding(String? rounding) => _$this._rounding = rounding;

  String? _total;
  String? get total => _$this._total;
  set total(String? total) => _$this._total = total;

  String? _pickupPayment;
  String? get pickupPayment => _$this._pickupPayment;
  set pickupPayment(String? pickupPayment) =>
      _$this._pickupPayment = pickupPayment;

  AdminOrderDtoOutputOrderMoneyBuilder() {
    AdminOrderDtoOutputOrderMoney._defaults(this);
  }

  AdminOrderDtoOutputOrderMoneyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _itemsValue = $v.itemsValue;
      _deliveryFee = $v.deliveryFee;
      _discount = $v.discount;
      _rounding = $v.rounding;
      _total = $v.total;
      _pickupPayment = $v.pickupPayment;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderMoney other) {
    _$v = other as _$AdminOrderDtoOutputOrderMoney;
  }

  @override
  void update(void Function(AdminOrderDtoOutputOrderMoneyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderMoney build() => _build();

  _$AdminOrderDtoOutputOrderMoney _build() {
    final _$result =
        _$v ??
        _$AdminOrderDtoOutputOrderMoney._(
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminOrderDtoOutputOrderMoney',
            'currency',
          ),
          itemsValue: BuiltValueNullFieldError.checkNotNull(
            itemsValue,
            r'AdminOrderDtoOutputOrderMoney',
            'itemsValue',
          ),
          deliveryFee: BuiltValueNullFieldError.checkNotNull(
            deliveryFee,
            r'AdminOrderDtoOutputOrderMoney',
            'deliveryFee',
          ),
          discount: BuiltValueNullFieldError.checkNotNull(
            discount,
            r'AdminOrderDtoOutputOrderMoney',
            'discount',
          ),
          rounding: BuiltValueNullFieldError.checkNotNull(
            rounding,
            r'AdminOrderDtoOutputOrderMoney',
            'rounding',
          ),
          total: BuiltValueNullFieldError.checkNotNull(
            total,
            r'AdminOrderDtoOutputOrderMoney',
            'total',
          ),
          pickupPayment: BuiltValueNullFieldError.checkNotNull(
            pickupPayment,
            r'AdminOrderDtoOutputOrderMoney',
            'pickupPayment',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
