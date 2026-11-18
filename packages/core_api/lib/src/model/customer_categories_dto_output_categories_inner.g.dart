// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_categories_dto_output_categories_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerCategoriesDtoOutputCategoriesInner
    extends CustomerCategoriesDtoOutputCategoriesInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final String? imageKey;

  factory _$CustomerCategoriesDtoOutputCategoriesInner([
    void Function(CustomerCategoriesDtoOutputCategoriesInnerBuilder)? updates,
  ]) => (CustomerCategoriesDtoOutputCategoriesInnerBuilder()..update(updates))
      ._build();

  _$CustomerCategoriesDtoOutputCategoriesInner._({
    required this.id,
    required this.name,
    this.imageKey,
  }) : super._();
  @override
  CustomerCategoriesDtoOutputCategoriesInner rebuild(
    void Function(CustomerCategoriesDtoOutputCategoriesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerCategoriesDtoOutputCategoriesInnerBuilder toBuilder() =>
      CustomerCategoriesDtoOutputCategoriesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerCategoriesDtoOutputCategoriesInner &&
        id == other.id &&
        name == other.name &&
        imageKey == other.imageKey;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, imageKey.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerCategoriesDtoOutputCategoriesInner',
          )
          ..add('id', id)
          ..add('name', name)
          ..add('imageKey', imageKey))
        .toString();
  }
}

class CustomerCategoriesDtoOutputCategoriesInnerBuilder
    implements
        Builder<
          CustomerCategoriesDtoOutputCategoriesInner,
          CustomerCategoriesDtoOutputCategoriesInnerBuilder
        > {
  _$CustomerCategoriesDtoOutputCategoriesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _imageKey;
  String? get imageKey => _$this._imageKey;
  set imageKey(String? imageKey) => _$this._imageKey = imageKey;

  CustomerCategoriesDtoOutputCategoriesInnerBuilder() {
    CustomerCategoriesDtoOutputCategoriesInner._defaults(this);
  }

  CustomerCategoriesDtoOutputCategoriesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _imageKey = $v.imageKey;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerCategoriesDtoOutputCategoriesInner other) {
    _$v = other as _$CustomerCategoriesDtoOutputCategoriesInner;
  }

  @override
  void update(
    void Function(CustomerCategoriesDtoOutputCategoriesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerCategoriesDtoOutputCategoriesInner build() => _build();

  _$CustomerCategoriesDtoOutputCategoriesInner _build() {
    final _$result =
        _$v ??
        _$CustomerCategoriesDtoOutputCategoriesInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'CustomerCategoriesDtoOutputCategoriesInner',
            'id',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'CustomerCategoriesDtoOutputCategoriesInner',
            'name',
          ),
          imageKey: imageKey,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
