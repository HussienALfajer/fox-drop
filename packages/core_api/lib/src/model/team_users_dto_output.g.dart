// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_users_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TeamUsersDtoOutput extends TeamUsersDtoOutput {
  @override
  final BuiltList<TeamUsersDtoOutputUsersInner> users;

  factory _$TeamUsersDtoOutput([
    void Function(TeamUsersDtoOutputBuilder)? updates,
  ]) => (TeamUsersDtoOutputBuilder()..update(updates))._build();

  _$TeamUsersDtoOutput._({required this.users}) : super._();
  @override
  TeamUsersDtoOutput rebuild(
    void Function(TeamUsersDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  TeamUsersDtoOutputBuilder toBuilder() =>
      TeamUsersDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TeamUsersDtoOutput && users == other.users;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, users.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'TeamUsersDtoOutput',
    )..add('users', users)).toString();
  }
}

class TeamUsersDtoOutputBuilder
    implements Builder<TeamUsersDtoOutput, TeamUsersDtoOutputBuilder> {
  _$TeamUsersDtoOutput? _$v;

  ListBuilder<TeamUsersDtoOutputUsersInner>? _users;
  ListBuilder<TeamUsersDtoOutputUsersInner> get users =>
      _$this._users ??= ListBuilder<TeamUsersDtoOutputUsersInner>();
  set users(ListBuilder<TeamUsersDtoOutputUsersInner>? users) =>
      _$this._users = users;

  TeamUsersDtoOutputBuilder() {
    TeamUsersDtoOutput._defaults(this);
  }

  TeamUsersDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _users = $v.users.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TeamUsersDtoOutput other) {
    _$v = other as _$TeamUsersDtoOutput;
  }

  @override
  void update(void Function(TeamUsersDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TeamUsersDtoOutput build() => _build();

  _$TeamUsersDtoOutput _build() {
    _$TeamUsersDtoOutput _$result;
    try {
      _$result = _$v ?? _$TeamUsersDtoOutput._(users: users.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'users';
        users.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'TeamUsersDtoOutput',
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
