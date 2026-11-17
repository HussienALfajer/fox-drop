// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_rate_order_dto_captain.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerRateOrderDtoCaptain extends CustomerRateOrderDtoCaptain {
  @override
  final int stars;
  @override
  final BuiltList<String> reasons;
  @override
  final String? comment;

  factory _$CustomerRateOrderDtoCaptain([
    void Function(CustomerRateOrderDtoCaptainBuilder)? updates,
  ]) => (CustomerRateOrderDtoCaptainBuilder()..update(updates))._build();

  _$CustomerRateOrderDtoCaptain._({
    required this.stars,
    required this.reasons,
    this.comment,
  }) : super._();
  @override
  CustomerRateOrderDtoCaptain rebuild(
    void Function(CustomerRateOrderDtoCaptainBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerRateOrderDtoCaptainBuilder toBuilder() =>
      CustomerRateOrderDtoCaptainBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerRateOrderDtoCaptain &&
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
    return (newBuiltValueToStringHelper(r'CustomerRateOrderDtoCaptain')
          ..add('stars', stars)
          ..add('reasons', reasons)
          ..add('comment', comment))
        .toString();
  }
}

class CustomerRateOrderDtoCaptainBuilder
    implements
        Builder<
          CustomerRateOrderDtoCaptain,
          CustomerRateOrderDtoCaptainBuilder
        > {
  _$CustomerRateOrderDtoCaptain? _$v;

  int? _stars;
  int? get stars => _$this._stars;
  set stars(int? stars) => _$this._stars = stars;

  ListBuilder<String>? _reasons;
  ListBuilder<String> get reasons => _$this._reasons ??= ListBuilder<String>();
  set reasons(ListBuilder<String>? reasons) => _$this._reasons = reasons;

  String? _comment;
  String? get comment => _$this._comment;
  set comment(String? comment) => _$this._comment = comment;

  CustomerRateOrderDtoCaptainBuilder() {
    CustomerRateOrderDtoCaptain._defaults(this);
  }

  CustomerRateOrderDtoCaptainBuilder get _$this {
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
  void replace(CustomerRateOrderDtoCaptain other) {
    _$v = other as _$CustomerRateOrderDtoCaptain;
  }

  @override
  void update(void Function(CustomerRateOrderDtoCaptainBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerRateOrderDtoCaptain build() => _build();

  _$CustomerRateOrderDtoCaptain _build() {
    _$CustomerRateOrderDtoCaptain _$result;
    try {
      _$result =
          _$v ??
          _$CustomerRateOrderDtoCaptain._(
            stars: BuiltValueNullFieldError.checkNotNull(
              stars,
              r'CustomerRateOrderDtoCaptain',
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
          r'CustomerRateOrderDtoCaptain',
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
