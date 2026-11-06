// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainActiveOrderDtoOutput extends CaptainActiveOrderDtoOutput {
  @override
  final CaptainActiveOrderDtoOutputOrder? order;

  factory _$CaptainActiveOrderDtoOutput([
    void Function(CaptainActiveOrderDtoOutputBuilder)? updates,
  ]) => (CaptainActiveOrderDtoOutputBuilder()..update(updates))._build();

  _$CaptainActiveOrderDtoOutput._({this.order}) : super._();
  @override
  CaptainActiveOrderDtoOutput rebuild(
    void Function(CaptainActiveOrderDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutput && order == other.order;
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
      r'CaptainActiveOrderDtoOutput',
    )..add('order', order)).toString();
  }
}

class CaptainActiveOrderDtoOutputBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutput,
          CaptainActiveOrderDtoOutputBuilder
        > {
  _$CaptainActiveOrderDtoOutput? _$v;

  CaptainActiveOrderDtoOutputOrderBuilder? _order;
  CaptainActiveOrderDtoOutputOrderBuilder get order =>
      _$this._order ??= CaptainActiveOrderDtoOutputOrderBuilder();
  set order(CaptainActiveOrderDtoOutputOrderBuilder? order) =>
      _$this._order = order;

  CaptainActiveOrderDtoOutputBuilder() {
    CaptainActiveOrderDtoOutput._defaults(this);
  }

  CaptainActiveOrderDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _order = $v.order?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainActiveOrderDtoOutput other) {
    _$v = other as _$CaptainActiveOrderDtoOutput;
  }

  @override
  void update(void Function(CaptainActiveOrderDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutput build() => _build();

  _$CaptainActiveOrderDtoOutput _build() {
    _$CaptainActiveOrderDtoOutput _$result;
    try {
      _$result = _$v ?? _$CaptainActiveOrderDtoOutput._(order: _order?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'order';
        _order?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainActiveOrderDtoOutput',
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
