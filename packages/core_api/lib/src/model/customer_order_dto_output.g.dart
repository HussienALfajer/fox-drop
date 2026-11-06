// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_order_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerOrderDtoOutput extends CustomerOrderDtoOutput {
  @override
  final CustomerOrderDtoOutputOrder order;

  factory _$CustomerOrderDtoOutput([
    void Function(CustomerOrderDtoOutputBuilder)? updates,
  ]) => (CustomerOrderDtoOutputBuilder()..update(updates))._build();

  _$CustomerOrderDtoOutput._({required this.order}) : super._();
  @override
  CustomerOrderDtoOutput rebuild(
    void Function(CustomerOrderDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerOrderDtoOutputBuilder toBuilder() =>
      CustomerOrderDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerOrderDtoOutput && order == other.order;
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
      r'CustomerOrderDtoOutput',
    )..add('order', order)).toString();
  }
}

class CustomerOrderDtoOutputBuilder
    implements Builder<CustomerOrderDtoOutput, CustomerOrderDtoOutputBuilder> {
  _$CustomerOrderDtoOutput? _$v;

  CustomerOrderDtoOutputOrderBuilder? _order;
  CustomerOrderDtoOutputOrderBuilder get order =>
      _$this._order ??= CustomerOrderDtoOutputOrderBuilder();
  set order(CustomerOrderDtoOutputOrderBuilder? order) => _$this._order = order;

  CustomerOrderDtoOutputBuilder() {
    CustomerOrderDtoOutput._defaults(this);
  }

  CustomerOrderDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _order = $v.order.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerOrderDtoOutput other) {
    _$v = other as _$CustomerOrderDtoOutput;
  }

  @override
  void update(void Function(CustomerOrderDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerOrderDtoOutput build() => _build();

  _$CustomerOrderDtoOutput _build() {
    _$CustomerOrderDtoOutput _$result;
    try {
      _$result = _$v ?? _$CustomerOrderDtoOutput._(order: order.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'order';
        order.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerOrderDtoOutput',
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
