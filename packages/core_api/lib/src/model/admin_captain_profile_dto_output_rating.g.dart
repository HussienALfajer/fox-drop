// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_profile_dto_output_rating.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainProfileDtoOutputRating
    extends AdminCaptainProfileDtoOutputRating {
  @override
  final int count;
  @override
  final num average;

  factory _$AdminCaptainProfileDtoOutputRating([
    void Function(AdminCaptainProfileDtoOutputRatingBuilder)? updates,
  ]) => (AdminCaptainProfileDtoOutputRatingBuilder()..update(updates))._build();

  _$AdminCaptainProfileDtoOutputRating._({
    required this.count,
    required this.average,
  }) : super._();
  @override
  AdminCaptainProfileDtoOutputRating rebuild(
    void Function(AdminCaptainProfileDtoOutputRatingBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainProfileDtoOutputRatingBuilder toBuilder() =>
      AdminCaptainProfileDtoOutputRatingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainProfileDtoOutputRating &&
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
    return (newBuiltValueToStringHelper(r'AdminCaptainProfileDtoOutputRating')
          ..add('count', count)
          ..add('average', average))
        .toString();
  }
}

class AdminCaptainProfileDtoOutputRatingBuilder
    implements
        Builder<
          AdminCaptainProfileDtoOutputRating,
          AdminCaptainProfileDtoOutputRatingBuilder
        > {
  _$AdminCaptainProfileDtoOutputRating? _$v;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  num? _average;
  num? get average => _$this._average;
  set average(num? average) => _$this._average = average;

  AdminCaptainProfileDtoOutputRatingBuilder() {
    AdminCaptainProfileDtoOutputRating._defaults(this);
  }

  AdminCaptainProfileDtoOutputRatingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _count = $v.count;
      _average = $v.average;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainProfileDtoOutputRating other) {
    _$v = other as _$AdminCaptainProfileDtoOutputRating;
  }

  @override
  void update(
    void Function(AdminCaptainProfileDtoOutputRatingBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainProfileDtoOutputRating build() => _build();

  _$AdminCaptainProfileDtoOutputRating _build() {
    final _$result =
        _$v ??
        _$AdminCaptainProfileDtoOutputRating._(
          count: BuiltValueNullFieldError.checkNotNull(
            count,
            r'AdminCaptainProfileDtoOutputRating',
            'count',
          ),
          average: BuiltValueNullFieldError.checkNotNull(
            average,
            r'AdminCaptainProfileDtoOutputRating',
            'average',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
