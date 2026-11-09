// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_active_orders_dto_output_orders_inner_restaurant.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerActiveOrdersDtoOutputOrdersInnerRestaurant
    extends CustomerActiveOrdersDtoOutputOrdersInnerRestaurant {
  @override
  final String id;
  @override
  final String nameAr;
  @override
  final String? nameEn;

  factory _$CustomerActiveOrdersDtoOutputOrdersInnerRestaurant([
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerRestaurantBuilder)?
    updates,
  ]) =>
      (CustomerActiveOrdersDtoOutputOrdersInnerRestaurantBuilder()
            ..update(updates))
          ._build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerRestaurant._({
    required this.id,
    required this.nameAr,
    this.nameEn,
  }) : super._();
  @override
  CustomerActiveOrdersDtoOutputOrdersInnerRestaurant rebuild(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerRestaurantBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerRestaurantBuilder toBuilder() =>
      CustomerActiveOrdersDtoOutputOrdersInnerRestaurantBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerActiveOrdersDtoOutputOrdersInnerRestaurant &&
        id == other.id &&
        nameAr == other.nameAr &&
        nameEn == other.nameEn;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, nameAr.hashCode);
    _$hash = $jc(_$hash, nameEn.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerActiveOrdersDtoOutputOrdersInnerRestaurant',
          )
          ..add('id', id)
          ..add('nameAr', nameAr)
          ..add('nameEn', nameEn))
        .toString();
  }
}

class CustomerActiveOrdersDtoOutputOrdersInnerRestaurantBuilder
    implements
        Builder<
          CustomerActiveOrdersDtoOutputOrdersInnerRestaurant,
          CustomerActiveOrdersDtoOutputOrdersInnerRestaurantBuilder
        > {
  _$CustomerActiveOrdersDtoOutputOrdersInnerRestaurant? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _nameAr;
  String? get nameAr => _$this._nameAr;
  set nameAr(String? nameAr) => _$this._nameAr = nameAr;

  String? _nameEn;
  String? get nameEn => _$this._nameEn;
  set nameEn(String? nameEn) => _$this._nameEn = nameEn;

  CustomerActiveOrdersDtoOutputOrdersInnerRestaurantBuilder() {
    CustomerActiveOrdersDtoOutputOrdersInnerRestaurant._defaults(this);
  }

  CustomerActiveOrdersDtoOutputOrdersInnerRestaurantBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _nameAr = $v.nameAr;
      _nameEn = $v.nameEn;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerActiveOrdersDtoOutputOrdersInnerRestaurant other) {
    _$v = other as _$CustomerActiveOrdersDtoOutputOrdersInnerRestaurant;
  }

  @override
  void update(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerRestaurantBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerRestaurant build() => _build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerRestaurant _build() {
    final _$result =
        _$v ??
        _$CustomerActiveOrdersDtoOutputOrdersInnerRestaurant._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'CustomerActiveOrdersDtoOutputOrdersInnerRestaurant',
            'id',
          ),
          nameAr: BuiltValueNullFieldError.checkNotNull(
            nameAr,
            r'CustomerActiveOrdersDtoOutputOrdersInnerRestaurant',
            'nameAr',
          ),
          nameEn: nameEn,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
