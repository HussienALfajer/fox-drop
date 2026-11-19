// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_import_plan_dto_output_changed_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum
_$adminMenuImportPlanDtoOutputChangedInnerFieldsEnum_category =
    const AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum._('category');
const AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum
_$adminMenuImportPlanDtoOutputChangedInnerFieldsEnum_name =
    const AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum._('name');
const AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum
_$adminMenuImportPlanDtoOutputChangedInnerFieldsEnum_description =
    const AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum._('description');
const AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum
_$adminMenuImportPlanDtoOutputChangedInnerFieldsEnum_price =
    const AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum._('price');
const AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum
_$adminMenuImportPlanDtoOutputChangedInnerFieldsEnum_groups =
    const AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum._('groups');

AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum
_$adminMenuImportPlanDtoOutputChangedInnerFieldsEnumValueOf(String name) {
  switch (name) {
    case 'category':
      return _$adminMenuImportPlanDtoOutputChangedInnerFieldsEnum_category;
    case 'name':
      return _$adminMenuImportPlanDtoOutputChangedInnerFieldsEnum_name;
    case 'description':
      return _$adminMenuImportPlanDtoOutputChangedInnerFieldsEnum_description;
    case 'price':
      return _$adminMenuImportPlanDtoOutputChangedInnerFieldsEnum_price;
    case 'groups':
      return _$adminMenuImportPlanDtoOutputChangedInnerFieldsEnum_groups;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum>
_$adminMenuImportPlanDtoOutputChangedInnerFieldsEnumValues =
    BuiltSet<AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum>(
      const <AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum>[
        _$adminMenuImportPlanDtoOutputChangedInnerFieldsEnum_category,
        _$adminMenuImportPlanDtoOutputChangedInnerFieldsEnum_name,
        _$adminMenuImportPlanDtoOutputChangedInnerFieldsEnum_description,
        _$adminMenuImportPlanDtoOutputChangedInnerFieldsEnum_price,
        _$adminMenuImportPlanDtoOutputChangedInnerFieldsEnum_groups,
      ],
    );

Serializer<AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum>
_$adminMenuImportPlanDtoOutputChangedInnerFieldsEnumSerializer =
    _$AdminMenuImportPlanDtoOutputChangedInnerFieldsEnumSerializer();

class _$AdminMenuImportPlanDtoOutputChangedInnerFieldsEnumSerializer
    implements
        PrimitiveSerializer<
          AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'category': 'category',
    'name': 'name',
    'description': 'description',
    'price': 'price',
    'groups': 'groups',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'category': 'category',
    'name': 'name',
    'description': 'description',
    'price': 'price',
    'groups': 'groups',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum,
  ];
  @override
  final String wireName = 'AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminMenuImportPlanDtoOutputChangedInner
    extends AdminMenuImportPlanDtoOutputChangedInner {
  @override
  final int row;
  @override
  final String itemId;
  @override
  final String code;
  @override
  final BuiltList<AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum> fields;
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
  @override
  final String? oldPrice;

  factory _$AdminMenuImportPlanDtoOutputChangedInner([
    void Function(AdminMenuImportPlanDtoOutputChangedInnerBuilder)? updates,
  ]) => (AdminMenuImportPlanDtoOutputChangedInnerBuilder()..update(updates))
      ._build();

  _$AdminMenuImportPlanDtoOutputChangedInner._({
    required this.row,
    required this.itemId,
    required this.code,
    required this.fields,
    required this.categoryName,
    required this.name,
    this.description,
    required this.price,
    required this.groupIds,
    this.oldPrice,
  }) : super._();
  @override
  AdminMenuImportPlanDtoOutputChangedInner rebuild(
    void Function(AdminMenuImportPlanDtoOutputChangedInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMenuImportPlanDtoOutputChangedInnerBuilder toBuilder() =>
      AdminMenuImportPlanDtoOutputChangedInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuImportPlanDtoOutputChangedInner &&
        row == other.row &&
        itemId == other.itemId &&
        code == other.code &&
        fields == other.fields &&
        categoryName == other.categoryName &&
        name == other.name &&
        description == other.description &&
        price == other.price &&
        groupIds == other.groupIds &&
        oldPrice == other.oldPrice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, row.hashCode);
    _$hash = $jc(_$hash, itemId.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, fields.hashCode);
    _$hash = $jc(_$hash, categoryName.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jc(_$hash, groupIds.hashCode);
    _$hash = $jc(_$hash, oldPrice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminMenuImportPlanDtoOutputChangedInner',
          )
          ..add('row', row)
          ..add('itemId', itemId)
          ..add('code', code)
          ..add('fields', fields)
          ..add('categoryName', categoryName)
          ..add('name', name)
          ..add('description', description)
          ..add('price', price)
          ..add('groupIds', groupIds)
          ..add('oldPrice', oldPrice))
        .toString();
  }
}

class AdminMenuImportPlanDtoOutputChangedInnerBuilder
    implements
        Builder<
          AdminMenuImportPlanDtoOutputChangedInner,
          AdminMenuImportPlanDtoOutputChangedInnerBuilder
        > {
  _$AdminMenuImportPlanDtoOutputChangedInner? _$v;

  int? _row;
  int? get row => _$this._row;
  set row(int? row) => _$this._row = row;

  String? _itemId;
  String? get itemId => _$this._itemId;
  set itemId(String? itemId) => _$this._itemId = itemId;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  ListBuilder<AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum>? _fields;
  ListBuilder<AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum> get fields =>
      _$this._fields ??=
          ListBuilder<AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum>();
  set fields(
    ListBuilder<AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum>? fields,
  ) => _$this._fields = fields;

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

  String? _oldPrice;
  String? get oldPrice => _$this._oldPrice;
  set oldPrice(String? oldPrice) => _$this._oldPrice = oldPrice;

  AdminMenuImportPlanDtoOutputChangedInnerBuilder() {
    AdminMenuImportPlanDtoOutputChangedInner._defaults(this);
  }

  AdminMenuImportPlanDtoOutputChangedInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _row = $v.row;
      _itemId = $v.itemId;
      _code = $v.code;
      _fields = $v.fields.toBuilder();
      _categoryName = $v.categoryName;
      _name = $v.name;
      _description = $v.description;
      _price = $v.price;
      _groupIds = $v.groupIds.toBuilder();
      _oldPrice = $v.oldPrice;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMenuImportPlanDtoOutputChangedInner other) {
    _$v = other as _$AdminMenuImportPlanDtoOutputChangedInner;
  }

  @override
  void update(
    void Function(AdminMenuImportPlanDtoOutputChangedInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuImportPlanDtoOutputChangedInner build() => _build();

  _$AdminMenuImportPlanDtoOutputChangedInner _build() {
    _$AdminMenuImportPlanDtoOutputChangedInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminMenuImportPlanDtoOutputChangedInner._(
            row: BuiltValueNullFieldError.checkNotNull(
              row,
              r'AdminMenuImportPlanDtoOutputChangedInner',
              'row',
            ),
            itemId: BuiltValueNullFieldError.checkNotNull(
              itemId,
              r'AdminMenuImportPlanDtoOutputChangedInner',
              'itemId',
            ),
            code: BuiltValueNullFieldError.checkNotNull(
              code,
              r'AdminMenuImportPlanDtoOutputChangedInner',
              'code',
            ),
            fields: fields.build(),
            categoryName: BuiltValueNullFieldError.checkNotNull(
              categoryName,
              r'AdminMenuImportPlanDtoOutputChangedInner',
              'categoryName',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AdminMenuImportPlanDtoOutputChangedInner',
              'name',
            ),
            description: description,
            price: BuiltValueNullFieldError.checkNotNull(
              price,
              r'AdminMenuImportPlanDtoOutputChangedInner',
              'price',
            ),
            groupIds: groupIds.build(),
            oldPrice: oldPrice,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'fields';
        fields.build();

        _$failedField = 'groupIds';
        groupIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminMenuImportPlanDtoOutputChangedInner',
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
