// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_removed_lines_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderRemovedLinesInner
    extends AdminOrderDtoOutputOrderRemovedLinesInner {
  @override
  final String name;
  @override
  final int quantity;

  factory _$AdminOrderDtoOutputOrderRemovedLinesInner([
    void Function(AdminOrderDtoOutputOrderRemovedLinesInnerBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderRemovedLinesInnerBuilder()..update(updates))
      ._build();

  _$AdminOrderDtoOutputOrderRemovedLinesInner._({
    required this.name,
    required this.quantity,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderRemovedLinesInner rebuild(
    void Function(AdminOrderDtoOutputOrderRemovedLinesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderRemovedLinesInnerBuilder toBuilder() =>
      AdminOrderDtoOutputOrderRemovedLinesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderRemovedLinesInner &&
        name == other.name &&
        quantity == other.quantity;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderDtoOutputOrderRemovedLinesInner',
          )
          ..add('name', name)
          ..add('quantity', quantity))
        .toString();
  }
}

class AdminOrderDtoOutputOrderRemovedLinesInnerBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderRemovedLinesInner,
          AdminOrderDtoOutputOrderRemovedLinesInnerBuilder
        > {
  _$AdminOrderDtoOutputOrderRemovedLinesInner? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _quantity;
  int? get quantity => _$this._quantity;
  set quantity(int? quantity) => _$this._quantity = quantity;

  AdminOrderDtoOutputOrderRemovedLinesInnerBuilder() {
    AdminOrderDtoOutputOrderRemovedLinesInner._defaults(this);
  }

  AdminOrderDtoOutputOrderRemovedLinesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _quantity = $v.quantity;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderRemovedLinesInner other) {
    _$v = other as _$AdminOrderDtoOutputOrderRemovedLinesInner;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderRemovedLinesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderRemovedLinesInner build() => _build();

  _$AdminOrderDtoOutputOrderRemovedLinesInner _build() {
    final _$result =
        _$v ??
        _$AdminOrderDtoOutputOrderRemovedLinesInner._(
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminOrderDtoOutputOrderRemovedLinesInner',
            'name',
          ),
          quantity: BuiltValueNullFieldError.checkNotNull(
            quantity,
            r'AdminOrderDtoOutputOrderRemovedLinesInner',
            'quantity',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
