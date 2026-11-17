// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_active_orders_dto_output_orders_inner_redelivery_of.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOf
    extends CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOf {
  @override
  final String orderId;
  @override
  final String number;

  factory _$CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOf([
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOfBuilder)?
    updates,
  ]) =>
      (CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOfBuilder()
            ..update(updates))
          ._build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOf._({
    required this.orderId,
    required this.number,
  }) : super._();
  @override
  CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOf rebuild(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOfBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOfBuilder toBuilder() =>
      CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOfBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOf &&
        orderId == other.orderId &&
        number == other.number;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOf',
          )
          ..add('orderId', orderId)
          ..add('number', number))
        .toString();
  }
}

class CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOfBuilder
    implements
        Builder<
          CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOf,
          CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOfBuilder
        > {
  _$CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOf? _$v;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOfBuilder() {
    CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOf._defaults(this);
  }

  CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOfBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderId = $v.orderId;
      _number = $v.number;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOf other) {
    _$v = other as _$CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOf;
  }

  @override
  void update(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOfBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOf build() => _build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOf _build() {
    final _$result =
        _$v ??
        _$CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOf._(
          orderId: BuiltValueNullFieldError.checkNotNull(
            orderId,
            r'CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOf',
            'orderId',
          ),
          number: BuiltValueNullFieldError.checkNotNull(
            number,
            r'CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOf',
            'number',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
