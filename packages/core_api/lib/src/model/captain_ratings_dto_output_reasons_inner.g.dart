// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_ratings_dto_output_reasons_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainRatingsDtoOutputReasonsInner
    extends CaptainRatingsDtoOutputReasonsInner {
  @override
  final String code;
  @override
  final String label;
  @override
  final int count;

  factory _$CaptainRatingsDtoOutputReasonsInner([
    void Function(CaptainRatingsDtoOutputReasonsInnerBuilder)? updates,
  ]) =>
      (CaptainRatingsDtoOutputReasonsInnerBuilder()..update(updates))._build();

  _$CaptainRatingsDtoOutputReasonsInner._({
    required this.code,
    required this.label,
    required this.count,
  }) : super._();
  @override
  CaptainRatingsDtoOutputReasonsInner rebuild(
    void Function(CaptainRatingsDtoOutputReasonsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainRatingsDtoOutputReasonsInnerBuilder toBuilder() =>
      CaptainRatingsDtoOutputReasonsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainRatingsDtoOutputReasonsInner &&
        code == other.code &&
        label == other.label &&
        count == other.count;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainRatingsDtoOutputReasonsInner')
          ..add('code', code)
          ..add('label', label)
          ..add('count', count))
        .toString();
  }
}

class CaptainRatingsDtoOutputReasonsInnerBuilder
    implements
        Builder<
          CaptainRatingsDtoOutputReasonsInner,
          CaptainRatingsDtoOutputReasonsInnerBuilder
        > {
  _$CaptainRatingsDtoOutputReasonsInner? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  CaptainRatingsDtoOutputReasonsInnerBuilder() {
    CaptainRatingsDtoOutputReasonsInner._defaults(this);
  }

  CaptainRatingsDtoOutputReasonsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _label = $v.label;
      _count = $v.count;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainRatingsDtoOutputReasonsInner other) {
    _$v = other as _$CaptainRatingsDtoOutputReasonsInner;
  }

  @override
  void update(
    void Function(CaptainRatingsDtoOutputReasonsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainRatingsDtoOutputReasonsInner build() => _build();

  _$CaptainRatingsDtoOutputReasonsInner _build() {
    final _$result =
        _$v ??
        _$CaptainRatingsDtoOutputReasonsInner._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'CaptainRatingsDtoOutputReasonsInner',
            'code',
          ),
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'CaptainRatingsDtoOutputReasonsInner',
            'label',
          ),
          count: BuiltValueNullFieldError.checkNotNull(
            count,
            r'CaptainRatingsDtoOutputReasonsInner',
            'count',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
