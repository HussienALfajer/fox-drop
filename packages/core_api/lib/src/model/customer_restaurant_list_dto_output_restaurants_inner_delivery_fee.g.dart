// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_restaurant_list_dto_output_restaurants_inner_delivery_fee.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee
    extends CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee {
  @override
  final CaptainWentOfflineDtoOutputHandIn? fee;
  @override
  final bool free;

  factory _$CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee([
    void Function(
      CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFeeBuilder,
    )?
    updates,
  ]) =>
      (CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFeeBuilder()
            ..update(updates))
          ._build();

  _$CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee._({
    this.fee,
    required this.free,
  }) : super._();
  @override
  CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee rebuild(
    void Function(
      CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFeeBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFeeBuilder
  toBuilder() =>
      CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFeeBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other
            is CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee &&
        fee == other.fee &&
        free == other.free;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fee.hashCode);
    _$hash = $jc(_$hash, free.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee',
          )
          ..add('fee', fee)
          ..add('free', free))
        .toString();
  }
}

class CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFeeBuilder
    implements
        Builder<
          CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee,
          CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFeeBuilder
        > {
  _$CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee? _$v;

  CaptainWentOfflineDtoOutputHandInBuilder? _fee;
  CaptainWentOfflineDtoOutputHandInBuilder get fee =>
      _$this._fee ??= CaptainWentOfflineDtoOutputHandInBuilder();
  set fee(CaptainWentOfflineDtoOutputHandInBuilder? fee) => _$this._fee = fee;

  bool? _free;
  bool? get free => _$this._free;
  set free(bool? free) => _$this._free = free;

  CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFeeBuilder() {
    CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee._defaults(this);
  }

  CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFeeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fee = $v.fee?.toBuilder();
      _free = $v.free;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
    CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee other,
  ) {
    _$v = other as _$CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee;
  }

  @override
  void update(
    void Function(
      CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFeeBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee build() =>
      _build();

  _$CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee _build() {
    _$CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee _$result;
    try {
      _$result =
          _$v ??
          _$CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee._(
            fee: _fee?.build(),
            free: BuiltValueNullFieldError.checkNotNull(
              free,
              r'CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee',
              'free',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'fee';
        _fee?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee',
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
