// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_deposits_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDepositsDtoOutput extends AdminDepositsDtoOutput {
  @override
  final BuiltList<AdminDepositsDtoOutputApplicationsInner> applications;

  factory _$AdminDepositsDtoOutput([
    void Function(AdminDepositsDtoOutputBuilder)? updates,
  ]) => (AdminDepositsDtoOutputBuilder()..update(updates))._build();

  _$AdminDepositsDtoOutput._({required this.applications}) : super._();
  @override
  AdminDepositsDtoOutput rebuild(
    void Function(AdminDepositsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDepositsDtoOutputBuilder toBuilder() =>
      AdminDepositsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDepositsDtoOutput &&
        applications == other.applications;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, applications.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminDepositsDtoOutput',
    )..add('applications', applications)).toString();
  }
}

class AdminDepositsDtoOutputBuilder
    implements Builder<AdminDepositsDtoOutput, AdminDepositsDtoOutputBuilder> {
  _$AdminDepositsDtoOutput? _$v;

  ListBuilder<AdminDepositsDtoOutputApplicationsInner>? _applications;
  ListBuilder<AdminDepositsDtoOutputApplicationsInner> get applications =>
      _$this._applications ??=
          ListBuilder<AdminDepositsDtoOutputApplicationsInner>();
  set applications(
    ListBuilder<AdminDepositsDtoOutputApplicationsInner>? applications,
  ) => _$this._applications = applications;

  AdminDepositsDtoOutputBuilder() {
    AdminDepositsDtoOutput._defaults(this);
  }

  AdminDepositsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _applications = $v.applications.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDepositsDtoOutput other) {
    _$v = other as _$AdminDepositsDtoOutput;
  }

  @override
  void update(void Function(AdminDepositsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDepositsDtoOutput build() => _build();

  _$AdminDepositsDtoOutput _build() {
    _$AdminDepositsDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$AdminDepositsDtoOutput._(applications: applications.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'applications';
        applications.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminDepositsDtoOutput',
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
