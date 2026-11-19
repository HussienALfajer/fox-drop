// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_bulk_availability_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminMenuBulkAvailabilityDtoUntilEnum
_$adminMenuBulkAvailabilityDtoUntilEnum_tomorrow =
    const AdminMenuBulkAvailabilityDtoUntilEnum._('tomorrow');
const AdminMenuBulkAvailabilityDtoUntilEnum
_$adminMenuBulkAvailabilityDtoUntilEnum_turnedBackOn =
    const AdminMenuBulkAvailabilityDtoUntilEnum._('turnedBackOn');

AdminMenuBulkAvailabilityDtoUntilEnum
_$adminMenuBulkAvailabilityDtoUntilEnumValueOf(String name) {
  switch (name) {
    case 'tomorrow':
      return _$adminMenuBulkAvailabilityDtoUntilEnum_tomorrow;
    case 'turnedBackOn':
      return _$adminMenuBulkAvailabilityDtoUntilEnum_turnedBackOn;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminMenuBulkAvailabilityDtoUntilEnum>
_$adminMenuBulkAvailabilityDtoUntilEnumValues =
    BuiltSet<AdminMenuBulkAvailabilityDtoUntilEnum>(
      const <AdminMenuBulkAvailabilityDtoUntilEnum>[
        _$adminMenuBulkAvailabilityDtoUntilEnum_tomorrow,
        _$adminMenuBulkAvailabilityDtoUntilEnum_turnedBackOn,
      ],
    );

Serializer<AdminMenuBulkAvailabilityDtoUntilEnum>
_$adminMenuBulkAvailabilityDtoUntilEnumSerializer =
    _$AdminMenuBulkAvailabilityDtoUntilEnumSerializer();

class _$AdminMenuBulkAvailabilityDtoUntilEnumSerializer
    implements PrimitiveSerializer<AdminMenuBulkAvailabilityDtoUntilEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'tomorrow': 'tomorrow',
    'turnedBackOn': 'turned_back_on',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'tomorrow': 'tomorrow',
    'turned_back_on': 'turnedBackOn',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminMenuBulkAvailabilityDtoUntilEnum,
  ];
  @override
  final String wireName = 'AdminMenuBulkAvailabilityDtoUntilEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuBulkAvailabilityDtoUntilEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminMenuBulkAvailabilityDtoUntilEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminMenuBulkAvailabilityDtoUntilEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminMenuBulkAvailabilityDto extends AdminMenuBulkAvailabilityDto {
  @override
  final BuiltList<String> itemIds;
  @override
  final bool available;
  @override
  final AdminMenuBulkAvailabilityDtoUntilEnum? until;

  factory _$AdminMenuBulkAvailabilityDto([
    void Function(AdminMenuBulkAvailabilityDtoBuilder)? updates,
  ]) => (AdminMenuBulkAvailabilityDtoBuilder()..update(updates))._build();

  _$AdminMenuBulkAvailabilityDto._({
    required this.itemIds,
    required this.available,
    this.until,
  }) : super._();
  @override
  AdminMenuBulkAvailabilityDto rebuild(
    void Function(AdminMenuBulkAvailabilityDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMenuBulkAvailabilityDtoBuilder toBuilder() =>
      AdminMenuBulkAvailabilityDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuBulkAvailabilityDto &&
        itemIds == other.itemIds &&
        available == other.available &&
        until == other.until;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, itemIds.hashCode);
    _$hash = $jc(_$hash, available.hashCode);
    _$hash = $jc(_$hash, until.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminMenuBulkAvailabilityDto')
          ..add('itemIds', itemIds)
          ..add('available', available)
          ..add('until', until))
        .toString();
  }
}

class AdminMenuBulkAvailabilityDtoBuilder
    implements
        Builder<
          AdminMenuBulkAvailabilityDto,
          AdminMenuBulkAvailabilityDtoBuilder
        > {
  _$AdminMenuBulkAvailabilityDto? _$v;

  ListBuilder<String>? _itemIds;
  ListBuilder<String> get itemIds => _$this._itemIds ??= ListBuilder<String>();
  set itemIds(ListBuilder<String>? itemIds) => _$this._itemIds = itemIds;

  bool? _available;
  bool? get available => _$this._available;
  set available(bool? available) => _$this._available = available;

  AdminMenuBulkAvailabilityDtoUntilEnum? _until;
  AdminMenuBulkAvailabilityDtoUntilEnum? get until => _$this._until;
  set until(AdminMenuBulkAvailabilityDtoUntilEnum? until) =>
      _$this._until = until;

  AdminMenuBulkAvailabilityDtoBuilder() {
    AdminMenuBulkAvailabilityDto._defaults(this);
  }

  AdminMenuBulkAvailabilityDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _itemIds = $v.itemIds.toBuilder();
      _available = $v.available;
      _until = $v.until;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMenuBulkAvailabilityDto other) {
    _$v = other as _$AdminMenuBulkAvailabilityDto;
  }

  @override
  void update(void Function(AdminMenuBulkAvailabilityDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuBulkAvailabilityDto build() => _build();

  _$AdminMenuBulkAvailabilityDto _build() {
    _$AdminMenuBulkAvailabilityDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminMenuBulkAvailabilityDto._(
            itemIds: itemIds.build(),
            available: BuiltValueNullFieldError.checkNotNull(
              available,
              r'AdminMenuBulkAvailabilityDto',
              'available',
            ),
            until: until,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'itemIds';
        itemIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminMenuBulkAvailabilityDto',
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
