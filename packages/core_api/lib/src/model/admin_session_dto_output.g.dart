// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_session_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSessionDtoOutput extends AdminSessionDtoOutput {
  @override
  final String accountId;
  @override
  final BuiltList<String> roles;
  @override
  final BuiltList<String> permissions;
  @override
  final DateTime signedInAt;
  @override
  final DateTime expiresAt;

  factory _$AdminSessionDtoOutput([
    void Function(AdminSessionDtoOutputBuilder)? updates,
  ]) => (AdminSessionDtoOutputBuilder()..update(updates))._build();

  _$AdminSessionDtoOutput._({
    required this.accountId,
    required this.roles,
    required this.permissions,
    required this.signedInAt,
    required this.expiresAt,
  }) : super._();
  @override
  AdminSessionDtoOutput rebuild(
    void Function(AdminSessionDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSessionDtoOutputBuilder toBuilder() =>
      AdminSessionDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSessionDtoOutput &&
        accountId == other.accountId &&
        roles == other.roles &&
        permissions == other.permissions &&
        signedInAt == other.signedInAt &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accountId.hashCode);
    _$hash = $jc(_$hash, roles.hashCode);
    _$hash = $jc(_$hash, permissions.hashCode);
    _$hash = $jc(_$hash, signedInAt.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSessionDtoOutput')
          ..add('accountId', accountId)
          ..add('roles', roles)
          ..add('permissions', permissions)
          ..add('signedInAt', signedInAt)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class AdminSessionDtoOutputBuilder
    implements Builder<AdminSessionDtoOutput, AdminSessionDtoOutputBuilder> {
  _$AdminSessionDtoOutput? _$v;

  String? _accountId;
  String? get accountId => _$this._accountId;
  set accountId(String? accountId) => _$this._accountId = accountId;

  ListBuilder<String>? _roles;
  ListBuilder<String> get roles => _$this._roles ??= ListBuilder<String>();
  set roles(ListBuilder<String>? roles) => _$this._roles = roles;

  ListBuilder<String>? _permissions;
  ListBuilder<String> get permissions =>
      _$this._permissions ??= ListBuilder<String>();
  set permissions(ListBuilder<String>? permissions) =>
      _$this._permissions = permissions;

  DateTime? _signedInAt;
  DateTime? get signedInAt => _$this._signedInAt;
  set signedInAt(DateTime? signedInAt) => _$this._signedInAt = signedInAt;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  AdminSessionDtoOutputBuilder() {
    AdminSessionDtoOutput._defaults(this);
  }

  AdminSessionDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accountId = $v.accountId;
      _roles = $v.roles.toBuilder();
      _permissions = $v.permissions.toBuilder();
      _signedInAt = $v.signedInAt;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSessionDtoOutput other) {
    _$v = other as _$AdminSessionDtoOutput;
  }

  @override
  void update(void Function(AdminSessionDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSessionDtoOutput build() => _build();

  _$AdminSessionDtoOutput _build() {
    _$AdminSessionDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminSessionDtoOutput._(
            accountId: BuiltValueNullFieldError.checkNotNull(
              accountId,
              r'AdminSessionDtoOutput',
              'accountId',
            ),
            roles: roles.build(),
            permissions: permissions.build(),
            signedInAt: BuiltValueNullFieldError.checkNotNull(
              signedInAt,
              r'AdminSessionDtoOutput',
              'signedInAt',
            ),
            expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt,
              r'AdminSessionDtoOutput',
              'expiresAt',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'roles';
        roles.build();
        _$failedField = 'permissions';
        permissions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminSessionDtoOutput',
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
