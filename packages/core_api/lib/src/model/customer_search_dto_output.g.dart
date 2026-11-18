// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_search_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerSearchDtoOutput extends CustomerSearchDtoOutput {
  @override
  final BuiltList<CustomerSearchDtoOutputRestaurantsInner> restaurants;
  @override
  final BuiltList<CustomerSearchDtoOutputItemsInner> items;

  factory _$CustomerSearchDtoOutput([
    void Function(CustomerSearchDtoOutputBuilder)? updates,
  ]) => (CustomerSearchDtoOutputBuilder()..update(updates))._build();

  _$CustomerSearchDtoOutput._({required this.restaurants, required this.items})
    : super._();
  @override
  CustomerSearchDtoOutput rebuild(
    void Function(CustomerSearchDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerSearchDtoOutputBuilder toBuilder() =>
      CustomerSearchDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerSearchDtoOutput &&
        restaurants == other.restaurants &&
        items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, restaurants.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerSearchDtoOutput')
          ..add('restaurants', restaurants)
          ..add('items', items))
        .toString();
  }
}

class CustomerSearchDtoOutputBuilder
    implements
        Builder<CustomerSearchDtoOutput, CustomerSearchDtoOutputBuilder> {
  _$CustomerSearchDtoOutput? _$v;

  ListBuilder<CustomerSearchDtoOutputRestaurantsInner>? _restaurants;
  ListBuilder<CustomerSearchDtoOutputRestaurantsInner> get restaurants =>
      _$this._restaurants ??=
          ListBuilder<CustomerSearchDtoOutputRestaurantsInner>();
  set restaurants(
    ListBuilder<CustomerSearchDtoOutputRestaurantsInner>? restaurants,
  ) => _$this._restaurants = restaurants;

  ListBuilder<CustomerSearchDtoOutputItemsInner>? _items;
  ListBuilder<CustomerSearchDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<CustomerSearchDtoOutputItemsInner>();
  set items(ListBuilder<CustomerSearchDtoOutputItemsInner>? items) =>
      _$this._items = items;

  CustomerSearchDtoOutputBuilder() {
    CustomerSearchDtoOutput._defaults(this);
  }

  CustomerSearchDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _restaurants = $v.restaurants.toBuilder();
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerSearchDtoOutput other) {
    _$v = other as _$CustomerSearchDtoOutput;
  }

  @override
  void update(void Function(CustomerSearchDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerSearchDtoOutput build() => _build();

  _$CustomerSearchDtoOutput _build() {
    _$CustomerSearchDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$CustomerSearchDtoOutput._(
            restaurants: restaurants.build(),
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'restaurants';
        restaurants.build();
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerSearchDtoOutput',
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
