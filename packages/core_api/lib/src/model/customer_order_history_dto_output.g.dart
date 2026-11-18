// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_order_history_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerOrderHistoryDtoOutput extends CustomerOrderHistoryDtoOutput {
  @override
  final BuiltList<CustomerOrderHistoryDtoOutputOrdersInner> orders;
  @override
  final String? next;

  factory _$CustomerOrderHistoryDtoOutput([
    void Function(CustomerOrderHistoryDtoOutputBuilder)? updates,
  ]) => (CustomerOrderHistoryDtoOutputBuilder()..update(updates))._build();

  _$CustomerOrderHistoryDtoOutput._({required this.orders, this.next})
    : super._();
  @override
  CustomerOrderHistoryDtoOutput rebuild(
    void Function(CustomerOrderHistoryDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerOrderHistoryDtoOutputBuilder toBuilder() =>
      CustomerOrderHistoryDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerOrderHistoryDtoOutput &&
        orders == other.orders &&
        next == other.next;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, next.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerOrderHistoryDtoOutput')
          ..add('orders', orders)
          ..add('next', next))
        .toString();
  }
}

class CustomerOrderHistoryDtoOutputBuilder
    implements
        Builder<
          CustomerOrderHistoryDtoOutput,
          CustomerOrderHistoryDtoOutputBuilder
        > {
  _$CustomerOrderHistoryDtoOutput? _$v;

  ListBuilder<CustomerOrderHistoryDtoOutputOrdersInner>? _orders;
  ListBuilder<CustomerOrderHistoryDtoOutputOrdersInner> get orders =>
      _$this._orders ??=
          ListBuilder<CustomerOrderHistoryDtoOutputOrdersInner>();
  set orders(ListBuilder<CustomerOrderHistoryDtoOutputOrdersInner>? orders) =>
      _$this._orders = orders;

  String? _next;
  String? get next => _$this._next;
  set next(String? next) => _$this._next = next;

  CustomerOrderHistoryDtoOutputBuilder() {
    CustomerOrderHistoryDtoOutput._defaults(this);
  }

  CustomerOrderHistoryDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orders = $v.orders.toBuilder();
      _next = $v.next;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerOrderHistoryDtoOutput other) {
    _$v = other as _$CustomerOrderHistoryDtoOutput;
  }

  @override
  void update(void Function(CustomerOrderHistoryDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerOrderHistoryDtoOutput build() => _build();

  _$CustomerOrderHistoryDtoOutput _build() {
    _$CustomerOrderHistoryDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$CustomerOrderHistoryDtoOutput._(orders: orders.build(), next: next);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'orders';
        orders.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerOrderHistoryDtoOutput',
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
