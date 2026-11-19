// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_audit_log_dto_output_events_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminAuditLogDtoOutputEventsInnerKindEnum
_$adminAuditLogDtoOutputEventsInnerKindEnum_write =
    const AdminAuditLogDtoOutputEventsInnerKindEnum._('write');
const AdminAuditLogDtoOutputEventsInnerKindEnum
_$adminAuditLogDtoOutputEventsInnerKindEnum_view =
    const AdminAuditLogDtoOutputEventsInnerKindEnum._('view');

AdminAuditLogDtoOutputEventsInnerKindEnum
_$adminAuditLogDtoOutputEventsInnerKindEnumValueOf(String name) {
  switch (name) {
    case 'write':
      return _$adminAuditLogDtoOutputEventsInnerKindEnum_write;
    case 'view':
      return _$adminAuditLogDtoOutputEventsInnerKindEnum_view;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminAuditLogDtoOutputEventsInnerKindEnum>
_$adminAuditLogDtoOutputEventsInnerKindEnumValues =
    BuiltSet<AdminAuditLogDtoOutputEventsInnerKindEnum>(
      const <AdminAuditLogDtoOutputEventsInnerKindEnum>[
        _$adminAuditLogDtoOutputEventsInnerKindEnum_write,
        _$adminAuditLogDtoOutputEventsInnerKindEnum_view,
      ],
    );

const AdminAuditLogDtoOutputEventsInnerActorTypeEnum
_$adminAuditLogDtoOutputEventsInnerActorTypeEnum_admin =
    const AdminAuditLogDtoOutputEventsInnerActorTypeEnum._('admin');
const AdminAuditLogDtoOutputEventsInnerActorTypeEnum
_$adminAuditLogDtoOutputEventsInnerActorTypeEnum_merchant =
    const AdminAuditLogDtoOutputEventsInnerActorTypeEnum._('merchant');
const AdminAuditLogDtoOutputEventsInnerActorTypeEnum
_$adminAuditLogDtoOutputEventsInnerActorTypeEnum_captain =
    const AdminAuditLogDtoOutputEventsInnerActorTypeEnum._('captain');
const AdminAuditLogDtoOutputEventsInnerActorTypeEnum
_$adminAuditLogDtoOutputEventsInnerActorTypeEnum_customer =
    const AdminAuditLogDtoOutputEventsInnerActorTypeEnum._('customer');
const AdminAuditLogDtoOutputEventsInnerActorTypeEnum
_$adminAuditLogDtoOutputEventsInnerActorTypeEnum_system =
    const AdminAuditLogDtoOutputEventsInnerActorTypeEnum._('system');

AdminAuditLogDtoOutputEventsInnerActorTypeEnum
_$adminAuditLogDtoOutputEventsInnerActorTypeEnumValueOf(String name) {
  switch (name) {
    case 'admin':
      return _$adminAuditLogDtoOutputEventsInnerActorTypeEnum_admin;
    case 'merchant':
      return _$adminAuditLogDtoOutputEventsInnerActorTypeEnum_merchant;
    case 'captain':
      return _$adminAuditLogDtoOutputEventsInnerActorTypeEnum_captain;
    case 'customer':
      return _$adminAuditLogDtoOutputEventsInnerActorTypeEnum_customer;
    case 'system':
      return _$adminAuditLogDtoOutputEventsInnerActorTypeEnum_system;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminAuditLogDtoOutputEventsInnerActorTypeEnum>
_$adminAuditLogDtoOutputEventsInnerActorTypeEnumValues =
    BuiltSet<AdminAuditLogDtoOutputEventsInnerActorTypeEnum>(
      const <AdminAuditLogDtoOutputEventsInnerActorTypeEnum>[
        _$adminAuditLogDtoOutputEventsInnerActorTypeEnum_admin,
        _$adminAuditLogDtoOutputEventsInnerActorTypeEnum_merchant,
        _$adminAuditLogDtoOutputEventsInnerActorTypeEnum_captain,
        _$adminAuditLogDtoOutputEventsInnerActorTypeEnum_customer,
        _$adminAuditLogDtoOutputEventsInnerActorTypeEnum_system,
      ],
    );

Serializer<AdminAuditLogDtoOutputEventsInnerKindEnum>
_$adminAuditLogDtoOutputEventsInnerKindEnumSerializer =
    _$AdminAuditLogDtoOutputEventsInnerKindEnumSerializer();
Serializer<AdminAuditLogDtoOutputEventsInnerActorTypeEnum>
_$adminAuditLogDtoOutputEventsInnerActorTypeEnumSerializer =
    _$AdminAuditLogDtoOutputEventsInnerActorTypeEnumSerializer();

class _$AdminAuditLogDtoOutputEventsInnerKindEnumSerializer
    implements PrimitiveSerializer<AdminAuditLogDtoOutputEventsInnerKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'write': 'write',
    'view': 'view',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'write': 'write',
    'view': 'view',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminAuditLogDtoOutputEventsInnerKindEnum,
  ];
  @override
  final String wireName = 'AdminAuditLogDtoOutputEventsInnerKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminAuditLogDtoOutputEventsInnerKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminAuditLogDtoOutputEventsInnerKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminAuditLogDtoOutputEventsInnerKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminAuditLogDtoOutputEventsInnerActorTypeEnumSerializer
    implements
        PrimitiveSerializer<AdminAuditLogDtoOutputEventsInnerActorTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'admin': 'admin',
    'merchant': 'merchant',
    'captain': 'captain',
    'customer': 'customer',
    'system': 'system',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'admin': 'admin',
    'merchant': 'merchant',
    'captain': 'captain',
    'customer': 'customer',
    'system': 'system',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminAuditLogDtoOutputEventsInnerActorTypeEnum,
  ];
  @override
  final String wireName = 'AdminAuditLogDtoOutputEventsInnerActorTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminAuditLogDtoOutputEventsInnerActorTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminAuditLogDtoOutputEventsInnerActorTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminAuditLogDtoOutputEventsInnerActorTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminAuditLogDtoOutputEventsInner
    extends AdminAuditLogDtoOutputEventsInner {
  @override
  final String id;
  @override
  final DateTime at;
  @override
  final AdminAuditLogDtoOutputEventsInnerKindEnum kind;
  @override
  final String? cityId;
  @override
  final AdminAuditLogDtoOutputEventsInnerActorTypeEnum actorType;
  @override
  final String? actorId;
  @override
  final String? actorName;
  @override
  final String? actorRole;
  @override
  final String action;
  @override
  final String targetType;
  @override
  final String targetId;
  @override
  final BuiltList<AdminAuditLogDtoOutputEventsInnerChangesInner> changes;
  @override
  final String? reason;
  @override
  final String? ipAddress;
  @override
  final String? device;

  factory _$AdminAuditLogDtoOutputEventsInner([
    void Function(AdminAuditLogDtoOutputEventsInnerBuilder)? updates,
  ]) => (AdminAuditLogDtoOutputEventsInnerBuilder()..update(updates))._build();

  _$AdminAuditLogDtoOutputEventsInner._({
    required this.id,
    required this.at,
    required this.kind,
    this.cityId,
    required this.actorType,
    this.actorId,
    this.actorName,
    this.actorRole,
    required this.action,
    required this.targetType,
    required this.targetId,
    required this.changes,
    this.reason,
    this.ipAddress,
    this.device,
  }) : super._();
  @override
  AdminAuditLogDtoOutputEventsInner rebuild(
    void Function(AdminAuditLogDtoOutputEventsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminAuditLogDtoOutputEventsInnerBuilder toBuilder() =>
      AdminAuditLogDtoOutputEventsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminAuditLogDtoOutputEventsInner &&
        id == other.id &&
        at == other.at &&
        kind == other.kind &&
        cityId == other.cityId &&
        actorType == other.actorType &&
        actorId == other.actorId &&
        actorName == other.actorName &&
        actorRole == other.actorRole &&
        action == other.action &&
        targetType == other.targetType &&
        targetId == other.targetId &&
        changes == other.changes &&
        reason == other.reason &&
        ipAddress == other.ipAddress &&
        device == other.device;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, actorType.hashCode);
    _$hash = $jc(_$hash, actorId.hashCode);
    _$hash = $jc(_$hash, actorName.hashCode);
    _$hash = $jc(_$hash, actorRole.hashCode);
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, targetType.hashCode);
    _$hash = $jc(_$hash, targetId.hashCode);
    _$hash = $jc(_$hash, changes.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, ipAddress.hashCode);
    _$hash = $jc(_$hash, device.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminAuditLogDtoOutputEventsInner')
          ..add('id', id)
          ..add('at', at)
          ..add('kind', kind)
          ..add('cityId', cityId)
          ..add('actorType', actorType)
          ..add('actorId', actorId)
          ..add('actorName', actorName)
          ..add('actorRole', actorRole)
          ..add('action', action)
          ..add('targetType', targetType)
          ..add('targetId', targetId)
          ..add('changes', changes)
          ..add('reason', reason)
          ..add('ipAddress', ipAddress)
          ..add('device', device))
        .toString();
  }
}

class AdminAuditLogDtoOutputEventsInnerBuilder
    implements
        Builder<
          AdminAuditLogDtoOutputEventsInner,
          AdminAuditLogDtoOutputEventsInnerBuilder
        > {
  _$AdminAuditLogDtoOutputEventsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  AdminAuditLogDtoOutputEventsInnerKindEnum? _kind;
  AdminAuditLogDtoOutputEventsInnerKindEnum? get kind => _$this._kind;
  set kind(AdminAuditLogDtoOutputEventsInnerKindEnum? kind) =>
      _$this._kind = kind;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  AdminAuditLogDtoOutputEventsInnerActorTypeEnum? _actorType;
  AdminAuditLogDtoOutputEventsInnerActorTypeEnum? get actorType =>
      _$this._actorType;
  set actorType(AdminAuditLogDtoOutputEventsInnerActorTypeEnum? actorType) =>
      _$this._actorType = actorType;

  String? _actorId;
  String? get actorId => _$this._actorId;
  set actorId(String? actorId) => _$this._actorId = actorId;

  String? _actorName;
  String? get actorName => _$this._actorName;
  set actorName(String? actorName) => _$this._actorName = actorName;

  String? _actorRole;
  String? get actorRole => _$this._actorRole;
  set actorRole(String? actorRole) => _$this._actorRole = actorRole;

  String? _action;
  String? get action => _$this._action;
  set action(String? action) => _$this._action = action;

  String? _targetType;
  String? get targetType => _$this._targetType;
  set targetType(String? targetType) => _$this._targetType = targetType;

  String? _targetId;
  String? get targetId => _$this._targetId;
  set targetId(String? targetId) => _$this._targetId = targetId;

  ListBuilder<AdminAuditLogDtoOutputEventsInnerChangesInner>? _changes;
  ListBuilder<AdminAuditLogDtoOutputEventsInnerChangesInner> get changes =>
      _$this._changes ??=
          ListBuilder<AdminAuditLogDtoOutputEventsInnerChangesInner>();
  set changes(
    ListBuilder<AdminAuditLogDtoOutputEventsInnerChangesInner>? changes,
  ) => _$this._changes = changes;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _ipAddress;
  String? get ipAddress => _$this._ipAddress;
  set ipAddress(String? ipAddress) => _$this._ipAddress = ipAddress;

  String? _device;
  String? get device => _$this._device;
  set device(String? device) => _$this._device = device;

  AdminAuditLogDtoOutputEventsInnerBuilder() {
    AdminAuditLogDtoOutputEventsInner._defaults(this);
  }

  AdminAuditLogDtoOutputEventsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _at = $v.at;
      _kind = $v.kind;
      _cityId = $v.cityId;
      _actorType = $v.actorType;
      _actorId = $v.actorId;
      _actorName = $v.actorName;
      _actorRole = $v.actorRole;
      _action = $v.action;
      _targetType = $v.targetType;
      _targetId = $v.targetId;
      _changes = $v.changes.toBuilder();
      _reason = $v.reason;
      _ipAddress = $v.ipAddress;
      _device = $v.device;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminAuditLogDtoOutputEventsInner other) {
    _$v = other as _$AdminAuditLogDtoOutputEventsInner;
  }

  @override
  void update(
    void Function(AdminAuditLogDtoOutputEventsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminAuditLogDtoOutputEventsInner build() => _build();

  _$AdminAuditLogDtoOutputEventsInner _build() {
    _$AdminAuditLogDtoOutputEventsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminAuditLogDtoOutputEventsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminAuditLogDtoOutputEventsInner',
              'id',
            ),
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'AdminAuditLogDtoOutputEventsInner',
              'at',
            ),
            kind: BuiltValueNullFieldError.checkNotNull(
              kind,
              r'AdminAuditLogDtoOutputEventsInner',
              'kind',
            ),
            cityId: cityId,
            actorType: BuiltValueNullFieldError.checkNotNull(
              actorType,
              r'AdminAuditLogDtoOutputEventsInner',
              'actorType',
            ),
            actorId: actorId,
            actorName: actorName,
            actorRole: actorRole,
            action: BuiltValueNullFieldError.checkNotNull(
              action,
              r'AdminAuditLogDtoOutputEventsInner',
              'action',
            ),
            targetType: BuiltValueNullFieldError.checkNotNull(
              targetType,
              r'AdminAuditLogDtoOutputEventsInner',
              'targetType',
            ),
            targetId: BuiltValueNullFieldError.checkNotNull(
              targetId,
              r'AdminAuditLogDtoOutputEventsInner',
              'targetId',
            ),
            changes: changes.build(),
            reason: reason,
            ipAddress: ipAddress,
            device: device,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'changes';
        changes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminAuditLogDtoOutputEventsInner',
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
