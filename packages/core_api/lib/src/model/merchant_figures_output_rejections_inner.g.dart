// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_figures_output_rejections_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantFiguresOutputRejectionsInner
    extends MerchantFiguresOutputRejectionsInner {
  @override
  final String label;
  @override
  final bool byOperations;
  @override
  final int count;

  factory _$MerchantFiguresOutputRejectionsInner([
    void Function(MerchantFiguresOutputRejectionsInnerBuilder)? updates,
  ]) =>
      (MerchantFiguresOutputRejectionsInnerBuilder()..update(updates))._build();

  _$MerchantFiguresOutputRejectionsInner._({
    required this.label,
    required this.byOperations,
    required this.count,
  }) : super._();
  @override
  MerchantFiguresOutputRejectionsInner rebuild(
    void Function(MerchantFiguresOutputRejectionsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantFiguresOutputRejectionsInnerBuilder toBuilder() =>
      MerchantFiguresOutputRejectionsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantFiguresOutputRejectionsInner &&
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
    return (newBuiltValueToStringHelper(r'MerchantFiguresOutputRejectionsInner')
          ..add('label', label)
          ..add('byOperations', byOperations)
          ..add('count', count))
        .toString();
  }
}

class MerchantFiguresOutputRejectionsInnerBuilder
    implements
        Builder<
          MerchantFiguresOutputRejectionsInner,
          MerchantFiguresOutputRejectionsInnerBuilder
        > {
  _$MerchantFiguresOutputRejectionsInner? _$v;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  bool? _byOperations;
  bool? get byOperations => _$this._byOperations;
  set byOperations(bool? byOperations) => _$this._byOperations = byOperations;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  MerchantFiguresOutputRejectionsInnerBuilder() {
    MerchantFiguresOutputRejectionsInner._defaults(this);
  }

  MerchantFiguresOutputRejectionsInnerBuilder get _$this {
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
  void replace(MerchantFiguresOutputRejectionsInner other) {
    _$v = other as _$MerchantFiguresOutputRejectionsInner;
  }

  @override
  void update(
    void Function(MerchantFiguresOutputRejectionsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantFiguresOutputRejectionsInner build() => _build();

  _$MerchantFiguresOutputRejectionsInner _build() {
    final _$result =
        _$v ??
        _$MerchantFiguresOutputRejectionsInner._(
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'MerchantFiguresOutputRejectionsInner',
            'label',
          ),
          byOperations: BuiltValueNullFieldError.checkNotNull(
            byOperations,
            r'MerchantFiguresOutputRejectionsInner',
            'byOperations',
          ),
          count: BuiltValueNullFieldError.checkNotNull(
            count,
            r'MerchantFiguresOutputRejectionsInner',
            'count',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
