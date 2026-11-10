// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_edit_choices_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderEditChoicesItemsInner
    extends AdminOrderDtoOutputOrderEditChoicesItemsInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final String category;
  @override
  final String price;
  @override
  final BuiltList<
    AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInner
  >
  optionGroups;

  factory _$AdminOrderDtoOutputOrderEditChoicesItemsInner([
    void Function(AdminOrderDtoOutputOrderEditChoicesItemsInnerBuilder)?
    updates,
  ]) =>
      (AdminOrderDtoOutputOrderEditChoicesItemsInnerBuilder()..update(updates))
          ._build();

  _$AdminOrderDtoOutputOrderEditChoicesItemsInner._({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.optionGroups,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderEditChoicesItemsInner rebuild(
    void Function(AdminOrderDtoOutputOrderEditChoicesItemsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderEditChoicesItemsInnerBuilder toBuilder() =>
      AdminOrderDtoOutputOrderEditChoicesItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderEditChoicesItemsInner &&
        id == other.id &&
        name == other.name &&
        category == other.category &&
        price == other.price &&
        optionGroups == other.optionGroups;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jc(_$hash, optionGroups.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderDtoOutputOrderEditChoicesItemsInner',
          )
          ..add('id', id)
          ..add('name', name)
          ..add('category', category)
          ..add('price', price)
          ..add('optionGroups', optionGroups))
        .toString();
  }
}

class AdminOrderDtoOutputOrderEditChoicesItemsInnerBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderEditChoicesItemsInner,
          AdminOrderDtoOutputOrderEditChoicesItemsInnerBuilder
        > {
  _$AdminOrderDtoOutputOrderEditChoicesItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  String? _price;
  String? get price => _$this._price;
  set price(String? price) => _$this._price = price;

  ListBuilder<AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInner>?
  _optionGroups;
  ListBuilder<AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInner>
  get optionGroups => _$this._optionGroups ??=
      ListBuilder<
        AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInner
      >();
  set optionGroups(
    ListBuilder<AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInner>?
    optionGroups,
  ) => _$this._optionGroups = optionGroups;

  AdminOrderDtoOutputOrderEditChoicesItemsInnerBuilder() {
    AdminOrderDtoOutputOrderEditChoicesItemsInner._defaults(this);
  }

  AdminOrderDtoOutputOrderEditChoicesItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _category = $v.category;
      _price = $v.price;
      _optionGroups = $v.optionGroups.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderEditChoicesItemsInner other) {
    _$v = other as _$AdminOrderDtoOutputOrderEditChoicesItemsInner;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderEditChoicesItemsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderEditChoicesItemsInner build() => _build();

  _$AdminOrderDtoOutputOrderEditChoicesItemsInner _build() {
    _$AdminOrderDtoOutputOrderEditChoicesItemsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderDtoOutputOrderEditChoicesItemsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminOrderDtoOutputOrderEditChoicesItemsInner',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AdminOrderDtoOutputOrderEditChoicesItemsInner',
              'name',
            ),
            category: BuiltValueNullFieldError.checkNotNull(
              category,
              r'AdminOrderDtoOutputOrderEditChoicesItemsInner',
              'category',
            ),
            price: BuiltValueNullFieldError.checkNotNull(
              price,
              r'AdminOrderDtoOutputOrderEditChoicesItemsInner',
              'price',
            ),
            optionGroups: optionGroups.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'optionGroups';
        optionGroups.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderDtoOutputOrderEditChoicesItemsInner',
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
