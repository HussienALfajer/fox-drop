// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_import_plan_dto_output_added_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMenuImportPlanDtoOutputAddedInner
    extends AdminMenuImportPlanDtoOutputAddedInner {
  @override
  final int row;
  @override
  final String? code;
  @override
  final String categoryName;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String price;
  @override
  final BuiltList<String> groupIds;

  factory _$AdminMenuImportPlanDtoOutputAddedInner([
    void Function(AdminMenuImportPlanDtoOutputAddedInnerBuilder)? updates,
  ]) => (AdminMenuImportPlanDtoOutputAddedInnerBuilder()..update(updates))
      ._build();

  _$AdminMenuImportPlanDtoOutputAddedInner._({
    required this.row,
    this.code,
    required this.categoryName,
    required this.name,
    this.description,
    required this.price,
    required this.groupIds,
  }) : super._();
  @override
  AdminMenuImportPlanDtoOutputAddedInner rebuild(
    void Function(AdminMenuImportPlanDtoOutputAddedInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMenuImportPlanDtoOutputAddedInnerBuilder toBuilder() =>
      AdminMenuImportPlanDtoOutputAddedInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuImportPlanDtoOutputAddedInner &&
        row == other.row &&
        code == other.code &&
        categoryName == other.categoryName &&
        name == other.name &&
        description == other.description &&
        price == other.price &&
        groupIds == other.groupIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, row.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, categoryName.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jc(_$hash, groupIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminMenuImportPlanDtoOutputAddedInner',
          )
          ..add('row', row)
          ..add('code', code)
          ..add('categoryName', categoryName)
          ..add('name', name)
          ..add('description', description)
          ..add('price', price)
          ..add('groupIds', groupIds))
        .toString();
  }
}

class AdminMenuImportPlanDtoOutputAddedInnerBuilder
    implements
        Builder<
          AdminMenuImportPlanDtoOutputAddedInner,
          AdminMenuImportPlanDtoOutputAddedInnerBuilder
        > {
  _$AdminMenuImportPlanDtoOutputAddedInner? _$v;

  int? _row;
  int? get row => _$this._row;
  set row(int? row) => _$this._row = row;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _categoryName;
  String? get categoryName => _$this._categoryName;
  set categoryName(String? categoryName) => _$this._categoryName = categoryName;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _price;
  String? get price => _$this._price;
  set price(String? price) => _$this._price = price;

  ListBuilder<String>? _groupIds;
  ListBuilder<String> get groupIds =>
      _$this._groupIds ??= ListBuilder<String>();
  set groupIds(ListBuilder<String>? groupIds) => _$this._groupIds = groupIds;

  AdminMenuImportPlanDtoOutputAddedInnerBuilder() {
    AdminMenuImportPlanDtoOutputAddedInner._defaults(this);
  }

  AdminMenuImportPlanDtoOutputAddedInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _row = $v.row;
      _code = $v.code;
      _categoryName = $v.categoryName;
      _name = $v.name;
      _description = $v.description;
      _price = $v.price;
      _groupIds = $v.groupIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMenuImportPlanDtoOutputAddedInner other) {
    _$v = other as _$AdminMenuImportPlanDtoOutputAddedInner;
  }

  @override
  void update(
    void Function(AdminMenuImportPlanDtoOutputAddedInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuImportPlanDtoOutputAddedInner build() => _build();

  _$AdminMenuImportPlanDtoOutputAddedInner _build() {
    _$AdminMenuImportPlanDtoOutputAddedInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminMenuImportPlanDtoOutputAddedInner._(
            row: BuiltValueNullFieldError.checkNotNull(
              row,
              r'AdminMenuImportPlanDtoOutputAddedInner',
              'row',
            ),
            code: code,
            categoryName: BuiltValueNullFieldError.checkNotNull(
              categoryName,
              r'AdminMenuImportPlanDtoOutputAddedInner',
              'categoryName',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AdminMenuImportPlanDtoOutputAddedInner',
              'name',
            ),
            description: description,
            price: BuiltValueNullFieldError.checkNotNull(
              price,
              r'AdminMenuImportPlanDtoOutputAddedInner',
              'price',
            ),
            groupIds: groupIds.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'groupIds';
        groupIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminMenuImportPlanDtoOutputAddedInner',
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
