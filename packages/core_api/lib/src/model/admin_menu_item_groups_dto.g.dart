// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_item_groups_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMenuItemGroupsDto extends AdminMenuItemGroupsDto {
  @override
  final BuiltList<String> groupIds;

  factory _$AdminMenuItemGroupsDto([
    void Function(AdminMenuItemGroupsDtoBuilder)? updates,
  ]) => (AdminMenuItemGroupsDtoBuilder()..update(updates))._build();

  _$AdminMenuItemGroupsDto._({required this.groupIds}) : super._();
  @override
  AdminMenuItemGroupsDto rebuild(
    void Function(AdminMenuItemGroupsDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMenuItemGroupsDtoBuilder toBuilder() =>
      AdminMenuItemGroupsDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuItemGroupsDto && groupIds == other.groupIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, groupIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminMenuItemGroupsDto',
    )..add('groupIds', groupIds)).toString();
  }
}

class AdminMenuItemGroupsDtoBuilder
    implements Builder<AdminMenuItemGroupsDto, AdminMenuItemGroupsDtoBuilder> {
  _$AdminMenuItemGroupsDto? _$v;

  ListBuilder<String>? _groupIds;
  ListBuilder<String> get groupIds =>
      _$this._groupIds ??= ListBuilder<String>();
  set groupIds(ListBuilder<String>? groupIds) => _$this._groupIds = groupIds;

  AdminMenuItemGroupsDtoBuilder() {
    AdminMenuItemGroupsDto._defaults(this);
  }

  AdminMenuItemGroupsDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _groupIds = $v.groupIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMenuItemGroupsDto other) {
    _$v = other as _$AdminMenuItemGroupsDto;
  }

  @override
  void update(void Function(AdminMenuItemGroupsDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuItemGroupsDto build() => _build();

  _$AdminMenuItemGroupsDto _build() {
    _$AdminMenuItemGroupsDto _$result;
    try {
      _$result = _$v ?? _$AdminMenuItemGroupsDto._(groupIds: groupIds.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'groupIds';
        groupIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminMenuItemGroupsDto',
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
