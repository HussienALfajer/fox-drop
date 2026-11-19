// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_change_log_dto_output_entries_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum
_$adminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum_admin =
    const AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum._('admin');
const AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum
_$adminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum_merchant =
    const AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum._('merchant');
const AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum
_$adminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum_captain =
    const AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum._('captain');
const AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum
_$adminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum_customer =
    const AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum._('customer');
const AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum
_$adminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum_system =
    const AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum._('system');

AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum
_$adminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnumValueOf(String name) {
  switch (name) {
    case 'admin':
      return _$adminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum_admin;
    case 'merchant':
      return _$adminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum_merchant;
    case 'captain':
      return _$adminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum_captain;
    case 'customer':
      return _$adminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum_customer;
    case 'system':
      return _$adminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum_system;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum>
_$adminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnumValues =
    BuiltSet<AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum>(
      const <AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum>[
        _$adminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum_admin,
        _$adminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum_merchant,
        _$adminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum_captain,
        _$adminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum_customer,
        _$adminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum_system,
      ],
    );

Serializer<AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum>
_$adminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnumSerializer =
    _$AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnumSerializer();

class _$AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnumSerializer
    implements
        PrimitiveSerializer<
          AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum
        > {
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
    AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum,
  ];
  @override
  final String wireName =
      'AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCaptainChangeLogDtoOutputEntriesInner
    extends AdminCaptainChangeLogDtoOutputEntriesInner {
  @override
  final String id;
  @override
  final DateTime at;
  @override
  final String action;
  @override
  final AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum actorType;
  @override
  final String? actorName;
  @override
  final String? actorRole;
  @override
  final BuiltList<AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner>
  changes;
  @override
  final String? reason;

  factory _$AdminCaptainChangeLogDtoOutputEntriesInner([
    void Function(AdminCaptainChangeLogDtoOutputEntriesInnerBuilder)? updates,
  ]) => (AdminCaptainChangeLogDtoOutputEntriesInnerBuilder()..update(updates))
      ._build();

  _$AdminCaptainChangeLogDtoOutputEntriesInner._({
    required this.id,
    required this.at,
    required this.action,
    required this.actorType,
    this.actorName,
    this.actorRole,
    required this.changes,
    this.reason,
  }) : super._();
  @override
  AdminCaptainChangeLogDtoOutputEntriesInner rebuild(
    void Function(AdminCaptainChangeLogDtoOutputEntriesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainChangeLogDtoOutputEntriesInnerBuilder toBuilder() =>
      AdminCaptainChangeLogDtoOutputEntriesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainChangeLogDtoOutputEntriesInner &&
        id == other.id &&
        at == other.at &&
        action == other.action &&
        actorType == other.actorType &&
        actorName == other.actorName &&
        actorRole == other.actorRole &&
        changes == other.changes &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, actorType.hashCode);
    _$hash = $jc(_$hash, actorName.hashCode);
    _$hash = $jc(_$hash, actorRole.hashCode);
    _$hash = $jc(_$hash, changes.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCaptainChangeLogDtoOutputEntriesInner',
          )
          ..add('id', id)
          ..add('at', at)
          ..add('action', action)
          ..add('actorType', actorType)
          ..add('actorName', actorName)
          ..add('actorRole', actorRole)
          ..add('changes', changes)
          ..add('reason', reason))
        .toString();
  }
}

class AdminCaptainChangeLogDtoOutputEntriesInnerBuilder
    implements
        Builder<
          AdminCaptainChangeLogDtoOutputEntriesInner,
          AdminCaptainChangeLogDtoOutputEntriesInnerBuilder
        > {
  _$AdminCaptainChangeLogDtoOutputEntriesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  String? _action;
  String? get action => _$this._action;
  set action(String? action) => _$this._action = action;

  AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum? _actorType;
  AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum? get actorType =>
      _$this._actorType;
  set actorType(
    AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum? actorType,
  ) => _$this._actorType = actorType;

  String? _actorName;
  String? get actorName => _$this._actorName;
  set actorName(String? actorName) => _$this._actorName = actorName;

  String? _actorRole;
  String? get actorRole => _$this._actorRole;
  set actorRole(String? actorRole) => _$this._actorRole = actorRole;

  ListBuilder<AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner>? _changes;
  ListBuilder<AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner>
  get changes => _$this._changes ??=
      ListBuilder<AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner>();
  set changes(
    ListBuilder<AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner>?
    changes,
  ) => _$this._changes = changes;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminCaptainChangeLogDtoOutputEntriesInnerBuilder() {
    AdminCaptainChangeLogDtoOutputEntriesInner._defaults(this);
  }

  AdminCaptainChangeLogDtoOutputEntriesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _at = $v.at;
      _action = $v.action;
      _actorType = $v.actorType;
      _actorName = $v.actorName;
      _actorRole = $v.actorRole;
      _changes = $v.changes.toBuilder();
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainChangeLogDtoOutputEntriesInner other) {
    _$v = other as _$AdminCaptainChangeLogDtoOutputEntriesInner;
  }

  @override
  void update(
    void Function(AdminCaptainChangeLogDtoOutputEntriesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainChangeLogDtoOutputEntriesInner build() => _build();

  _$AdminCaptainChangeLogDtoOutputEntriesInner _build() {
    _$AdminCaptainChangeLogDtoOutputEntriesInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminCaptainChangeLogDtoOutputEntriesInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminCaptainChangeLogDtoOutputEntriesInner',
              'id',
            ),
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'AdminCaptainChangeLogDtoOutputEntriesInner',
              'at',
            ),
            action: BuiltValueNullFieldError.checkNotNull(
              action,
              r'AdminCaptainChangeLogDtoOutputEntriesInner',
              'action',
            ),
            actorType: BuiltValueNullFieldError.checkNotNull(
              actorType,
              r'AdminCaptainChangeLogDtoOutputEntriesInner',
              'actorType',
            ),
            actorName: actorName,
            actorRole: actorRole,
            changes: changes.build(),
            reason: reason,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'changes';
        changes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCaptainChangeLogDtoOutputEntriesInner',
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
