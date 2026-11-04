// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_matrix_dto_output_roles_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RoleMatrixDtoOutputRolesInner extends RoleMatrixDtoOutputRolesInner {
  @override
  final String role;
  @override
  final BuiltList<String> permissions;

  factory _$RoleMatrixDtoOutputRolesInner([
    void Function(RoleMatrixDtoOutputRolesInnerBuilder)? updates,
  ]) => (RoleMatrixDtoOutputRolesInnerBuilder()..update(updates))._build();

  _$RoleMatrixDtoOutputRolesInner._({
    required this.role,
    required this.permissions,
  }) : super._();
  @override
  RoleMatrixDtoOutputRolesInner rebuild(
    void Function(RoleMatrixDtoOutputRolesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  RoleMatrixDtoOutputRolesInnerBuilder toBuilder() =>
      RoleMatrixDtoOutputRolesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RoleMatrixDtoOutputRolesInner &&
        role == other.role &&
        permissions == other.permissions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, permissions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RoleMatrixDtoOutputRolesInner')
          ..add('role', role)
          ..add('permissions', permissions))
        .toString();
  }
}

class RoleMatrixDtoOutputRolesInnerBuilder
    implements
        Builder<
          RoleMatrixDtoOutputRolesInner,
          RoleMatrixDtoOutputRolesInnerBuilder
        > {
  _$RoleMatrixDtoOutputRolesInner? _$v;

  String? _role;
  String? get role => _$this._role;
  set role(String? role) => _$this._role = role;

  ListBuilder<String>? _permissions;
  ListBuilder<String> get permissions =>
      _$this._permissions ??= ListBuilder<String>();
  set permissions(ListBuilder<String>? permissions) =>
      _$this._permissions = permissions;

  RoleMatrixDtoOutputRolesInnerBuilder() {
    RoleMatrixDtoOutputRolesInner._defaults(this);
  }

  RoleMatrixDtoOutputRolesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _role = $v.role;
      _permissions = $v.permissions.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RoleMatrixDtoOutputRolesInner other) {
    _$v = other as _$RoleMatrixDtoOutputRolesInner;
  }

  @override
  void update(void Function(RoleMatrixDtoOutputRolesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RoleMatrixDtoOutputRolesInner build() => _build();

  _$RoleMatrixDtoOutputRolesInner _build() {
    _$RoleMatrixDtoOutputRolesInner _$result;
    try {
      _$result =
          _$v ??
          _$RoleMatrixDtoOutputRolesInner._(
            role: BuiltValueNullFieldError.checkNotNull(
              role,
              r'RoleMatrixDtoOutputRolesInner',
              'role',
            ),
            permissions: permissions.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'permissions';
        permissions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'RoleMatrixDtoOutputRolesInner',
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
