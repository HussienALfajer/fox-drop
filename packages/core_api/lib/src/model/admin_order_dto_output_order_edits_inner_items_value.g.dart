// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_edits_inner_items_value.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderEditsInnerItemsValue
    extends AdminOrderDtoOutputOrderEditsInnerItemsValue {
  @override
  final String before;
  @override
  final String after;

  factory _$AdminOrderDtoOutputOrderEditsInnerItemsValue([
    void Function(AdminOrderDtoOutputOrderEditsInnerItemsValueBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderEditsInnerItemsValueBuilder()..update(updates))
      ._build();

  _$AdminOrderDtoOutputOrderEditsInnerItemsValue._({
    required this.before,
    required this.after,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderEditsInnerItemsValue rebuild(
    void Function(AdminOrderDtoOutputOrderEditsInnerItemsValueBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderEditsInnerItemsValueBuilder toBuilder() =>
      AdminOrderDtoOutputOrderEditsInnerItemsValueBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderEditsInnerItemsValue &&
        before == other.before &&
        after == other.after;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, before.hashCode);
    _$hash = $jc(_$hash, after.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderDtoOutputOrderEditsInnerItemsValue',
          )
          ..add('before', before)
          ..add('after', after))
        .toString();
  }
}

class AdminOrderDtoOutputOrderEditsInnerItemsValueBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderEditsInnerItemsValue,
          AdminOrderDtoOutputOrderEditsInnerItemsValueBuilder
        > {
  _$AdminOrderDtoOutputOrderEditsInnerItemsValue? _$v;

  String? _before;
  String? get before => _$this._before;
  set before(String? before) => _$this._before = before;

  String? _after;
  String? get after => _$this._after;
  set after(String? after) => _$this._after = after;

  AdminOrderDtoOutputOrderEditsInnerItemsValueBuilder() {
    AdminOrderDtoOutputOrderEditsInnerItemsValue._defaults(this);
  }

  AdminOrderDtoOutputOrderEditsInnerItemsValueBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _before = $v.before;
      _after = $v.after;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderEditsInnerItemsValue other) {
    _$v = other as _$AdminOrderDtoOutputOrderEditsInnerItemsValue;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderEditsInnerItemsValueBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderEditsInnerItemsValue build() => _build();

  _$AdminOrderDtoOutputOrderEditsInnerItemsValue _build() {
    final _$result =
        _$v ??
        _$AdminOrderDtoOutputOrderEditsInnerItemsValue._(
          before: BuiltValueNullFieldError.checkNotNull(
            before,
            r'AdminOrderDtoOutputOrderEditsInnerItemsValue',
            'before',
          ),
          after: BuiltValueNullFieldError.checkNotNull(
            after,
            r'AdminOrderDtoOutputOrderEditsInnerItemsValue',
            'after',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
