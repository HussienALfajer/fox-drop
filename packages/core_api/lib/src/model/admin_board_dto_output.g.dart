// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_board_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminBoardDtoOutput extends AdminBoardDtoOutput {
  @override
  final BuiltList<AdminBoardDtoOutputOrdersInner> orders;

  factory _$AdminBoardDtoOutput([
    void Function(AdminBoardDtoOutputBuilder)? updates,
  ]) => (AdminBoardDtoOutputBuilder()..update(updates))._build();

  _$AdminBoardDtoOutput._({required this.orders}) : super._();
  @override
  AdminBoardDtoOutput rebuild(
    void Function(AdminBoardDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminBoardDtoOutputBuilder toBuilder() =>
      AdminBoardDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminBoardDtoOutput && orders == other.orders;
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
      r'AdminBoardDtoOutput',
    )..add('orders', orders)).toString();
  }
}

class AdminBoardDtoOutputBuilder
    implements Builder<AdminBoardDtoOutput, AdminBoardDtoOutputBuilder> {
  _$AdminBoardDtoOutput? _$v;

  ListBuilder<AdminBoardDtoOutputOrdersInner>? _orders;
  ListBuilder<AdminBoardDtoOutputOrdersInner> get orders =>
      _$this._orders ??= ListBuilder<AdminBoardDtoOutputOrdersInner>();
  set orders(ListBuilder<AdminBoardDtoOutputOrdersInner>? orders) =>
      _$this._orders = orders;

  AdminBoardDtoOutputBuilder() {
    AdminBoardDtoOutput._defaults(this);
  }

  AdminBoardDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orders = $v.orders.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminBoardDtoOutput other) {
    _$v = other as _$AdminBoardDtoOutput;
  }

  @override
  void update(void Function(AdminBoardDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminBoardDtoOutput build() => _build();

  _$AdminBoardDtoOutput _build() {
    _$AdminBoardDtoOutput _$result;
    try {
      _$result = _$v ?? _$AdminBoardDtoOutput._(orders: orders.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'orders';
        orders.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminBoardDtoOutput',
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
