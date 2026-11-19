// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_change_item_name_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminChangeItemNameOutput extends AdminChangeItemNameOutput {
  @override
  final String id;
  @override
  final String name;

  factory _$AdminChangeItemNameOutput([
    void Function(AdminChangeItemNameOutputBuilder)? updates,
  ]) => (AdminChangeItemNameOutputBuilder()..update(updates))._build();

  _$AdminChangeItemNameOutput._({required this.id, required this.name})
    : super._();
  @override
  AdminChangeItemNameOutput rebuild(
    void Function(AdminChangeItemNameOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminChangeItemNameOutputBuilder toBuilder() =>
      AdminChangeItemNameOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminChangeItemNameOutput &&
        id == other.id &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminChangeItemNameOutput')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class AdminChangeItemNameOutputBuilder
    implements
        Builder<AdminChangeItemNameOutput, AdminChangeItemNameOutputBuilder> {
  _$AdminChangeItemNameOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminChangeItemNameOutputBuilder() {
    AdminChangeItemNameOutput._defaults(this);
  }

  AdminChangeItemNameOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminChangeItemNameOutput other) {
    _$v = other as _$AdminChangeItemNameOutput;
  }

  @override
  void update(void Function(AdminChangeItemNameOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminChangeItemNameOutput build() => _build();

  _$AdminChangeItemNameOutput _build() {
    final _$result =
        _$v ??
        _$AdminChangeItemNameOutput._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminChangeItemNameOutput',
            'id',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminChangeItemNameOutput',
            'name',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
