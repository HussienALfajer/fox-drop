// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_orders_dto_output_orders_inner_redelivery_of.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantOrdersDtoOutputOrdersInnerRedeliveryOf
    extends MerchantOrdersDtoOutputOrdersInnerRedeliveryOf {
  @override
  final String orderId;
  @override
  final String number;

  factory _$MerchantOrdersDtoOutputOrdersInnerRedeliveryOf([
    void Function(MerchantOrdersDtoOutputOrdersInnerRedeliveryOfBuilder)?
    updates,
  ]) =>
      (MerchantOrdersDtoOutputOrdersInnerRedeliveryOfBuilder()..update(updates))
          ._build();

  _$MerchantOrdersDtoOutputOrdersInnerRedeliveryOf._({
    required this.orderId,
    required this.number,
  }) : super._();
  @override
  MerchantOrdersDtoOutputOrdersInnerRedeliveryOf rebuild(
    void Function(MerchantOrdersDtoOutputOrdersInnerRedeliveryOfBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantOrdersDtoOutputOrdersInnerRedeliveryOfBuilder toBuilder() =>
      MerchantOrdersDtoOutputOrdersInnerRedeliveryOfBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOrdersDtoOutputOrdersInnerRedeliveryOf &&
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
            r'MerchantOrdersDtoOutputOrdersInnerRedeliveryOf',
          )
          ..add('orderId', orderId)
          ..add('number', number))
        .toString();
  }
}

class MerchantOrdersDtoOutputOrdersInnerRedeliveryOfBuilder
    implements
        Builder<
          MerchantOrdersDtoOutputOrdersInnerRedeliveryOf,
          MerchantOrdersDtoOutputOrdersInnerRedeliveryOfBuilder
        > {
  _$MerchantOrdersDtoOutputOrdersInnerRedeliveryOf? _$v;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  MerchantOrdersDtoOutputOrdersInnerRedeliveryOfBuilder() {
    MerchantOrdersDtoOutputOrdersInnerRedeliveryOf._defaults(this);
  }

  MerchantOrdersDtoOutputOrdersInnerRedeliveryOfBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderId = $v.orderId;
      _number = $v.number;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantOrdersDtoOutputOrdersInnerRedeliveryOf other) {
    _$v = other as _$MerchantOrdersDtoOutputOrdersInnerRedeliveryOf;
  }

  @override
  void update(
    void Function(MerchantOrdersDtoOutputOrdersInnerRedeliveryOfBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOrdersDtoOutputOrdersInnerRedeliveryOf build() => _build();

  _$MerchantOrdersDtoOutputOrdersInnerRedeliveryOf _build() {
    final _$result =
        _$v ??
        _$MerchantOrdersDtoOutputOrdersInnerRedeliveryOf._(
          orderId: BuiltValueNullFieldError.checkNotNull(
            orderId,
            r'MerchantOrdersDtoOutputOrdersInnerRedeliveryOf',
            'orderId',
          ),
          number: BuiltValueNullFieldError.checkNotNull(
            number,
            r'MerchantOrdersDtoOutputOrdersInnerRedeliveryOf',
            'number',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
