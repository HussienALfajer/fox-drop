// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_active_orders_dto_output_orders_inner_rating_captain.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain
    extends CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain {
  @override
  final int stars;
  @override
  final BuiltList<AdminCustomerDtoOutputBlockReasonsInner> reasons;
  @override
  final String? comment;
  @override
  final DateTime at;

  factory _$CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain([
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptainBuilder)?
    updates,
  ]) =>
      (CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptainBuilder()
            ..update(updates))
          ._build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain._({
    required this.stars,
    required this.reasons,
    this.comment,
    required this.at,
  }) : super._();
  @override
  CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain rebuild(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptainBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptainBuilder toBuilder() =>
      CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptainBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain &&
        stars == other.stars &&
        reasons == other.reasons &&
        comment == other.comment &&
        at == other.at;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, stars.hashCode);
    _$hash = $jc(_$hash, reasons.hashCode);
    _$hash = $jc(_$hash, comment.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain',
          )
          ..add('stars', stars)
          ..add('reasons', reasons)
          ..add('comment', comment)
          ..add('at', at))
        .toString();
  }
}

class CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptainBuilder
    implements
        Builder<
          CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain,
          CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptainBuilder
        > {
  _$CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain? _$v;

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

  CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptainBuilder() {
    CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain._defaults(this);
  }

  CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptainBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _stars = $v.stars;
      _reasons = $v.reasons.toBuilder();
      _comment = $v.comment;
      _at = $v.at;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain other) {
    _$v = other as _$CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain;
  }

  @override
  void update(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptainBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain build() => _build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain _build() {
    _$CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain _$result;
    try {
      _$result =
          _$v ??
          _$CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain._(
            stars: BuiltValueNullFieldError.checkNotNull(
              stars,
              r'CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain',
              'stars',
            ),
            reasons: reasons.build(),
            comment: comment,
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain',
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
          r'CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain',
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
