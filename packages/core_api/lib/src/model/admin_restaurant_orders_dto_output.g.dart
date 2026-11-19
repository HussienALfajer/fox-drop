// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_orders_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantOrdersDtoOutput extends AdminRestaurantOrdersDtoOutput {
  @override
  final BuiltList<AdminRestaurantOrdersDtoOutputOrdersInner> orders;

  factory _$AdminRestaurantOrdersDtoOutput([
    void Function(AdminRestaurantOrdersDtoOutputBuilder)? updates,
  ]) => (AdminRestaurantOrdersDtoOutputBuilder()..update(updates))._build();

  _$AdminRestaurantOrdersDtoOutput._({required this.orders}) : super._();
  @override
  AdminRestaurantOrdersDtoOutput rebuild(
    void Function(AdminRestaurantOrdersDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantOrdersDtoOutputBuilder toBuilder() =>
      AdminRestaurantOrdersDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantOrdersDtoOutput && orders == other.orders;
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
      r'AdminRestaurantOrdersDtoOutput',
    )..add('orders', orders)).toString();
  }
}

class AdminRestaurantOrdersDtoOutputBuilder
    implements
        Builder<
          AdminRestaurantOrdersDtoOutput,
          AdminRestaurantOrdersDtoOutputBuilder
        > {
  _$AdminRestaurantOrdersDtoOutput? _$v;

  ListBuilder<AdminRestaurantOrdersDtoOutputOrdersInner>? _orders;
  ListBuilder<AdminRestaurantOrdersDtoOutputOrdersInner> get orders =>
      _$this._orders ??=
          ListBuilder<AdminRestaurantOrdersDtoOutputOrdersInner>();
  set orders(ListBuilder<AdminRestaurantOrdersDtoOutputOrdersInner>? orders) =>
      _$this._orders = orders;

  AdminRestaurantOrdersDtoOutputBuilder() {
    AdminRestaurantOrdersDtoOutput._defaults(this);
  }

  AdminRestaurantOrdersDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orders = $v.orders.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantOrdersDtoOutput other) {
    _$v = other as _$AdminRestaurantOrdersDtoOutput;
  }

  @override
  void update(void Function(AdminRestaurantOrdersDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantOrdersDtoOutput build() => _build();

  _$AdminRestaurantOrdersDtoOutput _build() {
    _$AdminRestaurantOrdersDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$AdminRestaurantOrdersDtoOutput._(orders: orders.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'orders';
        orders.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantOrdersDtoOutput',
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
