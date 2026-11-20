// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_history_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderHistoryDtoOutput extends AdminOrderHistoryDtoOutput {
  @override
  final BuiltList<AdminOrderHistoryDtoOutputOrdersInner> orders;
  @override
  final String? next;

  factory _$AdminOrderHistoryDtoOutput([
    void Function(AdminOrderHistoryDtoOutputBuilder)? updates,
  ]) => (AdminOrderHistoryDtoOutputBuilder()..update(updates))._build();

  _$AdminOrderHistoryDtoOutput._({required this.orders, this.next}) : super._();
  @override
  AdminOrderHistoryDtoOutput rebuild(
    void Function(AdminOrderHistoryDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderHistoryDtoOutputBuilder toBuilder() =>
      AdminOrderHistoryDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderHistoryDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'AdminOrderHistoryDtoOutput')
          ..add('orders', orders)
          ..add('next', next))
        .toString();
  }
}

class AdminOrderHistoryDtoOutputBuilder
    implements
        Builder<AdminOrderHistoryDtoOutput, AdminOrderHistoryDtoOutputBuilder> {
  _$AdminOrderHistoryDtoOutput? _$v;

  ListBuilder<AdminOrderHistoryDtoOutputOrdersInner>? _orders;
  ListBuilder<AdminOrderHistoryDtoOutputOrdersInner> get orders =>
      _$this._orders ??= ListBuilder<AdminOrderHistoryDtoOutputOrdersInner>();
  set orders(ListBuilder<AdminOrderHistoryDtoOutputOrdersInner>? orders) =>
      _$this._orders = orders;

  String? _next;
  String? get next => _$this._next;
  set next(String? next) => _$this._next = next;

  AdminOrderHistoryDtoOutputBuilder() {
    AdminOrderHistoryDtoOutput._defaults(this);
  }

  AdminOrderHistoryDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orders = $v.orders.toBuilder();
      _next = $v.next;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderHistoryDtoOutput other) {
    _$v = other as _$AdminOrderHistoryDtoOutput;
  }

  @override
  void update(void Function(AdminOrderHistoryDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderHistoryDtoOutput build() => _build();

  _$AdminOrderHistoryDtoOutput _build() {
    _$AdminOrderHistoryDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderHistoryDtoOutput._(orders: orders.build(), next: next);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'orders';
        orders.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderHistoryDtoOutput',
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
