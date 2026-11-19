// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_orders_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainOrdersDtoOutput extends AdminCaptainOrdersDtoOutput {
  @override
  final BuiltList<AdminRestaurantOrdersDtoOutputOrdersInner> orders;

  factory _$AdminCaptainOrdersDtoOutput([
    void Function(AdminCaptainOrdersDtoOutputBuilder)? updates,
  ]) => (AdminCaptainOrdersDtoOutputBuilder()..update(updates))._build();

  _$AdminCaptainOrdersDtoOutput._({required this.orders}) : super._();
  @override
  AdminCaptainOrdersDtoOutput rebuild(
    void Function(AdminCaptainOrdersDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainOrdersDtoOutputBuilder toBuilder() =>
      AdminCaptainOrdersDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainOrdersDtoOutput && orders == other.orders;
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
      r'AdminCaptainOrdersDtoOutput',
    )..add('orders', orders)).toString();
  }
}

class AdminCaptainOrdersDtoOutputBuilder
    implements
        Builder<
          AdminCaptainOrdersDtoOutput,
          AdminCaptainOrdersDtoOutputBuilder
        > {
  _$AdminCaptainOrdersDtoOutput? _$v;

  ListBuilder<AdminRestaurantOrdersDtoOutputOrdersInner>? _orders;
  ListBuilder<AdminRestaurantOrdersDtoOutputOrdersInner> get orders =>
      _$this._orders ??=
          ListBuilder<AdminRestaurantOrdersDtoOutputOrdersInner>();
  set orders(ListBuilder<AdminRestaurantOrdersDtoOutputOrdersInner>? orders) =>
      _$this._orders = orders;

  AdminCaptainOrdersDtoOutputBuilder() {
    AdminCaptainOrdersDtoOutput._defaults(this);
  }

  AdminCaptainOrdersDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orders = $v.orders.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainOrdersDtoOutput other) {
    _$v = other as _$AdminCaptainOrdersDtoOutput;
  }

  @override
  void update(void Function(AdminCaptainOrdersDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainOrdersDtoOutput build() => _build();

  _$AdminCaptainOrdersDtoOutput _build() {
    _$AdminCaptainOrdersDtoOutput _$result;
    try {
      _$result = _$v ?? _$AdminCaptainOrdersDtoOutput._(orders: orders.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'orders';
        orders.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCaptainOrdersDtoOutput',
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
