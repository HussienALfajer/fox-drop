// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurants_dto_output_restaurants_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantsDtoOutputRestaurantsInner
    extends AdminRestaurantsDtoOutputRestaurantsInner {
  @override
  final String id;
  @override
  final String nameAr;

  factory _$AdminRestaurantsDtoOutputRestaurantsInner([
    void Function(AdminRestaurantsDtoOutputRestaurantsInnerBuilder)? updates,
  ]) => (AdminRestaurantsDtoOutputRestaurantsInnerBuilder()..update(updates))
      ._build();

  _$AdminRestaurantsDtoOutputRestaurantsInner._({
    required this.id,
    required this.nameAr,
  }) : super._();
  @override
  AdminRestaurantsDtoOutputRestaurantsInner rebuild(
    void Function(AdminRestaurantsDtoOutputRestaurantsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantsDtoOutputRestaurantsInnerBuilder toBuilder() =>
      AdminRestaurantsDtoOutputRestaurantsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantsDtoOutputRestaurantsInner &&
        id == other.id &&
        nameAr == other.nameAr;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, nameAr.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantsDtoOutputRestaurantsInner',
          )
          ..add('id', id)
          ..add('nameAr', nameAr))
        .toString();
  }
}

class AdminRestaurantsDtoOutputRestaurantsInnerBuilder
    implements
        Builder<
          AdminRestaurantsDtoOutputRestaurantsInner,
          AdminRestaurantsDtoOutputRestaurantsInnerBuilder
        > {
  _$AdminRestaurantsDtoOutputRestaurantsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _nameAr;
  String? get nameAr => _$this._nameAr;
  set nameAr(String? nameAr) => _$this._nameAr = nameAr;

  AdminRestaurantsDtoOutputRestaurantsInnerBuilder() {
    AdminRestaurantsDtoOutputRestaurantsInner._defaults(this);
  }

  AdminRestaurantsDtoOutputRestaurantsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _nameAr = $v.nameAr;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantsDtoOutputRestaurantsInner other) {
    _$v = other as _$AdminRestaurantsDtoOutputRestaurantsInner;
  }

  @override
  void update(
    void Function(AdminRestaurantsDtoOutputRestaurantsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantsDtoOutputRestaurantsInner build() => _build();

  _$AdminRestaurantsDtoOutputRestaurantsInner _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantsDtoOutputRestaurantsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminRestaurantsDtoOutputRestaurantsInner',
            'id',
          ),
          nameAr: BuiltValueNullFieldError.checkNotNull(
            nameAr,
            r'AdminRestaurantsDtoOutputRestaurantsInner',
            'nameAr',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
