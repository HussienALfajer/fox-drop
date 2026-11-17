// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_active_orders_dto_output_orders_inner_redeliveries_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInner
    extends CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInner {
  @override
  final String orderId;
  @override
  final String number;

  factory _$CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInner([
    void Function(
      CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInnerBuilder,
    )?
    updates,
  ]) =>
      (CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInnerBuilder()
            ..update(updates))
          ._build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInner._({
    required this.orderId,
    required this.number,
  }) : super._();
  @override
  CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInner rebuild(
    void Function(
      CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInnerBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInnerBuilder
  toBuilder() =>
      CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInner &&
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
            r'CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInner',
          )
          ..add('orderId', orderId)
          ..add('number', number))
        .toString();
  }
}

class CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInnerBuilder
    implements
        Builder<
          CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInner,
          CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInnerBuilder
        > {
  _$CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInner? _$v;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInnerBuilder() {
    CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInner._defaults(this);
  }

  CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderId = $v.orderId;
      _number = $v.number;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
    CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInner other,
  ) {
    _$v = other as _$CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInner;
  }

  @override
  void update(
    void Function(
      CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInnerBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInner build() => _build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInner _build() {
    final _$result =
        _$v ??
        _$CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInner._(
          orderId: BuiltValueNullFieldError.checkNotNull(
            orderId,
            r'CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInner',
            'orderId',
          ),
          number: BuiltValueNullFieldError.checkNotNull(
            number,
            r'CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInner',
            'number',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
