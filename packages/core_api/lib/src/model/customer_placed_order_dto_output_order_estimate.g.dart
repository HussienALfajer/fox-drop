// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_placed_order_dto_output_order_estimate.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerPlacedOrderDtoOutputOrderEstimate
    extends CustomerPlacedOrderDtoOutputOrderEstimate {
  @override
  final int fromMin;
  @override
  final int toMin;

  factory _$CustomerPlacedOrderDtoOutputOrderEstimate([
    void Function(CustomerPlacedOrderDtoOutputOrderEstimateBuilder)? updates,
  ]) => (CustomerPlacedOrderDtoOutputOrderEstimateBuilder()..update(updates))
      ._build();

  _$CustomerPlacedOrderDtoOutputOrderEstimate._({
    required this.fromMin,
    required this.toMin,
  }) : super._();
  @override
  CustomerPlacedOrderDtoOutputOrderEstimate rebuild(
    void Function(CustomerPlacedOrderDtoOutputOrderEstimateBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerPlacedOrderDtoOutputOrderEstimateBuilder toBuilder() =>
      CustomerPlacedOrderDtoOutputOrderEstimateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerPlacedOrderDtoOutputOrderEstimate &&
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
            r'CustomerPlacedOrderDtoOutputOrderEstimate',
          )
          ..add('fromMin', fromMin)
          ..add('toMin', toMin))
        .toString();
  }
}

class CustomerPlacedOrderDtoOutputOrderEstimateBuilder
    implements
        Builder<
          CustomerPlacedOrderDtoOutputOrderEstimate,
          CustomerPlacedOrderDtoOutputOrderEstimateBuilder
        > {
  _$CustomerPlacedOrderDtoOutputOrderEstimate? _$v;

  int? _fromMin;
  int? get fromMin => _$this._fromMin;
  set fromMin(int? fromMin) => _$this._fromMin = fromMin;

  int? _toMin;
  int? get toMin => _$this._toMin;
  set toMin(int? toMin) => _$this._toMin = toMin;

  CustomerPlacedOrderDtoOutputOrderEstimateBuilder() {
    CustomerPlacedOrderDtoOutputOrderEstimate._defaults(this);
  }

  CustomerPlacedOrderDtoOutputOrderEstimateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fromMin = $v.fromMin;
      _toMin = $v.toMin;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerPlacedOrderDtoOutputOrderEstimate other) {
    _$v = other as _$CustomerPlacedOrderDtoOutputOrderEstimate;
  }

  @override
  void update(
    void Function(CustomerPlacedOrderDtoOutputOrderEstimateBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerPlacedOrderDtoOutputOrderEstimate build() => _build();

  _$CustomerPlacedOrderDtoOutputOrderEstimate _build() {
    final _$result =
        _$v ??
        _$CustomerPlacedOrderDtoOutputOrderEstimate._(
          fromMin: BuiltValueNullFieldError.checkNotNull(
            fromMin,
            r'CustomerPlacedOrderDtoOutputOrderEstimate',
            'fromMin',
          ),
          toMin: BuiltValueNullFieldError.checkNotNull(
            toMin,
            r'CustomerPlacedOrderDtoOutputOrderEstimate',
            'toMin',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
