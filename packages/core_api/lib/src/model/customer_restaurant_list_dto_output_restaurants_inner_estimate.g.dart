// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_restaurant_list_dto_output_restaurants_inner_estimate.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerRestaurantListDtoOutputRestaurantsInnerEstimate
    extends CustomerRestaurantListDtoOutputRestaurantsInnerEstimate {
  @override
  final int fromMin;
  @override
  final int toMin;

  factory _$CustomerRestaurantListDtoOutputRestaurantsInnerEstimate([
    void Function(
      CustomerRestaurantListDtoOutputRestaurantsInnerEstimateBuilder,
    )?
    updates,
  ]) =>
      (CustomerRestaurantListDtoOutputRestaurantsInnerEstimateBuilder()
            ..update(updates))
          ._build();

  _$CustomerRestaurantListDtoOutputRestaurantsInnerEstimate._({
    required this.fromMin,
    required this.toMin,
  }) : super._();
  @override
  CustomerRestaurantListDtoOutputRestaurantsInnerEstimate rebuild(
    void Function(
      CustomerRestaurantListDtoOutputRestaurantsInnerEstimateBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerRestaurantListDtoOutputRestaurantsInnerEstimateBuilder toBuilder() =>
      CustomerRestaurantListDtoOutputRestaurantsInnerEstimateBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerRestaurantListDtoOutputRestaurantsInnerEstimate &&
        fromMin == other.fromMin &&
        toMin == other.toMin;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fromMin.hashCode);
    _$hash = $jc(_$hash, toMin.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerRestaurantListDtoOutputRestaurantsInnerEstimate',
          )
          ..add('fromMin', fromMin)
          ..add('toMin', toMin))
        .toString();
  }
}

class CustomerRestaurantListDtoOutputRestaurantsInnerEstimateBuilder
    implements
        Builder<
          CustomerRestaurantListDtoOutputRestaurantsInnerEstimate,
          CustomerRestaurantListDtoOutputRestaurantsInnerEstimateBuilder
        > {
  _$CustomerRestaurantListDtoOutputRestaurantsInnerEstimate? _$v;

  int? _fromMin;
  int? get fromMin => _$this._fromMin;
  set fromMin(int? fromMin) => _$this._fromMin = fromMin;

  int? _toMin;
  int? get toMin => _$this._toMin;
  set toMin(int? toMin) => _$this._toMin = toMin;

  CustomerRestaurantListDtoOutputRestaurantsInnerEstimateBuilder() {
    CustomerRestaurantListDtoOutputRestaurantsInnerEstimate._defaults(this);
  }

  CustomerRestaurantListDtoOutputRestaurantsInnerEstimateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fromMin = $v.fromMin;
      _toMin = $v.toMin;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerRestaurantListDtoOutputRestaurantsInnerEstimate other) {
    _$v = other as _$CustomerRestaurantListDtoOutputRestaurantsInnerEstimate;
  }

  @override
  void update(
    void Function(
      CustomerRestaurantListDtoOutputRestaurantsInnerEstimateBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerRestaurantListDtoOutputRestaurantsInnerEstimate build() => _build();

  _$CustomerRestaurantListDtoOutputRestaurantsInnerEstimate _build() {
    final _$result =
        _$v ??
        _$CustomerRestaurantListDtoOutputRestaurantsInnerEstimate._(
          fromMin: BuiltValueNullFieldError.checkNotNull(
            fromMin,
            r'CustomerRestaurantListDtoOutputRestaurantsInnerEstimate',
            'fromMin',
          ),
          toMin: BuiltValueNullFieldError.checkNotNull(
            toMin,
            r'CustomerRestaurantListDtoOutputRestaurantsInnerEstimate',
            'toMin',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
