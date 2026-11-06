// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_placed_order_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerPlacedOrderDtoOutput extends CustomerPlacedOrderDtoOutput {
  @override
  final CustomerPlacedOrderDtoOutputOrder order;

  factory _$CustomerPlacedOrderDtoOutput([
    void Function(CustomerPlacedOrderDtoOutputBuilder)? updates,
  ]) => (CustomerPlacedOrderDtoOutputBuilder()..update(updates))._build();

  _$CustomerPlacedOrderDtoOutput._({required this.order}) : super._();
  @override
  CustomerPlacedOrderDtoOutput rebuild(
    void Function(CustomerPlacedOrderDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerPlacedOrderDtoOutputBuilder toBuilder() =>
      CustomerPlacedOrderDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerPlacedOrderDtoOutput && order == other.order;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, order.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CustomerPlacedOrderDtoOutput',
    )..add('order', order)).toString();
  }
}

class CustomerPlacedOrderDtoOutputBuilder
    implements
        Builder<
          CustomerPlacedOrderDtoOutput,
          CustomerPlacedOrderDtoOutputBuilder
        > {
  _$CustomerPlacedOrderDtoOutput? _$v;

  CustomerPlacedOrderDtoOutputOrderBuilder? _order;
  CustomerPlacedOrderDtoOutputOrderBuilder get order =>
      _$this._order ??= CustomerPlacedOrderDtoOutputOrderBuilder();
  set order(CustomerPlacedOrderDtoOutputOrderBuilder? order) =>
      _$this._order = order;

  CustomerPlacedOrderDtoOutputBuilder() {
    CustomerPlacedOrderDtoOutput._defaults(this);
  }

  CustomerPlacedOrderDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _order = $v.order.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerPlacedOrderDtoOutput other) {
    _$v = other as _$CustomerPlacedOrderDtoOutput;
  }

  @override
  void update(void Function(CustomerPlacedOrderDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerPlacedOrderDtoOutput build() => _build();

  _$CustomerPlacedOrderDtoOutput _build() {
    _$CustomerPlacedOrderDtoOutput _$result;
    try {
      _$result = _$v ?? _$CustomerPlacedOrderDtoOutput._(order: order.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'order';
        order.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerPlacedOrderDtoOutput',
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
