// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_active_orders_dto_output_orders_inner_rating.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerActiveOrdersDtoOutputOrdersInnerRating
    extends CustomerActiveOrdersDtoOutputOrdersInnerRating {
  @override
  final DateTime? until;
  @override
  final bool captainRatable;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurant? restaurant;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain? captain;

  factory _$CustomerActiveOrdersDtoOutputOrdersInnerRating([
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerRatingBuilder)?
    updates,
  ]) =>
      (CustomerActiveOrdersDtoOutputOrdersInnerRatingBuilder()..update(updates))
          ._build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerRating._({
    this.until,
    required this.captainRatable,
    this.restaurant,
    this.captain,
  }) : super._();
  @override
  CustomerActiveOrdersDtoOutputOrdersInnerRating rebuild(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerRatingBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerRatingBuilder toBuilder() =>
      CustomerActiveOrdersDtoOutputOrdersInnerRatingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerActiveOrdersDtoOutputOrdersInnerRating &&
        until == other.until &&
        captainRatable == other.captainRatable &&
        restaurant == other.restaurant &&
        captain == other.captain;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, until.hashCode);
    _$hash = $jc(_$hash, captainRatable.hashCode);
    _$hash = $jc(_$hash, restaurant.hashCode);
    _$hash = $jc(_$hash, captain.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerActiveOrdersDtoOutputOrdersInnerRating',
          )
          ..add('until', until)
          ..add('captainRatable', captainRatable)
          ..add('restaurant', restaurant)
          ..add('captain', captain))
        .toString();
  }
}

class CustomerActiveOrdersDtoOutputOrdersInnerRatingBuilder
    implements
        Builder<
          CustomerActiveOrdersDtoOutputOrdersInnerRating,
          CustomerActiveOrdersDtoOutputOrdersInnerRatingBuilder
        > {
  _$CustomerActiveOrdersDtoOutputOrdersInnerRating? _$v;

  DateTime? _until;
  DateTime? get until => _$this._until;
  set until(DateTime? until) => _$this._until = until;

  bool? _captainRatable;
  bool? get captainRatable => _$this._captainRatable;
  set captainRatable(bool? captainRatable) =>
      _$this._captainRatable = captainRatable;

  CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurantBuilder? _restaurant;
  CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurantBuilder
  get restaurant => _$this._restaurant ??=
      CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurantBuilder();
  set restaurant(
    CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurantBuilder? restaurant,
  ) => _$this._restaurant = restaurant;

  CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptainBuilder? _captain;
  CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptainBuilder get captain =>
      _$this._captain ??=
          CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptainBuilder();
  set captain(
    CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptainBuilder? captain,
  ) => _$this._captain = captain;

  CustomerActiveOrdersDtoOutputOrdersInnerRatingBuilder() {
    CustomerActiveOrdersDtoOutputOrdersInnerRating._defaults(this);
  }

  CustomerActiveOrdersDtoOutputOrdersInnerRatingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _until = $v.until;
      _captainRatable = $v.captainRatable;
      _restaurant = $v.restaurant?.toBuilder();
      _captain = $v.captain?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerActiveOrdersDtoOutputOrdersInnerRating other) {
    _$v = other as _$CustomerActiveOrdersDtoOutputOrdersInnerRating;
  }

  @override
  void update(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerRatingBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerRating build() => _build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerRating _build() {
    _$CustomerActiveOrdersDtoOutputOrdersInnerRating _$result;
    try {
      _$result =
          _$v ??
          _$CustomerActiveOrdersDtoOutputOrdersInnerRating._(
            until: until,
            captainRatable: BuiltValueNullFieldError.checkNotNull(
              captainRatable,
              r'CustomerActiveOrdersDtoOutputOrdersInnerRating',
              'captainRatable',
            ),
            restaurant: _restaurant?.build(),
            captain: _captain?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'restaurant';
        _restaurant?.build();
        _$failedField = 'captain';
        _captain?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerActiveOrdersDtoOutputOrdersInnerRating',
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
