// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_card_dto_output_order_restaurant.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderCardDtoOutputOrderRestaurant
    extends AdminOrderCardDtoOutputOrderRestaurant {
  @override
  final String id;
  @override
  final String name;

  factory _$AdminOrderCardDtoOutputOrderRestaurant([
    void Function(AdminOrderCardDtoOutputOrderRestaurantBuilder)? updates,
  ]) => (AdminOrderCardDtoOutputOrderRestaurantBuilder()..update(updates))
      ._build();

  _$AdminOrderCardDtoOutputOrderRestaurant._({
    required this.id,
    required this.name,
  }) : super._();
  @override
  AdminOrderCardDtoOutputOrderRestaurant rebuild(
    void Function(AdminOrderCardDtoOutputOrderRestaurantBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderCardDtoOutputOrderRestaurantBuilder toBuilder() =>
      AdminOrderCardDtoOutputOrderRestaurantBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderCardDtoOutputOrderRestaurant &&
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
            r'AdminOrderCardDtoOutputOrderRestaurant',
          )
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class AdminOrderCardDtoOutputOrderRestaurantBuilder
    implements
        Builder<
          AdminOrderCardDtoOutputOrderRestaurant,
          AdminOrderCardDtoOutputOrderRestaurantBuilder
        > {
  _$AdminOrderCardDtoOutputOrderRestaurant? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminOrderCardDtoOutputOrderRestaurantBuilder() {
    AdminOrderCardDtoOutputOrderRestaurant._defaults(this);
  }

  AdminOrderCardDtoOutputOrderRestaurantBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderCardDtoOutputOrderRestaurant other) {
    _$v = other as _$AdminOrderCardDtoOutputOrderRestaurant;
  }

  @override
  void update(
    void Function(AdminOrderCardDtoOutputOrderRestaurantBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderCardDtoOutputOrderRestaurant build() => _build();

  _$AdminOrderCardDtoOutputOrderRestaurant _build() {
    final _$result =
        _$v ??
        _$AdminOrderCardDtoOutputOrderRestaurant._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminOrderCardDtoOutputOrderRestaurant',
            'id',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminOrderCardDtoOutputOrderRestaurant',
            'name',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
