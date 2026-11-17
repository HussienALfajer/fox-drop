// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_ratings_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantRatingsDtoOutput extends MerchantRatingsDtoOutput {
  @override
  final int count;
  @override
  final num? average;
  @override
  final BuiltList<MerchantRatingsDtoOutputDistributionInner> distribution;
  @override
  final BuiltList<MerchantRatingsDtoOutputRatingsInner> ratings;
  @override
  final String? next;

  factory _$MerchantRatingsDtoOutput([
    void Function(MerchantRatingsDtoOutputBuilder)? updates,
  ]) => (MerchantRatingsDtoOutputBuilder()..update(updates))._build();

  _$MerchantRatingsDtoOutput._({
    required this.count,
    this.average,
    required this.distribution,
    required this.ratings,
    this.next,
  }) : super._();
  @override
  MerchantRatingsDtoOutput rebuild(
    void Function(MerchantRatingsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantRatingsDtoOutputBuilder toBuilder() =>
      MerchantRatingsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantRatingsDtoOutput &&
        count == other.count &&
        average == other.average &&
        distribution == other.distribution &&
        ratings == other.ratings &&
        next == other.next;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jc(_$hash, average.hashCode);
    _$hash = $jc(_$hash, distribution.hashCode);
    _$hash = $jc(_$hash, ratings.hashCode);
    _$hash = $jc(_$hash, next.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantRatingsDtoOutput')
          ..add('count', count)
          ..add('average', average)
          ..add('distribution', distribution)
          ..add('ratings', ratings)
          ..add('next', next))
        .toString();
  }
}

class MerchantRatingsDtoOutputBuilder
    implements
        Builder<MerchantRatingsDtoOutput, MerchantRatingsDtoOutputBuilder> {
  _$MerchantRatingsDtoOutput? _$v;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  num? _average;
  num? get average => _$this._average;
  set average(num? average) => _$this._average = average;

  ListBuilder<MerchantRatingsDtoOutputDistributionInner>? _distribution;
  ListBuilder<MerchantRatingsDtoOutputDistributionInner> get distribution =>
      _$this._distribution ??=
          ListBuilder<MerchantRatingsDtoOutputDistributionInner>();
  set distribution(
    ListBuilder<MerchantRatingsDtoOutputDistributionInner>? distribution,
  ) => _$this._distribution = distribution;

  ListBuilder<MerchantRatingsDtoOutputRatingsInner>? _ratings;
  ListBuilder<MerchantRatingsDtoOutputRatingsInner> get ratings =>
      _$this._ratings ??= ListBuilder<MerchantRatingsDtoOutputRatingsInner>();
  set ratings(ListBuilder<MerchantRatingsDtoOutputRatingsInner>? ratings) =>
      _$this._ratings = ratings;

  String? _next;
  String? get next => _$this._next;
  set next(String? next) => _$this._next = next;

  MerchantRatingsDtoOutputBuilder() {
    MerchantRatingsDtoOutput._defaults(this);
  }

  MerchantRatingsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _count = $v.count;
      _average = $v.average;
      _distribution = $v.distribution.toBuilder();
      _ratings = $v.ratings.toBuilder();
      _next = $v.next;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantRatingsDtoOutput other) {
    _$v = other as _$MerchantRatingsDtoOutput;
  }

  @override
  void update(void Function(MerchantRatingsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantRatingsDtoOutput build() => _build();

  _$MerchantRatingsDtoOutput _build() {
    _$MerchantRatingsDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$MerchantRatingsDtoOutput._(
            count: BuiltValueNullFieldError.checkNotNull(
              count,
              r'MerchantRatingsDtoOutput',
              'count',
            ),
            average: average,
            distribution: distribution.build(),
            ratings: ratings.build(),
            next: next,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'distribution';
        distribution.build();
        _$failedField = 'ratings';
        ratings.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantRatingsDtoOutput',
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
