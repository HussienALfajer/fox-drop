// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_order_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainOrderDtoOutput extends CaptainOrderDtoOutput {
  @override
  final CaptainOrderDtoOutputOrder order;

  factory _$CaptainOrderDtoOutput([
    void Function(CaptainOrderDtoOutputBuilder)? updates,
  ]) => (CaptainOrderDtoOutputBuilder()..update(updates))._build();

  _$CaptainOrderDtoOutput._({required this.order}) : super._();
  @override
  CaptainOrderDtoOutput rebuild(
    void Function(CaptainOrderDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainOrderDtoOutputBuilder toBuilder() =>
      CaptainOrderDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainOrderDtoOutput && order == other.order;
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
      r'CaptainOrderDtoOutput',
    )..add('order', order)).toString();
  }
}

class CaptainOrderDtoOutputBuilder
    implements Builder<CaptainOrderDtoOutput, CaptainOrderDtoOutputBuilder> {
  _$CaptainOrderDtoOutput? _$v;

  CaptainOrderDtoOutputOrderBuilder? _order;
  CaptainOrderDtoOutputOrderBuilder get order =>
      _$this._order ??= CaptainOrderDtoOutputOrderBuilder();
  set order(CaptainOrderDtoOutputOrderBuilder? order) => _$this._order = order;

  CaptainOrderDtoOutputBuilder() {
    CaptainOrderDtoOutput._defaults(this);
  }

  CaptainOrderDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _order = $v.order.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainOrderDtoOutput other) {
    _$v = other as _$CaptainOrderDtoOutput;
  }

  @override
  void update(void Function(CaptainOrderDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainOrderDtoOutput build() => _build();

  _$CaptainOrderDtoOutput _build() {
    _$CaptainOrderDtoOutput _$result;
    try {
      _$result = _$v ?? _$CaptainOrderDtoOutput._(order: order.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'order';
        order.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainOrderDtoOutput',
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
