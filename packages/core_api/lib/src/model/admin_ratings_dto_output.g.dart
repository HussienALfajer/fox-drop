// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ratings_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRatingsDtoOutput extends AdminRatingsDtoOutput {
  @override
  final DateTime asOf;
  @override
  final int count;
  @override
  final num? average;
  @override
  final BuiltList<MerchantRatingsDtoOutputDistributionInner> distribution;
  @override
  final BuiltList<AdminRatingsDtoOutputRatingsInner> ratings;
  @override
  final bool more;

  factory _$AdminRatingsDtoOutput([
    void Function(AdminRatingsDtoOutputBuilder)? updates,
  ]) => (AdminRatingsDtoOutputBuilder()..update(updates))._build();

  _$AdminRatingsDtoOutput._({
    required this.asOf,
    required this.count,
    this.average,
    required this.distribution,
    required this.ratings,
    required this.more,
  }) : super._();
  @override
  AdminRatingsDtoOutput rebuild(
    void Function(AdminRatingsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRatingsDtoOutputBuilder toBuilder() =>
      AdminRatingsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRatingsDtoOutput &&
        asOf == other.asOf &&
        count == other.count &&
        average == other.average &&
        distribution == other.distribution &&
        ratings == other.ratings &&
        more == other.more;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, asOf.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jc(_$hash, average.hashCode);
    _$hash = $jc(_$hash, distribution.hashCode);
    _$hash = $jc(_$hash, ratings.hashCode);
    _$hash = $jc(_$hash, more.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminRatingsDtoOutput')
          ..add('asOf', asOf)
          ..add('count', count)
          ..add('average', average)
          ..add('distribution', distribution)
          ..add('ratings', ratings)
          ..add('more', more))
        .toString();
  }
}

class AdminRatingsDtoOutputBuilder
    implements Builder<AdminRatingsDtoOutput, AdminRatingsDtoOutputBuilder> {
  _$AdminRatingsDtoOutput? _$v;

  DateTime? _asOf;
  DateTime? get asOf => _$this._asOf;
  set asOf(DateTime? asOf) => _$this._asOf = asOf;

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

  ListBuilder<AdminRatingsDtoOutputRatingsInner>? _ratings;
  ListBuilder<AdminRatingsDtoOutputRatingsInner> get ratings =>
      _$this._ratings ??= ListBuilder<AdminRatingsDtoOutputRatingsInner>();
  set ratings(ListBuilder<AdminRatingsDtoOutputRatingsInner>? ratings) =>
      _$this._ratings = ratings;

  bool? _more;
  bool? get more => _$this._more;
  set more(bool? more) => _$this._more = more;

  AdminRatingsDtoOutputBuilder() {
    AdminRatingsDtoOutput._defaults(this);
  }

  AdminRatingsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _asOf = $v.asOf;
      _count = $v.count;
      _average = $v.average;
      _distribution = $v.distribution.toBuilder();
      _ratings = $v.ratings.toBuilder();
      _more = $v.more;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRatingsDtoOutput other) {
    _$v = other as _$AdminRatingsDtoOutput;
  }

  @override
  void update(void Function(AdminRatingsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRatingsDtoOutput build() => _build();

  _$AdminRatingsDtoOutput _build() {
    _$AdminRatingsDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminRatingsDtoOutput._(
            asOf: BuiltValueNullFieldError.checkNotNull(
              asOf,
              r'AdminRatingsDtoOutput',
              'asOf',
            ),
            count: BuiltValueNullFieldError.checkNotNull(
              count,
              r'AdminRatingsDtoOutput',
              'count',
            ),
            average: average,
            distribution: distribution.build(),
            ratings: ratings.build(),
            more: BuiltValueNullFieldError.checkNotNull(
              more,
              r'AdminRatingsDtoOutput',
              'more',
            ),
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
          r'AdminRatingsDtoOutput',
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
