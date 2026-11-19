// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_pay_calculation_dto_output_current.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainPayCalculationDtoOutputCurrent
    extends CaptainPayCalculationDtoOutputCurrent {
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

  factory _$CaptainPayCalculationDtoOutputCurrent([
    void Function(CaptainPayCalculationDtoOutputCurrentBuilder)? updates,
  ]) => (CaptainPayCalculationDtoOutputCurrentBuilder()..update(updates))
      ._build();

  _$CaptainPayCalculationDtoOutputCurrent._({
    required this.base_,
    required this.distance,
    required this.topUp,
    required this.orderPay,
    required this.waiting,
    required this.total,
  }) : super._();
  @override
  CaptainPayCalculationDtoOutputCurrent rebuild(
    void Function(CaptainPayCalculationDtoOutputCurrentBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainPayCalculationDtoOutputCurrentBuilder toBuilder() =>
      CaptainPayCalculationDtoOutputCurrentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainPayCalculationDtoOutputCurrent &&
        base_ == other.base_ &&
        distance == other.distance &&
        topUp == other.topUp &&
        orderPay == other.orderPay &&
        waiting == other.waiting &&
        total == other.total;
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
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainPayCalculationDtoOutputCurrent',
          )
          ..add('base_', base_)
          ..add('distance', distance)
          ..add('topUp', topUp)
          ..add('orderPay', orderPay)
          ..add('waiting', waiting)
          ..add('total', total))
        .toString();
  }
}

class CaptainPayCalculationDtoOutputCurrentBuilder
    implements
        Builder<
          CaptainPayCalculationDtoOutputCurrent,
          CaptainPayCalculationDtoOutputCurrentBuilder
        > {
  _$CaptainPayCalculationDtoOutputCurrent? _$v;

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

  CaptainPayCalculationDtoOutputCurrentBuilder() {
    CaptainPayCalculationDtoOutputCurrent._defaults(this);
  }

  CaptainPayCalculationDtoOutputCurrentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _base_ = $v.base_.toBuilder();
      _distance = $v.distance.toBuilder();
      _topUp = $v.topUp.toBuilder();
      _orderPay = $v.orderPay.toBuilder();
      _waiting = $v.waiting.toBuilder();
      _total = $v.total.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainPayCalculationDtoOutputCurrent other) {
    _$v = other as _$CaptainPayCalculationDtoOutputCurrent;
  }

  @override
  void update(
    void Function(CaptainPayCalculationDtoOutputCurrentBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainPayCalculationDtoOutputCurrent build() => _build();

  _$CaptainPayCalculationDtoOutputCurrent _build() {
    _$CaptainPayCalculationDtoOutputCurrent _$result;
    try {
      _$result =
          _$v ??
          _$CaptainPayCalculationDtoOutputCurrent._(
            base_: base_.build(),
            distance: distance.build(),
            topUp: topUp.build(),
            orderPay: orderPay.build(),
            waiting: waiting.build(),
            total: total.build(),
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
          r'CaptainPayCalculationDtoOutputCurrent',
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
