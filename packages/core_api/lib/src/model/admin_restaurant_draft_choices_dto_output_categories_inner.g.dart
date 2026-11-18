// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_draft_choices_dto_output_categories_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantDraftChoicesDtoOutputCategoriesInner
    extends AdminRestaurantDraftChoicesDtoOutputCategoriesInner {
  @override
  final String id;
  @override
  final String name;

  factory _$AdminRestaurantDraftChoicesDtoOutputCategoriesInner([
    void Function(AdminRestaurantDraftChoicesDtoOutputCategoriesInnerBuilder)?
    updates,
  ]) =>
      (AdminRestaurantDraftChoicesDtoOutputCategoriesInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminRestaurantDraftChoicesDtoOutputCategoriesInner._({
    required this.id,
    required this.name,
  }) : super._();
  @override
  AdminRestaurantDraftChoicesDtoOutputCategoriesInner rebuild(
    void Function(AdminRestaurantDraftChoicesDtoOutputCategoriesInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantDraftChoicesDtoOutputCategoriesInnerBuilder toBuilder() =>
      AdminRestaurantDraftChoicesDtoOutputCategoriesInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantDraftChoicesDtoOutputCategoriesInner &&
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
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantDraftChoicesDtoOutputCategoriesInner',
          )
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class AdminRestaurantDraftChoicesDtoOutputCategoriesInnerBuilder
    implements
        Builder<
          AdminRestaurantDraftChoicesDtoOutputCategoriesInner,
          AdminRestaurantDraftChoicesDtoOutputCategoriesInnerBuilder
        > {
  _$AdminRestaurantDraftChoicesDtoOutputCategoriesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminRestaurantDraftChoicesDtoOutputCategoriesInnerBuilder() {
    AdminRestaurantDraftChoicesDtoOutputCategoriesInner._defaults(this);
  }

  AdminRestaurantDraftChoicesDtoOutputCategoriesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantDraftChoicesDtoOutputCategoriesInner other) {
    _$v = other as _$AdminRestaurantDraftChoicesDtoOutputCategoriesInner;
  }

  @override
  void update(
    void Function(AdminRestaurantDraftChoicesDtoOutputCategoriesInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantDraftChoicesDtoOutputCategoriesInner build() => _build();

  _$AdminRestaurantDraftChoicesDtoOutputCategoriesInner _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantDraftChoicesDtoOutputCategoriesInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminRestaurantDraftChoicesDtoOutputCategoriesInner',
            'id',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminRestaurantDraftChoicesDtoOutputCategoriesInner',
            'name',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
