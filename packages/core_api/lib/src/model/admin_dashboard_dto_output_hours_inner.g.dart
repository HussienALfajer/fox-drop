// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_dto_output_hours_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDashboardDtoOutputHoursInner
    extends AdminDashboardDtoOutputHoursInner {
  @override
  final String hour;
  @override
  final int today;
  @override
  final int lastWeek;

  factory _$AdminDashboardDtoOutputHoursInner([
    void Function(AdminDashboardDtoOutputHoursInnerBuilder)? updates,
  ]) => (AdminDashboardDtoOutputHoursInnerBuilder()..update(updates))._build();

  _$AdminDashboardDtoOutputHoursInner._({
    required this.hour,
    required this.today,
    required this.lastWeek,
  }) : super._();
  @override
  AdminDashboardDtoOutputHoursInner rebuild(
    void Function(AdminDashboardDtoOutputHoursInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDashboardDtoOutputHoursInnerBuilder toBuilder() =>
      AdminDashboardDtoOutputHoursInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardDtoOutputHoursInner &&
        hour == other.hour &&
        today == other.today &&
        lastWeek == other.lastWeek;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, hour.hashCode);
    _$hash = $jc(_$hash, today.hashCode);
    _$hash = $jc(_$hash, lastWeek.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDashboardDtoOutputHoursInner')
          ..add('hour', hour)
          ..add('today', today)
          ..add('lastWeek', lastWeek))
        .toString();
  }
}

class AdminDashboardDtoOutputHoursInnerBuilder
    implements
        Builder<
          AdminDashboardDtoOutputHoursInner,
          AdminDashboardDtoOutputHoursInnerBuilder
        > {
  _$AdminDashboardDtoOutputHoursInner? _$v;

  String? _hour;
  String? get hour => _$this._hour;
  set hour(String? hour) => _$this._hour = hour;

  int? _today;
  int? get today => _$this._today;
  set today(int? today) => _$this._today = today;

  int? _lastWeek;
  int? get lastWeek => _$this._lastWeek;
  set lastWeek(int? lastWeek) => _$this._lastWeek = lastWeek;

  AdminDashboardDtoOutputHoursInnerBuilder() {
    AdminDashboardDtoOutputHoursInner._defaults(this);
  }

  AdminDashboardDtoOutputHoursInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _hour = $v.hour;
      _today = $v.today;
      _lastWeek = $v.lastWeek;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardDtoOutputHoursInner other) {
    _$v = other as _$AdminDashboardDtoOutputHoursInner;
  }

  @override
  void update(
    void Function(AdminDashboardDtoOutputHoursInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardDtoOutputHoursInner build() => _build();

  _$AdminDashboardDtoOutputHoursInner _build() {
    final _$result =
        _$v ??
        _$AdminDashboardDtoOutputHoursInner._(
          hour: BuiltValueNullFieldError.checkNotNull(
            hour,
            r'AdminDashboardDtoOutputHoursInner',
            'hour',
          ),
          today: BuiltValueNullFieldError.checkNotNull(
            today,
            r'AdminDashboardDtoOutputHoursInner',
            'today',
          ),
          lastWeek: BuiltValueNullFieldError.checkNotNull(
            lastWeek,
            r'AdminDashboardDtoOutputHoursInner',
            'lastWeek',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
