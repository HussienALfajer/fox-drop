// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_order_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantOrderDtoOutput extends MerchantOrderDtoOutput {
  @override
  final MerchantOrdersDtoOutputOrdersInner order;

  factory _$MerchantOrderDtoOutput([
    void Function(MerchantOrderDtoOutputBuilder)? updates,
  ]) => (MerchantOrderDtoOutputBuilder()..update(updates))._build();

  _$MerchantOrderDtoOutput._({required this.order}) : super._();
  @override
  MerchantOrderDtoOutput rebuild(
    void Function(MerchantOrderDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantOrderDtoOutputBuilder toBuilder() =>
      MerchantOrderDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOrderDtoOutput && order == other.order;
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
      r'MerchantOrderDtoOutput',
    )..add('order', order)).toString();
  }
}

class MerchantOrderDtoOutputBuilder
    implements Builder<MerchantOrderDtoOutput, MerchantOrderDtoOutputBuilder> {
  _$MerchantOrderDtoOutput? _$v;

  MerchantOrdersDtoOutputOrdersInnerBuilder? _order;
  MerchantOrdersDtoOutputOrdersInnerBuilder get order =>
      _$this._order ??= MerchantOrdersDtoOutputOrdersInnerBuilder();
  set order(MerchantOrdersDtoOutputOrdersInnerBuilder? order) =>
      _$this._order = order;

  MerchantOrderDtoOutputBuilder() {
    MerchantOrderDtoOutput._defaults(this);
  }

  MerchantOrderDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _order = $v.order.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantOrderDtoOutput other) {
    _$v = other as _$MerchantOrderDtoOutput;
  }

  @override
  void update(void Function(MerchantOrderDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOrderDtoOutput build() => _build();

  _$MerchantOrderDtoOutput _build() {
    _$MerchantOrderDtoOutput _$result;
    try {
      _$result = _$v ?? _$MerchantOrderDtoOutput._(order: order.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'order';
        order.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantOrderDtoOutput',
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
