// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_pay_table_preview_dto_output_announced_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPayTablePreviewDtoOutputAnnouncedInner
    extends AdminPayTablePreviewDtoOutputAnnouncedInner {
  @override
  final AdminPayTablePreviewDtoOutputInForceBase base_;
  @override
  final AdminPayTablePreviewDtoOutputInForceBase distance;
  @override
  final AdminPayTablePreviewDtoOutputInForceBase topUp;
  @override
  final AdminPayTablePreviewDtoOutputInForceBase orderPay;
  @override
  final AdminPayTablePreviewDtoOutputInForceBase waiting;
  @override
  final AdminPayTablePreviewDtoOutputInForceTotal total;
  @override
  final DateTime effectiveFrom;

  factory _$AdminPayTablePreviewDtoOutputAnnouncedInner([
    void Function(AdminPayTablePreviewDtoOutputAnnouncedInnerBuilder)? updates,
  ]) => (AdminPayTablePreviewDtoOutputAnnouncedInnerBuilder()..update(updates))
      ._build();

  _$AdminPayTablePreviewDtoOutputAnnouncedInner._({
    required this.base_,
    required this.distance,
    required this.topUp,
    required this.orderPay,
    required this.waiting,
    required this.total,
    required this.effectiveFrom,
  }) : super._();
  @override
  AdminPayTablePreviewDtoOutputAnnouncedInner rebuild(
    void Function(AdminPayTablePreviewDtoOutputAnnouncedInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminPayTablePreviewDtoOutputAnnouncedInnerBuilder toBuilder() =>
      AdminPayTablePreviewDtoOutputAnnouncedInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPayTablePreviewDtoOutputAnnouncedInner &&
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
            r'AdminPayTablePreviewDtoOutputAnnouncedInner',
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

class AdminPayTablePreviewDtoOutputAnnouncedInnerBuilder
    implements
        Builder<
          AdminPayTablePreviewDtoOutputAnnouncedInner,
          AdminPayTablePreviewDtoOutputAnnouncedInnerBuilder
        > {
  _$AdminPayTablePreviewDtoOutputAnnouncedInner? _$v;

  AdminPayTablePreviewDtoOutputInForceBaseBuilder? _base_;
  AdminPayTablePreviewDtoOutputInForceBaseBuilder get base_ =>
      _$this._base_ ??= AdminPayTablePreviewDtoOutputInForceBaseBuilder();
  set base_(AdminPayTablePreviewDtoOutputInForceBaseBuilder? base_) =>
      _$this._base_ = base_;

  AdminPayTablePreviewDtoOutputInForceBaseBuilder? _distance;
  AdminPayTablePreviewDtoOutputInForceBaseBuilder get distance =>
      _$this._distance ??= AdminPayTablePreviewDtoOutputInForceBaseBuilder();
  set distance(AdminPayTablePreviewDtoOutputInForceBaseBuilder? distance) =>
      _$this._distance = distance;

  AdminPayTablePreviewDtoOutputInForceBaseBuilder? _topUp;
  AdminPayTablePreviewDtoOutputInForceBaseBuilder get topUp =>
      _$this._topUp ??= AdminPayTablePreviewDtoOutputInForceBaseBuilder();
  set topUp(AdminPayTablePreviewDtoOutputInForceBaseBuilder? topUp) =>
      _$this._topUp = topUp;

  AdminPayTablePreviewDtoOutputInForceBaseBuilder? _orderPay;
  AdminPayTablePreviewDtoOutputInForceBaseBuilder get orderPay =>
      _$this._orderPay ??= AdminPayTablePreviewDtoOutputInForceBaseBuilder();
  set orderPay(AdminPayTablePreviewDtoOutputInForceBaseBuilder? orderPay) =>
      _$this._orderPay = orderPay;

  AdminPayTablePreviewDtoOutputInForceBaseBuilder? _waiting;
  AdminPayTablePreviewDtoOutputInForceBaseBuilder get waiting =>
      _$this._waiting ??= AdminPayTablePreviewDtoOutputInForceBaseBuilder();
  set waiting(AdminPayTablePreviewDtoOutputInForceBaseBuilder? waiting) =>
      _$this._waiting = waiting;

  AdminPayTablePreviewDtoOutputInForceTotalBuilder? _total;
  AdminPayTablePreviewDtoOutputInForceTotalBuilder get total =>
      _$this._total ??= AdminPayTablePreviewDtoOutputInForceTotalBuilder();
  set total(AdminPayTablePreviewDtoOutputInForceTotalBuilder? total) =>
      _$this._total = total;

  DateTime? _effectiveFrom;
  DateTime? get effectiveFrom => _$this._effectiveFrom;
  set effectiveFrom(DateTime? effectiveFrom) =>
      _$this._effectiveFrom = effectiveFrom;

  AdminPayTablePreviewDtoOutputAnnouncedInnerBuilder() {
    AdminPayTablePreviewDtoOutputAnnouncedInner._defaults(this);
  }

  AdminPayTablePreviewDtoOutputAnnouncedInnerBuilder get _$this {
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
  void replace(AdminPayTablePreviewDtoOutputAnnouncedInner other) {
    _$v = other as _$AdminPayTablePreviewDtoOutputAnnouncedInner;
  }

  @override
  void update(
    void Function(AdminPayTablePreviewDtoOutputAnnouncedInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminPayTablePreviewDtoOutputAnnouncedInner build() => _build();

  _$AdminPayTablePreviewDtoOutputAnnouncedInner _build() {
    _$AdminPayTablePreviewDtoOutputAnnouncedInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminPayTablePreviewDtoOutputAnnouncedInner._(
            base_: base_.build(),
            distance: distance.build(),
            topUp: topUp.build(),
            orderPay: orderPay.build(),
            waiting: waiting.build(),
            total: total.build(),
            effectiveFrom: BuiltValueNullFieldError.checkNotNull(
              effectiveFrom,
              r'AdminPayTablePreviewDtoOutputAnnouncedInner',
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
          r'AdminPayTablePreviewDtoOutputAnnouncedInner',
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
