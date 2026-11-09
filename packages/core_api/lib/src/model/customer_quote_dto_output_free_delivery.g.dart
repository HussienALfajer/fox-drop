// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_quote_dto_output_free_delivery.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerQuoteDtoOutputFreeDelivery
    extends CustomerQuoteDtoOutputFreeDelivery {
  @override
  final String threshold;
  @override
  final bool reached;
  @override
  final String missing;

  factory _$CustomerQuoteDtoOutputFreeDelivery([
    void Function(CustomerQuoteDtoOutputFreeDeliveryBuilder)? updates,
  ]) => (CustomerQuoteDtoOutputFreeDeliveryBuilder()..update(updates))._build();

  _$CustomerQuoteDtoOutputFreeDelivery._({
    required this.threshold,
    required this.reached,
    required this.missing,
  }) : super._();
  @override
  CustomerQuoteDtoOutputFreeDelivery rebuild(
    void Function(CustomerQuoteDtoOutputFreeDeliveryBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerQuoteDtoOutputFreeDeliveryBuilder toBuilder() =>
      CustomerQuoteDtoOutputFreeDeliveryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerQuoteDtoOutputFreeDelivery &&
        threshold == other.threshold &&
        reached == other.reached &&
        missing == other.missing;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, threshold.hashCode);
    _$hash = $jc(_$hash, reached.hashCode);
    _$hash = $jc(_$hash, missing.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerQuoteDtoOutputFreeDelivery')
          ..add('threshold', threshold)
          ..add('reached', reached)
          ..add('missing', missing))
        .toString();
  }
}

class CustomerQuoteDtoOutputFreeDeliveryBuilder
    implements
        Builder<
          CustomerQuoteDtoOutputFreeDelivery,
          CustomerQuoteDtoOutputFreeDeliveryBuilder
        > {
  _$CustomerQuoteDtoOutputFreeDelivery? _$v;

  String? _threshold;
  String? get threshold => _$this._threshold;
  set threshold(String? threshold) => _$this._threshold = threshold;

  bool? _reached;
  bool? get reached => _$this._reached;
  set reached(bool? reached) => _$this._reached = reached;

  String? _missing;
  String? get missing => _$this._missing;
  set missing(String? missing) => _$this._missing = missing;

  CustomerQuoteDtoOutputFreeDeliveryBuilder() {
    CustomerQuoteDtoOutputFreeDelivery._defaults(this);
  }

  CustomerQuoteDtoOutputFreeDeliveryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _threshold = $v.threshold;
      _reached = $v.reached;
      _missing = $v.missing;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerQuoteDtoOutputFreeDelivery other) {
    _$v = other as _$CustomerQuoteDtoOutputFreeDelivery;
  }

  @override
  void update(
    void Function(CustomerQuoteDtoOutputFreeDeliveryBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerQuoteDtoOutputFreeDelivery build() => _build();

  _$CustomerQuoteDtoOutputFreeDelivery _build() {
    final _$result =
        _$v ??
        _$CustomerQuoteDtoOutputFreeDelivery._(
          threshold: BuiltValueNullFieldError.checkNotNull(
            threshold,
            r'CustomerQuoteDtoOutputFreeDelivery',
            'threshold',
          ),
          reached: BuiltValueNullFieldError.checkNotNull(
            reached,
            r'CustomerQuoteDtoOutputFreeDelivery',
            'reached',
          ),
          missing: BuiltValueNullFieldError.checkNotNull(
            missing,
            r'CustomerQuoteDtoOutputFreeDelivery',
            'missing',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
