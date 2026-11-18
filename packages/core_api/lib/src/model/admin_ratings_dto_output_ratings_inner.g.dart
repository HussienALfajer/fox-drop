// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ratings_dto_output_ratings_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRatingsDtoOutputRatingsInner
    extends AdminRatingsDtoOutputRatingsInner {
  @override
  final String orderId;
  @override
  final String orderNumber;
  @override
  final int stars;
  @override
  final BuiltList<AdminCustomerDtoOutputBlockReasonsInner> reasons;
  @override
  final String? comment;
  @override
  final DateTime at;

  factory _$AdminRatingsDtoOutputRatingsInner([
    void Function(AdminRatingsDtoOutputRatingsInnerBuilder)? updates,
  ]) => (AdminRatingsDtoOutputRatingsInnerBuilder()..update(updates))._build();

  _$AdminRatingsDtoOutputRatingsInner._({
    required this.orderId,
    required this.orderNumber,
    required this.stars,
    required this.reasons,
    this.comment,
    required this.at,
  }) : super._();
  @override
  AdminRatingsDtoOutputRatingsInner rebuild(
    void Function(AdminRatingsDtoOutputRatingsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRatingsDtoOutputRatingsInnerBuilder toBuilder() =>
      AdminRatingsDtoOutputRatingsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRatingsDtoOutputRatingsInner &&
        orderId == other.orderId &&
        orderNumber == other.orderNumber &&
        stars == other.stars &&
        reasons == other.reasons &&
        comment == other.comment &&
        at == other.at;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, orderNumber.hashCode);
    _$hash = $jc(_$hash, stars.hashCode);
    _$hash = $jc(_$hash, reasons.hashCode);
    _$hash = $jc(_$hash, comment.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminRatingsDtoOutputRatingsInner')
          ..add('orderId', orderId)
          ..add('orderNumber', orderNumber)
          ..add('stars', stars)
          ..add('reasons', reasons)
          ..add('comment', comment)
          ..add('at', at))
        .toString();
  }
}

class AdminRatingsDtoOutputRatingsInnerBuilder
    implements
        Builder<
          AdminRatingsDtoOutputRatingsInner,
          AdminRatingsDtoOutputRatingsInnerBuilder
        > {
  _$AdminRatingsDtoOutputRatingsInner? _$v;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _orderNumber;
  String? get orderNumber => _$this._orderNumber;
  set orderNumber(String? orderNumber) => _$this._orderNumber = orderNumber;

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

  AdminRatingsDtoOutputRatingsInnerBuilder() {
    AdminRatingsDtoOutputRatingsInner._defaults(this);
  }

  AdminRatingsDtoOutputRatingsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderId = $v.orderId;
      _orderNumber = $v.orderNumber;
      _stars = $v.stars;
      _reasons = $v.reasons.toBuilder();
      _comment = $v.comment;
      _at = $v.at;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRatingsDtoOutputRatingsInner other) {
    _$v = other as _$AdminRatingsDtoOutputRatingsInner;
  }

  @override
  void update(
    void Function(AdminRatingsDtoOutputRatingsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRatingsDtoOutputRatingsInner build() => _build();

  _$AdminRatingsDtoOutputRatingsInner _build() {
    _$AdminRatingsDtoOutputRatingsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminRatingsDtoOutputRatingsInner._(
            orderId: BuiltValueNullFieldError.checkNotNull(
              orderId,
              r'AdminRatingsDtoOutputRatingsInner',
              'orderId',
            ),
            orderNumber: BuiltValueNullFieldError.checkNotNull(
              orderNumber,
              r'AdminRatingsDtoOutputRatingsInner',
              'orderNumber',
            ),
            stars: BuiltValueNullFieldError.checkNotNull(
              stars,
              r'AdminRatingsDtoOutputRatingsInner',
              'stars',
            ),
            reasons: reasons.build(),
            comment: comment,
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'AdminRatingsDtoOutputRatingsInner',
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
          r'AdminRatingsDtoOutputRatingsInner',
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
