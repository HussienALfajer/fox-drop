// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_card_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderCardDtoOutput extends AdminOrderCardDtoOutput {
  @override
  final AdminOrderCardDtoOutputOrder order;

  factory _$AdminOrderCardDtoOutput([
    void Function(AdminOrderCardDtoOutputBuilder)? updates,
  ]) => (AdminOrderCardDtoOutputBuilder()..update(updates))._build();

  _$AdminOrderCardDtoOutput._({required this.order}) : super._();
  @override
  AdminOrderCardDtoOutput rebuild(
    void Function(AdminOrderCardDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderCardDtoOutputBuilder toBuilder() =>
      AdminOrderCardDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderCardDtoOutput && order == other.order;
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
      r'AdminOrderCardDtoOutput',
    )..add('order', order)).toString();
  }
}

class AdminOrderCardDtoOutputBuilder
    implements
        Builder<AdminOrderCardDtoOutput, AdminOrderCardDtoOutputBuilder> {
  _$AdminOrderCardDtoOutput? _$v;

  AdminOrderCardDtoOutputOrderBuilder? _order;
  AdminOrderCardDtoOutputOrderBuilder get order =>
      _$this._order ??= AdminOrderCardDtoOutputOrderBuilder();
  set order(AdminOrderCardDtoOutputOrderBuilder? order) =>
      _$this._order = order;

  AdminOrderCardDtoOutputBuilder() {
    AdminOrderCardDtoOutput._defaults(this);
  }

  AdminOrderCardDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _order = $v.order.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderCardDtoOutput other) {
    _$v = other as _$AdminOrderCardDtoOutput;
  }

  @override
  void update(void Function(AdminOrderCardDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderCardDtoOutput build() => _build();

  _$AdminOrderCardDtoOutput _build() {
    _$AdminOrderCardDtoOutput _$result;
    try {
      _$result = _$v ?? _$AdminOrderCardDtoOutput._(order: order.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'order';
        order.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderCardDtoOutput',
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
