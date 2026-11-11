// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_peak_bonus_dto_output_in_force_windows_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPeakBonusDtoOutputInForceWindowsInner
    extends AdminPeakBonusDtoOutputInForceWindowsInner {
  @override
  final BuiltList<int> days;
  @override
  final int startMinute;
  @override
  final int endMinute;
  @override
  final String amount;
  @override
  final BuiltList<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?> zones;

  factory _$AdminPeakBonusDtoOutputInForceWindowsInner([
    void Function(AdminPeakBonusDtoOutputInForceWindowsInnerBuilder)? updates,
  ]) => (AdminPeakBonusDtoOutputInForceWindowsInnerBuilder()..update(updates))
      ._build();

  _$AdminPeakBonusDtoOutputInForceWindowsInner._({
    required this.days,
    required this.startMinute,
    required this.endMinute,
    required this.amount,
    required this.zones,
  }) : super._();
  @override
  AdminPeakBonusDtoOutputInForceWindowsInner rebuild(
    void Function(AdminPeakBonusDtoOutputInForceWindowsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminPeakBonusDtoOutputInForceWindowsInnerBuilder toBuilder() =>
      AdminPeakBonusDtoOutputInForceWindowsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPeakBonusDtoOutputInForceWindowsInner &&
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
            r'AdminPeakBonusDtoOutputInForceWindowsInner',
          )
          ..add('days', days)
          ..add('startMinute', startMinute)
          ..add('endMinute', endMinute)
          ..add('amount', amount)
          ..add('zones', zones))
        .toString();
  }
}

class AdminPeakBonusDtoOutputInForceWindowsInnerBuilder
    implements
        Builder<
          AdminPeakBonusDtoOutputInForceWindowsInner,
          AdminPeakBonusDtoOutputInForceWindowsInnerBuilder
        > {
  _$AdminPeakBonusDtoOutputInForceWindowsInner? _$v;

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

  ListBuilder<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?>? _zones;
  ListBuilder<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?>
  get zones => _$this._zones ??=
      ListBuilder<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?>();
  set zones(
    ListBuilder<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?>? zones,
  ) => _$this._zones = zones;

  AdminPeakBonusDtoOutputInForceWindowsInnerBuilder() {
    AdminPeakBonusDtoOutputInForceWindowsInner._defaults(this);
  }

  AdminPeakBonusDtoOutputInForceWindowsInnerBuilder get _$this {
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
  void replace(AdminPeakBonusDtoOutputInForceWindowsInner other) {
    _$v = other as _$AdminPeakBonusDtoOutputInForceWindowsInner;
  }

  @override
  void update(
    void Function(AdminPeakBonusDtoOutputInForceWindowsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminPeakBonusDtoOutputInForceWindowsInner build() => _build();

  _$AdminPeakBonusDtoOutputInForceWindowsInner _build() {
    _$AdminPeakBonusDtoOutputInForceWindowsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminPeakBonusDtoOutputInForceWindowsInner._(
            days: days.build(),
            startMinute: BuiltValueNullFieldError.checkNotNull(
              startMinute,
              r'AdminPeakBonusDtoOutputInForceWindowsInner',
              'startMinute',
            ),
            endMinute: BuiltValueNullFieldError.checkNotNull(
              endMinute,
              r'AdminPeakBonusDtoOutputInForceWindowsInner',
              'endMinute',
            ),
            amount: BuiltValueNullFieldError.checkNotNull(
              amount,
              r'AdminPeakBonusDtoOutputInForceWindowsInner',
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
          r'AdminPeakBonusDtoOutputInForceWindowsInner',
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
