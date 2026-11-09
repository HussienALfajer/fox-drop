// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_hours_dto_output_periods_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantHoursDtoOutputPeriodsInner
    extends MerchantHoursDtoOutputPeriodsInner {
  @override
  final int weekday;
  @override
  final int opensAt;
  @override
  final int closesAt;

  factory _$MerchantHoursDtoOutputPeriodsInner([
    void Function(MerchantHoursDtoOutputPeriodsInnerBuilder)? updates,
  ]) => (MerchantHoursDtoOutputPeriodsInnerBuilder()..update(updates))._build();

  _$MerchantHoursDtoOutputPeriodsInner._({
    required this.weekday,
    required this.opensAt,
    required this.closesAt,
  }) : super._();
  @override
  MerchantHoursDtoOutputPeriodsInner rebuild(
    void Function(MerchantHoursDtoOutputPeriodsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantHoursDtoOutputPeriodsInnerBuilder toBuilder() =>
      MerchantHoursDtoOutputPeriodsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantHoursDtoOutputPeriodsInner &&
        weekday == other.weekday &&
        opensAt == other.opensAt &&
        closesAt == other.closesAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, weekday.hashCode);
    _$hash = $jc(_$hash, opensAt.hashCode);
    _$hash = $jc(_$hash, closesAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantHoursDtoOutputPeriodsInner')
          ..add('weekday', weekday)
          ..add('opensAt', opensAt)
          ..add('closesAt', closesAt))
        .toString();
  }
}

class MerchantHoursDtoOutputPeriodsInnerBuilder
    implements
        Builder<
          MerchantHoursDtoOutputPeriodsInner,
          MerchantHoursDtoOutputPeriodsInnerBuilder
        > {
  _$MerchantHoursDtoOutputPeriodsInner? _$v;

  int? _weekday;
  int? get weekday => _$this._weekday;
  set weekday(int? weekday) => _$this._weekday = weekday;

  int? _opensAt;
  int? get opensAt => _$this._opensAt;
  set opensAt(int? opensAt) => _$this._opensAt = opensAt;

  int? _closesAt;
  int? get closesAt => _$this._closesAt;
  set closesAt(int? closesAt) => _$this._closesAt = closesAt;

  MerchantHoursDtoOutputPeriodsInnerBuilder() {
    MerchantHoursDtoOutputPeriodsInner._defaults(this);
  }

  MerchantHoursDtoOutputPeriodsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _weekday = $v.weekday;
      _opensAt = $v.opensAt;
      _closesAt = $v.closesAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantHoursDtoOutputPeriodsInner other) {
    _$v = other as _$MerchantHoursDtoOutputPeriodsInner;
  }

  @override
  void update(
    void Function(MerchantHoursDtoOutputPeriodsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantHoursDtoOutputPeriodsInner build() => _build();

  _$MerchantHoursDtoOutputPeriodsInner _build() {
    final _$result =
        _$v ??
        _$MerchantHoursDtoOutputPeriodsInner._(
          weekday: BuiltValueNullFieldError.checkNotNull(
            weekday,
            r'MerchantHoursDtoOutputPeriodsInner',
            'weekday',
          ),
          opensAt: BuiltValueNullFieldError.checkNotNull(
            opensAt,
            r'MerchantHoursDtoOutputPeriodsInner',
            'opensAt',
          ),
          closesAt: BuiltValueNullFieldError.checkNotNull(
            closesAt,
            r'MerchantHoursDtoOutputPeriodsInner',
            'closesAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
