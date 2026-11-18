// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_peak_bonus_dto_output_windows_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainPeakBonusDtoOutputWindowsInner
    extends CaptainPeakBonusDtoOutputWindowsInner {
  @override
  final BuiltList<int> days;
  @override
  final int startMinute;
  @override
  final int endMinute;
  @override
  final CaptainPeakBonusDtoOutputWindowsInnerAmount amount;
  @override
  final BuiltList<CaptainPeakBonusDtoOutputWindowsInnerZonesInner> zones;

  factory _$CaptainPeakBonusDtoOutputWindowsInner([
    void Function(CaptainPeakBonusDtoOutputWindowsInnerBuilder)? updates,
  ]) => (CaptainPeakBonusDtoOutputWindowsInnerBuilder()..update(updates))
      ._build();

  _$CaptainPeakBonusDtoOutputWindowsInner._({
    required this.days,
    required this.startMinute,
    required this.endMinute,
    required this.amount,
    required this.zones,
  }) : super._();
  @override
  CaptainPeakBonusDtoOutputWindowsInner rebuild(
    void Function(CaptainPeakBonusDtoOutputWindowsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainPeakBonusDtoOutputWindowsInnerBuilder toBuilder() =>
      CaptainPeakBonusDtoOutputWindowsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainPeakBonusDtoOutputWindowsInner &&
        days == other.days &&
        startMinute == other.startMinute &&
        endMinute == other.endMinute &&
        amount == other.amount &&
        zones == other.zones;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, days.hashCode);
    _$hash = $jc(_$hash, startMinute.hashCode);
    _$hash = $jc(_$hash, endMinute.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, zones.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainPeakBonusDtoOutputWindowsInner',
          )
          ..add('days', days)
          ..add('startMinute', startMinute)
          ..add('endMinute', endMinute)
          ..add('amount', amount)
          ..add('zones', zones))
        .toString();
  }
}

class CaptainPeakBonusDtoOutputWindowsInnerBuilder
    implements
        Builder<
          CaptainPeakBonusDtoOutputWindowsInner,
          CaptainPeakBonusDtoOutputWindowsInnerBuilder
        > {
  _$CaptainPeakBonusDtoOutputWindowsInner? _$v;

  ListBuilder<int>? _days;
  ListBuilder<int> get days => _$this._days ??= ListBuilder<int>();
  set days(ListBuilder<int>? days) => _$this._days = days;

  int? _startMinute;
  int? get startMinute => _$this._startMinute;
  set startMinute(int? startMinute) => _$this._startMinute = startMinute;

  int? _endMinute;
  int? get endMinute => _$this._endMinute;
  set endMinute(int? endMinute) => _$this._endMinute = endMinute;

  CaptainPeakBonusDtoOutputWindowsInnerAmountBuilder? _amount;
  CaptainPeakBonusDtoOutputWindowsInnerAmountBuilder get amount =>
      _$this._amount ??= CaptainPeakBonusDtoOutputWindowsInnerAmountBuilder();
  set amount(CaptainPeakBonusDtoOutputWindowsInnerAmountBuilder? amount) =>
      _$this._amount = amount;

  ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner>? _zones;
  ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner> get zones =>
      _$this._zones ??=
          ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner>();
  set zones(
    ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner>? zones,
  ) => _$this._zones = zones;

  CaptainPeakBonusDtoOutputWindowsInnerBuilder() {
    CaptainPeakBonusDtoOutputWindowsInner._defaults(this);
  }

  CaptainPeakBonusDtoOutputWindowsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _days = $v.days.toBuilder();
      _startMinute = $v.startMinute;
      _endMinute = $v.endMinute;
      _amount = $v.amount.toBuilder();
      _zones = $v.zones.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainPeakBonusDtoOutputWindowsInner other) {
    _$v = other as _$CaptainPeakBonusDtoOutputWindowsInner;
  }

  @override
  void update(
    void Function(CaptainPeakBonusDtoOutputWindowsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainPeakBonusDtoOutputWindowsInner build() => _build();

  _$CaptainPeakBonusDtoOutputWindowsInner _build() {
    _$CaptainPeakBonusDtoOutputWindowsInner _$result;
    try {
      _$result =
          _$v ??
          _$CaptainPeakBonusDtoOutputWindowsInner._(
            days: days.build(),
            startMinute: BuiltValueNullFieldError.checkNotNull(
              startMinute,
              r'CaptainPeakBonusDtoOutputWindowsInner',
              'startMinute',
            ),
            endMinute: BuiltValueNullFieldError.checkNotNull(
              endMinute,
              r'CaptainPeakBonusDtoOutputWindowsInner',
              'endMinute',
            ),
            amount: amount.build(),
            zones: zones.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'days';
        days.build();

        _$failedField = 'amount';
        amount.build();
        _$failedField = 'zones';
        zones.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainPeakBonusDtoOutputWindowsInner',
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
