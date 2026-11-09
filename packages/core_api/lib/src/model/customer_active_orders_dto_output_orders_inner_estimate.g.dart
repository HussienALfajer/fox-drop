// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_active_orders_dto_output_orders_inner_estimate.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerActiveOrdersDtoOutputOrdersInnerEstimate
    extends CustomerActiveOrdersDtoOutputOrdersInnerEstimate {
  @override
  final int fromMin;
  @override
  final int toMin;

  factory _$CustomerActiveOrdersDtoOutputOrdersInnerEstimate([
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerEstimateBuilder)?
    updates,
  ]) =>
      (CustomerActiveOrdersDtoOutputOrdersInnerEstimateBuilder()
            ..update(updates))
          ._build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerEstimate._({
    required this.fromMin,
    required this.toMin,
  }) : super._();
  @override
  CustomerActiveOrdersDtoOutputOrdersInnerEstimate rebuild(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerEstimateBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerEstimateBuilder toBuilder() =>
      CustomerActiveOrdersDtoOutputOrdersInnerEstimateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerActiveOrdersDtoOutputOrdersInnerEstimate &&
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
            r'CustomerActiveOrdersDtoOutputOrdersInnerEstimate',
          )
          ..add('fromMin', fromMin)
          ..add('toMin', toMin))
        .toString();
  }
}

class CustomerActiveOrdersDtoOutputOrdersInnerEstimateBuilder
    implements
        Builder<
          CustomerActiveOrdersDtoOutputOrdersInnerEstimate,
          CustomerActiveOrdersDtoOutputOrdersInnerEstimateBuilder
        > {
  _$CustomerActiveOrdersDtoOutputOrdersInnerEstimate? _$v;

  int? _fromMin;
  int? get fromMin => _$this._fromMin;
  set fromMin(int? fromMin) => _$this._fromMin = fromMin;

  int? _toMin;
  int? get toMin => _$this._toMin;
  set toMin(int? toMin) => _$this._toMin = toMin;

  CustomerActiveOrdersDtoOutputOrdersInnerEstimateBuilder() {
    CustomerActiveOrdersDtoOutputOrdersInnerEstimate._defaults(this);
  }

  CustomerActiveOrdersDtoOutputOrdersInnerEstimateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fromMin = $v.fromMin;
      _toMin = $v.toMin;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerActiveOrdersDtoOutputOrdersInnerEstimate other) {
    _$v = other as _$CustomerActiveOrdersDtoOutputOrdersInnerEstimate;
  }

  @override
  void update(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerEstimateBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerEstimate build() => _build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerEstimate _build() {
    final _$result =
        _$v ??
        _$CustomerActiveOrdersDtoOutputOrdersInnerEstimate._(
          fromMin: BuiltValueNullFieldError.checkNotNull(
            fromMin,
            r'CustomerActiveOrdersDtoOutputOrdersInnerEstimate',
            'fromMin',
          ),
          toMin: BuiltValueNullFieldError.checkNotNull(
            toMin,
            r'CustomerActiveOrdersDtoOutputOrdersInnerEstimate',
            'toMin',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
