// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_users_dto_output_users_inner_open_sessions_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TeamUsersDtoOutputUsersInnerOpenSessionsInner
    extends TeamUsersDtoOutputUsersInnerOpenSessionsInner {
  @override
  final String id;
  @override
  final String? userAgent;
  @override
  final String? ipAddress;
  @override
  final DateTime signedInAt;
  @override
  final DateTime lastActivityAt;

  factory _$TeamUsersDtoOutputUsersInnerOpenSessionsInner([
    void Function(TeamUsersDtoOutputUsersInnerOpenSessionsInnerBuilder)?
    updates,
  ]) =>
      (TeamUsersDtoOutputUsersInnerOpenSessionsInnerBuilder()..update(updates))
          ._build();

  _$TeamUsersDtoOutputUsersInnerOpenSessionsInner._({
    required this.id,
    this.userAgent,
    this.ipAddress,
    required this.signedInAt,
    required this.lastActivityAt,
  }) : super._();
  @override
  TeamUsersDtoOutputUsersInnerOpenSessionsInner rebuild(
    void Function(TeamUsersDtoOutputUsersInnerOpenSessionsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  TeamUsersDtoOutputUsersInnerOpenSessionsInnerBuilder toBuilder() =>
      TeamUsersDtoOutputUsersInnerOpenSessionsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TeamUsersDtoOutputUsersInnerOpenSessionsInner &&
        id == other.id &&
        userAgent == other.userAgent &&
        ipAddress == other.ipAddress &&
        signedInAt == other.signedInAt &&
        lastActivityAt == other.lastActivityAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, userAgent.hashCode);
    _$hash = $jc(_$hash, ipAddress.hashCode);
    _$hash = $jc(_$hash, signedInAt.hashCode);
    _$hash = $jc(_$hash, lastActivityAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'TeamUsersDtoOutputUsersInnerOpenSessionsInner',
          )
          ..add('id', id)
          ..add('userAgent', userAgent)
          ..add('ipAddress', ipAddress)
          ..add('signedInAt', signedInAt)
          ..add('lastActivityAt', lastActivityAt))
        .toString();
  }
}

class TeamUsersDtoOutputUsersInnerOpenSessionsInnerBuilder
    implements
        Builder<
          TeamUsersDtoOutputUsersInnerOpenSessionsInner,
          TeamUsersDtoOutputUsersInnerOpenSessionsInnerBuilder
        > {
  _$TeamUsersDtoOutputUsersInnerOpenSessionsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _userAgent;
  String? get userAgent => _$this._userAgent;
  set userAgent(String? userAgent) => _$this._userAgent = userAgent;

  String? _ipAddress;
  String? get ipAddress => _$this._ipAddress;
  set ipAddress(String? ipAddress) => _$this._ipAddress = ipAddress;

  DateTime? _signedInAt;
  DateTime? get signedInAt => _$this._signedInAt;
  set signedInAt(DateTime? signedInAt) => _$this._signedInAt = signedInAt;

  DateTime? _lastActivityAt;
  DateTime? get lastActivityAt => _$this._lastActivityAt;
  set lastActivityAt(DateTime? lastActivityAt) =>
      _$this._lastActivityAt = lastActivityAt;

  TeamUsersDtoOutputUsersInnerOpenSessionsInnerBuilder() {
    TeamUsersDtoOutputUsersInnerOpenSessionsInner._defaults(this);
  }

  TeamUsersDtoOutputUsersInnerOpenSessionsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _userAgent = $v.userAgent;
      _ipAddress = $v.ipAddress;
      _signedInAt = $v.signedInAt;
      _lastActivityAt = $v.lastActivityAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TeamUsersDtoOutputUsersInnerOpenSessionsInner other) {
    _$v = other as _$TeamUsersDtoOutputUsersInnerOpenSessionsInner;
  }

  @override
  void update(
    void Function(TeamUsersDtoOutputUsersInnerOpenSessionsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  TeamUsersDtoOutputUsersInnerOpenSessionsInner build() => _build();

  _$TeamUsersDtoOutputUsersInnerOpenSessionsInner _build() {
    final _$result =
        _$v ??
        _$TeamUsersDtoOutputUsersInnerOpenSessionsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'TeamUsersDtoOutputUsersInnerOpenSessionsInner',
            'id',
          ),
          userAgent: userAgent,
          ipAddress: ipAddress,
          signedInAt: BuiltValueNullFieldError.checkNotNull(
            signedInAt,
            r'TeamUsersDtoOutputUsersInnerOpenSessionsInner',
            'signedInAt',
          ),
          lastActivityAt: BuiltValueNullFieldError.checkNotNull(
            lastActivityAt,
            r'TeamUsersDtoOutputUsersInnerOpenSessionsInner',
            'lastActivityAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
