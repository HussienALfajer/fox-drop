// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_category_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCategoryDtoOutput extends AdminCategoryDtoOutput {
  @override
  final String id;
  @override
  final String name;
  @override
  final String? imageKey;
  @override
  final bool active;

  factory _$AdminCategoryDtoOutput([
    void Function(AdminCategoryDtoOutputBuilder)? updates,
  ]) => (AdminCategoryDtoOutputBuilder()..update(updates))._build();

  _$AdminCategoryDtoOutput._({
    required this.id,
    required this.name,
    this.imageKey,
    required this.active,
  }) : super._();
  @override
  AdminCategoryDtoOutput rebuild(
    void Function(AdminCategoryDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCategoryDtoOutputBuilder toBuilder() =>
      AdminCategoryDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCategoryDtoOutput &&
        id == other.id &&
        name == other.name &&
        imageKey == other.imageKey &&
        active == other.active;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, imageKey.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCategoryDtoOutput')
          ..add('id', id)
          ..add('name', name)
          ..add('imageKey', imageKey)
          ..add('active', active))
        .toString();
  }
}

class AdminCategoryDtoOutputBuilder
    implements Builder<AdminCategoryDtoOutput, AdminCategoryDtoOutputBuilder> {
  _$AdminCategoryDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _imageKey;
  String? get imageKey => _$this._imageKey;
  set imageKey(String? imageKey) => _$this._imageKey = imageKey;

  bool? _active;
  bool? get active => _$this._active;
  set active(bool? active) => _$this._active = active;

  AdminCategoryDtoOutputBuilder() {
    AdminCategoryDtoOutput._defaults(this);
  }

  AdminCategoryDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _imageKey = $v.imageKey;
      _active = $v.active;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCategoryDtoOutput other) {
    _$v = other as _$AdminCategoryDtoOutput;
  }

  @override
  void update(void Function(AdminCategoryDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCategoryDtoOutput build() => _build();

  _$AdminCategoryDtoOutput _build() {
    final _$result =
        _$v ??
        _$AdminCategoryDtoOutput._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminCategoryDtoOutput',
            'id',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminCategoryDtoOutput',
            'name',
          ),
          imageKey: imageKey,
          active: BuiltValueNullFieldError.checkNotNull(
            active,
            r'AdminCategoryDtoOutput',
            'active',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
