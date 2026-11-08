// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_images_dto_output_categories_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantImagesDtoOutputCategoriesInner
    extends AdminRestaurantImagesDtoOutputCategoriesInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final BuiltList<AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner>
  items;

  factory _$AdminRestaurantImagesDtoOutputCategoriesInner([
    void Function(AdminRestaurantImagesDtoOutputCategoriesInnerBuilder)?
    updates,
  ]) =>
      (AdminRestaurantImagesDtoOutputCategoriesInnerBuilder()..update(updates))
          ._build();

  _$AdminRestaurantImagesDtoOutputCategoriesInner._({
    required this.id,
    required this.name,
    required this.items,
  }) : super._();
  @override
  AdminRestaurantImagesDtoOutputCategoriesInner rebuild(
    void Function(AdminRestaurantImagesDtoOutputCategoriesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantImagesDtoOutputCategoriesInnerBuilder toBuilder() =>
      AdminRestaurantImagesDtoOutputCategoriesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantImagesDtoOutputCategoriesInner &&
        id == other.id &&
        name == other.name &&
        items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantImagesDtoOutputCategoriesInner',
          )
          ..add('id', id)
          ..add('name', name)
          ..add('items', items))
        .toString();
  }
}

class AdminRestaurantImagesDtoOutputCategoriesInnerBuilder
    implements
        Builder<
          AdminRestaurantImagesDtoOutputCategoriesInner,
          AdminRestaurantImagesDtoOutputCategoriesInnerBuilder
        > {
  _$AdminRestaurantImagesDtoOutputCategoriesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ListBuilder<AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner>? _items;
  ListBuilder<AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner>
  get items => _$this._items ??=
      ListBuilder<AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner>();
  set items(
    ListBuilder<AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner>? items,
  ) => _$this._items = items;

  AdminRestaurantImagesDtoOutputCategoriesInnerBuilder() {
    AdminRestaurantImagesDtoOutputCategoriesInner._defaults(this);
  }

  AdminRestaurantImagesDtoOutputCategoriesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantImagesDtoOutputCategoriesInner other) {
    _$v = other as _$AdminRestaurantImagesDtoOutputCategoriesInner;
  }

  @override
  void update(
    void Function(AdminRestaurantImagesDtoOutputCategoriesInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantImagesDtoOutputCategoriesInner build() => _build();

  _$AdminRestaurantImagesDtoOutputCategoriesInner _build() {
    _$AdminRestaurantImagesDtoOutputCategoriesInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantImagesDtoOutputCategoriesInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminRestaurantImagesDtoOutputCategoriesInner',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AdminRestaurantImagesDtoOutputCategoriesInner',
              'name',
            ),
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantImagesDtoOutputCategoriesInner',
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
