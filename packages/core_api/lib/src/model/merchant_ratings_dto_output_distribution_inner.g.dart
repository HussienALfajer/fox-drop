// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_ratings_dto_output_distribution_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantRatingsDtoOutputDistributionInner
    extends MerchantRatingsDtoOutputDistributionInner {
  @override
  final int stars;
  @override
  final int count;

  factory _$MerchantRatingsDtoOutputDistributionInner([
    void Function(MerchantRatingsDtoOutputDistributionInnerBuilder)? updates,
  ]) => (MerchantRatingsDtoOutputDistributionInnerBuilder()..update(updates))
      ._build();

  _$MerchantRatingsDtoOutputDistributionInner._({
    required this.stars,
    required this.count,
  }) : super._();
  @override
  MerchantRatingsDtoOutputDistributionInner rebuild(
    void Function(MerchantRatingsDtoOutputDistributionInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantRatingsDtoOutputDistributionInnerBuilder toBuilder() =>
      MerchantRatingsDtoOutputDistributionInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantRatingsDtoOutputDistributionInner &&
        stars == other.stars &&
        count == other.count;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, stars.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantRatingsDtoOutputDistributionInner',
          )
          ..add('stars', stars)
          ..add('count', count))
        .toString();
  }
}

class MerchantRatingsDtoOutputDistributionInnerBuilder
    implements
        Builder<
          MerchantRatingsDtoOutputDistributionInner,
          MerchantRatingsDtoOutputDistributionInnerBuilder
        > {
  _$MerchantRatingsDtoOutputDistributionInner? _$v;

  int? _stars;
  int? get stars => _$this._stars;
  set stars(int? stars) => _$this._stars = stars;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  MerchantRatingsDtoOutputDistributionInnerBuilder() {
    MerchantRatingsDtoOutputDistributionInner._defaults(this);
  }

  MerchantRatingsDtoOutputDistributionInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _stars = $v.stars;
      _count = $v.count;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantRatingsDtoOutputDistributionInner other) {
    _$v = other as _$MerchantRatingsDtoOutputDistributionInner;
  }

  @override
  void update(
    void Function(MerchantRatingsDtoOutputDistributionInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantRatingsDtoOutputDistributionInner build() => _build();

  _$MerchantRatingsDtoOutputDistributionInner _build() {
    final _$result =
        _$v ??
        _$MerchantRatingsDtoOutputDistributionInner._(
          stars: BuiltValueNullFieldError.checkNotNull(
            stars,
            r'MerchantRatingsDtoOutputDistributionInner',
            'stars',
          ),
          count: BuiltValueNullFieldError.checkNotNull(
            count,
            r'MerchantRatingsDtoOutputDistributionInner',
            'count',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
