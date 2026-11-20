// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_figures_dto_output_current_rejections_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantFiguresDtoOutputCurrentRejectionsInner
    extends MerchantFiguresDtoOutputCurrentRejectionsInner {
  @override
  final String label;
  @override
  final bool byOperations;
  @override
  final int count;

  factory _$MerchantFiguresDtoOutputCurrentRejectionsInner([
    void Function(MerchantFiguresDtoOutputCurrentRejectionsInnerBuilder)?
    updates,
  ]) =>
      (MerchantFiguresDtoOutputCurrentRejectionsInnerBuilder()..update(updates))
          ._build();

  _$MerchantFiguresDtoOutputCurrentRejectionsInner._({
    required this.label,
    required this.byOperations,
    required this.count,
  }) : super._();
  @override
  MerchantFiguresDtoOutputCurrentRejectionsInner rebuild(
    void Function(MerchantFiguresDtoOutputCurrentRejectionsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantFiguresDtoOutputCurrentRejectionsInnerBuilder toBuilder() =>
      MerchantFiguresDtoOutputCurrentRejectionsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantFiguresDtoOutputCurrentRejectionsInner &&
        label == other.label &&
        byOperations == other.byOperations &&
        count == other.count;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, byOperations.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantFiguresDtoOutputCurrentRejectionsInner',
          )
          ..add('label', label)
          ..add('byOperations', byOperations)
          ..add('count', count))
        .toString();
  }
}

class MerchantFiguresDtoOutputCurrentRejectionsInnerBuilder
    implements
        Builder<
          MerchantFiguresDtoOutputCurrentRejectionsInner,
          MerchantFiguresDtoOutputCurrentRejectionsInnerBuilder
        > {
  _$MerchantFiguresDtoOutputCurrentRejectionsInner? _$v;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  bool? _byOperations;
  bool? get byOperations => _$this._byOperations;
  set byOperations(bool? byOperations) => _$this._byOperations = byOperations;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  MerchantFiguresDtoOutputCurrentRejectionsInnerBuilder() {
    MerchantFiguresDtoOutputCurrentRejectionsInner._defaults(this);
  }

  MerchantFiguresDtoOutputCurrentRejectionsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _label = $v.label;
      _byOperations = $v.byOperations;
      _count = $v.count;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantFiguresDtoOutputCurrentRejectionsInner other) {
    _$v = other as _$MerchantFiguresDtoOutputCurrentRejectionsInner;
  }

  @override
  void update(
    void Function(MerchantFiguresDtoOutputCurrentRejectionsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantFiguresDtoOutputCurrentRejectionsInner build() => _build();

  _$MerchantFiguresDtoOutputCurrentRejectionsInner _build() {
    final _$result =
        _$v ??
        _$MerchantFiguresDtoOutputCurrentRejectionsInner._(
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'MerchantFiguresDtoOutputCurrentRejectionsInner',
            'label',
          ),
          byOperations: BuiltValueNullFieldError.checkNotNull(
            byOperations,
            r'MerchantFiguresDtoOutputCurrentRejectionsInner',
            'byOperations',
          ),
          count: BuiltValueNullFieldError.checkNotNull(
            count,
            r'MerchantFiguresDtoOutputCurrentRejectionsInner',
            'count',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
