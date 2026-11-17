// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_rate_order_dto_restaurant.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerRateOrderDtoRestaurant extends CustomerRateOrderDtoRestaurant {
  @override
  final int stars;
  @override
  final BuiltList<String> reasons;
  @override
  final String? comment;

  factory _$CustomerRateOrderDtoRestaurant([
    void Function(CustomerRateOrderDtoRestaurantBuilder)? updates,
  ]) => (CustomerRateOrderDtoRestaurantBuilder()..update(updates))._build();

  _$CustomerRateOrderDtoRestaurant._({
    required this.stars,
    required this.reasons,
    this.comment,
  }) : super._();
  @override
  CustomerRateOrderDtoRestaurant rebuild(
    void Function(CustomerRateOrderDtoRestaurantBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerRateOrderDtoRestaurantBuilder toBuilder() =>
      CustomerRateOrderDtoRestaurantBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerRateOrderDtoRestaurant &&
        stars == other.stars &&
        reasons == other.reasons &&
        comment == other.comment;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, stars.hashCode);
    _$hash = $jc(_$hash, reasons.hashCode);
    _$hash = $jc(_$hash, comment.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerRateOrderDtoRestaurant')
          ..add('stars', stars)
          ..add('reasons', reasons)
          ..add('comment', comment))
        .toString();
  }
}

class CustomerRateOrderDtoRestaurantBuilder
    implements
        Builder<
          CustomerRateOrderDtoRestaurant,
          CustomerRateOrderDtoRestaurantBuilder
        > {
  _$CustomerRateOrderDtoRestaurant? _$v;

  int? _stars;
  int? get stars => _$this._stars;
  set stars(int? stars) => _$this._stars = stars;

  ListBuilder<String>? _reasons;
  ListBuilder<String> get reasons => _$this._reasons ??= ListBuilder<String>();
  set reasons(ListBuilder<String>? reasons) => _$this._reasons = reasons;

  String? _comment;
  String? get comment => _$this._comment;
  set comment(String? comment) => _$this._comment = comment;

  CustomerRateOrderDtoRestaurantBuilder() {
    CustomerRateOrderDtoRestaurant._defaults(this);
  }

  CustomerRateOrderDtoRestaurantBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _stars = $v.stars;
      _reasons = $v.reasons.toBuilder();
      _comment = $v.comment;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerRateOrderDtoRestaurant other) {
    _$v = other as _$CustomerRateOrderDtoRestaurant;
  }

  @override
  void update(void Function(CustomerRateOrderDtoRestaurantBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerRateOrderDtoRestaurant build() => _build();

  _$CustomerRateOrderDtoRestaurant _build() {
    _$CustomerRateOrderDtoRestaurant _$result;
    try {
      _$result =
          _$v ??
          _$CustomerRateOrderDtoRestaurant._(
            stars: BuiltValueNullFieldError.checkNotNull(
              stars,
              r'CustomerRateOrderDtoRestaurant',
              'stars',
            ),
            reasons: reasons.build(),
            comment: comment,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'reasons';
        reasons.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerRateOrderDtoRestaurant',
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
