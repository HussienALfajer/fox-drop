// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_max_active_orders_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantMaxActiveOrdersDto
    extends AdminRestaurantMaxActiveOrdersDto {
  @override
  final int? maxActiveOrders;

  factory _$AdminRestaurantMaxActiveOrdersDto([
    void Function(AdminRestaurantMaxActiveOrdersDtoBuilder)? updates,
  ]) => (AdminRestaurantMaxActiveOrdersDtoBuilder()..update(updates))._build();

  _$AdminRestaurantMaxActiveOrdersDto._({this.maxActiveOrders}) : super._();
  @override
  AdminRestaurantMaxActiveOrdersDto rebuild(
    void Function(AdminRestaurantMaxActiveOrdersDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantMaxActiveOrdersDtoBuilder toBuilder() =>
      AdminRestaurantMaxActiveOrdersDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantMaxActiveOrdersDto &&
        maxActiveOrders == other.maxActiveOrders;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, maxActiveOrders.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminRestaurantMaxActiveOrdersDto',
    )..add('maxActiveOrders', maxActiveOrders)).toString();
  }
}

class AdminRestaurantMaxActiveOrdersDtoBuilder
    implements
        Builder<
          AdminRestaurantMaxActiveOrdersDto,
          AdminRestaurantMaxActiveOrdersDtoBuilder
        > {
  _$AdminRestaurantMaxActiveOrdersDto? _$v;

  int? _maxActiveOrders;
  int? get maxActiveOrders => _$this._maxActiveOrders;
  set maxActiveOrders(int? maxActiveOrders) =>
      _$this._maxActiveOrders = maxActiveOrders;

  AdminRestaurantMaxActiveOrdersDtoBuilder() {
    AdminRestaurantMaxActiveOrdersDto._defaults(this);
  }

  AdminRestaurantMaxActiveOrdersDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _maxActiveOrders = $v.maxActiveOrders;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantMaxActiveOrdersDto other) {
    _$v = other as _$AdminRestaurantMaxActiveOrdersDto;
  }

  @override
  void update(
    void Function(AdminRestaurantMaxActiveOrdersDtoBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantMaxActiveOrdersDto build() => _build();

  _$AdminRestaurantMaxActiveOrdersDto _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantMaxActiveOrdersDto._(maxActiveOrders: maxActiveOrders);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
