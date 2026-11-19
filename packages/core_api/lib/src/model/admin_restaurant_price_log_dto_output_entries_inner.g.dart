// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_price_log_dto_output_entries_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum
_$adminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum_item =
    const AdminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum._('item');
const AdminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum
_$adminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum_option =
    const AdminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum._(
      'option',
    );

AdminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum
_$adminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnumValueOf(
  String name,
) {
  switch (name) {
    case 'item':
      return _$adminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum_item;
    case 'option':
      return _$adminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum_option;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum>
_$adminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnumValues =
    BuiltSet<AdminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum>(
      const <AdminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum>[
        _$adminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum_item,
        _$adminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum_option,
      ],
    );

const AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum
_$adminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum_admin =
    const AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum._('admin');
const AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum
_$adminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum_merchant =
    const AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum._('merchant');
const AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum
_$adminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum_system =
    const AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum._('system');

AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum
_$adminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnumValueOf(String name) {
  switch (name) {
    case 'admin':
      return _$adminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum_admin;
    case 'merchant':
      return _$adminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum_merchant;
    case 'system':
      return _$adminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum_system;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum>
_$adminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnumValues =
    BuiltSet<AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum>(
      const <AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum>[
        _$adminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum_admin,
        _$adminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum_merchant,
        _$adminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum_system,
      ],
    );

Serializer<AdminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum>
_$adminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnumSerializer =
    _$AdminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnumSerializer();
Serializer<AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum>
_$adminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnumSerializer =
    _$AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnumSerializer();

class _$AdminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnumSerializer
    implements
        PrimitiveSerializer<
          AdminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'item': 'item',
    'option': 'option',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'item': 'item',
    'option': 'option',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum,
  ];
  @override
  final String wireName =
      'AdminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnumSerializer
    implements
        PrimitiveSerializer<
          AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'admin': 'admin',
    'merchant': 'merchant',
    'system': 'system',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'admin': 'admin',
    'merchant': 'merchant',
    'system': 'system',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum,
  ];
  @override
  final String wireName =
      'AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminRestaurantPriceLogDtoOutputEntriesInner
    extends AdminRestaurantPriceLogDtoOutputEntriesInner {
  @override
  final String id;
  @override
  final AdminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum targetType;
  @override
  final String targetId;
  @override
  final String name;
  @override
  final String? groupName;
  @override
  final AdminPriceLogMoneyOutput oldPrice;
  @override
  final AdminPriceLogMoneyOutput newPrice;
  @override
  final AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum byType;
  @override
  final String? byName;
  @override
  final DateTime at;

  factory _$AdminRestaurantPriceLogDtoOutputEntriesInner([
    void Function(AdminRestaurantPriceLogDtoOutputEntriesInnerBuilder)? updates,
  ]) => (AdminRestaurantPriceLogDtoOutputEntriesInnerBuilder()..update(updates))
      ._build();

  _$AdminRestaurantPriceLogDtoOutputEntriesInner._({
    required this.id,
    required this.targetType,
    required this.targetId,
    required this.name,
    this.groupName,
    required this.oldPrice,
    required this.newPrice,
    required this.byType,
    this.byName,
    required this.at,
  }) : super._();
  @override
  AdminRestaurantPriceLogDtoOutputEntriesInner rebuild(
    void Function(AdminRestaurantPriceLogDtoOutputEntriesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantPriceLogDtoOutputEntriesInnerBuilder toBuilder() =>
      AdminRestaurantPriceLogDtoOutputEntriesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantPriceLogDtoOutputEntriesInner &&
        id == other.id &&
        targetType == other.targetType &&
        targetId == other.targetId &&
        name == other.name &&
        groupName == other.groupName &&
        oldPrice == other.oldPrice &&
        newPrice == other.newPrice &&
        byType == other.byType &&
        byName == other.byName &&
        at == other.at;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, targetType.hashCode);
    _$hash = $jc(_$hash, targetId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, groupName.hashCode);
    _$hash = $jc(_$hash, oldPrice.hashCode);
    _$hash = $jc(_$hash, newPrice.hashCode);
    _$hash = $jc(_$hash, byType.hashCode);
    _$hash = $jc(_$hash, byName.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantPriceLogDtoOutputEntriesInner',
          )
          ..add('id', id)
          ..add('targetType', targetType)
          ..add('targetId', targetId)
          ..add('name', name)
          ..add('groupName', groupName)
          ..add('oldPrice', oldPrice)
          ..add('newPrice', newPrice)
          ..add('byType', byType)
          ..add('byName', byName)
          ..add('at', at))
        .toString();
  }
}

class AdminRestaurantPriceLogDtoOutputEntriesInnerBuilder
    implements
        Builder<
          AdminRestaurantPriceLogDtoOutputEntriesInner,
          AdminRestaurantPriceLogDtoOutputEntriesInnerBuilder
        > {
  _$AdminRestaurantPriceLogDtoOutputEntriesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  AdminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum? _targetType;
  AdminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum? get targetType =>
      _$this._targetType;
  set targetType(
    AdminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum? targetType,
  ) => _$this._targetType = targetType;

  String? _targetId;
  String? get targetId => _$this._targetId;
  set targetId(String? targetId) => _$this._targetId = targetId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _groupName;
  String? get groupName => _$this._groupName;
  set groupName(String? groupName) => _$this._groupName = groupName;

  AdminPriceLogMoneyOutputBuilder? _oldPrice;
  AdminPriceLogMoneyOutputBuilder get oldPrice =>
      _$this._oldPrice ??= AdminPriceLogMoneyOutputBuilder();
  set oldPrice(AdminPriceLogMoneyOutputBuilder? oldPrice) =>
      _$this._oldPrice = oldPrice;

  AdminPriceLogMoneyOutputBuilder? _newPrice;
  AdminPriceLogMoneyOutputBuilder get newPrice =>
      _$this._newPrice ??= AdminPriceLogMoneyOutputBuilder();
  set newPrice(AdminPriceLogMoneyOutputBuilder? newPrice) =>
      _$this._newPrice = newPrice;

  AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum? _byType;
  AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum? get byType =>
      _$this._byType;
  set byType(AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum? byType) =>
      _$this._byType = byType;

  String? _byName;
  String? get byName => _$this._byName;
  set byName(String? byName) => _$this._byName = byName;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  AdminRestaurantPriceLogDtoOutputEntriesInnerBuilder() {
    AdminRestaurantPriceLogDtoOutputEntriesInner._defaults(this);
  }

  AdminRestaurantPriceLogDtoOutputEntriesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _targetType = $v.targetType;
      _targetId = $v.targetId;
      _name = $v.name;
      _groupName = $v.groupName;
      _oldPrice = $v.oldPrice.toBuilder();
      _newPrice = $v.newPrice.toBuilder();
      _byType = $v.byType;
      _byName = $v.byName;
      _at = $v.at;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantPriceLogDtoOutputEntriesInner other) {
    _$v = other as _$AdminRestaurantPriceLogDtoOutputEntriesInner;
  }

  @override
  void update(
    void Function(AdminRestaurantPriceLogDtoOutputEntriesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantPriceLogDtoOutputEntriesInner build() => _build();

  _$AdminRestaurantPriceLogDtoOutputEntriesInner _build() {
    _$AdminRestaurantPriceLogDtoOutputEntriesInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantPriceLogDtoOutputEntriesInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminRestaurantPriceLogDtoOutputEntriesInner',
              'id',
            ),
            targetType: BuiltValueNullFieldError.checkNotNull(
              targetType,
              r'AdminRestaurantPriceLogDtoOutputEntriesInner',
              'targetType',
            ),
            targetId: BuiltValueNullFieldError.checkNotNull(
              targetId,
              r'AdminRestaurantPriceLogDtoOutputEntriesInner',
              'targetId',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AdminRestaurantPriceLogDtoOutputEntriesInner',
              'name',
            ),
            groupName: groupName,
            oldPrice: oldPrice.build(),
            newPrice: newPrice.build(),
            byType: BuiltValueNullFieldError.checkNotNull(
              byType,
              r'AdminRestaurantPriceLogDtoOutputEntriesInner',
              'byType',
            ),
            byName: byName,
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'AdminRestaurantPriceLogDtoOutputEntriesInner',
              'at',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'oldPrice';
        oldPrice.build();
        _$failedField = 'newPrice';
        newPrice.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantPriceLogDtoOutputEntriesInner',
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
