// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantListDtoOutput extends AdminRestaurantListDtoOutput {
  @override
  final String? currency;
  @override
  final BuiltList<AdminRestaurantListDtoOutputRestaurantsInner> restaurants;

  factory _$AdminRestaurantListDtoOutput([
    void Function(AdminRestaurantListDtoOutputBuilder)? updates,
  ]) => (AdminRestaurantListDtoOutputBuilder()..update(updates))._build();

  _$AdminRestaurantListDtoOutput._({this.currency, required this.restaurants})
    : super._();
  @override
  AdminRestaurantListDtoOutput rebuild(
    void Function(AdminRestaurantListDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantListDtoOutputBuilder toBuilder() =>
      AdminRestaurantListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantListDtoOutput &&
        currency == other.currency &&
        restaurants == other.restaurants;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, restaurants.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminRestaurantListDtoOutput')
          ..add('currency', currency)
          ..add('restaurants', restaurants))
        .toString();
  }
}

class AdminRestaurantListDtoOutputBuilder
    implements
        Builder<
          AdminRestaurantListDtoOutput,
          AdminRestaurantListDtoOutputBuilder
        > {
  _$AdminRestaurantListDtoOutput? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  ListBuilder<AdminRestaurantListDtoOutputRestaurantsInner>? _restaurants;
  ListBuilder<AdminRestaurantListDtoOutputRestaurantsInner> get restaurants =>
      _$this._restaurants ??=
          ListBuilder<AdminRestaurantListDtoOutputRestaurantsInner>();
  set restaurants(
    ListBuilder<AdminRestaurantListDtoOutputRestaurantsInner>? restaurants,
  ) => _$this._restaurants = restaurants;

  AdminRestaurantListDtoOutputBuilder() {
    AdminRestaurantListDtoOutput._defaults(this);
  }

  AdminRestaurantListDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _restaurants = $v.restaurants.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantListDtoOutput other) {
    _$v = other as _$AdminRestaurantListDtoOutput;
  }

  @override
  void update(void Function(AdminRestaurantListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantListDtoOutput build() => _build();

  _$AdminRestaurantListDtoOutput _build() {
    _$AdminRestaurantListDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantListDtoOutput._(
            currency: currency,
            restaurants: restaurants.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'restaurants';
        restaurants.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantListDtoOutput',
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
