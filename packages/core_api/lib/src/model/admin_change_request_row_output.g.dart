// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_change_request_row_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminChangeRequestRowOutputTargetTypeEnum
_$adminChangeRequestRowOutputTargetTypeEnum_category =
    const AdminChangeRequestRowOutputTargetTypeEnum._('category');
const AdminChangeRequestRowOutputTargetTypeEnum
_$adminChangeRequestRowOutputTargetTypeEnum_item =
    const AdminChangeRequestRowOutputTargetTypeEnum._('item');
const AdminChangeRequestRowOutputTargetTypeEnum
_$adminChangeRequestRowOutputTargetTypeEnum_optionGroup =
    const AdminChangeRequestRowOutputTargetTypeEnum._('optionGroup');
const AdminChangeRequestRowOutputTargetTypeEnum
_$adminChangeRequestRowOutputTargetTypeEnum_option =
    const AdminChangeRequestRowOutputTargetTypeEnum._('option');

AdminChangeRequestRowOutputTargetTypeEnum
_$adminChangeRequestRowOutputTargetTypeEnumValueOf(String name) {
  switch (name) {
    case 'category':
      return _$adminChangeRequestRowOutputTargetTypeEnum_category;
    case 'item':
      return _$adminChangeRequestRowOutputTargetTypeEnum_item;
    case 'optionGroup':
      return _$adminChangeRequestRowOutputTargetTypeEnum_optionGroup;
    case 'option':
      return _$adminChangeRequestRowOutputTargetTypeEnum_option;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminChangeRequestRowOutputTargetTypeEnum>
_$adminChangeRequestRowOutputTargetTypeEnumValues =
    BuiltSet<AdminChangeRequestRowOutputTargetTypeEnum>(
      const <AdminChangeRequestRowOutputTargetTypeEnum>[
        _$adminChangeRequestRowOutputTargetTypeEnum_category,
        _$adminChangeRequestRowOutputTargetTypeEnum_item,
        _$adminChangeRequestRowOutputTargetTypeEnum_optionGroup,
        _$adminChangeRequestRowOutputTargetTypeEnum_option,
      ],
    );

const AdminChangeRequestRowOutputFieldEnum
_$adminChangeRequestRowOutputFieldEnum_created =
    const AdminChangeRequestRowOutputFieldEnum._('created');
const AdminChangeRequestRowOutputFieldEnum
_$adminChangeRequestRowOutputFieldEnum_name =
    const AdminChangeRequestRowOutputFieldEnum._('name');
const AdminChangeRequestRowOutputFieldEnum
_$adminChangeRequestRowOutputFieldEnum_description =
    const AdminChangeRequestRowOutputFieldEnum._('description');
const AdminChangeRequestRowOutputFieldEnum
_$adminChangeRequestRowOutputFieldEnum_photo =
    const AdminChangeRequestRowOutputFieldEnum._('photo');
const AdminChangeRequestRowOutputFieldEnum
_$adminChangeRequestRowOutputFieldEnum_choices =
    const AdminChangeRequestRowOutputFieldEnum._('choices');
const AdminChangeRequestRowOutputFieldEnum
_$adminChangeRequestRowOutputFieldEnum_items =
    const AdminChangeRequestRowOutputFieldEnum._('items');

AdminChangeRequestRowOutputFieldEnum
_$adminChangeRequestRowOutputFieldEnumValueOf(String name) {
  switch (name) {
    case 'created':
      return _$adminChangeRequestRowOutputFieldEnum_created;
    case 'name':
      return _$adminChangeRequestRowOutputFieldEnum_name;
    case 'description':
      return _$adminChangeRequestRowOutputFieldEnum_description;
    case 'photo':
      return _$adminChangeRequestRowOutputFieldEnum_photo;
    case 'choices':
      return _$adminChangeRequestRowOutputFieldEnum_choices;
    case 'items':
      return _$adminChangeRequestRowOutputFieldEnum_items;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminChangeRequestRowOutputFieldEnum>
_$adminChangeRequestRowOutputFieldEnumValues =
    BuiltSet<AdminChangeRequestRowOutputFieldEnum>(
      const <AdminChangeRequestRowOutputFieldEnum>[
        _$adminChangeRequestRowOutputFieldEnum_created,
        _$adminChangeRequestRowOutputFieldEnum_name,
        _$adminChangeRequestRowOutputFieldEnum_description,
        _$adminChangeRequestRowOutputFieldEnum_photo,
        _$adminChangeRequestRowOutputFieldEnum_choices,
        _$adminChangeRequestRowOutputFieldEnum_items,
      ],
    );

Serializer<AdminChangeRequestRowOutputTargetTypeEnum>
_$adminChangeRequestRowOutputTargetTypeEnumSerializer =
    _$AdminChangeRequestRowOutputTargetTypeEnumSerializer();
Serializer<AdminChangeRequestRowOutputFieldEnum>
_$adminChangeRequestRowOutputFieldEnumSerializer =
    _$AdminChangeRequestRowOutputFieldEnumSerializer();

class _$AdminChangeRequestRowOutputTargetTypeEnumSerializer
    implements PrimitiveSerializer<AdminChangeRequestRowOutputTargetTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'category': 'category',
    'item': 'item',
    'optionGroup': 'option_group',
    'option': 'option',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'category': 'category',
    'item': 'item',
    'option_group': 'optionGroup',
    'option': 'option',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminChangeRequestRowOutputTargetTypeEnum,
  ];
  @override
  final String wireName = 'AdminChangeRequestRowOutputTargetTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminChangeRequestRowOutputTargetTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminChangeRequestRowOutputTargetTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminChangeRequestRowOutputTargetTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminChangeRequestRowOutputFieldEnumSerializer
    implements PrimitiveSerializer<AdminChangeRequestRowOutputFieldEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'created': 'created',
    'name': 'name',
    'description': 'description',
    'photo': 'photo',
    'choices': 'choices',
    'items': 'items',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'created': 'created',
    'name': 'name',
    'description': 'description',
    'photo': 'photo',
    'choices': 'choices',
    'items': 'items',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminChangeRequestRowOutputFieldEnum,
  ];
  @override
  final String wireName = 'AdminChangeRequestRowOutputFieldEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminChangeRequestRowOutputFieldEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminChangeRequestRowOutputFieldEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminChangeRequestRowOutputFieldEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminChangeRequestRowOutput extends AdminChangeRequestRowOutput {
  @override
  final String id;
  @override
  final String restaurantId;
  @override
  final String restaurantName;
  @override
  final AdminChangeRequestRowOutputTargetTypeEnum targetType;
  @override
  final String targetId;
  @override
  final AdminChangeRequestRowOutputFieldEnum field;
  @override
  final String targetName;
  @override
  final DateTime createdAt;

  factory _$AdminChangeRequestRowOutput([
    void Function(AdminChangeRequestRowOutputBuilder)? updates,
  ]) => (AdminChangeRequestRowOutputBuilder()..update(updates))._build();

  _$AdminChangeRequestRowOutput._({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.targetType,
    required this.targetId,
    required this.field,
    required this.targetName,
    required this.createdAt,
  }) : super._();
  @override
  AdminChangeRequestRowOutput rebuild(
    void Function(AdminChangeRequestRowOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminChangeRequestRowOutputBuilder toBuilder() =>
      AdminChangeRequestRowOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminChangeRequestRowOutput &&
        id == other.id &&
        restaurantId == other.restaurantId &&
        restaurantName == other.restaurantName &&
        targetType == other.targetType &&
        targetId == other.targetId &&
        field == other.field &&
        targetName == other.targetName &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, restaurantId.hashCode);
    _$hash = $jc(_$hash, restaurantName.hashCode);
    _$hash = $jc(_$hash, targetType.hashCode);
    _$hash = $jc(_$hash, targetId.hashCode);
    _$hash = $jc(_$hash, field.hashCode);
    _$hash = $jc(_$hash, targetName.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminChangeRequestRowOutput')
          ..add('id', id)
          ..add('restaurantId', restaurantId)
          ..add('restaurantName', restaurantName)
          ..add('targetType', targetType)
          ..add('targetId', targetId)
          ..add('field', field)
          ..add('targetName', targetName)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class AdminChangeRequestRowOutputBuilder
    implements
        Builder<
          AdminChangeRequestRowOutput,
          AdminChangeRequestRowOutputBuilder
        > {
  _$AdminChangeRequestRowOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _restaurantId;
  String? get restaurantId => _$this._restaurantId;
  set restaurantId(String? restaurantId) => _$this._restaurantId = restaurantId;

  String? _restaurantName;
  String? get restaurantName => _$this._restaurantName;
  set restaurantName(String? restaurantName) =>
      _$this._restaurantName = restaurantName;

  AdminChangeRequestRowOutputTargetTypeEnum? _targetType;
  AdminChangeRequestRowOutputTargetTypeEnum? get targetType =>
      _$this._targetType;
  set targetType(AdminChangeRequestRowOutputTargetTypeEnum? targetType) =>
      _$this._targetType = targetType;

  String? _targetId;
  String? get targetId => _$this._targetId;
  set targetId(String? targetId) => _$this._targetId = targetId;

  AdminChangeRequestRowOutputFieldEnum? _field;
  AdminChangeRequestRowOutputFieldEnum? get field => _$this._field;
  set field(AdminChangeRequestRowOutputFieldEnum? field) =>
      _$this._field = field;

  String? _targetName;
  String? get targetName => _$this._targetName;
  set targetName(String? targetName) => _$this._targetName = targetName;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  AdminChangeRequestRowOutputBuilder() {
    AdminChangeRequestRowOutput._defaults(this);
  }

  AdminChangeRequestRowOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _restaurantId = $v.restaurantId;
      _restaurantName = $v.restaurantName;
      _targetType = $v.targetType;
      _targetId = $v.targetId;
      _field = $v.field;
      _targetName = $v.targetName;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminChangeRequestRowOutput other) {
    _$v = other as _$AdminChangeRequestRowOutput;
  }

  @override
  void update(void Function(AdminChangeRequestRowOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminChangeRequestRowOutput build() => _build();

  _$AdminChangeRequestRowOutput _build() {
    final _$result =
        _$v ??
        _$AdminChangeRequestRowOutput._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminChangeRequestRowOutput',
            'id',
          ),
          restaurantId: BuiltValueNullFieldError.checkNotNull(
            restaurantId,
            r'AdminChangeRequestRowOutput',
            'restaurantId',
          ),
          restaurantName: BuiltValueNullFieldError.checkNotNull(
            restaurantName,
            r'AdminChangeRequestRowOutput',
            'restaurantName',
          ),
          targetType: BuiltValueNullFieldError.checkNotNull(
            targetType,
            r'AdminChangeRequestRowOutput',
            'targetType',
          ),
          targetId: BuiltValueNullFieldError.checkNotNull(
            targetId,
            r'AdminChangeRequestRowOutput',
            'targetId',
          ),
          field: BuiltValueNullFieldError.checkNotNull(
            field,
            r'AdminChangeRequestRowOutput',
            'field',
          ),
          targetName: BuiltValueNullFieldError.checkNotNull(
            targetName,
            r'AdminChangeRequestRowOutput',
            'targetName',
          ),
          createdAt: BuiltValueNullFieldError.checkNotNull(
            createdAt,
            r'AdminChangeRequestRowOutput',
            'createdAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
