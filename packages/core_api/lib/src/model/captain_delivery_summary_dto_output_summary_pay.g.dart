// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_delivery_summary_dto_output_summary_pay.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainDeliverySummaryDtoOutputSummaryPay
    extends CaptainDeliverySummaryDtoOutputSummaryPay {
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
  @override
  final String total;
  @override
  final String currency;

  factory _$CaptainDeliverySummaryDtoOutputSummaryPay([
    void Function(CaptainDeliverySummaryDtoOutputSummaryPayBuilder)? updates,
  ]) => (CaptainDeliverySummaryDtoOutputSummaryPayBuilder()..update(updates))
      ._build();

  _$CaptainDeliverySummaryDtoOutputSummaryPay._({
    required this.base_,
    required this.distance,
    required this.topUp,
    required this.waiting,
    required this.peak,
    required this.total,
    required this.currency,
  }) : super._();
  @override
  CaptainDeliverySummaryDtoOutputSummaryPay rebuild(
    void Function(CaptainDeliverySummaryDtoOutputSummaryPayBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainDeliverySummaryDtoOutputSummaryPayBuilder toBuilder() =>
      CaptainDeliverySummaryDtoOutputSummaryPayBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainDeliverySummaryDtoOutputSummaryPay &&
        base_ == other.base_ &&
        distance == other.distance &&
        topUp == other.topUp &&
        waiting == other.waiting &&
        peak == other.peak &&
        total == other.total &&
        currency == other.currency;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, base_.hashCode);
    _$hash = $jc(_$hash, distance.hashCode);
    _$hash = $jc(_$hash, topUp.hashCode);
    _$hash = $jc(_$hash, waiting.hashCode);
    _$hash = $jc(_$hash, peak.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainDeliverySummaryDtoOutputSummaryPay',
          )
          ..add('base_', base_)
          ..add('distance', distance)
          ..add('topUp', topUp)
          ..add('waiting', waiting)
          ..add('peak', peak)
          ..add('total', total)
          ..add('currency', currency))
        .toString();
  }
}

class CaptainDeliverySummaryDtoOutputSummaryPayBuilder
    implements
        Builder<
          CaptainDeliverySummaryDtoOutputSummaryPay,
          CaptainDeliverySummaryDtoOutputSummaryPayBuilder
        > {
  _$CaptainDeliverySummaryDtoOutputSummaryPay? _$v;

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

  String? _total;
  String? get total => _$this._total;
  set total(String? total) => _$this._total = total;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CaptainDeliverySummaryDtoOutputSummaryPayBuilder() {
    CaptainDeliverySummaryDtoOutputSummaryPay._defaults(this);
  }

  CaptainDeliverySummaryDtoOutputSummaryPayBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _base_ = $v.base_;
      _distance = $v.distance;
      _topUp = $v.topUp;
      _waiting = $v.waiting;
      _peak = $v.peak;
      _total = $v.total;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainDeliverySummaryDtoOutputSummaryPay other) {
    _$v = other as _$CaptainDeliverySummaryDtoOutputSummaryPay;
  }

  @override
  void update(
    void Function(CaptainDeliverySummaryDtoOutputSummaryPayBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainDeliverySummaryDtoOutputSummaryPay build() => _build();

  _$CaptainDeliverySummaryDtoOutputSummaryPay _build() {
    final _$result =
        _$v ??
        _$CaptainDeliverySummaryDtoOutputSummaryPay._(
          base_: BuiltValueNullFieldError.checkNotNull(
            base_,
            r'CaptainDeliverySummaryDtoOutputSummaryPay',
            'base_',
          ),
          distance: BuiltValueNullFieldError.checkNotNull(
            distance,
            r'CaptainDeliverySummaryDtoOutputSummaryPay',
            'distance',
          ),
          topUp: BuiltValueNullFieldError.checkNotNull(
            topUp,
            r'CaptainDeliverySummaryDtoOutputSummaryPay',
            'topUp',
          ),
          waiting: BuiltValueNullFieldError.checkNotNull(
            waiting,
            r'CaptainDeliverySummaryDtoOutputSummaryPay',
            'waiting',
          ),
          peak: BuiltValueNullFieldError.checkNotNull(
            peak,
            r'CaptainDeliverySummaryDtoOutputSummaryPay',
            'peak',
          ),
          total: BuiltValueNullFieldError.checkNotNull(
            total,
            r'CaptainDeliverySummaryDtoOutputSummaryPay',
            'total',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CaptainDeliverySummaryDtoOutputSummaryPay',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
