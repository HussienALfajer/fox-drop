// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_draft_choice_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDraftChoiceOutput extends AdminDraftChoiceOutput {
  @override
  final String id;
  @override
  final String name;

  factory _$AdminDraftChoiceOutput([
    void Function(AdminDraftChoiceOutputBuilder)? updates,
  ]) => (AdminDraftChoiceOutputBuilder()..update(updates))._build();

  _$AdminDraftChoiceOutput._({required this.id, required this.name})
    : super._();
  @override
  AdminDraftChoiceOutput rebuild(
    void Function(AdminDraftChoiceOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDraftChoiceOutputBuilder toBuilder() =>
      AdminDraftChoiceOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDraftChoiceOutput &&
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
    return (newBuiltValueToStringHelper(r'AdminDraftChoiceOutput')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class AdminDraftChoiceOutputBuilder
    implements Builder<AdminDraftChoiceOutput, AdminDraftChoiceOutputBuilder> {
  _$AdminDraftChoiceOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminDraftChoiceOutputBuilder() {
    AdminDraftChoiceOutput._defaults(this);
  }

  AdminDraftChoiceOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDraftChoiceOutput other) {
    _$v = other as _$AdminDraftChoiceOutput;
  }

  @override
  void update(void Function(AdminDraftChoiceOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDraftChoiceOutput build() => _build();

  _$AdminDraftChoiceOutput _build() {
    final _$result =
        _$v ??
        _$AdminDraftChoiceOutput._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminDraftChoiceOutput',
            'id',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminDraftChoiceOutput',
            'name',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
