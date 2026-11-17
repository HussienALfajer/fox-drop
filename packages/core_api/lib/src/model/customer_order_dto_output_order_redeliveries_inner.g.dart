// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_order_dto_output_order_redeliveries_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerOrderDtoOutputOrderRedeliveriesInner
    extends CustomerOrderDtoOutputOrderRedeliveriesInner {
  @override
  final String orderId;
  @override
  final String number;

  factory _$CustomerOrderDtoOutputOrderRedeliveriesInner([
    void Function(CustomerOrderDtoOutputOrderRedeliveriesInnerBuilder)? updates,
  ]) => (CustomerOrderDtoOutputOrderRedeliveriesInnerBuilder()..update(updates))
      ._build();

  _$CustomerOrderDtoOutputOrderRedeliveriesInner._({
    required this.orderId,
    required this.number,
  }) : super._();
  @override
  CustomerOrderDtoOutputOrderRedeliveriesInner rebuild(
    void Function(CustomerOrderDtoOutputOrderRedeliveriesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerOrderDtoOutputOrderRedeliveriesInnerBuilder toBuilder() =>
      CustomerOrderDtoOutputOrderRedeliveriesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerOrderDtoOutputOrderRedeliveriesInner &&
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
            r'CustomerOrderDtoOutputOrderRedeliveriesInner',
          )
          ..add('orderId', orderId)
          ..add('number', number))
        .toString();
  }
}

class CustomerOrderDtoOutputOrderRedeliveriesInnerBuilder
    implements
        Builder<
          CustomerOrderDtoOutputOrderRedeliveriesInner,
          CustomerOrderDtoOutputOrderRedeliveriesInnerBuilder
        > {
  _$CustomerOrderDtoOutputOrderRedeliveriesInner? _$v;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  CustomerOrderDtoOutputOrderRedeliveriesInnerBuilder() {
    CustomerOrderDtoOutputOrderRedeliveriesInner._defaults(this);
  }

  CustomerOrderDtoOutputOrderRedeliveriesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderId = $v.orderId;
      _number = $v.number;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerOrderDtoOutputOrderRedeliveriesInner other) {
    _$v = other as _$CustomerOrderDtoOutputOrderRedeliveriesInner;
  }

  @override
  void update(
    void Function(CustomerOrderDtoOutputOrderRedeliveriesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerOrderDtoOutputOrderRedeliveriesInner build() => _build();

  _$CustomerOrderDtoOutputOrderRedeliveriesInner _build() {
    final _$result =
        _$v ??
        _$CustomerOrderDtoOutputOrderRedeliveriesInner._(
          orderId: BuiltValueNullFieldError.checkNotNull(
            orderId,
            r'CustomerOrderDtoOutputOrderRedeliveriesInner',
            'orderId',
          ),
          number: BuiltValueNullFieldError.checkNotNull(
            number,
            r'CustomerOrderDtoOutputOrderRedeliveriesInner',
            'number',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
