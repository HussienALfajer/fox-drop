// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_categories_dto_output_categories_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCategoriesDtoOutputCategoriesInner
    extends AdminCategoriesDtoOutputCategoriesInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final String? imageKey;
  @override
  final bool active;

  factory _$AdminCategoriesDtoOutputCategoriesInner([
    void Function(AdminCategoriesDtoOutputCategoriesInnerBuilder)? updates,
  ]) => (AdminCategoriesDtoOutputCategoriesInnerBuilder()..update(updates))
      ._build();

  _$AdminCategoriesDtoOutputCategoriesInner._({
    required this.id,
    required this.name,
    this.imageKey,
    required this.active,
  }) : super._();
  @override
  AdminCategoriesDtoOutputCategoriesInner rebuild(
    void Function(AdminCategoriesDtoOutputCategoriesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCategoriesDtoOutputCategoriesInnerBuilder toBuilder() =>
      AdminCategoriesDtoOutputCategoriesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCategoriesDtoOutputCategoriesInner &&
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
    return (newBuiltValueToStringHelper(
            r'AdminCategoriesDtoOutputCategoriesInner',
          )
          ..add('id', id)
          ..add('name', name)
          ..add('imageKey', imageKey)
          ..add('active', active))
        .toString();
  }
}

class AdminCategoriesDtoOutputCategoriesInnerBuilder
    implements
        Builder<
          AdminCategoriesDtoOutputCategoriesInner,
          AdminCategoriesDtoOutputCategoriesInnerBuilder
        > {
  _$AdminCategoriesDtoOutputCategoriesInner? _$v;

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

  AdminCategoriesDtoOutputCategoriesInnerBuilder() {
    AdminCategoriesDtoOutputCategoriesInner._defaults(this);
  }

  AdminCategoriesDtoOutputCategoriesInnerBuilder get _$this {
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
  void replace(AdminCategoriesDtoOutputCategoriesInner other) {
    _$v = other as _$AdminCategoriesDtoOutputCategoriesInner;
  }

  @override
  void update(
    void Function(AdminCategoriesDtoOutputCategoriesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCategoriesDtoOutputCategoriesInner build() => _build();

  _$AdminCategoriesDtoOutputCategoriesInner _build() {
    final _$result =
        _$v ??
        _$AdminCategoriesDtoOutputCategoriesInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminCategoriesDtoOutputCategoriesInner',
            'id',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminCategoriesDtoOutputCategoriesInner',
            'name',
          ),
          imageKey: imageKey,
          active: BuiltValueNullFieldError.checkNotNull(
            active,
            r'AdminCategoriesDtoOutputCategoriesInner',
            'active',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
