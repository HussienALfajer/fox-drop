// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_orders_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantOrdersDtoOutput extends MerchantOrdersDtoOutput {
  @override
  final BuiltList<MerchantOrdersDtoOutputOrdersInner> orders;

  factory _$MerchantOrdersDtoOutput([
    void Function(MerchantOrdersDtoOutputBuilder)? updates,
  ]) => (MerchantOrdersDtoOutputBuilder()..update(updates))._build();

  _$MerchantOrdersDtoOutput._({required this.orders}) : super._();
  @override
  MerchantOrdersDtoOutput rebuild(
    void Function(MerchantOrdersDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantOrdersDtoOutputBuilder toBuilder() =>
      MerchantOrdersDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOrdersDtoOutput && orders == other.orders;
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
      r'MerchantOrdersDtoOutput',
    )..add('orders', orders)).toString();
  }
}

class MerchantOrdersDtoOutputBuilder
    implements
        Builder<MerchantOrdersDtoOutput, MerchantOrdersDtoOutputBuilder> {
  _$MerchantOrdersDtoOutput? _$v;

  ListBuilder<MerchantOrdersDtoOutputOrdersInner>? _orders;
  ListBuilder<MerchantOrdersDtoOutputOrdersInner> get orders =>
      _$this._orders ??= ListBuilder<MerchantOrdersDtoOutputOrdersInner>();
  set orders(ListBuilder<MerchantOrdersDtoOutputOrdersInner>? orders) =>
      _$this._orders = orders;

  MerchantOrdersDtoOutputBuilder() {
    MerchantOrdersDtoOutput._defaults(this);
  }

  MerchantOrdersDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orders = $v.orders.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantOrdersDtoOutput other) {
    _$v = other as _$MerchantOrdersDtoOutput;
  }

  @override
  void update(void Function(MerchantOrdersDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOrdersDtoOutput build() => _build();

  _$MerchantOrdersDtoOutput _build() {
    _$MerchantOrdersDtoOutput _$result;
    try {
      _$result = _$v ?? _$MerchantOrdersDtoOutput._(orders: orders.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'orders';
        orders.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantOrdersDtoOutput',
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
