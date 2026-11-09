// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_quote_dto_output_estimate.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerQuoteDtoOutputEstimate extends CustomerQuoteDtoOutputEstimate {
  @override
  final int fromMin;
  @override
  final int toMin;

  factory _$CustomerQuoteDtoOutputEstimate([
    void Function(CustomerQuoteDtoOutputEstimateBuilder)? updates,
  ]) => (CustomerQuoteDtoOutputEstimateBuilder()..update(updates))._build();

  _$CustomerQuoteDtoOutputEstimate._({
    required this.fromMin,
    required this.toMin,
  }) : super._();
  @override
  CustomerQuoteDtoOutputEstimate rebuild(
    void Function(CustomerQuoteDtoOutputEstimateBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerQuoteDtoOutputEstimateBuilder toBuilder() =>
      CustomerQuoteDtoOutputEstimateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerQuoteDtoOutputEstimate &&
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
    return (newBuiltValueToStringHelper(r'CustomerQuoteDtoOutputEstimate')
          ..add('fromMin', fromMin)
          ..add('toMin', toMin))
        .toString();
  }
}

class CustomerQuoteDtoOutputEstimateBuilder
    implements
        Builder<
          CustomerQuoteDtoOutputEstimate,
          CustomerQuoteDtoOutputEstimateBuilder
        > {
  _$CustomerQuoteDtoOutputEstimate? _$v;

  int? _fromMin;
  int? get fromMin => _$this._fromMin;
  set fromMin(int? fromMin) => _$this._fromMin = fromMin;

  int? _toMin;
  int? get toMin => _$this._toMin;
  set toMin(int? toMin) => _$this._toMin = toMin;

  CustomerQuoteDtoOutputEstimateBuilder() {
    CustomerQuoteDtoOutputEstimate._defaults(this);
  }

  CustomerQuoteDtoOutputEstimateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fromMin = $v.fromMin;
      _toMin = $v.toMin;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerQuoteDtoOutputEstimate other) {
    _$v = other as _$CustomerQuoteDtoOutputEstimate;
  }

  @override
  void update(void Function(CustomerQuoteDtoOutputEstimateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerQuoteDtoOutputEstimate build() => _build();

  _$CustomerQuoteDtoOutputEstimate _build() {
    final _$result =
        _$v ??
        _$CustomerQuoteDtoOutputEstimate._(
          fromMin: BuiltValueNullFieldError.checkNotNull(
            fromMin,
            r'CustomerQuoteDtoOutputEstimate',
            'fromMin',
          ),
          toMin: BuiltValueNullFieldError.checkNotNull(
            toMin,
            r'CustomerQuoteDtoOutputEstimate',
            'toMin',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
