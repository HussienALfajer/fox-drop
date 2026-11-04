// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_users_dto_output_users_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TeamUsersDtoOutputUsersInnerStatusEnum
_$teamUsersDtoOutputUsersInnerStatusEnum_pending =
    const TeamUsersDtoOutputUsersInnerStatusEnum._('pending');
const TeamUsersDtoOutputUsersInnerStatusEnum
_$teamUsersDtoOutputUsersInnerStatusEnum_active =
    const TeamUsersDtoOutputUsersInnerStatusEnum._('active');
const TeamUsersDtoOutputUsersInnerStatusEnum
_$teamUsersDtoOutputUsersInnerStatusEnum_totpReset =
    const TeamUsersDtoOutputUsersInnerStatusEnum._('totpReset');
const TeamUsersDtoOutputUsersInnerStatusEnum
_$teamUsersDtoOutputUsersInnerStatusEnum_disabled =
    const TeamUsersDtoOutputUsersInnerStatusEnum._('disabled');

TeamUsersDtoOutputUsersInnerStatusEnum
_$teamUsersDtoOutputUsersInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'pending':
      return _$teamUsersDtoOutputUsersInnerStatusEnum_pending;
    case 'active':
      return _$teamUsersDtoOutputUsersInnerStatusEnum_active;
    case 'totpReset':
      return _$teamUsersDtoOutputUsersInnerStatusEnum_totpReset;
    case 'disabled':
      return _$teamUsersDtoOutputUsersInnerStatusEnum_disabled;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TeamUsersDtoOutputUsersInnerStatusEnum>
_$teamUsersDtoOutputUsersInnerStatusEnumValues =
    BuiltSet<TeamUsersDtoOutputUsersInnerStatusEnum>(
      const <TeamUsersDtoOutputUsersInnerStatusEnum>[
        _$teamUsersDtoOutputUsersInnerStatusEnum_pending,
        _$teamUsersDtoOutputUsersInnerStatusEnum_active,
        _$teamUsersDtoOutputUsersInnerStatusEnum_totpReset,
        _$teamUsersDtoOutputUsersInnerStatusEnum_disabled,
      ],
    );

Serializer<TeamUsersDtoOutputUsersInnerStatusEnum>
_$teamUsersDtoOutputUsersInnerStatusEnumSerializer =
    _$TeamUsersDtoOutputUsersInnerStatusEnumSerializer();

class _$TeamUsersDtoOutputUsersInnerStatusEnumSerializer
    implements PrimitiveSerializer<TeamUsersDtoOutputUsersInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'pending': 'pending',
    'active': 'active',
    'totpReset': 'totp_reset',
    'disabled': 'disabled',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'pending': 'pending',
    'active': 'active',
    'totp_reset': 'totpReset',
    'disabled': 'disabled',
  };

  @override
  final Iterable<Type> types = const <Type>[
    TeamUsersDtoOutputUsersInnerStatusEnum,
  ];
  @override
  final String wireName = 'TeamUsersDtoOutputUsersInnerStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    TeamUsersDtoOutputUsersInnerStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  TeamUsersDtoOutputUsersInnerStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => TeamUsersDtoOutputUsersInnerStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$TeamUsersDtoOutputUsersInner extends TeamUsersDtoOutputUsersInner {
  @override
  final String id;
  @override
  final String? name;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final BuiltList<String> roles;
  @override
  final TeamUsersDtoOutputUsersInnerStatusEnum status;
  @override
  final bool totpEnrolled;
  @override
  final DateTime? lastSignInAt;
  @override
  final BuiltList<TeamUsersDtoOutputUsersInnerOpenSessionsInner> openSessions;

  factory _$TeamUsersDtoOutputUsersInner([
    void Function(TeamUsersDtoOutputUsersInnerBuilder)? updates,
  ]) => (TeamUsersDtoOutputUsersInnerBuilder()..update(updates))._build();

  _$TeamUsersDtoOutputUsersInner._({
    required this.id,
    this.name,
    this.email,
    this.phone,
    required this.roles,
    required this.status,
    required this.totpEnrolled,
    this.lastSignInAt,
    required this.openSessions,
  }) : super._();
  @override
  TeamUsersDtoOutputUsersInner rebuild(
    void Function(TeamUsersDtoOutputUsersInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  TeamUsersDtoOutputUsersInnerBuilder toBuilder() =>
      TeamUsersDtoOutputUsersInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TeamUsersDtoOutputUsersInner &&
        id == other.id &&
        name == other.name &&
        email == other.email &&
        phone == other.phone &&
        roles == other.roles &&
        status == other.status &&
        totpEnrolled == other.totpEnrolled &&
        lastSignInAt == other.lastSignInAt &&
        openSessions == other.openSessions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, roles.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, totpEnrolled.hashCode);
    _$hash = $jc(_$hash, lastSignInAt.hashCode);
    _$hash = $jc(_$hash, openSessions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TeamUsersDtoOutputUsersInner')
          ..add('id', id)
          ..add('name', name)
          ..add('email', email)
          ..add('phone', phone)
          ..add('roles', roles)
          ..add('status', status)
          ..add('totpEnrolled', totpEnrolled)
          ..add('lastSignInAt', lastSignInAt)
          ..add('openSessions', openSessions))
        .toString();
  }
}

class TeamUsersDtoOutputUsersInnerBuilder
    implements
        Builder<
          TeamUsersDtoOutputUsersInner,
          TeamUsersDtoOutputUsersInnerBuilder
        > {
  _$TeamUsersDtoOutputUsersInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  ListBuilder<String>? _roles;
  ListBuilder<String> get roles => _$this._roles ??= ListBuilder<String>();
  set roles(ListBuilder<String>? roles) => _$this._roles = roles;

  TeamUsersDtoOutputUsersInnerStatusEnum? _status;
  TeamUsersDtoOutputUsersInnerStatusEnum? get status => _$this._status;
  set status(TeamUsersDtoOutputUsersInnerStatusEnum? status) =>
      _$this._status = status;

  bool? _totpEnrolled;
  bool? get totpEnrolled => _$this._totpEnrolled;
  set totpEnrolled(bool? totpEnrolled) => _$this._totpEnrolled = totpEnrolled;

  DateTime? _lastSignInAt;
  DateTime? get lastSignInAt => _$this._lastSignInAt;
  set lastSignInAt(DateTime? lastSignInAt) =>
      _$this._lastSignInAt = lastSignInAt;

  ListBuilder<TeamUsersDtoOutputUsersInnerOpenSessionsInner>? _openSessions;
  ListBuilder<TeamUsersDtoOutputUsersInnerOpenSessionsInner> get openSessions =>
      _$this._openSessions ??=
          ListBuilder<TeamUsersDtoOutputUsersInnerOpenSessionsInner>();
  set openSessions(
    ListBuilder<TeamUsersDtoOutputUsersInnerOpenSessionsInner>? openSessions,
  ) => _$this._openSessions = openSessions;

  TeamUsersDtoOutputUsersInnerBuilder() {
    TeamUsersDtoOutputUsersInner._defaults(this);
  }

  TeamUsersDtoOutputUsersInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _email = $v.email;
      _phone = $v.phone;
      _roles = $v.roles.toBuilder();
      _status = $v.status;
      _totpEnrolled = $v.totpEnrolled;
      _lastSignInAt = $v.lastSignInAt;
      _openSessions = $v.openSessions.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TeamUsersDtoOutputUsersInner other) {
    _$v = other as _$TeamUsersDtoOutputUsersInner;
  }

  @override
  void update(void Function(TeamUsersDtoOutputUsersInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TeamUsersDtoOutputUsersInner build() => _build();

  _$TeamUsersDtoOutputUsersInner _build() {
    _$TeamUsersDtoOutputUsersInner _$result;
    try {
      _$result =
          _$v ??
          _$TeamUsersDtoOutputUsersInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'TeamUsersDtoOutputUsersInner',
              'id',
            ),
            name: name,
            email: email,
            phone: phone,
            roles: roles.build(),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'TeamUsersDtoOutputUsersInner',
              'status',
            ),
            totpEnrolled: BuiltValueNullFieldError.checkNotNull(
              totpEnrolled,
              r'TeamUsersDtoOutputUsersInner',
              'totpEnrolled',
            ),
            lastSignInAt: lastSignInAt,
            openSessions: openSessions.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'roles';
        roles.build();

        _$failedField = 'openSessions';
        openSessions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'TeamUsersDtoOutputUsersInner',
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
