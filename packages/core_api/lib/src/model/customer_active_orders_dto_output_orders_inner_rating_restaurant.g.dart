// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_active_orders_dto_output_orders_inner_rating_restaurant.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurant
    extends CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurant {
  @override
  final int stars;
  @override
  final BuiltList<AdminCustomerDtoOutputBlockReasonsInner> reasons;
  @override
  final String? comment;
  @override
  final DateTime at;

  factory _$CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurant([
    void Function(
      CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurantBuilder,
    )?
    updates,
  ]) =>
      (CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurantBuilder()
            ..update(updates))
          ._build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurant._({
    required this.stars,
    required this.reasons,
    this.comment,
    required this.at,
  }) : super._();
  @override
  CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurant rebuild(
    void Function(
      CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurantBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurantBuilder toBuilder() =>
      CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurantBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurant &&
        stars == other.stars &&
        reasons == other.reasons &&
        comment == other.comment &&
        at == other.at;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, stars.hashCode);
    _$hash = $jc(_$hash, reasons.hashCode);
    _$hash = $jc(_$hash, comment.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurant',
          )
          ..add('stars', stars)
          ..add('reasons', reasons)
          ..add('comment', comment)
          ..add('at', at))
        .toString();
  }
}

class CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurantBuilder
    implements
        Builder<
          CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurant,
          CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurantBuilder
        > {
  _$CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurant? _$v;

  int? _stars;
  int? get stars => _$this._stars;
  set stars(int? stars) => _$this._stars = stars;

  ListBuilder<AdminCustomerDtoOutputBlockReasonsInner>? _reasons;
  ListBuilder<AdminCustomerDtoOutputBlockReasonsInner> get reasons =>
      _$this._reasons ??=
          ListBuilder<AdminCustomerDtoOutputBlockReasonsInner>();
  set reasons(ListBuilder<AdminCustomerDtoOutputBlockReasonsInner>? reasons) =>
      _$this._reasons = reasons;

  String? _comment;
  String? get comment => _$this._comment;
  set comment(String? comment) => _$this._comment = comment;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurantBuilder() {
    CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurant._defaults(this);
  }

  CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurantBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _stars = $v.stars;
      _reasons = $v.reasons.toBuilder();
      _comment = $v.comment;
      _at = $v.at;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurant other) {
    _$v = other as _$CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurant;
  }

  @override
  void update(
    void Function(
      CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurantBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurant build() => _build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurant _build() {
    _$CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurant _$result;
    try {
      _$result =
          _$v ??
          _$CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurant._(
            stars: BuiltValueNullFieldError.checkNotNull(
              stars,
              r'CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurant',
              'stars',
            ),
            reasons: reasons.build(),
            comment: comment,
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurant',
              'at',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'reasons';
        reasons.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurant',
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
