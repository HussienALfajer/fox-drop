// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_availability_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminMenuAvailabilityDtoTypeEnum
_$adminMenuAvailabilityDtoTypeEnum_category =
    const AdminMenuAvailabilityDtoTypeEnum._('category');
const AdminMenuAvailabilityDtoTypeEnum _$adminMenuAvailabilityDtoTypeEnum_item =
    const AdminMenuAvailabilityDtoTypeEnum._('item');
const AdminMenuAvailabilityDtoTypeEnum
_$adminMenuAvailabilityDtoTypeEnum_option =
    const AdminMenuAvailabilityDtoTypeEnum._('option');

AdminMenuAvailabilityDtoTypeEnum _$adminMenuAvailabilityDtoTypeEnumValueOf(
  String name,
) {
  switch (name) {
    case 'category':
      return _$adminMenuAvailabilityDtoTypeEnum_category;
    case 'item':
      return _$adminMenuAvailabilityDtoTypeEnum_item;
    case 'option':
      return _$adminMenuAvailabilityDtoTypeEnum_option;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminMenuAvailabilityDtoTypeEnum>
_$adminMenuAvailabilityDtoTypeEnumValues =
    BuiltSet<AdminMenuAvailabilityDtoTypeEnum>(
      const <AdminMenuAvailabilityDtoTypeEnum>[
        _$adminMenuAvailabilityDtoTypeEnum_category,
        _$adminMenuAvailabilityDtoTypeEnum_item,
        _$adminMenuAvailabilityDtoTypeEnum_option,
      ],
    );

const AdminMenuAvailabilityDtoUntilEnum
_$adminMenuAvailabilityDtoUntilEnum_tomorrow =
    const AdminMenuAvailabilityDtoUntilEnum._('tomorrow');
const AdminMenuAvailabilityDtoUntilEnum
_$adminMenuAvailabilityDtoUntilEnum_turnedBackOn =
    const AdminMenuAvailabilityDtoUntilEnum._('turnedBackOn');

AdminMenuAvailabilityDtoUntilEnum _$adminMenuAvailabilityDtoUntilEnumValueOf(
  String name,
) {
  switch (name) {
    case 'tomorrow':
      return _$adminMenuAvailabilityDtoUntilEnum_tomorrow;
    case 'turnedBackOn':
      return _$adminMenuAvailabilityDtoUntilEnum_turnedBackOn;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminMenuAvailabilityDtoUntilEnum>
_$adminMenuAvailabilityDtoUntilEnumValues =
    BuiltSet<AdminMenuAvailabilityDtoUntilEnum>(
      const <AdminMenuAvailabilityDtoUntilEnum>[
        _$adminMenuAvailabilityDtoUntilEnum_tomorrow,
        _$adminMenuAvailabilityDtoUntilEnum_turnedBackOn,
      ],
    );

Serializer<AdminMenuAvailabilityDtoTypeEnum>
_$adminMenuAvailabilityDtoTypeEnumSerializer =
    _$AdminMenuAvailabilityDtoTypeEnumSerializer();
Serializer<AdminMenuAvailabilityDtoUntilEnum>
_$adminMenuAvailabilityDtoUntilEnumSerializer =
    _$AdminMenuAvailabilityDtoUntilEnumSerializer();

class _$AdminMenuAvailabilityDtoTypeEnumSerializer
    implements PrimitiveSerializer<AdminMenuAvailabilityDtoTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'category': 'category',
    'item': 'item',
    'option': 'option',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'category': 'category',
    'item': 'item',
    'option': 'option',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminMenuAvailabilityDtoTypeEnum];
  @override
  final String wireName = 'AdminMenuAvailabilityDtoTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuAvailabilityDtoTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminMenuAvailabilityDtoTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminMenuAvailabilityDtoTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminMenuAvailabilityDtoUntilEnumSerializer
    implements PrimitiveSerializer<AdminMenuAvailabilityDtoUntilEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'tomorrow': 'tomorrow',
    'turnedBackOn': 'turned_back_on',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'tomorrow': 'tomorrow',
    'turned_back_on': 'turnedBackOn',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminMenuAvailabilityDtoUntilEnum];
  @override
  final String wireName = 'AdminMenuAvailabilityDtoUntilEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuAvailabilityDtoUntilEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminMenuAvailabilityDtoUntilEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminMenuAvailabilityDtoUntilEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminMenuAvailabilityDto extends AdminMenuAvailabilityDto {
  @override
  final AdminMenuAvailabilityDtoTypeEnum type;
  @override
  final String id;
  @override
  final bool available;
  @override
  final AdminMenuAvailabilityDtoUntilEnum? until;

  factory _$AdminMenuAvailabilityDto([
    void Function(AdminMenuAvailabilityDtoBuilder)? updates,
  ]) => (AdminMenuAvailabilityDtoBuilder()..update(updates))._build();

  _$AdminMenuAvailabilityDto._({
    required this.type,
    required this.id,
    required this.available,
    this.until,
  }) : super._();
  @override
  AdminMenuAvailabilityDto rebuild(
    void Function(AdminMenuAvailabilityDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMenuAvailabilityDtoBuilder toBuilder() =>
      AdminMenuAvailabilityDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuAvailabilityDto &&
        type == other.type &&
        id == other.id &&
        available == other.available &&
        until == other.until;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, available.hashCode);
    _$hash = $jc(_$hash, until.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminMenuAvailabilityDto')
          ..add('type', type)
          ..add('id', id)
          ..add('available', available)
          ..add('until', until))
        .toString();
  }
}

class AdminMenuAvailabilityDtoBuilder
    implements
        Builder<AdminMenuAvailabilityDto, AdminMenuAvailabilityDtoBuilder> {
  _$AdminMenuAvailabilityDto? _$v;

  AdminMenuAvailabilityDtoTypeEnum? _type;
  AdminMenuAvailabilityDtoTypeEnum? get type => _$this._type;
  set type(AdminMenuAvailabilityDtoTypeEnum? type) => _$this._type = type;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  bool? _available;
  bool? get available => _$this._available;
  set available(bool? available) => _$this._available = available;

  AdminMenuAvailabilityDtoUntilEnum? _until;
  AdminMenuAvailabilityDtoUntilEnum? get until => _$this._until;
  set until(AdminMenuAvailabilityDtoUntilEnum? until) => _$this._until = until;

  AdminMenuAvailabilityDtoBuilder() {
    AdminMenuAvailabilityDto._defaults(this);
  }

  AdminMenuAvailabilityDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _id = $v.id;
      _available = $v.available;
      _until = $v.until;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMenuAvailabilityDto other) {
    _$v = other as _$AdminMenuAvailabilityDto;
  }

  @override
  void update(void Function(AdminMenuAvailabilityDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuAvailabilityDto build() => _build();

  _$AdminMenuAvailabilityDto _build() {
    final _$result =
        _$v ??
        _$AdminMenuAvailabilityDto._(
          type: BuiltValueNullFieldError.checkNotNull(
            type,
            r'AdminMenuAvailabilityDto',
            'type',
          ),
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminMenuAvailabilityDto',
            'id',
          ),
          available: BuiltValueNullFieldError.checkNotNull(
            available,
            r'AdminMenuAvailabilityDto',
            'available',
          ),
          until: until,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
