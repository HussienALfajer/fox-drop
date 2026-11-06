// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_active_orders_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerActiveOrdersDtoOutput extends CustomerActiveOrdersDtoOutput {
  @override
  final BuiltList<CustomerActiveOrdersDtoOutputOrdersInner> orders;

  factory _$CustomerActiveOrdersDtoOutput([
    void Function(CustomerActiveOrdersDtoOutputBuilder)? updates,
  ]) => (CustomerActiveOrdersDtoOutputBuilder()..update(updates))._build();

  _$CustomerActiveOrdersDtoOutput._({required this.orders}) : super._();
  @override
  CustomerActiveOrdersDtoOutput rebuild(
    void Function(CustomerActiveOrdersDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerActiveOrdersDtoOutputBuilder toBuilder() =>
      CustomerActiveOrdersDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerActiveOrdersDtoOutput && orders == other.orders;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CustomerActiveOrdersDtoOutput',
    )..add('orders', orders)).toString();
  }
}

class CustomerActiveOrdersDtoOutputBuilder
    implements
        Builder<
          CustomerActiveOrdersDtoOutput,
          CustomerActiveOrdersDtoOutputBuilder
        > {
  _$CustomerActiveOrdersDtoOutput? _$v;

  ListBuilder<CustomerActiveOrdersDtoOutputOrdersInner>? _orders;
  ListBuilder<CustomerActiveOrdersDtoOutputOrdersInner> get orders =>
      _$this._orders ??=
          ListBuilder<CustomerActiveOrdersDtoOutputOrdersInner>();
  set orders(ListBuilder<CustomerActiveOrdersDtoOutputOrdersInner>? orders) =>
      _$this._orders = orders;

  CustomerActiveOrdersDtoOutputBuilder() {
    CustomerActiveOrdersDtoOutput._defaults(this);
  }

  CustomerActiveOrdersDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orders = $v.orders.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerActiveOrdersDtoOutput other) {
    _$v = other as _$CustomerActiveOrdersDtoOutput;
  }

  @override
  void update(void Function(CustomerActiveOrdersDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerActiveOrdersDtoOutput build() => _build();

  _$CustomerActiveOrdersDtoOutput _build() {
    _$CustomerActiveOrdersDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$CustomerActiveOrdersDtoOutput._(orders: orders.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'orders';
        orders.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerActiveOrdersDtoOutput',
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
