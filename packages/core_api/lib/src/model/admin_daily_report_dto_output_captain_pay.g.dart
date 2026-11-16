// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_daily_report_dto_output_captain_pay.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDailyReportDtoOutputCaptainPay
    extends AdminDailyReportDtoOutputCaptainPay {
  @override
  final String base_;
  @override
  final String distance;
  @override
  final String waiting;
  @override
  final String peak;
  @override
  final String bonuses;
  @override
  final String total;

  factory _$AdminDailyReportDtoOutputCaptainPay([
    void Function(AdminDailyReportDtoOutputCaptainPayBuilder)? updates,
  ]) =>
      (AdminDailyReportDtoOutputCaptainPayBuilder()..update(updates))._build();

  _$AdminDailyReportDtoOutputCaptainPay._({
    required this.base_,
    required this.distance,
    required this.waiting,
    required this.peak,
    required this.bonuses,
    required this.total,
  }) : super._();
  @override
  AdminDailyReportDtoOutputCaptainPay rebuild(
    void Function(AdminDailyReportDtoOutputCaptainPayBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDailyReportDtoOutputCaptainPayBuilder toBuilder() =>
      AdminDailyReportDtoOutputCaptainPayBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDailyReportDtoOutputCaptainPay &&
        base_ == other.base_ &&
        distance == other.distance &&
        waiting == other.waiting &&
        peak == other.peak &&
        bonuses == other.bonuses &&
        total == other.total;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, base_.hashCode);
    _$hash = $jc(_$hash, distance.hashCode);
    _$hash = $jc(_$hash, waiting.hashCode);
    _$hash = $jc(_$hash, peak.hashCode);
    _$hash = $jc(_$hash, bonuses.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDailyReportDtoOutputCaptainPay')
          ..add('base_', base_)
          ..add('distance', distance)
          ..add('waiting', waiting)
          ..add('peak', peak)
          ..add('bonuses', bonuses)
          ..add('total', total))
        .toString();
  }
}

class AdminDailyReportDtoOutputCaptainPayBuilder
    implements
        Builder<
          AdminDailyReportDtoOutputCaptainPay,
          AdminDailyReportDtoOutputCaptainPayBuilder
        > {
  _$AdminDailyReportDtoOutputCaptainPay? _$v;

  String? _base_;
  String? get base_ => _$this._base_;
  set base_(String? base_) => _$this._base_ = base_;

  String? _distance;
  String? get distance => _$this._distance;
  set distance(String? distance) => _$this._distance = distance;

  String? _waiting;
  String? get waiting => _$this._waiting;
  set waiting(String? waiting) => _$this._waiting = waiting;

  String? _peak;
  String? get peak => _$this._peak;
  set peak(String? peak) => _$this._peak = peak;

  String? _bonuses;
  String? get bonuses => _$this._bonuses;
  set bonuses(String? bonuses) => _$this._bonuses = bonuses;

  String? _total;
  String? get total => _$this._total;
  set total(String? total) => _$this._total = total;

  AdminDailyReportDtoOutputCaptainPayBuilder() {
    AdminDailyReportDtoOutputCaptainPay._defaults(this);
  }

  AdminDailyReportDtoOutputCaptainPayBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _base_ = $v.base_;
      _distance = $v.distance;
      _waiting = $v.waiting;
      _peak = $v.peak;
      _bonuses = $v.bonuses;
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDailyReportDtoOutputCaptainPay other) {
    _$v = other as _$AdminDailyReportDtoOutputCaptainPay;
  }

  @override
  void update(
    void Function(AdminDailyReportDtoOutputCaptainPayBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDailyReportDtoOutputCaptainPay build() => _build();

  _$AdminDailyReportDtoOutputCaptainPay _build() {
    final _$result =
        _$v ??
        _$AdminDailyReportDtoOutputCaptainPay._(
          base_: BuiltValueNullFieldError.checkNotNull(
            base_,
            r'AdminDailyReportDtoOutputCaptainPay',
            'base_',
          ),
          distance: BuiltValueNullFieldError.checkNotNull(
            distance,
            r'AdminDailyReportDtoOutputCaptainPay',
            'distance',
          ),
          waiting: BuiltValueNullFieldError.checkNotNull(
            waiting,
            r'AdminDailyReportDtoOutputCaptainPay',
            'waiting',
          ),
          peak: BuiltValueNullFieldError.checkNotNull(
            peak,
            r'AdminDailyReportDtoOutputCaptainPay',
            'peak',
          ),
          bonuses: BuiltValueNullFieldError.checkNotNull(
            bonuses,
            r'AdminDailyReportDtoOutputCaptainPay',
            'bonuses',
          ),
          total: BuiltValueNullFieldError.checkNotNull(
            total,
            r'AdminDailyReportDtoOutputCaptainPay',
            'total',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
