// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_item_order_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMenuItemOrderDto extends AdminMenuItemOrderDto {
  @override
  final BuiltList<String> itemIds;

  factory _$AdminMenuItemOrderDto([
    void Function(AdminMenuItemOrderDtoBuilder)? updates,
  ]) => (AdminMenuItemOrderDtoBuilder()..update(updates))._build();

  _$AdminMenuItemOrderDto._({required this.itemIds}) : super._();
  @override
  AdminMenuItemOrderDto rebuild(
    void Function(AdminMenuItemOrderDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMenuItemOrderDtoBuilder toBuilder() =>
      AdminMenuItemOrderDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuItemOrderDto && itemIds == other.itemIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, itemIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminMenuItemOrderDto',
    )..add('itemIds', itemIds)).toString();
  }
}

class AdminMenuItemOrderDtoBuilder
    implements Builder<AdminMenuItemOrderDto, AdminMenuItemOrderDtoBuilder> {
  _$AdminMenuItemOrderDto? _$v;

  ListBuilder<String>? _itemIds;
  ListBuilder<String> get itemIds => _$this._itemIds ??= ListBuilder<String>();
  set itemIds(ListBuilder<String>? itemIds) => _$this._itemIds = itemIds;

  AdminMenuItemOrderDtoBuilder() {
    AdminMenuItemOrderDto._defaults(this);
  }

  AdminMenuItemOrderDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _itemIds = $v.itemIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMenuItemOrderDto other) {
    _$v = other as _$AdminMenuItemOrderDto;
  }

  @override
  void update(void Function(AdminMenuItemOrderDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuItemOrderDto build() => _build();

  _$AdminMenuItemOrderDto _build() {
    _$AdminMenuItemOrderDto _$result;
    try {
      _$result = _$v ?? _$AdminMenuItemOrderDto._(itemIds: itemIds.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'itemIds';
        itemIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminMenuItemOrderDto',
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
