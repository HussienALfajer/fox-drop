// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_pay_calculation_dto_output_announced_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainPayCalculationDtoOutputAnnouncedInner
    extends CaptainPayCalculationDtoOutputAnnouncedInner {
  @override
  final CaptainPayMoneyOutput base_;
  @override
  final CaptainPayMoneyOutput distance;
  @override
  final CaptainPayMoneyOutput topUp;
  @override
  final CaptainPayMoneyOutput orderPay;
  @override
  final CaptainPayMoneyOutput waiting;
  @override
  final CaptainPayMoneyOutput total;
  @override
  final DateTime effectiveFrom;

  factory _$CaptainPayCalculationDtoOutputAnnouncedInner([
    void Function(CaptainPayCalculationDtoOutputAnnouncedInnerBuilder)? updates,
  ]) => (CaptainPayCalculationDtoOutputAnnouncedInnerBuilder()..update(updates))
      ._build();

  _$CaptainPayCalculationDtoOutputAnnouncedInner._({
    required this.base_,
    required this.distance,
    required this.topUp,
    required this.orderPay,
    required this.waiting,
    required this.total,
    required this.effectiveFrom,
  }) : super._();
  @override
  CaptainPayCalculationDtoOutputAnnouncedInner rebuild(
    void Function(CaptainPayCalculationDtoOutputAnnouncedInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainPayCalculationDtoOutputAnnouncedInnerBuilder toBuilder() =>
      CaptainPayCalculationDtoOutputAnnouncedInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainPayCalculationDtoOutputAnnouncedInner &&
        base_ == other.base_ &&
        distance == other.distance &&
        topUp == other.topUp &&
        orderPay == other.orderPay &&
        waiting == other.waiting &&
        total == other.total &&
        effectiveFrom == other.effectiveFrom;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, base_.hashCode);
    _$hash = $jc(_$hash, distance.hashCode);
    _$hash = $jc(_$hash, topUp.hashCode);
    _$hash = $jc(_$hash, orderPay.hashCode);
    _$hash = $jc(_$hash, waiting.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, effectiveFrom.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainPayCalculationDtoOutputAnnouncedInner',
          )
          ..add('base_', base_)
          ..add('distance', distance)
          ..add('topUp', topUp)
          ..add('orderPay', orderPay)
          ..add('waiting', waiting)
          ..add('total', total)
          ..add('effectiveFrom', effectiveFrom))
        .toString();
  }
}

class CaptainPayCalculationDtoOutputAnnouncedInnerBuilder
    implements
        Builder<
          CaptainPayCalculationDtoOutputAnnouncedInner,
          CaptainPayCalculationDtoOutputAnnouncedInnerBuilder
        > {
  _$CaptainPayCalculationDtoOutputAnnouncedInner? _$v;

  CaptainPayMoneyOutputBuilder? _base_;
  CaptainPayMoneyOutputBuilder get base_ =>
      _$this._base_ ??= CaptainPayMoneyOutputBuilder();
  set base_(CaptainPayMoneyOutputBuilder? base_) => _$this._base_ = base_;

  CaptainPayMoneyOutputBuilder? _distance;
  CaptainPayMoneyOutputBuilder get distance =>
      _$this._distance ??= CaptainPayMoneyOutputBuilder();
  set distance(CaptainPayMoneyOutputBuilder? distance) =>
      _$this._distance = distance;

  CaptainPayMoneyOutputBuilder? _topUp;
  CaptainPayMoneyOutputBuilder get topUp =>
      _$this._topUp ??= CaptainPayMoneyOutputBuilder();
  set topUp(CaptainPayMoneyOutputBuilder? topUp) => _$this._topUp = topUp;

  CaptainPayMoneyOutputBuilder? _orderPay;
  CaptainPayMoneyOutputBuilder get orderPay =>
      _$this._orderPay ??= CaptainPayMoneyOutputBuilder();
  set orderPay(CaptainPayMoneyOutputBuilder? orderPay) =>
      _$this._orderPay = orderPay;

  CaptainPayMoneyOutputBuilder? _waiting;
  CaptainPayMoneyOutputBuilder get waiting =>
      _$this._waiting ??= CaptainPayMoneyOutputBuilder();
  set waiting(CaptainPayMoneyOutputBuilder? waiting) =>
      _$this._waiting = waiting;

  CaptainPayMoneyOutputBuilder? _total;
  CaptainPayMoneyOutputBuilder get total =>
      _$this._total ??= CaptainPayMoneyOutputBuilder();
  set total(CaptainPayMoneyOutputBuilder? total) => _$this._total = total;

  DateTime? _effectiveFrom;
  DateTime? get effectiveFrom => _$this._effectiveFrom;
  set effectiveFrom(DateTime? effectiveFrom) =>
      _$this._effectiveFrom = effectiveFrom;

  CaptainPayCalculationDtoOutputAnnouncedInnerBuilder() {
    CaptainPayCalculationDtoOutputAnnouncedInner._defaults(this);
  }

  CaptainPayCalculationDtoOutputAnnouncedInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _base_ = $v.base_.toBuilder();
      _distance = $v.distance.toBuilder();
      _topUp = $v.topUp.toBuilder();
      _orderPay = $v.orderPay.toBuilder();
      _waiting = $v.waiting.toBuilder();
      _total = $v.total.toBuilder();
      _effectiveFrom = $v.effectiveFrom;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainPayCalculationDtoOutputAnnouncedInner other) {
    _$v = other as _$CaptainPayCalculationDtoOutputAnnouncedInner;
  }

  @override
  void update(
    void Function(CaptainPayCalculationDtoOutputAnnouncedInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainPayCalculationDtoOutputAnnouncedInner build() => _build();

  _$CaptainPayCalculationDtoOutputAnnouncedInner _build() {
    _$CaptainPayCalculationDtoOutputAnnouncedInner _$result;
    try {
      _$result =
          _$v ??
          _$CaptainPayCalculationDtoOutputAnnouncedInner._(
            base_: base_.build(),
            distance: distance.build(),
            topUp: topUp.build(),
            orderPay: orderPay.build(),
            waiting: waiting.build(),
            total: total.build(),
            effectiveFrom: BuiltValueNullFieldError.checkNotNull(
              effectiveFrom,
              r'CaptainPayCalculationDtoOutputAnnouncedInner',
              'effectiveFrom',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'base_';
        base_.build();
        _$failedField = 'distance';
        distance.build();
        _$failedField = 'topUp';
        topUp.build();
        _$failedField = 'orderPay';
        orderPay.build();
        _$failedField = 'waiting';
        waiting.build();
        _$failedField = 'total';
        total.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainPayCalculationDtoOutputAnnouncedInner',
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
