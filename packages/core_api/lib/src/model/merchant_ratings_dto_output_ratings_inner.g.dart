// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_ratings_dto_output_ratings_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantRatingsDtoOutputRatingsInner
    extends MerchantRatingsDtoOutputRatingsInner {
  @override
  final String id;
  @override
  final int stars;
  @override
  final BuiltList<AdminCustomerDtoOutputRatingsInnerReasonsInner?> reasons;
  @override
  final String? comment;
  @override
  final DateTime at;

  factory _$MerchantRatingsDtoOutputRatingsInner([
    void Function(MerchantRatingsDtoOutputRatingsInnerBuilder)? updates,
  ]) =>
      (MerchantRatingsDtoOutputRatingsInnerBuilder()..update(updates))._build();

  _$MerchantRatingsDtoOutputRatingsInner._({
    required this.id,
    required this.stars,
    required this.reasons,
    this.comment,
    required this.at,
  }) : super._();
  @override
  MerchantRatingsDtoOutputRatingsInner rebuild(
    void Function(MerchantRatingsDtoOutputRatingsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantRatingsDtoOutputRatingsInnerBuilder toBuilder() =>
      MerchantRatingsDtoOutputRatingsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantRatingsDtoOutputRatingsInner &&
        id == other.id &&
        stars == other.stars &&
        reasons == other.reasons &&
        comment == other.comment &&
        at == other.at;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, stars.hashCode);
    _$hash = $jc(_$hash, reasons.hashCode);
    _$hash = $jc(_$hash, comment.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantRatingsDtoOutputRatingsInner')
          ..add('id', id)
          ..add('stars', stars)
          ..add('reasons', reasons)
          ..add('comment', comment)
          ..add('at', at))
        .toString();
  }
}

class MerchantRatingsDtoOutputRatingsInnerBuilder
    implements
        Builder<
          MerchantRatingsDtoOutputRatingsInner,
          MerchantRatingsDtoOutputRatingsInnerBuilder
        > {
  _$MerchantRatingsDtoOutputRatingsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _stars;
  int? get stars => _$this._stars;
  set stars(int? stars) => _$this._stars = stars;

  ListBuilder<AdminCustomerDtoOutputRatingsInnerReasonsInner?>? _reasons;
  ListBuilder<AdminCustomerDtoOutputRatingsInnerReasonsInner?> get reasons =>
      _$this._reasons ??=
          ListBuilder<AdminCustomerDtoOutputRatingsInnerReasonsInner?>();
  set reasons(
    ListBuilder<AdminCustomerDtoOutputRatingsInnerReasonsInner?>? reasons,
  ) => _$this._reasons = reasons;

  String? _comment;
  String? get comment => _$this._comment;
  set comment(String? comment) => _$this._comment = comment;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  MerchantRatingsDtoOutputRatingsInnerBuilder() {
    MerchantRatingsDtoOutputRatingsInner._defaults(this);
  }

  MerchantRatingsDtoOutputRatingsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _stars = $v.stars;
      _reasons = $v.reasons.toBuilder();
      _comment = $v.comment;
      _at = $v.at;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantRatingsDtoOutputRatingsInner other) {
    _$v = other as _$MerchantRatingsDtoOutputRatingsInner;
  }

  @override
  void update(
    void Function(MerchantRatingsDtoOutputRatingsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantRatingsDtoOutputRatingsInner build() => _build();

  _$MerchantRatingsDtoOutputRatingsInner _build() {
    _$MerchantRatingsDtoOutputRatingsInner _$result;
    try {
      _$result =
          _$v ??
          _$MerchantRatingsDtoOutputRatingsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'MerchantRatingsDtoOutputRatingsInner',
              'id',
            ),
            stars: BuiltValueNullFieldError.checkNotNull(
              stars,
              r'MerchantRatingsDtoOutputRatingsInner',
              'stars',
            ),
            reasons: reasons.build(),
            comment: comment,
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'MerchantRatingsDtoOutputRatingsInner',
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
          r'MerchantRatingsDtoOutputRatingsInner',
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
