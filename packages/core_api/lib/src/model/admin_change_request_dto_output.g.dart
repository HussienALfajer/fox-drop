// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_change_request_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminChangeRequestDtoOutputTargetTypeEnum
_$adminChangeRequestDtoOutputTargetTypeEnum_category =
    const AdminChangeRequestDtoOutputTargetTypeEnum._('category');
const AdminChangeRequestDtoOutputTargetTypeEnum
_$adminChangeRequestDtoOutputTargetTypeEnum_item =
    const AdminChangeRequestDtoOutputTargetTypeEnum._('item');
const AdminChangeRequestDtoOutputTargetTypeEnum
_$adminChangeRequestDtoOutputTargetTypeEnum_optionGroup =
    const AdminChangeRequestDtoOutputTargetTypeEnum._('optionGroup');
const AdminChangeRequestDtoOutputTargetTypeEnum
_$adminChangeRequestDtoOutputTargetTypeEnum_option =
    const AdminChangeRequestDtoOutputTargetTypeEnum._('option');

AdminChangeRequestDtoOutputTargetTypeEnum
_$adminChangeRequestDtoOutputTargetTypeEnumValueOf(String name) {
  switch (name) {
    case 'category':
      return _$adminChangeRequestDtoOutputTargetTypeEnum_category;
    case 'item':
      return _$adminChangeRequestDtoOutputTargetTypeEnum_item;
    case 'optionGroup':
      return _$adminChangeRequestDtoOutputTargetTypeEnum_optionGroup;
    case 'option':
      return _$adminChangeRequestDtoOutputTargetTypeEnum_option;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminChangeRequestDtoOutputTargetTypeEnum>
_$adminChangeRequestDtoOutputTargetTypeEnumValues =
    BuiltSet<AdminChangeRequestDtoOutputTargetTypeEnum>(
      const <AdminChangeRequestDtoOutputTargetTypeEnum>[
        _$adminChangeRequestDtoOutputTargetTypeEnum_category,
        _$adminChangeRequestDtoOutputTargetTypeEnum_item,
        _$adminChangeRequestDtoOutputTargetTypeEnum_optionGroup,
        _$adminChangeRequestDtoOutputTargetTypeEnum_option,
      ],
    );

const AdminChangeRequestDtoOutputFieldEnum
_$adminChangeRequestDtoOutputFieldEnum_created =
    const AdminChangeRequestDtoOutputFieldEnum._('created');
const AdminChangeRequestDtoOutputFieldEnum
_$adminChangeRequestDtoOutputFieldEnum_name =
    const AdminChangeRequestDtoOutputFieldEnum._('name');
const AdminChangeRequestDtoOutputFieldEnum
_$adminChangeRequestDtoOutputFieldEnum_description =
    const AdminChangeRequestDtoOutputFieldEnum._('description');
const AdminChangeRequestDtoOutputFieldEnum
_$adminChangeRequestDtoOutputFieldEnum_photo =
    const AdminChangeRequestDtoOutputFieldEnum._('photo');
const AdminChangeRequestDtoOutputFieldEnum
_$adminChangeRequestDtoOutputFieldEnum_choices =
    const AdminChangeRequestDtoOutputFieldEnum._('choices');
const AdminChangeRequestDtoOutputFieldEnum
_$adminChangeRequestDtoOutputFieldEnum_items =
    const AdminChangeRequestDtoOutputFieldEnum._('items');

AdminChangeRequestDtoOutputFieldEnum
_$adminChangeRequestDtoOutputFieldEnumValueOf(String name) {
  switch (name) {
    case 'created':
      return _$adminChangeRequestDtoOutputFieldEnum_created;
    case 'name':
      return _$adminChangeRequestDtoOutputFieldEnum_name;
    case 'description':
      return _$adminChangeRequestDtoOutputFieldEnum_description;
    case 'photo':
      return _$adminChangeRequestDtoOutputFieldEnum_photo;
    case 'choices':
      return _$adminChangeRequestDtoOutputFieldEnum_choices;
    case 'items':
      return _$adminChangeRequestDtoOutputFieldEnum_items;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminChangeRequestDtoOutputFieldEnum>
_$adminChangeRequestDtoOutputFieldEnumValues =
    BuiltSet<AdminChangeRequestDtoOutputFieldEnum>(
      const <AdminChangeRequestDtoOutputFieldEnum>[
        _$adminChangeRequestDtoOutputFieldEnum_created,
        _$adminChangeRequestDtoOutputFieldEnum_name,
        _$adminChangeRequestDtoOutputFieldEnum_description,
        _$adminChangeRequestDtoOutputFieldEnum_photo,
        _$adminChangeRequestDtoOutputFieldEnum_choices,
        _$adminChangeRequestDtoOutputFieldEnum_items,
      ],
    );

const AdminChangeRequestDtoOutputStatusEnum
_$adminChangeRequestDtoOutputStatusEnum_pending =
    const AdminChangeRequestDtoOutputStatusEnum._('pending');
const AdminChangeRequestDtoOutputStatusEnum
_$adminChangeRequestDtoOutputStatusEnum_approved =
    const AdminChangeRequestDtoOutputStatusEnum._('approved');
const AdminChangeRequestDtoOutputStatusEnum
_$adminChangeRequestDtoOutputStatusEnum_rejected =
    const AdminChangeRequestDtoOutputStatusEnum._('rejected');
const AdminChangeRequestDtoOutputStatusEnum
_$adminChangeRequestDtoOutputStatusEnum_withdrawn =
    const AdminChangeRequestDtoOutputStatusEnum._('withdrawn');

AdminChangeRequestDtoOutputStatusEnum
_$adminChangeRequestDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'pending':
      return _$adminChangeRequestDtoOutputStatusEnum_pending;
    case 'approved':
      return _$adminChangeRequestDtoOutputStatusEnum_approved;
    case 'rejected':
      return _$adminChangeRequestDtoOutputStatusEnum_rejected;
    case 'withdrawn':
      return _$adminChangeRequestDtoOutputStatusEnum_withdrawn;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminChangeRequestDtoOutputStatusEnum>
_$adminChangeRequestDtoOutputStatusEnumValues =
    BuiltSet<AdminChangeRequestDtoOutputStatusEnum>(
      const <AdminChangeRequestDtoOutputStatusEnum>[
        _$adminChangeRequestDtoOutputStatusEnum_pending,
        _$adminChangeRequestDtoOutputStatusEnum_approved,
        _$adminChangeRequestDtoOutputStatusEnum_rejected,
        _$adminChangeRequestDtoOutputStatusEnum_withdrawn,
      ],
    );

Serializer<AdminChangeRequestDtoOutputTargetTypeEnum>
_$adminChangeRequestDtoOutputTargetTypeEnumSerializer =
    _$AdminChangeRequestDtoOutputTargetTypeEnumSerializer();
Serializer<AdminChangeRequestDtoOutputFieldEnum>
_$adminChangeRequestDtoOutputFieldEnumSerializer =
    _$AdminChangeRequestDtoOutputFieldEnumSerializer();
Serializer<AdminChangeRequestDtoOutputStatusEnum>
_$adminChangeRequestDtoOutputStatusEnumSerializer =
    _$AdminChangeRequestDtoOutputStatusEnumSerializer();

class _$AdminChangeRequestDtoOutputTargetTypeEnumSerializer
    implements PrimitiveSerializer<AdminChangeRequestDtoOutputTargetTypeEnum> {
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
    AdminChangeRequestDtoOutputTargetTypeEnum,
  ];
  @override
  final String wireName = 'AdminChangeRequestDtoOutputTargetTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminChangeRequestDtoOutputTargetTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminChangeRequestDtoOutputTargetTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminChangeRequestDtoOutputTargetTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminChangeRequestDtoOutputFieldEnumSerializer
    implements PrimitiveSerializer<AdminChangeRequestDtoOutputFieldEnum> {
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
    AdminChangeRequestDtoOutputFieldEnum,
  ];
  @override
  final String wireName = 'AdminChangeRequestDtoOutputFieldEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminChangeRequestDtoOutputFieldEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminChangeRequestDtoOutputFieldEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminChangeRequestDtoOutputFieldEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminChangeRequestDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<AdminChangeRequestDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'pending': 'pending',
    'approved': 'approved',
    'rejected': 'rejected',
    'withdrawn': 'withdrawn',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'pending': 'pending',
    'approved': 'approved',
    'rejected': 'rejected',
    'withdrawn': 'withdrawn',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminChangeRequestDtoOutputStatusEnum,
  ];
  @override
  final String wireName = 'AdminChangeRequestDtoOutputStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminChangeRequestDtoOutputStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminChangeRequestDtoOutputStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminChangeRequestDtoOutputStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminChangeRequestDtoOutput extends AdminChangeRequestDtoOutput {
  @override
  final String id;
  @override
  final String restaurantId;
  @override
  final String restaurantName;
  @override
  final AdminChangeRequestDtoOutputTargetTypeEnum targetType;
  @override
  final String targetId;
  @override
  final AdminChangeRequestDtoOutputFieldEnum field;
  @override
  final String targetName;
  @override
  final DateTime createdAt;
  @override
  final AdminChangeRequestDtoOutputStatusEnum status;
  @override
  final AdminChangeValuesOutput? before;
  @override
  final AdminChangeValuesOutput after;
  @override
  final String? parentName;
  @override
  final AdminChangeItemOutput? item;
  @override
  final BuiltList<AdminChangeItemNameOutput> itemNames;

  factory _$AdminChangeRequestDtoOutput([
    void Function(AdminChangeRequestDtoOutputBuilder)? updates,
  ]) => (AdminChangeRequestDtoOutputBuilder()..update(updates))._build();

  _$AdminChangeRequestDtoOutput._({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.targetType,
    required this.targetId,
    required this.field,
    required this.targetName,
    required this.createdAt,
    required this.status,
    this.before,
    required this.after,
    this.parentName,
    this.item,
    required this.itemNames,
  }) : super._();
  @override
  AdminChangeRequestDtoOutput rebuild(
    void Function(AdminChangeRequestDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminChangeRequestDtoOutputBuilder toBuilder() =>
      AdminChangeRequestDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminChangeRequestDtoOutput &&
        id == other.id &&
        restaurantId == other.restaurantId &&
        restaurantName == other.restaurantName &&
        targetType == other.targetType &&
        targetId == other.targetId &&
        field == other.field &&
        targetName == other.targetName &&
        createdAt == other.createdAt &&
        status == other.status &&
        before == other.before &&
        after == other.after &&
        parentName == other.parentName &&
        item == other.item &&
        itemNames == other.itemNames;
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
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, before.hashCode);
    _$hash = $jc(_$hash, after.hashCode);
    _$hash = $jc(_$hash, parentName.hashCode);
    _$hash = $jc(_$hash, item.hashCode);
    _$hash = $jc(_$hash, itemNames.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminChangeRequestDtoOutput')
          ..add('id', id)
          ..add('restaurantId', restaurantId)
          ..add('restaurantName', restaurantName)
          ..add('targetType', targetType)
          ..add('targetId', targetId)
          ..add('field', field)
          ..add('targetName', targetName)
          ..add('createdAt', createdAt)
          ..add('status', status)
          ..add('before', before)
          ..add('after', after)
          ..add('parentName', parentName)
          ..add('item', item)
          ..add('itemNames', itemNames))
        .toString();
  }
}

class AdminChangeRequestDtoOutputBuilder
    implements
        Builder<
          AdminChangeRequestDtoOutput,
          AdminChangeRequestDtoOutputBuilder
        > {
  _$AdminChangeRequestDtoOutput? _$v;

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

  AdminChangeRequestDtoOutputTargetTypeEnum? _targetType;
  AdminChangeRequestDtoOutputTargetTypeEnum? get targetType =>
      _$this._targetType;
  set targetType(AdminChangeRequestDtoOutputTargetTypeEnum? targetType) =>
      _$this._targetType = targetType;

  String? _targetId;
  String? get targetId => _$this._targetId;
  set targetId(String? targetId) => _$this._targetId = targetId;

  AdminChangeRequestDtoOutputFieldEnum? _field;
  AdminChangeRequestDtoOutputFieldEnum? get field => _$this._field;
  set field(AdminChangeRequestDtoOutputFieldEnum? field) =>
      _$this._field = field;

  String? _targetName;
  String? get targetName => _$this._targetName;
  set targetName(String? targetName) => _$this._targetName = targetName;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  AdminChangeRequestDtoOutputStatusEnum? _status;
  AdminChangeRequestDtoOutputStatusEnum? get status => _$this._status;
  set status(AdminChangeRequestDtoOutputStatusEnum? status) =>
      _$this._status = status;

  AdminChangeValuesOutputBuilder? _before;
  AdminChangeValuesOutputBuilder get before =>
      _$this._before ??= AdminChangeValuesOutputBuilder();
  set before(AdminChangeValuesOutputBuilder? before) => _$this._before = before;

  AdminChangeValuesOutputBuilder? _after;
  AdminChangeValuesOutputBuilder get after =>
      _$this._after ??= AdminChangeValuesOutputBuilder();
  set after(AdminChangeValuesOutputBuilder? after) => _$this._after = after;

  String? _parentName;
  String? get parentName => _$this._parentName;
  set parentName(String? parentName) => _$this._parentName = parentName;

  AdminChangeItemOutputBuilder? _item;
  AdminChangeItemOutputBuilder get item =>
      _$this._item ??= AdminChangeItemOutputBuilder();
  set item(AdminChangeItemOutputBuilder? item) => _$this._item = item;

  ListBuilder<AdminChangeItemNameOutput>? _itemNames;
  ListBuilder<AdminChangeItemNameOutput> get itemNames =>
      _$this._itemNames ??= ListBuilder<AdminChangeItemNameOutput>();
  set itemNames(ListBuilder<AdminChangeItemNameOutput>? itemNames) =>
      _$this._itemNames = itemNames;

  AdminChangeRequestDtoOutputBuilder() {
    AdminChangeRequestDtoOutput._defaults(this);
  }

  AdminChangeRequestDtoOutputBuilder get _$this {
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
      _status = $v.status;
      _before = $v.before?.toBuilder();
      _after = $v.after.toBuilder();
      _parentName = $v.parentName;
      _item = $v.item?.toBuilder();
      _itemNames = $v.itemNames.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminChangeRequestDtoOutput other) {
    _$v = other as _$AdminChangeRequestDtoOutput;
  }

  @override
  void update(void Function(AdminChangeRequestDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminChangeRequestDtoOutput build() => _build();

  _$AdminChangeRequestDtoOutput _build() {
    _$AdminChangeRequestDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminChangeRequestDtoOutput._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminChangeRequestDtoOutput',
              'id',
            ),
            restaurantId: BuiltValueNullFieldError.checkNotNull(
              restaurantId,
              r'AdminChangeRequestDtoOutput',
              'restaurantId',
            ),
            restaurantName: BuiltValueNullFieldError.checkNotNull(
              restaurantName,
              r'AdminChangeRequestDtoOutput',
              'restaurantName',
            ),
            targetType: BuiltValueNullFieldError.checkNotNull(
              targetType,
              r'AdminChangeRequestDtoOutput',
              'targetType',
            ),
            targetId: BuiltValueNullFieldError.checkNotNull(
              targetId,
              r'AdminChangeRequestDtoOutput',
              'targetId',
            ),
            field: BuiltValueNullFieldError.checkNotNull(
              field,
              r'AdminChangeRequestDtoOutput',
              'field',
            ),
            targetName: BuiltValueNullFieldError.checkNotNull(
              targetName,
              r'AdminChangeRequestDtoOutput',
              'targetName',
            ),
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'AdminChangeRequestDtoOutput',
              'createdAt',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'AdminChangeRequestDtoOutput',
              'status',
            ),
            before: _before?.build(),
            after: after.build(),
            parentName: parentName,
            item: _item?.build(),
            itemNames: itemNames.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'before';
        _before?.build();
        _$failedField = 'after';
        after.build();

        _$failedField = 'item';
        _item?.build();
        _$failedField = 'itemNames';
        itemNames.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminChangeRequestDtoOutput',
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
