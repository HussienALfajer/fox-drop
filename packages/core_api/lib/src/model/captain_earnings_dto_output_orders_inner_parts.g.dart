// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_earnings_dto_output_orders_inner_parts.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainEarningsDtoOutputOrdersInnerParts
    extends CaptainEarningsDtoOutputOrdersInnerParts {
  @override
  final String base_;
  @override
  final String distance;
  @override
  final String topUp;
  @override
  final String waiting;
  @override
  final String peak;

  factory _$CaptainEarningsDtoOutputOrdersInnerParts([
    void Function(CaptainEarningsDtoOutputOrdersInnerPartsBuilder)? updates,
  ]) => (CaptainEarningsDtoOutputOrdersInnerPartsBuilder()..update(updates))
      ._build();

  _$CaptainEarningsDtoOutputOrdersInnerParts._({
    required this.base_,
    required this.distance,
    required this.topUp,
    required this.waiting,
    required this.peak,
  }) : super._();
  @override
  CaptainEarningsDtoOutputOrdersInnerParts rebuild(
    void Function(CaptainEarningsDtoOutputOrdersInnerPartsBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainEarningsDtoOutputOrdersInnerPartsBuilder toBuilder() =>
      CaptainEarningsDtoOutputOrdersInnerPartsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainEarningsDtoOutputOrdersInnerParts &&
        base_ == other.base_ &&
        distance == other.distance &&
        topUp == other.topUp &&
        waiting == other.waiting &&
        peak == other.peak;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, base_.hashCode);
    _$hash = $jc(_$hash, distance.hashCode);
    _$hash = $jc(_$hash, topUp.hashCode);
    _$hash = $jc(_$hash, waiting.hashCode);
    _$hash = $jc(_$hash, peak.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainEarningsDtoOutputOrdersInnerParts',
          )
          ..add('base_', base_)
          ..add('distance', distance)
          ..add('topUp', topUp)
          ..add('waiting', waiting)
          ..add('peak', peak))
        .toString();
  }
}

class CaptainEarningsDtoOutputOrdersInnerPartsBuilder
    implements
        Builder<
          CaptainEarningsDtoOutputOrdersInnerParts,
          CaptainEarningsDtoOutputOrdersInnerPartsBuilder
        > {
  _$CaptainEarningsDtoOutputOrdersInnerParts? _$v;

  String? _base_;
  String? get base_ => _$this._base_;
  set base_(String? base_) => _$this._base_ = base_;

  String? _distance;
  String? get distance => _$this._distance;
  set distance(String? distance) => _$this._distance = distance;

  String? _topUp;
  String? get topUp => _$this._topUp;
  set topUp(String? topUp) => _$this._topUp = topUp;

  String? _waiting;
  String? get waiting => _$this._waiting;
  set waiting(String? waiting) => _$this._waiting = waiting;

  String? _peak;
  String? get peak => _$this._peak;
  set peak(String? peak) => _$this._peak = peak;

  CaptainEarningsDtoOutputOrdersInnerPartsBuilder() {
    CaptainEarningsDtoOutputOrdersInnerParts._defaults(this);
  }

  CaptainEarningsDtoOutputOrdersInnerPartsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _base_ = $v.base_;
      _distance = $v.distance;
      _topUp = $v.topUp;
      _waiting = $v.waiting;
      _peak = $v.peak;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainEarningsDtoOutputOrdersInnerParts other) {
    _$v = other as _$CaptainEarningsDtoOutputOrdersInnerParts;
  }

  @override
  void update(
    void Function(CaptainEarningsDtoOutputOrdersInnerPartsBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainEarningsDtoOutputOrdersInnerParts build() => _build();

  _$CaptainEarningsDtoOutputOrdersInnerParts _build() {
    final _$result =
        _$v ??
        _$CaptainEarningsDtoOutputOrdersInnerParts._(
          base_: BuiltValueNullFieldError.checkNotNull(
            base_,
            r'CaptainEarningsDtoOutputOrdersInnerParts',
            'base_',
          ),
          distance: BuiltValueNullFieldError.checkNotNull(
            distance,
            r'CaptainEarningsDtoOutputOrdersInnerParts',
            'distance',
          ),
          topUp: BuiltValueNullFieldError.checkNotNull(
            topUp,
            r'CaptainEarningsDtoOutputOrdersInnerParts',
            'topUp',
          ),
          waiting: BuiltValueNullFieldError.checkNotNull(
            waiting,
            r'CaptainEarningsDtoOutputOrdersInnerParts',
            'waiting',
          ),
          peak: BuiltValueNullFieldError.checkNotNull(
            peak,
            r'CaptainEarningsDtoOutputOrdersInnerParts',
            'peak',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
