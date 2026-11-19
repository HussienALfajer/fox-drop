// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_change_approve_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminChangeApproveDto extends AdminChangeApproveDto {
  @override
  final String? name;
  @override
  final String? description;

  factory _$AdminChangeApproveDto([
    void Function(AdminChangeApproveDtoBuilder)? updates,
  ]) => (AdminChangeApproveDtoBuilder()..update(updates))._build();

  _$AdminChangeApproveDto._({this.name, this.description}) : super._();
  @override
  AdminChangeApproveDto rebuild(
    void Function(AdminChangeApproveDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminChangeApproveDtoBuilder toBuilder() =>
      AdminChangeApproveDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminChangeApproveDto &&
        name == other.name &&
        description == other.description;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminChangeApproveDto')
          ..add('name', name)
          ..add('description', description))
        .toString();
  }
}

class AdminChangeApproveDtoBuilder
    implements Builder<AdminChangeApproveDto, AdminChangeApproveDtoBuilder> {
  _$AdminChangeApproveDto? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  AdminChangeApproveDtoBuilder() {
    AdminChangeApproveDto._defaults(this);
  }

  AdminChangeApproveDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _description = $v.description;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminChangeApproveDto other) {
    _$v = other as _$AdminChangeApproveDto;
  }

  @override
  void update(void Function(AdminChangeApproveDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminChangeApproveDto build() => _build();

  _$AdminChangeApproveDto _build() {
    final _$result =
        _$v ?? _$AdminChangeApproveDto._(name: name, description: description);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
