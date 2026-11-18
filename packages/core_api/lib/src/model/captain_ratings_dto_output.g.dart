// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_ratings_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainRatingsDtoOutput extends CaptainRatingsDtoOutput {
  @override
  final int count;
  @override
  final num? average;
  @override
  final BuiltList<CaptainRatingsDtoOutputReasonsInner> reasons;

  factory _$CaptainRatingsDtoOutput([
    void Function(CaptainRatingsDtoOutputBuilder)? updates,
  ]) => (CaptainRatingsDtoOutputBuilder()..update(updates))._build();

  _$CaptainRatingsDtoOutput._({
    required this.count,
    this.average,
    required this.reasons,
  }) : super._();
  @override
  CaptainRatingsDtoOutput rebuild(
    void Function(CaptainRatingsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainRatingsDtoOutputBuilder toBuilder() =>
      CaptainRatingsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainRatingsDtoOutput &&
        count == other.count &&
        average == other.average &&
        reasons == other.reasons;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jc(_$hash, average.hashCode);
    _$hash = $jc(_$hash, reasons.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainRatingsDtoOutput')
          ..add('count', count)
          ..add('average', average)
          ..add('reasons', reasons))
        .toString();
  }
}

class CaptainRatingsDtoOutputBuilder
    implements
        Builder<CaptainRatingsDtoOutput, CaptainRatingsDtoOutputBuilder> {
  _$CaptainRatingsDtoOutput? _$v;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  num? _average;
  num? get average => _$this._average;
  set average(num? average) => _$this._average = average;

  ListBuilder<CaptainRatingsDtoOutputReasonsInner>? _reasons;
  ListBuilder<CaptainRatingsDtoOutputReasonsInner> get reasons =>
      _$this._reasons ??= ListBuilder<CaptainRatingsDtoOutputReasonsInner>();
  set reasons(ListBuilder<CaptainRatingsDtoOutputReasonsInner>? reasons) =>
      _$this._reasons = reasons;

  CaptainRatingsDtoOutputBuilder() {
    CaptainRatingsDtoOutput._defaults(this);
  }

  CaptainRatingsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _count = $v.count;
      _average = $v.average;
      _reasons = $v.reasons.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainRatingsDtoOutput other) {
    _$v = other as _$CaptainRatingsDtoOutput;
  }

  @override
  void update(void Function(CaptainRatingsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainRatingsDtoOutput build() => _build();

  _$CaptainRatingsDtoOutput _build() {
    _$CaptainRatingsDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$CaptainRatingsDtoOutput._(
            count: BuiltValueNullFieldError.checkNotNull(
              count,
              r'CaptainRatingsDtoOutput',
              'count',
            ),
            average: average,
            reasons: reasons.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'reasons';
        reasons.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainRatingsDtoOutput',
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
