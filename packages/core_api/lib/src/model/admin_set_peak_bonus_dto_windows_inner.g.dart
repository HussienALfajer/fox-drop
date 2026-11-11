// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_set_peak_bonus_dto_windows_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSetPeakBonusDtoWindowsInner
    extends AdminSetPeakBonusDtoWindowsInner {
  @override
  final BuiltList<int> days;
  @override
  final int startMinute;
  @override
  final int endMinute;
  @override
  final String amount;
  @override
  final BuiltList<String> zoneIds;

  factory _$AdminSetPeakBonusDtoWindowsInner([
    void Function(AdminSetPeakBonusDtoWindowsInnerBuilder)? updates,
  ]) => (AdminSetPeakBonusDtoWindowsInnerBuilder()..update(updates))._build();

  _$AdminSetPeakBonusDtoWindowsInner._({
    required this.days,
    required this.startMinute,
    required this.endMinute,
    required this.amount,
    required this.zoneIds,
  }) : super._();
  @override
  AdminSetPeakBonusDtoWindowsInner rebuild(
    void Function(AdminSetPeakBonusDtoWindowsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSetPeakBonusDtoWindowsInnerBuilder toBuilder() =>
      AdminSetPeakBonusDtoWindowsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSetPeakBonusDtoWindowsInner &&
        days == other.days &&
        startMinute == other.startMinute &&
        endMinute == other.endMinute &&
        amount == other.amount &&
        zoneIds == other.zoneIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, days.hashCode);
    _$hash = $jc(_$hash, startMinute.hashCode);
    _$hash = $jc(_$hash, endMinute.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, zoneIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSetPeakBonusDtoWindowsInner')
          ..add('days', days)
          ..add('startMinute', startMinute)
          ..add('endMinute', endMinute)
          ..add('amount', amount)
          ..add('zoneIds', zoneIds))
        .toString();
  }
}

class AdminSetPeakBonusDtoWindowsInnerBuilder
    implements
        Builder<
          AdminSetPeakBonusDtoWindowsInner,
          AdminSetPeakBonusDtoWindowsInnerBuilder
        > {
  _$AdminSetPeakBonusDtoWindowsInner? _$v;

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

  ListBuilder<String>? _zoneIds;
  ListBuilder<String> get zoneIds => _$this._zoneIds ??= ListBuilder<String>();
  set zoneIds(ListBuilder<String>? zoneIds) => _$this._zoneIds = zoneIds;

  AdminSetPeakBonusDtoWindowsInnerBuilder() {
    AdminSetPeakBonusDtoWindowsInner._defaults(this);
  }

  AdminSetPeakBonusDtoWindowsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _days = $v.days.toBuilder();
      _startMinute = $v.startMinute;
      _endMinute = $v.endMinute;
      _amount = $v.amount;
      _zoneIds = $v.zoneIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSetPeakBonusDtoWindowsInner other) {
    _$v = other as _$AdminSetPeakBonusDtoWindowsInner;
  }

  @override
  void update(void Function(AdminSetPeakBonusDtoWindowsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSetPeakBonusDtoWindowsInner build() => _build();

  _$AdminSetPeakBonusDtoWindowsInner _build() {
    _$AdminSetPeakBonusDtoWindowsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminSetPeakBonusDtoWindowsInner._(
            days: days.build(),
            startMinute: BuiltValueNullFieldError.checkNotNull(
              startMinute,
              r'AdminSetPeakBonusDtoWindowsInner',
              'startMinute',
            ),
            endMinute: BuiltValueNullFieldError.checkNotNull(
              endMinute,
              r'AdminSetPeakBonusDtoWindowsInner',
              'endMinute',
            ),
            amount: BuiltValueNullFieldError.checkNotNull(
              amount,
              r'AdminSetPeakBonusDtoWindowsInner',
              'amount',
            ),
            zoneIds: zoneIds.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'days';
        days.build();

        _$failedField = 'zoneIds';
        zoneIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminSetPeakBonusDtoWindowsInner',
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
