// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_figures_output_rating.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantFiguresOutputRating extends MerchantFiguresOutputRating {
  @override
  final int count;
  @override
  final num? average;

  factory _$MerchantFiguresOutputRating([
    void Function(MerchantFiguresOutputRatingBuilder)? updates,
  ]) => (MerchantFiguresOutputRatingBuilder()..update(updates))._build();

  _$MerchantFiguresOutputRating._({required this.count, this.average})
    : super._();
  @override
  MerchantFiguresOutputRating rebuild(
    void Function(MerchantFiguresOutputRatingBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantFiguresOutputRatingBuilder toBuilder() =>
      MerchantFiguresOutputRatingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantFiguresOutputRating &&
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
    return (newBuiltValueToStringHelper(r'MerchantFiguresOutputRating')
          ..add('count', count)
          ..add('average', average))
        .toString();
  }
}

class MerchantFiguresOutputRatingBuilder
    implements
        Builder<
          MerchantFiguresOutputRating,
          MerchantFiguresOutputRatingBuilder
        > {
  _$MerchantFiguresOutputRating? _$v;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  num? _average;
  num? get average => _$this._average;
  set average(num? average) => _$this._average = average;

  MerchantFiguresOutputRatingBuilder() {
    MerchantFiguresOutputRating._defaults(this);
  }

  MerchantFiguresOutputRatingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _count = $v.count;
      _average = $v.average;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantFiguresOutputRating other) {
    _$v = other as _$MerchantFiguresOutputRating;
  }

  @override
  void update(void Function(MerchantFiguresOutputRatingBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantFiguresOutputRating build() => _build();

  _$MerchantFiguresOutputRating _build() {
    final _$result =
        _$v ??
        _$MerchantFiguresOutputRating._(
          count: BuiltValueNullFieldError.checkNotNull(
            count,
            r'MerchantFiguresOutputRating',
            'count',
          ),
          average: average,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
