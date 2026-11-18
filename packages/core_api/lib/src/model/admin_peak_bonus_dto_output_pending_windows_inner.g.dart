// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_peak_bonus_dto_output_pending_windows_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPeakBonusDtoOutputPendingWindowsInner
    extends AdminPeakBonusDtoOutputPendingWindowsInner {
  @override
  final BuiltList<int> days;
  @override
  final int startMinute;
  @override
  final int endMinute;
  @override
  final String amount;
  @override
  final BuiltList<CaptainPeakBonusDtoOutputWindowsInnerZonesInner> zones;

  factory _$AdminPeakBonusDtoOutputPendingWindowsInner([
    void Function(AdminPeakBonusDtoOutputPendingWindowsInnerBuilder)? updates,
  ]) => (AdminPeakBonusDtoOutputPendingWindowsInnerBuilder()..update(updates))
      ._build();

  _$AdminPeakBonusDtoOutputPendingWindowsInner._({
    required this.days,
    required this.startMinute,
    required this.endMinute,
    required this.amount,
    required this.zones,
  }) : super._();
  @override
  AdminPeakBonusDtoOutputPendingWindowsInner rebuild(
    void Function(AdminPeakBonusDtoOutputPendingWindowsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminPeakBonusDtoOutputPendingWindowsInnerBuilder toBuilder() =>
      AdminPeakBonusDtoOutputPendingWindowsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPeakBonusDtoOutputPendingWindowsInner &&
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
            r'AdminPeakBonusDtoOutputPendingWindowsInner',
          )
          ..add('days', days)
          ..add('startMinute', startMinute)
          ..add('endMinute', endMinute)
          ..add('amount', amount)
          ..add('zones', zones))
        .toString();
  }
}

class AdminPeakBonusDtoOutputPendingWindowsInnerBuilder
    implements
        Builder<
          AdminPeakBonusDtoOutputPendingWindowsInner,
          AdminPeakBonusDtoOutputPendingWindowsInnerBuilder
        > {
  _$AdminPeakBonusDtoOutputPendingWindowsInner? _$v;

  ListBuilder<int>? _days;
  ListBuilder<int> get days => _$this._days ??= ListBuilder<int>();
  set days(ListBuilder<int>? days) => _$this._days = days;

  int? _startMinute;
  int? get startMinute => _$this._startMinute;
  set startMinute(int? startMinute) => _$this._startMinute = startMinute;

  int? _endMinute;
  int? get endMinute => _$this._endMinute;
  set endMinute(int? endMinute) => _$this._endMinute = endMinute;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner>? _zones;
  ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner> get zones =>
      _$this._zones ??=
          ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner>();
  set zones(
    ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner>? zones,
  ) => _$this._zones = zones;

  AdminPeakBonusDtoOutputPendingWindowsInnerBuilder() {
    AdminPeakBonusDtoOutputPendingWindowsInner._defaults(this);
  }

  AdminPeakBonusDtoOutputPendingWindowsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _days = $v.days.toBuilder();
      _startMinute = $v.startMinute;
      _endMinute = $v.endMinute;
      _amount = $v.amount;
      _zones = $v.zones.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPeakBonusDtoOutputPendingWindowsInner other) {
    _$v = other as _$AdminPeakBonusDtoOutputPendingWindowsInner;
  }

  @override
  void update(
    void Function(AdminPeakBonusDtoOutputPendingWindowsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminPeakBonusDtoOutputPendingWindowsInner build() => _build();

  _$AdminPeakBonusDtoOutputPendingWindowsInner _build() {
    _$AdminPeakBonusDtoOutputPendingWindowsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminPeakBonusDtoOutputPendingWindowsInner._(
            days: days.build(),
            startMinute: BuiltValueNullFieldError.checkNotNull(
              startMinute,
              r'AdminPeakBonusDtoOutputPendingWindowsInner',
              'startMinute',
            ),
            endMinute: BuiltValueNullFieldError.checkNotNull(
              endMinute,
              r'AdminPeakBonusDtoOutputPendingWindowsInner',
              'endMinute',
            ),
            amount: BuiltValueNullFieldError.checkNotNull(
              amount,
              r'AdminPeakBonusDtoOutputPendingWindowsInner',
              'amount',
            ),
            zones: zones.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'days';
        days.build();

        _$failedField = 'zones';
        zones.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminPeakBonusDtoOutputPendingWindowsInner',
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
