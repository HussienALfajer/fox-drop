// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutput extends AdminOrderDtoOutput {
  @override
  final AdminOrderDtoOutputOrder order;

  factory _$AdminOrderDtoOutput([
    void Function(AdminOrderDtoOutputBuilder)? updates,
  ]) => (AdminOrderDtoOutputBuilder()..update(updates))._build();

  _$AdminOrderDtoOutput._({required this.order}) : super._();
  @override
  AdminOrderDtoOutput rebuild(
    void Function(AdminOrderDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputBuilder toBuilder() =>
      AdminOrderDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutput && order == other.order;
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
      r'AdminOrderDtoOutput',
    )..add('order', order)).toString();
  }
}

class AdminOrderDtoOutputBuilder
    implements Builder<AdminOrderDtoOutput, AdminOrderDtoOutputBuilder> {
  _$AdminOrderDtoOutput? _$v;

  AdminOrderDtoOutputOrderBuilder? _order;
  AdminOrderDtoOutputOrderBuilder get order =>
      _$this._order ??= AdminOrderDtoOutputOrderBuilder();
  set order(AdminOrderDtoOutputOrderBuilder? order) => _$this._order = order;

  AdminOrderDtoOutputBuilder() {
    AdminOrderDtoOutput._defaults(this);
  }

  AdminOrderDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _order = $v.order.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutput other) {
    _$v = other as _$AdminOrderDtoOutput;
  }

  @override
  void update(void Function(AdminOrderDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutput build() => _build();

  _$AdminOrderDtoOutput _build() {
    _$AdminOrderDtoOutput _$result;
    try {
      _$result = _$v ?? _$AdminOrderDtoOutput._(order: order.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'order';
        order.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderDtoOutput',
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
