// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_group_items_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMenuGroupItemsDto extends AdminMenuGroupItemsDto {
  @override
  final BuiltList<String> itemIds;

  factory _$AdminMenuGroupItemsDto([
    void Function(AdminMenuGroupItemsDtoBuilder)? updates,
  ]) => (AdminMenuGroupItemsDtoBuilder()..update(updates))._build();

  _$AdminMenuGroupItemsDto._({required this.itemIds}) : super._();
  @override
  AdminMenuGroupItemsDto rebuild(
    void Function(AdminMenuGroupItemsDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMenuGroupItemsDtoBuilder toBuilder() =>
      AdminMenuGroupItemsDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuGroupItemsDto && itemIds == other.itemIds;
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
      r'AdminMenuGroupItemsDto',
    )..add('itemIds', itemIds)).toString();
  }
}

class AdminMenuGroupItemsDtoBuilder
    implements Builder<AdminMenuGroupItemsDto, AdminMenuGroupItemsDtoBuilder> {
  _$AdminMenuGroupItemsDto? _$v;

  ListBuilder<String>? _itemIds;
  ListBuilder<String> get itemIds => _$this._itemIds ??= ListBuilder<String>();
  set itemIds(ListBuilder<String>? itemIds) => _$this._itemIds = itemIds;

  AdminMenuGroupItemsDtoBuilder() {
    AdminMenuGroupItemsDto._defaults(this);
  }

  AdminMenuGroupItemsDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _itemIds = $v.itemIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMenuGroupItemsDto other) {
    _$v = other as _$AdminMenuGroupItemsDto;
  }

  @override
  void update(void Function(AdminMenuGroupItemsDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuGroupItemsDto build() => _build();

  _$AdminMenuGroupItemsDto _build() {
    _$AdminMenuGroupItemsDto _$result;
    try {
      _$result = _$v ?? _$AdminMenuGroupItemsDto._(itemIds: itemIds.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'itemIds';
        itemIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminMenuGroupItemsDto',
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
