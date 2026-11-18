// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_favourites_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerFavouritesDtoOutput extends CustomerFavouritesDtoOutput {
  @override
  final BuiltList<CustomerSearchDtoOutputRestaurantsInner> restaurants;

  factory _$CustomerFavouritesDtoOutput([
    void Function(CustomerFavouritesDtoOutputBuilder)? updates,
  ]) => (CustomerFavouritesDtoOutputBuilder()..update(updates))._build();

  _$CustomerFavouritesDtoOutput._({required this.restaurants}) : super._();
  @override
  CustomerFavouritesDtoOutput rebuild(
    void Function(CustomerFavouritesDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerFavouritesDtoOutputBuilder toBuilder() =>
      CustomerFavouritesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerFavouritesDtoOutput &&
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
      r'CustomerFavouritesDtoOutput',
    )..add('restaurants', restaurants)).toString();
  }
}

class CustomerFavouritesDtoOutputBuilder
    implements
        Builder<
          CustomerFavouritesDtoOutput,
          CustomerFavouritesDtoOutputBuilder
        > {
  _$CustomerFavouritesDtoOutput? _$v;

  ListBuilder<CustomerSearchDtoOutputRestaurantsInner>? _restaurants;
  ListBuilder<CustomerSearchDtoOutputRestaurantsInner> get restaurants =>
      _$this._restaurants ??=
          ListBuilder<CustomerSearchDtoOutputRestaurantsInner>();
  set restaurants(
    ListBuilder<CustomerSearchDtoOutputRestaurantsInner>? restaurants,
  ) => _$this._restaurants = restaurants;

  CustomerFavouritesDtoOutputBuilder() {
    CustomerFavouritesDtoOutput._defaults(this);
  }

  CustomerFavouritesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _restaurants = $v.restaurants.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerFavouritesDtoOutput other) {
    _$v = other as _$CustomerFavouritesDtoOutput;
  }

  @override
  void update(void Function(CustomerFavouritesDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerFavouritesDtoOutput build() => _build();

  _$CustomerFavouritesDtoOutput _build() {
    _$CustomerFavouritesDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$CustomerFavouritesDtoOutput._(restaurants: restaurants.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'restaurants';
        restaurants.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerFavouritesDtoOutput',
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
