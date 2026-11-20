// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_figures_dto_output_current_rating.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantFiguresDtoOutputCurrentRating
    extends MerchantFiguresDtoOutputCurrentRating {
  @override
  final int count;
  @override
  final num? average;

  factory _$MerchantFiguresDtoOutputCurrentRating([
    void Function(MerchantFiguresDtoOutputCurrentRatingBuilder)? updates,
  ]) => (MerchantFiguresDtoOutputCurrentRatingBuilder()..update(updates))
      ._build();

  _$MerchantFiguresDtoOutputCurrentRating._({required this.count, this.average})
    : super._();
  @override
  MerchantFiguresDtoOutputCurrentRating rebuild(
    void Function(MerchantFiguresDtoOutputCurrentRatingBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantFiguresDtoOutputCurrentRatingBuilder toBuilder() =>
      MerchantFiguresDtoOutputCurrentRatingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantFiguresDtoOutputCurrentRating &&
        count == other.count &&
        average == other.average;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jc(_$hash, average.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantFiguresDtoOutputCurrentRating',
          )
          ..add('count', count)
          ..add('average', average))
        .toString();
  }
}

class MerchantFiguresDtoOutputCurrentRatingBuilder
    implements
        Builder<
          MerchantFiguresDtoOutputCurrentRating,
          MerchantFiguresDtoOutputCurrentRatingBuilder
        > {
  _$MerchantFiguresDtoOutputCurrentRating? _$v;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  num? _average;
  num? get average => _$this._average;
  set average(num? average) => _$this._average = average;

  MerchantFiguresDtoOutputCurrentRatingBuilder() {
    MerchantFiguresDtoOutputCurrentRating._defaults(this);
  }

  MerchantFiguresDtoOutputCurrentRatingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _count = $v.count;
      _average = $v.average;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantFiguresDtoOutputCurrentRating other) {
    _$v = other as _$MerchantFiguresDtoOutputCurrentRating;
  }

  @override
  void update(
    void Function(MerchantFiguresDtoOutputCurrentRatingBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantFiguresDtoOutputCurrentRating build() => _build();

  _$MerchantFiguresDtoOutputCurrentRating _build() {
    final _$result =
        _$v ??
        _$MerchantFiguresDtoOutputCurrentRating._(
          count: BuiltValueNullFieldError.checkNotNull(
            count,
            r'MerchantFiguresDtoOutputCurrentRating',
            'count',
          ),
          average: average,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
