// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_dto_output_option_groups_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMenuDtoOutputOptionGroupsInner
    extends AdminMenuDtoOutputOptionGroupsInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final int minChoices;
  @override
  final int maxChoices;
  @override
  final BuiltList<AdminMenuDtoOutputOptionGroupsInnerOptionsInner> options;
  @override
  final BuiltList<String> itemIds;

  factory _$AdminMenuDtoOutputOptionGroupsInner([
    void Function(AdminMenuDtoOutputOptionGroupsInnerBuilder)? updates,
  ]) =>
      (AdminMenuDtoOutputOptionGroupsInnerBuilder()..update(updates))._build();

  _$AdminMenuDtoOutputOptionGroupsInner._({
    required this.id,
    required this.name,
    required this.minChoices,
    required this.maxChoices,
    required this.options,
    required this.itemIds,
  }) : super._();
  @override
  AdminMenuDtoOutputOptionGroupsInner rebuild(
    void Function(AdminMenuDtoOutputOptionGroupsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMenuDtoOutputOptionGroupsInnerBuilder toBuilder() =>
      AdminMenuDtoOutputOptionGroupsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuDtoOutputOptionGroupsInner &&
        id == other.id &&
        name == other.name &&
        minChoices == other.minChoices &&
        maxChoices == other.maxChoices &&
        options == other.options &&
        itemIds == other.itemIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, minChoices.hashCode);
    _$hash = $jc(_$hash, maxChoices.hashCode);
    _$hash = $jc(_$hash, options.hashCode);
    _$hash = $jc(_$hash, itemIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminMenuDtoOutputOptionGroupsInner')
          ..add('id', id)
          ..add('name', name)
          ..add('minChoices', minChoices)
          ..add('maxChoices', maxChoices)
          ..add('options', options)
          ..add('itemIds', itemIds))
        .toString();
  }
}

class AdminMenuDtoOutputOptionGroupsInnerBuilder
    implements
        Builder<
          AdminMenuDtoOutputOptionGroupsInner,
          AdminMenuDtoOutputOptionGroupsInnerBuilder
        > {
  _$AdminMenuDtoOutputOptionGroupsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _minChoices;
  int? get minChoices => _$this._minChoices;
  set minChoices(int? minChoices) => _$this._minChoices = minChoices;

  int? _maxChoices;
  int? get maxChoices => _$this._maxChoices;
  set maxChoices(int? maxChoices) => _$this._maxChoices = maxChoices;

  ListBuilder<AdminMenuDtoOutputOptionGroupsInnerOptionsInner>? _options;
  ListBuilder<AdminMenuDtoOutputOptionGroupsInnerOptionsInner> get options =>
      _$this._options ??=
          ListBuilder<AdminMenuDtoOutputOptionGroupsInnerOptionsInner>();
  set options(
    ListBuilder<AdminMenuDtoOutputOptionGroupsInnerOptionsInner>? options,
  ) => _$this._options = options;

  ListBuilder<String>? _itemIds;
  ListBuilder<String> get itemIds => _$this._itemIds ??= ListBuilder<String>();
  set itemIds(ListBuilder<String>? itemIds) => _$this._itemIds = itemIds;

  AdminMenuDtoOutputOptionGroupsInnerBuilder() {
    AdminMenuDtoOutputOptionGroupsInner._defaults(this);
  }

  AdminMenuDtoOutputOptionGroupsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _minChoices = $v.minChoices;
      _maxChoices = $v.maxChoices;
      _options = $v.options.toBuilder();
      _itemIds = $v.itemIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMenuDtoOutputOptionGroupsInner other) {
    _$v = other as _$AdminMenuDtoOutputOptionGroupsInner;
  }

  @override
  void update(
    void Function(AdminMenuDtoOutputOptionGroupsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuDtoOutputOptionGroupsInner build() => _build();

  _$AdminMenuDtoOutputOptionGroupsInner _build() {
    _$AdminMenuDtoOutputOptionGroupsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminMenuDtoOutputOptionGroupsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminMenuDtoOutputOptionGroupsInner',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AdminMenuDtoOutputOptionGroupsInner',
              'name',
            ),
            minChoices: BuiltValueNullFieldError.checkNotNull(
              minChoices,
              r'AdminMenuDtoOutputOptionGroupsInner',
              'minChoices',
            ),
            maxChoices: BuiltValueNullFieldError.checkNotNull(
              maxChoices,
              r'AdminMenuDtoOutputOptionGroupsInner',
              'maxChoices',
            ),
            options: options.build(),
            itemIds: itemIds.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'options';
        options.build();
        _$failedField = 'itemIds';
        itemIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminMenuDtoOutputOptionGroupsInner',
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
