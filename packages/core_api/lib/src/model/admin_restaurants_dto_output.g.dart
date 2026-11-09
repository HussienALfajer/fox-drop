// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurants_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantsDtoOutput extends AdminRestaurantsDtoOutput {
  @override
  final BuiltList<AdminRestaurantsDtoOutputRestaurantsInner> restaurants;

  factory _$AdminRestaurantsDtoOutput([
    void Function(AdminRestaurantsDtoOutputBuilder)? updates,
  ]) => (AdminRestaurantsDtoOutputBuilder()..update(updates))._build();

  _$AdminRestaurantsDtoOutput._({required this.restaurants}) : super._();
  @override
  AdminRestaurantsDtoOutput rebuild(
    void Function(AdminRestaurantsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantsDtoOutputBuilder toBuilder() =>
      AdminRestaurantsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantsDtoOutput &&
        restaurants == other.restaurants;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, restaurants.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminRestaurantsDtoOutput',
    )..add('restaurants', restaurants)).toString();
  }
}

class AdminRestaurantsDtoOutputBuilder
    implements
        Builder<AdminRestaurantsDtoOutput, AdminRestaurantsDtoOutputBuilder> {
  _$AdminRestaurantsDtoOutput? _$v;

  ListBuilder<AdminRestaurantsDtoOutputRestaurantsInner>? _restaurants;
  ListBuilder<AdminRestaurantsDtoOutputRestaurantsInner> get restaurants =>
      _$this._restaurants ??=
          ListBuilder<AdminRestaurantsDtoOutputRestaurantsInner>();
  set restaurants(
    ListBuilder<AdminRestaurantsDtoOutputRestaurantsInner>? restaurants,
  ) => _$this._restaurants = restaurants;

  AdminRestaurantsDtoOutputBuilder() {
    AdminRestaurantsDtoOutput._defaults(this);
  }

  AdminRestaurantsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _restaurants = $v.restaurants.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantsDtoOutput other) {
    _$v = other as _$AdminRestaurantsDtoOutput;
  }

  @override
  void update(void Function(AdminRestaurantsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantsDtoOutput build() => _build();

  _$AdminRestaurantsDtoOutput _build() {
    _$AdminRestaurantsDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantsDtoOutput._(restaurants: restaurants.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'restaurants';
        restaurants.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantsDtoOutput',
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
