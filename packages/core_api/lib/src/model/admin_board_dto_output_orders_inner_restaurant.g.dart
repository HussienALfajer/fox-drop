// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_board_dto_output_orders_inner_restaurant.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminBoardDtoOutputOrdersInnerRestaurant
    extends AdminBoardDtoOutputOrdersInnerRestaurant {
  @override
  final String id;
  @override
  final String name;

  factory _$AdminBoardDtoOutputOrdersInnerRestaurant([
    void Function(AdminBoardDtoOutputOrdersInnerRestaurantBuilder)? updates,
  ]) => (AdminBoardDtoOutputOrdersInnerRestaurantBuilder()..update(updates))
      ._build();

  _$AdminBoardDtoOutputOrdersInnerRestaurant._({
    required this.id,
    required this.name,
  }) : super._();
  @override
  AdminBoardDtoOutputOrdersInnerRestaurant rebuild(
    void Function(AdminBoardDtoOutputOrdersInnerRestaurantBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminBoardDtoOutputOrdersInnerRestaurantBuilder toBuilder() =>
      AdminBoardDtoOutputOrdersInnerRestaurantBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminBoardDtoOutputOrdersInnerRestaurant &&
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
            r'AdminBoardDtoOutputOrdersInnerRestaurant',
          )
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class AdminBoardDtoOutputOrdersInnerRestaurantBuilder
    implements
        Builder<
          AdminBoardDtoOutputOrdersInnerRestaurant,
          AdminBoardDtoOutputOrdersInnerRestaurantBuilder
        > {
  _$AdminBoardDtoOutputOrdersInnerRestaurant? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminBoardDtoOutputOrdersInnerRestaurantBuilder() {
    AdminBoardDtoOutputOrdersInnerRestaurant._defaults(this);
  }

  AdminBoardDtoOutputOrdersInnerRestaurantBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminBoardDtoOutputOrdersInnerRestaurant other) {
    _$v = other as _$AdminBoardDtoOutputOrdersInnerRestaurant;
  }

  @override
  void update(
    void Function(AdminBoardDtoOutputOrdersInnerRestaurantBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminBoardDtoOutputOrdersInnerRestaurant build() => _build();

  _$AdminBoardDtoOutputOrdersInnerRestaurant _build() {
    final _$result =
        _$v ??
        _$AdminBoardDtoOutputOrdersInnerRestaurant._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminBoardDtoOutputOrdersInnerRestaurant',
            'id',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminBoardDtoOutputOrdersInnerRestaurant',
            'name',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
