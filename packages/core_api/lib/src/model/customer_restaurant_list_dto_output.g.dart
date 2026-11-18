// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_restaurant_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerRestaurantListDtoOutput
    extends CustomerRestaurantListDtoOutput {
  @override
  final BuiltList<CustomerRestaurantListDtoOutputRestaurantsInner> restaurants;
  @override
  final BuiltList<CustomerRestaurantListDtoOutputSectionsInner>? sections;

  factory _$CustomerRestaurantListDtoOutput([
    void Function(CustomerRestaurantListDtoOutputBuilder)? updates,
  ]) => (CustomerRestaurantListDtoOutputBuilder()..update(updates))._build();

  _$CustomerRestaurantListDtoOutput._({
    required this.restaurants,
    this.sections,
  }) : super._();
  @override
  CustomerRestaurantListDtoOutput rebuild(
    void Function(CustomerRestaurantListDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerRestaurantListDtoOutputBuilder toBuilder() =>
      CustomerRestaurantListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerRestaurantListDtoOutput &&
        restaurants == other.restaurants &&
        sections == other.sections;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, restaurants.hashCode);
    _$hash = $jc(_$hash, sections.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerRestaurantListDtoOutput')
          ..add('restaurants', restaurants)
          ..add('sections', sections))
        .toString();
  }
}

class CustomerRestaurantListDtoOutputBuilder
    implements
        Builder<
          CustomerRestaurantListDtoOutput,
          CustomerRestaurantListDtoOutputBuilder
        > {
  _$CustomerRestaurantListDtoOutput? _$v;

  ListBuilder<CustomerRestaurantListDtoOutputRestaurantsInner>? _restaurants;
  ListBuilder<CustomerRestaurantListDtoOutputRestaurantsInner>
  get restaurants => _$this._restaurants ??=
      ListBuilder<CustomerRestaurantListDtoOutputRestaurantsInner>();
  set restaurants(
    ListBuilder<CustomerRestaurantListDtoOutputRestaurantsInner>? restaurants,
  ) => _$this._restaurants = restaurants;

  ListBuilder<CustomerRestaurantListDtoOutputSectionsInner>? _sections;
  ListBuilder<CustomerRestaurantListDtoOutputSectionsInner> get sections =>
      _$this._sections ??=
          ListBuilder<CustomerRestaurantListDtoOutputSectionsInner>();
  set sections(
    ListBuilder<CustomerRestaurantListDtoOutputSectionsInner>? sections,
  ) => _$this._sections = sections;

  CustomerRestaurantListDtoOutputBuilder() {
    CustomerRestaurantListDtoOutput._defaults(this);
  }

  CustomerRestaurantListDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _restaurants = $v.restaurants.toBuilder();
      _sections = $v.sections?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerRestaurantListDtoOutput other) {
    _$v = other as _$CustomerRestaurantListDtoOutput;
  }

  @override
  void update(void Function(CustomerRestaurantListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerRestaurantListDtoOutput build() => _build();

  _$CustomerRestaurantListDtoOutput _build() {
    _$CustomerRestaurantListDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$CustomerRestaurantListDtoOutput._(
            restaurants: restaurants.build(),
            sections: _sections?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'restaurants';
        restaurants.build();
        _$failedField = 'sections';
        _sections?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerRestaurantListDtoOutput',
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
