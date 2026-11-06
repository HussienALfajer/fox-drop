// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_restaurant_page_dto_output_delivery_fee.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerRestaurantPageDtoOutputDeliveryFee
    extends CustomerRestaurantPageDtoOutputDeliveryFee {
  @override
  final CaptainAvailabilityDtoOutputCustodyLimit fee;
  @override
  final bool free;

  factory _$CustomerRestaurantPageDtoOutputDeliveryFee([
    void Function(CustomerRestaurantPageDtoOutputDeliveryFeeBuilder)? updates,
  ]) => (CustomerRestaurantPageDtoOutputDeliveryFeeBuilder()..update(updates))
      ._build();

  _$CustomerRestaurantPageDtoOutputDeliveryFee._({
    required this.fee,
    required this.free,
  }) : super._();
  @override
  CustomerRestaurantPageDtoOutputDeliveryFee rebuild(
    void Function(CustomerRestaurantPageDtoOutputDeliveryFeeBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerRestaurantPageDtoOutputDeliveryFeeBuilder toBuilder() =>
      CustomerRestaurantPageDtoOutputDeliveryFeeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerRestaurantPageDtoOutputDeliveryFee &&
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
            r'CustomerRestaurantPageDtoOutputDeliveryFee',
          )
          ..add('fee', fee)
          ..add('free', free))
        .toString();
  }
}

class CustomerRestaurantPageDtoOutputDeliveryFeeBuilder
    implements
        Builder<
          CustomerRestaurantPageDtoOutputDeliveryFee,
          CustomerRestaurantPageDtoOutputDeliveryFeeBuilder
        > {
  _$CustomerRestaurantPageDtoOutputDeliveryFee? _$v;

  CaptainAvailabilityDtoOutputCustodyLimitBuilder? _fee;
  CaptainAvailabilityDtoOutputCustodyLimitBuilder get fee =>
      _$this._fee ??= CaptainAvailabilityDtoOutputCustodyLimitBuilder();
  set fee(CaptainAvailabilityDtoOutputCustodyLimitBuilder? fee) =>
      _$this._fee = fee;

  bool? _free;
  bool? get free => _$this._free;
  set free(bool? free) => _$this._free = free;

  CustomerRestaurantPageDtoOutputDeliveryFeeBuilder() {
    CustomerRestaurantPageDtoOutputDeliveryFee._defaults(this);
  }

  CustomerRestaurantPageDtoOutputDeliveryFeeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fee = $v.fee.toBuilder();
      _free = $v.free;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerRestaurantPageDtoOutputDeliveryFee other) {
    _$v = other as _$CustomerRestaurantPageDtoOutputDeliveryFee;
  }

  @override
  void update(
    void Function(CustomerRestaurantPageDtoOutputDeliveryFeeBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerRestaurantPageDtoOutputDeliveryFee build() => _build();

  _$CustomerRestaurantPageDtoOutputDeliveryFee _build() {
    _$CustomerRestaurantPageDtoOutputDeliveryFee _$result;
    try {
      _$result =
          _$v ??
          _$CustomerRestaurantPageDtoOutputDeliveryFee._(
            fee: fee.build(),
            free: BuiltValueNullFieldError.checkNotNull(
              free,
              r'CustomerRestaurantPageDtoOutputDeliveryFee',
              'free',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'fee';
        fee.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerRestaurantPageDtoOutputDeliveryFee',
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
