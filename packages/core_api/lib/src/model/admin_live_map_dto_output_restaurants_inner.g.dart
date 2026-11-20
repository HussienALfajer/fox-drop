// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_live_map_dto_output_restaurants_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminLiveMapDtoOutputRestaurantsInnerStateEnum
_$adminLiveMapDtoOutputRestaurantsInnerStateEnum_open =
    const AdminLiveMapDtoOutputRestaurantsInnerStateEnum._('open');
const AdminLiveMapDtoOutputRestaurantsInnerStateEnum
_$adminLiveMapDtoOutputRestaurantsInnerStateEnum_busy =
    const AdminLiveMapDtoOutputRestaurantsInnerStateEnum._('busy');
const AdminLiveMapDtoOutputRestaurantsInnerStateEnum
_$adminLiveMapDtoOutputRestaurantsInnerStateEnum_paused =
    const AdminLiveMapDtoOutputRestaurantsInnerStateEnum._('paused');
const AdminLiveMapDtoOutputRestaurantsInnerStateEnum
_$adminLiveMapDtoOutputRestaurantsInnerStateEnum_closed =
    const AdminLiveMapDtoOutputRestaurantsInnerStateEnum._('closed');
const AdminLiveMapDtoOutputRestaurantsInnerStateEnum
_$adminLiveMapDtoOutputRestaurantsInnerStateEnum_holiday =
    const AdminLiveMapDtoOutputRestaurantsInnerStateEnum._('holiday');
const AdminLiveMapDtoOutputRestaurantsInnerStateEnum
_$adminLiveMapDtoOutputRestaurantsInnerStateEnum_suspended =
    const AdminLiveMapDtoOutputRestaurantsInnerStateEnum._('suspended');

AdminLiveMapDtoOutputRestaurantsInnerStateEnum
_$adminLiveMapDtoOutputRestaurantsInnerStateEnumValueOf(String name) {
  switch (name) {
    case 'open':
      return _$adminLiveMapDtoOutputRestaurantsInnerStateEnum_open;
    case 'busy':
      return _$adminLiveMapDtoOutputRestaurantsInnerStateEnum_busy;
    case 'paused':
      return _$adminLiveMapDtoOutputRestaurantsInnerStateEnum_paused;
    case 'closed':
      return _$adminLiveMapDtoOutputRestaurantsInnerStateEnum_closed;
    case 'holiday':
      return _$adminLiveMapDtoOutputRestaurantsInnerStateEnum_holiday;
    case 'suspended':
      return _$adminLiveMapDtoOutputRestaurantsInnerStateEnum_suspended;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminLiveMapDtoOutputRestaurantsInnerStateEnum>
_$adminLiveMapDtoOutputRestaurantsInnerStateEnumValues =
    BuiltSet<AdminLiveMapDtoOutputRestaurantsInnerStateEnum>(
      const <AdminLiveMapDtoOutputRestaurantsInnerStateEnum>[
        _$adminLiveMapDtoOutputRestaurantsInnerStateEnum_open,
        _$adminLiveMapDtoOutputRestaurantsInnerStateEnum_busy,
        _$adminLiveMapDtoOutputRestaurantsInnerStateEnum_paused,
        _$adminLiveMapDtoOutputRestaurantsInnerStateEnum_closed,
        _$adminLiveMapDtoOutputRestaurantsInnerStateEnum_holiday,
        _$adminLiveMapDtoOutputRestaurantsInnerStateEnum_suspended,
      ],
    );

Serializer<AdminLiveMapDtoOutputRestaurantsInnerStateEnum>
_$adminLiveMapDtoOutputRestaurantsInnerStateEnumSerializer =
    _$AdminLiveMapDtoOutputRestaurantsInnerStateEnumSerializer();

class _$AdminLiveMapDtoOutputRestaurantsInnerStateEnumSerializer
    implements
        PrimitiveSerializer<AdminLiveMapDtoOutputRestaurantsInnerStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'open': 'open',
    'busy': 'busy',
    'paused': 'paused',
    'closed': 'closed',
    'holiday': 'holiday',
    'suspended': 'suspended',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'open': 'open',
    'busy': 'busy',
    'paused': 'paused',
    'closed': 'closed',
    'holiday': 'holiday',
    'suspended': 'suspended',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminLiveMapDtoOutputRestaurantsInnerStateEnum,
  ];
  @override
  final String wireName = 'AdminLiveMapDtoOutputRestaurantsInnerStateEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminLiveMapDtoOutputRestaurantsInnerStateEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminLiveMapDtoOutputRestaurantsInnerStateEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminLiveMapDtoOutputRestaurantsInnerStateEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminLiveMapDtoOutputRestaurantsInner
    extends AdminLiveMapDtoOutputRestaurantsInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final AdminCustomerDtoOutputAddressesInnerLocation location;
  @override
  final AdminLiveMapDtoOutputRestaurantsInnerStateEnum state;

  factory _$AdminLiveMapDtoOutputRestaurantsInner([
    void Function(AdminLiveMapDtoOutputRestaurantsInnerBuilder)? updates,
  ]) => (AdminLiveMapDtoOutputRestaurantsInnerBuilder()..update(updates))
      ._build();

  _$AdminLiveMapDtoOutputRestaurantsInner._({
    required this.id,
    required this.name,
    required this.location,
    required this.state,
  }) : super._();
  @override
  AdminLiveMapDtoOutputRestaurantsInner rebuild(
    void Function(AdminLiveMapDtoOutputRestaurantsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminLiveMapDtoOutputRestaurantsInnerBuilder toBuilder() =>
      AdminLiveMapDtoOutputRestaurantsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminLiveMapDtoOutputRestaurantsInner &&
        id == other.id &&
        name == other.name &&
        location == other.location &&
        state == other.state;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminLiveMapDtoOutputRestaurantsInner',
          )
          ..add('id', id)
          ..add('name', name)
          ..add('location', location)
          ..add('state', state))
        .toString();
  }
}

class AdminLiveMapDtoOutputRestaurantsInnerBuilder
    implements
        Builder<
          AdminLiveMapDtoOutputRestaurantsInner,
          AdminLiveMapDtoOutputRestaurantsInnerBuilder
        > {
  _$AdminLiveMapDtoOutputRestaurantsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminCustomerDtoOutputAddressesInnerLocationBuilder? _location;
  AdminCustomerDtoOutputAddressesInnerLocationBuilder get location =>
      _$this._location ??=
          AdminCustomerDtoOutputAddressesInnerLocationBuilder();
  set location(AdminCustomerDtoOutputAddressesInnerLocationBuilder? location) =>
      _$this._location = location;

  AdminLiveMapDtoOutputRestaurantsInnerStateEnum? _state;
  AdminLiveMapDtoOutputRestaurantsInnerStateEnum? get state => _$this._state;
  set state(AdminLiveMapDtoOutputRestaurantsInnerStateEnum? state) =>
      _$this._state = state;

  AdminLiveMapDtoOutputRestaurantsInnerBuilder() {
    AdminLiveMapDtoOutputRestaurantsInner._defaults(this);
  }

  AdminLiveMapDtoOutputRestaurantsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _location = $v.location.toBuilder();
      _state = $v.state;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminLiveMapDtoOutputRestaurantsInner other) {
    _$v = other as _$AdminLiveMapDtoOutputRestaurantsInner;
  }

  @override
  void update(
    void Function(AdminLiveMapDtoOutputRestaurantsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminLiveMapDtoOutputRestaurantsInner build() => _build();

  _$AdminLiveMapDtoOutputRestaurantsInner _build() {
    _$AdminLiveMapDtoOutputRestaurantsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminLiveMapDtoOutputRestaurantsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminLiveMapDtoOutputRestaurantsInner',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AdminLiveMapDtoOutputRestaurantsInner',
              'name',
            ),
            location: location.build(),
            state: BuiltValueNullFieldError.checkNotNull(
              state,
              r'AdminLiveMapDtoOutputRestaurantsInner',
              'state',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'location';
        location.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminLiveMapDtoOutputRestaurantsInner',
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
