// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_change_log_dto_output_entries_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum
_$adminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum_admin =
    const AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum._('admin');
const AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum
_$adminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum_merchant =
    const AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum._(
      'merchant',
    );
const AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum
_$adminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum_captain =
    const AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum._(
      'captain',
    );
const AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum
_$adminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum_customer =
    const AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum._(
      'customer',
    );
const AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum
_$adminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum_system =
    const AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum._(
      'system',
    );

AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum
_$adminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnumValueOf(
  String name,
) {
  switch (name) {
    case 'admin':
      return _$adminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum_admin;
    case 'merchant':
      return _$adminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum_merchant;
    case 'captain':
      return _$adminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum_captain;
    case 'customer':
      return _$adminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum_customer;
    case 'system':
      return _$adminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum_system;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum>
_$adminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnumValues =
    BuiltSet<AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum>(
      const <AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum>[
        _$adminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum_admin,
        _$adminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum_merchant,
        _$adminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum_captain,
        _$adminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum_customer,
        _$adminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum_system,
      ],
    );

Serializer<AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum>
_$adminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnumSerializer =
    _$AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnumSerializer();

class _$AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnumSerializer
    implements
        PrimitiveSerializer<
          AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum
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
    AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum,
  ];
  @override
  final String wireName =
      'AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminRestaurantChangeLogDtoOutputEntriesInner
    extends AdminRestaurantChangeLogDtoOutputEntriesInner {
  @override
  final String id;
  @override
  final DateTime at;
  @override
  final String action;
  @override
  final AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum actorType;
  @override
  final String? actorName;
  @override
  final String? actorRole;
  @override
  final String? account;
  @override
  final BuiltList<AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner>
  changes;
  @override
  final String? reason;

  factory _$AdminRestaurantChangeLogDtoOutputEntriesInner([
    void Function(AdminRestaurantChangeLogDtoOutputEntriesInnerBuilder)?
    updates,
  ]) =>
      (AdminRestaurantChangeLogDtoOutputEntriesInnerBuilder()..update(updates))
          ._build();

  _$AdminRestaurantChangeLogDtoOutputEntriesInner._({
    required this.id,
    required this.at,
    required this.action,
    required this.actorType,
    this.actorName,
    this.actorRole,
    this.account,
    required this.changes,
    this.reason,
  }) : super._();
  @override
  AdminRestaurantChangeLogDtoOutputEntriesInner rebuild(
    void Function(AdminRestaurantChangeLogDtoOutputEntriesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantChangeLogDtoOutputEntriesInnerBuilder toBuilder() =>
      AdminRestaurantChangeLogDtoOutputEntriesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantChangeLogDtoOutputEntriesInner &&
        id == other.id &&
        at == other.at &&
        action == other.action &&
        actorType == other.actorType &&
        actorName == other.actorName &&
        actorRole == other.actorRole &&
        account == other.account &&
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
    _$hash = $jc(_$hash, account.hashCode);
    _$hash = $jc(_$hash, changes.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantChangeLogDtoOutputEntriesInner',
          )
          ..add('id', id)
          ..add('at', at)
          ..add('action', action)
          ..add('actorType', actorType)
          ..add('actorName', actorName)
          ..add('actorRole', actorRole)
          ..add('account', account)
          ..add('changes', changes)
          ..add('reason', reason))
        .toString();
  }
}

class AdminRestaurantChangeLogDtoOutputEntriesInnerBuilder
    implements
        Builder<
          AdminRestaurantChangeLogDtoOutputEntriesInner,
          AdminRestaurantChangeLogDtoOutputEntriesInnerBuilder
        > {
  _$AdminRestaurantChangeLogDtoOutputEntriesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  String? _action;
  String? get action => _$this._action;
  set action(String? action) => _$this._action = action;

  AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum? _actorType;
  AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum? get actorType =>
      _$this._actorType;
  set actorType(
    AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum? actorType,
  ) => _$this._actorType = actorType;

  String? _actorName;
  String? get actorName => _$this._actorName;
  set actorName(String? actorName) => _$this._actorName = actorName;

  String? _actorRole;
  String? get actorRole => _$this._actorRole;
  set actorRole(String? actorRole) => _$this._actorRole = actorRole;

  String? _account;
  String? get account => _$this._account;
  set account(String? account) => _$this._account = account;

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

  AdminRestaurantChangeLogDtoOutputEntriesInnerBuilder() {
    AdminRestaurantChangeLogDtoOutputEntriesInner._defaults(this);
  }

  AdminRestaurantChangeLogDtoOutputEntriesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _at = $v.at;
      _action = $v.action;
      _actorType = $v.actorType;
      _actorName = $v.actorName;
      _actorRole = $v.actorRole;
      _account = $v.account;
      _changes = $v.changes.toBuilder();
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantChangeLogDtoOutputEntriesInner other) {
    _$v = other as _$AdminRestaurantChangeLogDtoOutputEntriesInner;
  }

  @override
  void update(
    void Function(AdminRestaurantChangeLogDtoOutputEntriesInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantChangeLogDtoOutputEntriesInner build() => _build();

  _$AdminRestaurantChangeLogDtoOutputEntriesInner _build() {
    _$AdminRestaurantChangeLogDtoOutputEntriesInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantChangeLogDtoOutputEntriesInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminRestaurantChangeLogDtoOutputEntriesInner',
              'id',
            ),
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'AdminRestaurantChangeLogDtoOutputEntriesInner',
              'at',
            ),
            action: BuiltValueNullFieldError.checkNotNull(
              action,
              r'AdminRestaurantChangeLogDtoOutputEntriesInner',
              'action',
            ),
            actorType: BuiltValueNullFieldError.checkNotNull(
              actorType,
              r'AdminRestaurantChangeLogDtoOutputEntriesInner',
              'actorType',
            ),
            actorName: actorName,
            actorRole: actorRole,
            account: account,
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
          r'AdminRestaurantChangeLogDtoOutputEntriesInner',
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
