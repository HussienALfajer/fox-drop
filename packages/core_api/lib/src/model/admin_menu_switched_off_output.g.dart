// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_switched_off_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMenuSwitchedOffOutput extends AdminMenuSwitchedOffOutput {
  @override
  final DateTime? until;

  factory _$AdminMenuSwitchedOffOutput([
    void Function(AdminMenuSwitchedOffOutputBuilder)? updates,
  ]) => (AdminMenuSwitchedOffOutputBuilder()..update(updates))._build();

  _$AdminMenuSwitchedOffOutput._({this.until}) : super._();
  @override
  AdminMenuSwitchedOffOutput rebuild(
    void Function(AdminMenuSwitchedOffOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMenuSwitchedOffOutputBuilder toBuilder() =>
      AdminMenuSwitchedOffOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuSwitchedOffOutput && until == other.until;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, until.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminMenuSwitchedOffOutput',
    )..add('until', until)).toString();
  }
}

class AdminMenuSwitchedOffOutputBuilder
    implements
        Builder<AdminMenuSwitchedOffOutput, AdminMenuSwitchedOffOutputBuilder> {
  _$AdminMenuSwitchedOffOutput? _$v;

  DateTime? _until;
  DateTime? get until => _$this._until;
  set until(DateTime? until) => _$this._until = until;

  AdminMenuSwitchedOffOutputBuilder() {
    AdminMenuSwitchedOffOutput._defaults(this);
  }

  AdminMenuSwitchedOffOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _until = $v.until;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMenuSwitchedOffOutput other) {
    _$v = other as _$AdminMenuSwitchedOffOutput;
  }

  @override
  void update(void Function(AdminMenuSwitchedOffOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuSwitchedOffOutput build() => _build();

  _$AdminMenuSwitchedOffOutput _build() {
    final _$result = _$v ?? _$AdminMenuSwitchedOffOutput._(until: until);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
