// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_matrix_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RoleMatrixDtoOutput extends RoleMatrixDtoOutput {
  @override
  final BuiltList<RoleMatrixDtoOutputRolesInner> roles;

  factory _$RoleMatrixDtoOutput([
    void Function(RoleMatrixDtoOutputBuilder)? updates,
  ]) => (RoleMatrixDtoOutputBuilder()..update(updates))._build();

  _$RoleMatrixDtoOutput._({required this.roles}) : super._();
  @override
  RoleMatrixDtoOutput rebuild(
    void Function(RoleMatrixDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  RoleMatrixDtoOutputBuilder toBuilder() =>
      RoleMatrixDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RoleMatrixDtoOutput && roles == other.roles;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, roles.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'RoleMatrixDtoOutput',
    )..add('roles', roles)).toString();
  }
}

class RoleMatrixDtoOutputBuilder
    implements Builder<RoleMatrixDtoOutput, RoleMatrixDtoOutputBuilder> {
  _$RoleMatrixDtoOutput? _$v;

  ListBuilder<RoleMatrixDtoOutputRolesInner>? _roles;
  ListBuilder<RoleMatrixDtoOutputRolesInner> get roles =>
      _$this._roles ??= ListBuilder<RoleMatrixDtoOutputRolesInner>();
  set roles(ListBuilder<RoleMatrixDtoOutputRolesInner>? roles) =>
      _$this._roles = roles;

  RoleMatrixDtoOutputBuilder() {
    RoleMatrixDtoOutput._defaults(this);
  }

  RoleMatrixDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _roles = $v.roles.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RoleMatrixDtoOutput other) {
    _$v = other as _$RoleMatrixDtoOutput;
  }

  @override
  void update(void Function(RoleMatrixDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RoleMatrixDtoOutput build() => _build();

  _$RoleMatrixDtoOutput _build() {
    _$RoleMatrixDtoOutput _$result;
    try {
      _$result = _$v ?? _$RoleMatrixDtoOutput._(roles: roles.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'roles';
        roles.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'RoleMatrixDtoOutput',
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
