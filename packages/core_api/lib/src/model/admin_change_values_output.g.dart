// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_change_values_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminChangeValuesOutput extends AdminChangeValuesOutput {
  @override
  final String? name;
  @override
  final String? description;
  @override
  final String? photoKey;
  @override
  final AdminChangeMoneyOutput? price;
  @override
  final String? categoryId;
  @override
  final String? groupId;
  @override
  final int? minChoices;
  @override
  final int? maxChoices;
  @override
  final BuiltList<String>? itemIds;
  @override
  final BuiltList<AdminChangeOptionOutput>? options;

  factory _$AdminChangeValuesOutput([
    void Function(AdminChangeValuesOutputBuilder)? updates,
  ]) => (AdminChangeValuesOutputBuilder()..update(updates))._build();

  _$AdminChangeValuesOutput._({
    this.name,
    this.description,
    this.photoKey,
    this.price,
    this.categoryId,
    this.groupId,
    this.minChoices,
    this.maxChoices,
    this.itemIds,
    this.options,
  }) : super._();
  @override
  AdminChangeValuesOutput rebuild(
    void Function(AdminChangeValuesOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminChangeValuesOutputBuilder toBuilder() =>
      AdminChangeValuesOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminChangeValuesOutput &&
        name == other.name &&
        description == other.description &&
        photoKey == other.photoKey &&
        price == other.price &&
        categoryId == other.categoryId &&
        groupId == other.groupId &&
        minChoices == other.minChoices &&
        maxChoices == other.maxChoices &&
        itemIds == other.itemIds &&
        options == other.options;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, photoKey.hashCode);
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, groupId.hashCode);
    _$hash = $jc(_$hash, minChoices.hashCode);
    _$hash = $jc(_$hash, maxChoices.hashCode);
    _$hash = $jc(_$hash, itemIds.hashCode);
    _$hash = $jc(_$hash, options.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminChangeValuesOutput')
          ..add('name', name)
          ..add('description', description)
          ..add('photoKey', photoKey)
          ..add('price', price)
          ..add('categoryId', categoryId)
          ..add('groupId', groupId)
          ..add('minChoices', minChoices)
          ..add('maxChoices', maxChoices)
          ..add('itemIds', itemIds)
          ..add('options', options))
        .toString();
  }
}

class AdminChangeValuesOutputBuilder
    implements
        Builder<AdminChangeValuesOutput, AdminChangeValuesOutputBuilder> {
  _$AdminChangeValuesOutput? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _photoKey;
  String? get photoKey => _$this._photoKey;
  set photoKey(String? photoKey) => _$this._photoKey = photoKey;

  AdminChangeMoneyOutputBuilder? _price;
  AdminChangeMoneyOutputBuilder get price =>
      _$this._price ??= AdminChangeMoneyOutputBuilder();
  set price(AdminChangeMoneyOutputBuilder? price) => _$this._price = price;

  String? _categoryId;
  String? get categoryId => _$this._categoryId;
  set categoryId(String? categoryId) => _$this._categoryId = categoryId;

  String? _groupId;
  String? get groupId => _$this._groupId;
  set groupId(String? groupId) => _$this._groupId = groupId;

  int? _minChoices;
  int? get minChoices => _$this._minChoices;
  set minChoices(int? minChoices) => _$this._minChoices = minChoices;

  int? _maxChoices;
  int? get maxChoices => _$this._maxChoices;
  set maxChoices(int? maxChoices) => _$this._maxChoices = maxChoices;

  ListBuilder<String>? _itemIds;
  ListBuilder<String> get itemIds => _$this._itemIds ??= ListBuilder<String>();
  set itemIds(ListBuilder<String>? itemIds) => _$this._itemIds = itemIds;

  ListBuilder<AdminChangeOptionOutput>? _options;
  ListBuilder<AdminChangeOptionOutput> get options =>
      _$this._options ??= ListBuilder<AdminChangeOptionOutput>();
  set options(ListBuilder<AdminChangeOptionOutput>? options) =>
      _$this._options = options;

  AdminChangeValuesOutputBuilder() {
    AdminChangeValuesOutput._defaults(this);
  }

  AdminChangeValuesOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _description = $v.description;
      _photoKey = $v.photoKey;
      _price = $v.price?.toBuilder();
      _categoryId = $v.categoryId;
      _groupId = $v.groupId;
      _minChoices = $v.minChoices;
      _maxChoices = $v.maxChoices;
      _itemIds = $v.itemIds?.toBuilder();
      _options = $v.options?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminChangeValuesOutput other) {
    _$v = other as _$AdminChangeValuesOutput;
  }

  @override
  void update(void Function(AdminChangeValuesOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminChangeValuesOutput build() => _build();

  _$AdminChangeValuesOutput _build() {
    _$AdminChangeValuesOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminChangeValuesOutput._(
            name: name,
            description: description,
            photoKey: photoKey,
            price: _price?.build(),
            categoryId: categoryId,
            groupId: groupId,
            minChoices: minChoices,
            maxChoices: maxChoices,
            itemIds: _itemIds?.build(),
            options: _options?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'price';
        _price?.build();

        _$failedField = 'itemIds';
        _itemIds?.build();
        _$failedField = 'options';
        _options?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminChangeValuesOutput',
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
