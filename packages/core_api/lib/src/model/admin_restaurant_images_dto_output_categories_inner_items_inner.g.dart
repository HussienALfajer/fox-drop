// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_images_dto_output_categories_inner_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner
    extends AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final String? photoKey;

  factory _$AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner([
    void Function(
      AdminRestaurantImagesDtoOutputCategoriesInnerItemsInnerBuilder,
    )?
    updates,
  ]) =>
      (AdminRestaurantImagesDtoOutputCategoriesInnerItemsInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner._({
    required this.id,
    required this.name,
    this.photoKey,
  }) : super._();
  @override
  AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner rebuild(
    void Function(
      AdminRestaurantImagesDtoOutputCategoriesInnerItemsInnerBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantImagesDtoOutputCategoriesInnerItemsInnerBuilder toBuilder() =>
      AdminRestaurantImagesDtoOutputCategoriesInnerItemsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner &&
        id == other.id &&
        name == other.name &&
        photoKey == other.photoKey;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, photoKey.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner',
          )
          ..add('id', id)
          ..add('name', name)
          ..add('photoKey', photoKey))
        .toString();
  }
}

class AdminRestaurantImagesDtoOutputCategoriesInnerItemsInnerBuilder
    implements
        Builder<
          AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner,
          AdminRestaurantImagesDtoOutputCategoriesInnerItemsInnerBuilder
        > {
  _$AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _photoKey;
  String? get photoKey => _$this._photoKey;
  set photoKey(String? photoKey) => _$this._photoKey = photoKey;

  AdminRestaurantImagesDtoOutputCategoriesInnerItemsInnerBuilder() {
    AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner._defaults(this);
  }

  AdminRestaurantImagesDtoOutputCategoriesInnerItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _photoKey = $v.photoKey;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner other) {
    _$v = other as _$AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner;
  }

  @override
  void update(
    void Function(
      AdminRestaurantImagesDtoOutputCategoriesInnerItemsInnerBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner build() => _build();

  _$AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner',
            'id',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner',
            'name',
          ),
          photoKey: photoKey,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
