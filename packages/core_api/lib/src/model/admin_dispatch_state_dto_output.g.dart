// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dispatch_state_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDispatchStateDtoOutput extends AdminDispatchStateDtoOutput {
  @override
  final AdminDispatchStateDtoOutputOrder order;

  factory _$AdminDispatchStateDtoOutput([
    void Function(AdminDispatchStateDtoOutputBuilder)? updates,
  ]) => (AdminDispatchStateDtoOutputBuilder()..update(updates))._build();

  _$AdminDispatchStateDtoOutput._({required this.order}) : super._();
  @override
  AdminDispatchStateDtoOutput rebuild(
    void Function(AdminDispatchStateDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDispatchStateDtoOutputBuilder toBuilder() =>
      AdminDispatchStateDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDispatchStateDtoOutput && order == other.order;
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
      r'AdminDispatchStateDtoOutput',
    )..add('order', order)).toString();
  }
}

class AdminDispatchStateDtoOutputBuilder
    implements
        Builder<
          AdminDispatchStateDtoOutput,
          AdminDispatchStateDtoOutputBuilder
        > {
  _$AdminDispatchStateDtoOutput? _$v;

  AdminDispatchStateDtoOutputOrderBuilder? _order;
  AdminDispatchStateDtoOutputOrderBuilder get order =>
      _$this._order ??= AdminDispatchStateDtoOutputOrderBuilder();
  set order(AdminDispatchStateDtoOutputOrderBuilder? order) =>
      _$this._order = order;

  AdminDispatchStateDtoOutputBuilder() {
    AdminDispatchStateDtoOutput._defaults(this);
  }

  AdminDispatchStateDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _order = $v.order.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDispatchStateDtoOutput other) {
    _$v = other as _$AdminDispatchStateDtoOutput;
  }

  @override
  void update(void Function(AdminDispatchStateDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDispatchStateDtoOutput build() => _build();

  _$AdminDispatchStateDtoOutput _build() {
    _$AdminDispatchStateDtoOutput _$result;
    try {
      _$result = _$v ?? _$AdminDispatchStateDtoOutput._(order: order.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'order';
        order.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminDispatchStateDtoOutput',
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
