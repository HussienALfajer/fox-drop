// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_availability_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCaptainAvailabilityDtoOutputStateEnum
_$adminCaptainAvailabilityDtoOutputStateEnum_offline =
    const AdminCaptainAvailabilityDtoOutputStateEnum._('offline');
const AdminCaptainAvailabilityDtoOutputStateEnum
_$adminCaptainAvailabilityDtoOutputStateEnum_onlineAvailable =
    const AdminCaptainAvailabilityDtoOutputStateEnum._('onlineAvailable');
const AdminCaptainAvailabilityDtoOutputStateEnum
_$adminCaptainAvailabilityDtoOutputStateEnum_busy =
    const AdminCaptainAvailabilityDtoOutputStateEnum._('busy');
const AdminCaptainAvailabilityDtoOutputStateEnum
_$adminCaptainAvailabilityDtoOutputStateEnum_lastOrder =
    const AdminCaptainAvailabilityDtoOutputStateEnum._('lastOrder');
const AdminCaptainAvailabilityDtoOutputStateEnum
_$adminCaptainAvailabilityDtoOutputStateEnum_notReceivingOffers =
    const AdminCaptainAvailabilityDtoOutputStateEnum._('notReceivingOffers');
const AdminCaptainAvailabilityDtoOutputStateEnum
_$adminCaptainAvailabilityDtoOutputStateEnum_suspended =
    const AdminCaptainAvailabilityDtoOutputStateEnum._('suspended');

AdminCaptainAvailabilityDtoOutputStateEnum
_$adminCaptainAvailabilityDtoOutputStateEnumValueOf(String name) {
  switch (name) {
    case 'offline':
      return _$adminCaptainAvailabilityDtoOutputStateEnum_offline;
    case 'onlineAvailable':
      return _$adminCaptainAvailabilityDtoOutputStateEnum_onlineAvailable;
    case 'busy':
      return _$adminCaptainAvailabilityDtoOutputStateEnum_busy;
    case 'lastOrder':
      return _$adminCaptainAvailabilityDtoOutputStateEnum_lastOrder;
    case 'notReceivingOffers':
      return _$adminCaptainAvailabilityDtoOutputStateEnum_notReceivingOffers;
    case 'suspended':
      return _$adminCaptainAvailabilityDtoOutputStateEnum_suspended;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCaptainAvailabilityDtoOutputStateEnum>
_$adminCaptainAvailabilityDtoOutputStateEnumValues =
    BuiltSet<AdminCaptainAvailabilityDtoOutputStateEnum>(
      const <AdminCaptainAvailabilityDtoOutputStateEnum>[
        _$adminCaptainAvailabilityDtoOutputStateEnum_offline,
        _$adminCaptainAvailabilityDtoOutputStateEnum_onlineAvailable,
        _$adminCaptainAvailabilityDtoOutputStateEnum_busy,
        _$adminCaptainAvailabilityDtoOutputStateEnum_lastOrder,
        _$adminCaptainAvailabilityDtoOutputStateEnum_notReceivingOffers,
        _$adminCaptainAvailabilityDtoOutputStateEnum_suspended,
      ],
    );

const AdminCaptainAvailabilityDtoOutputLastOrderByEnum
_$adminCaptainAvailabilityDtoOutputLastOrderByEnum_captain =
    const AdminCaptainAvailabilityDtoOutputLastOrderByEnum._('captain');
const AdminCaptainAvailabilityDtoOutputLastOrderByEnum
_$adminCaptainAvailabilityDtoOutputLastOrderByEnum_forced =
    const AdminCaptainAvailabilityDtoOutputLastOrderByEnum._('forced');
const AdminCaptainAvailabilityDtoOutputLastOrderByEnum
_$adminCaptainAvailabilityDtoOutputLastOrderByEnum_suspended =
    const AdminCaptainAvailabilityDtoOutputLastOrderByEnum._('suspended');
const AdminCaptainAvailabilityDtoOutputLastOrderByEnum
_$adminCaptainAvailabilityDtoOutputLastOrderByEnum_terminated =
    const AdminCaptainAvailabilityDtoOutputLastOrderByEnum._('terminated');

AdminCaptainAvailabilityDtoOutputLastOrderByEnum
_$adminCaptainAvailabilityDtoOutputLastOrderByEnumValueOf(String name) {
  switch (name) {
    case 'captain':
      return _$adminCaptainAvailabilityDtoOutputLastOrderByEnum_captain;
    case 'forced':
      return _$adminCaptainAvailabilityDtoOutputLastOrderByEnum_forced;
    case 'suspended':
      return _$adminCaptainAvailabilityDtoOutputLastOrderByEnum_suspended;
    case 'terminated':
      return _$adminCaptainAvailabilityDtoOutputLastOrderByEnum_terminated;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCaptainAvailabilityDtoOutputLastOrderByEnum>
_$adminCaptainAvailabilityDtoOutputLastOrderByEnumValues =
    BuiltSet<AdminCaptainAvailabilityDtoOutputLastOrderByEnum>(
      const <AdminCaptainAvailabilityDtoOutputLastOrderByEnum>[
        _$adminCaptainAvailabilityDtoOutputLastOrderByEnum_captain,
        _$adminCaptainAvailabilityDtoOutputLastOrderByEnum_forced,
        _$adminCaptainAvailabilityDtoOutputLastOrderByEnum_suspended,
        _$adminCaptainAvailabilityDtoOutputLastOrderByEnum_terminated,
      ],
    );

Serializer<AdminCaptainAvailabilityDtoOutputStateEnum>
_$adminCaptainAvailabilityDtoOutputStateEnumSerializer =
    _$AdminCaptainAvailabilityDtoOutputStateEnumSerializer();
Serializer<AdminCaptainAvailabilityDtoOutputLastOrderByEnum>
_$adminCaptainAvailabilityDtoOutputLastOrderByEnumSerializer =
    _$AdminCaptainAvailabilityDtoOutputLastOrderByEnumSerializer();

class _$AdminCaptainAvailabilityDtoOutputStateEnumSerializer
    implements PrimitiveSerializer<AdminCaptainAvailabilityDtoOutputStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'offline': 'offline',
    'onlineAvailable': 'online_available',
    'busy': 'busy',
    'lastOrder': 'last_order',
    'notReceivingOffers': 'not_receiving_offers',
    'suspended': 'suspended',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'offline': 'offline',
    'online_available': 'onlineAvailable',
    'busy': 'busy',
    'last_order': 'lastOrder',
    'not_receiving_offers': 'notReceivingOffers',
    'suspended': 'suspended',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminCaptainAvailabilityDtoOutputStateEnum,
  ];
  @override
  final String wireName = 'AdminCaptainAvailabilityDtoOutputStateEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainAvailabilityDtoOutputStateEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCaptainAvailabilityDtoOutputStateEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCaptainAvailabilityDtoOutputStateEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCaptainAvailabilityDtoOutputLastOrderByEnumSerializer
    implements
        PrimitiveSerializer<AdminCaptainAvailabilityDtoOutputLastOrderByEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'captain': 'captain',
    'forced': 'forced',
    'suspended': 'suspended',
    'terminated': 'terminated',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'captain': 'captain',
    'forced': 'forced',
    'suspended': 'suspended',
    'terminated': 'terminated',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminCaptainAvailabilityDtoOutputLastOrderByEnum,
  ];
  @override
  final String wireName = 'AdminCaptainAvailabilityDtoOutputLastOrderByEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainAvailabilityDtoOutputLastOrderByEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCaptainAvailabilityDtoOutputLastOrderByEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCaptainAvailabilityDtoOutputLastOrderByEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCaptainAvailabilityDtoOutput
    extends AdminCaptainAvailabilityDtoOutput {
  @override
  final AdminCaptainAvailabilityDtoOutputStateEnum state;
  @override
  final AdminCaptainAvailabilityDtoOutputLastOrderByEnum? lastOrderBy;

  factory _$AdminCaptainAvailabilityDtoOutput([
    void Function(AdminCaptainAvailabilityDtoOutputBuilder)? updates,
  ]) => (AdminCaptainAvailabilityDtoOutputBuilder()..update(updates))._build();

  _$AdminCaptainAvailabilityDtoOutput._({required this.state, this.lastOrderBy})
    : super._();
  @override
  AdminCaptainAvailabilityDtoOutput rebuild(
    void Function(AdminCaptainAvailabilityDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainAvailabilityDtoOutputBuilder toBuilder() =>
      AdminCaptainAvailabilityDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainAvailabilityDtoOutput &&
        state == other.state &&
        lastOrderBy == other.lastOrderBy;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, lastOrderBy.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCaptainAvailabilityDtoOutput')
          ..add('state', state)
          ..add('lastOrderBy', lastOrderBy))
        .toString();
  }
}

class AdminCaptainAvailabilityDtoOutputBuilder
    implements
        Builder<
          AdminCaptainAvailabilityDtoOutput,
          AdminCaptainAvailabilityDtoOutputBuilder
        > {
  _$AdminCaptainAvailabilityDtoOutput? _$v;

  AdminCaptainAvailabilityDtoOutputStateEnum? _state;
  AdminCaptainAvailabilityDtoOutputStateEnum? get state => _$this._state;
  set state(AdminCaptainAvailabilityDtoOutputStateEnum? state) =>
      _$this._state = state;

  AdminCaptainAvailabilityDtoOutputLastOrderByEnum? _lastOrderBy;
  AdminCaptainAvailabilityDtoOutputLastOrderByEnum? get lastOrderBy =>
      _$this._lastOrderBy;
  set lastOrderBy(
    AdminCaptainAvailabilityDtoOutputLastOrderByEnum? lastOrderBy,
  ) => _$this._lastOrderBy = lastOrderBy;

  AdminCaptainAvailabilityDtoOutputBuilder() {
    AdminCaptainAvailabilityDtoOutput._defaults(this);
  }

  AdminCaptainAvailabilityDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _state = $v.state;
      _lastOrderBy = $v.lastOrderBy;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainAvailabilityDtoOutput other) {
    _$v = other as _$AdminCaptainAvailabilityDtoOutput;
  }

  @override
  void update(
    void Function(AdminCaptainAvailabilityDtoOutputBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainAvailabilityDtoOutput build() => _build();

  _$AdminCaptainAvailabilityDtoOutput _build() {
    final _$result =
        _$v ??
        _$AdminCaptainAvailabilityDtoOutput._(
          state: BuiltValueNullFieldError.checkNotNull(
            state,
            r'AdminCaptainAvailabilityDtoOutput',
            'state',
          ),
          lastOrderBy: lastOrderBy,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
