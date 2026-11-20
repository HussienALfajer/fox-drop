// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDashboardDtoOutput extends AdminDashboardDtoOutput {
  @override
  final String cityId;
  @override
  final String day;
  @override
  final String lastWeekDay;
  @override
  final AdminDashboardDtoOutputStatus status;
  @override
  final AdminDashboardDtoOutputToday today;
  @override
  final AdminDashboardDtoOutputToday lastWeek;
  @override
  final BuiltList<AdminDashboardDtoOutputTasksInner> tasks;
  @override
  final BuiltList<AdminDashboardDtoOutputHoursInner> hours;
  @override
  final BuiltList<AdminDashboardDtoOutputTopRestaurantsInner> topRestaurants;
  @override
  final BuiltList<AdminDashboardDtoOutputTroubledRestaurantsInner>
  troubledRestaurants;

  factory _$AdminDashboardDtoOutput([
    void Function(AdminDashboardDtoOutputBuilder)? updates,
  ]) => (AdminDashboardDtoOutputBuilder()..update(updates))._build();

  _$AdminDashboardDtoOutput._({
    required this.cityId,
    required this.day,
    required this.lastWeekDay,
    required this.status,
    required this.today,
    required this.lastWeek,
    required this.tasks,
    required this.hours,
    required this.topRestaurants,
    required this.troubledRestaurants,
  }) : super._();
  @override
  AdminDashboardDtoOutput rebuild(
    void Function(AdminDashboardDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDashboardDtoOutputBuilder toBuilder() =>
      AdminDashboardDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardDtoOutput &&
        cityId == other.cityId &&
        day == other.day &&
        lastWeekDay == other.lastWeekDay &&
        status == other.status &&
        today == other.today &&
        lastWeek == other.lastWeek &&
        tasks == other.tasks &&
        hours == other.hours &&
        topRestaurants == other.topRestaurants &&
        troubledRestaurants == other.troubledRestaurants;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, day.hashCode);
    _$hash = $jc(_$hash, lastWeekDay.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, today.hashCode);
    _$hash = $jc(_$hash, lastWeek.hashCode);
    _$hash = $jc(_$hash, tasks.hashCode);
    _$hash = $jc(_$hash, hours.hashCode);
    _$hash = $jc(_$hash, topRestaurants.hashCode);
    _$hash = $jc(_$hash, troubledRestaurants.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDashboardDtoOutput')
          ..add('cityId', cityId)
          ..add('day', day)
          ..add('lastWeekDay', lastWeekDay)
          ..add('status', status)
          ..add('today', today)
          ..add('lastWeek', lastWeek)
          ..add('tasks', tasks)
          ..add('hours', hours)
          ..add('topRestaurants', topRestaurants)
          ..add('troubledRestaurants', troubledRestaurants))
        .toString();
  }
}

class AdminDashboardDtoOutputBuilder
    implements
        Builder<AdminDashboardDtoOutput, AdminDashboardDtoOutputBuilder> {
  _$AdminDashboardDtoOutput? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _day;
  String? get day => _$this._day;
  set day(String? day) => _$this._day = day;

  String? _lastWeekDay;
  String? get lastWeekDay => _$this._lastWeekDay;
  set lastWeekDay(String? lastWeekDay) => _$this._lastWeekDay = lastWeekDay;

  AdminDashboardDtoOutputStatusBuilder? _status;
  AdminDashboardDtoOutputStatusBuilder get status =>
      _$this._status ??= AdminDashboardDtoOutputStatusBuilder();
  set status(AdminDashboardDtoOutputStatusBuilder? status) =>
      _$this._status = status;

  AdminDashboardDtoOutputTodayBuilder? _today;
  AdminDashboardDtoOutputTodayBuilder get today =>
      _$this._today ??= AdminDashboardDtoOutputTodayBuilder();
  set today(AdminDashboardDtoOutputTodayBuilder? today) =>
      _$this._today = today;

  AdminDashboardDtoOutputTodayBuilder? _lastWeek;
  AdminDashboardDtoOutputTodayBuilder get lastWeek =>
      _$this._lastWeek ??= AdminDashboardDtoOutputTodayBuilder();
  set lastWeek(AdminDashboardDtoOutputTodayBuilder? lastWeek) =>
      _$this._lastWeek = lastWeek;

  ListBuilder<AdminDashboardDtoOutputTasksInner>? _tasks;
  ListBuilder<AdminDashboardDtoOutputTasksInner> get tasks =>
      _$this._tasks ??= ListBuilder<AdminDashboardDtoOutputTasksInner>();
  set tasks(ListBuilder<AdminDashboardDtoOutputTasksInner>? tasks) =>
      _$this._tasks = tasks;

  ListBuilder<AdminDashboardDtoOutputHoursInner>? _hours;
  ListBuilder<AdminDashboardDtoOutputHoursInner> get hours =>
      _$this._hours ??= ListBuilder<AdminDashboardDtoOutputHoursInner>();
  set hours(ListBuilder<AdminDashboardDtoOutputHoursInner>? hours) =>
      _$this._hours = hours;

  ListBuilder<AdminDashboardDtoOutputTopRestaurantsInner>? _topRestaurants;
  ListBuilder<AdminDashboardDtoOutputTopRestaurantsInner> get topRestaurants =>
      _$this._topRestaurants ??=
          ListBuilder<AdminDashboardDtoOutputTopRestaurantsInner>();
  set topRestaurants(
    ListBuilder<AdminDashboardDtoOutputTopRestaurantsInner>? topRestaurants,
  ) => _$this._topRestaurants = topRestaurants;

  ListBuilder<AdminDashboardDtoOutputTroubledRestaurantsInner>?
  _troubledRestaurants;
  ListBuilder<AdminDashboardDtoOutputTroubledRestaurantsInner>
  get troubledRestaurants => _$this._troubledRestaurants ??=
      ListBuilder<AdminDashboardDtoOutputTroubledRestaurantsInner>();
  set troubledRestaurants(
    ListBuilder<AdminDashboardDtoOutputTroubledRestaurantsInner>?
    troubledRestaurants,
  ) => _$this._troubledRestaurants = troubledRestaurants;

  AdminDashboardDtoOutputBuilder() {
    AdminDashboardDtoOutput._defaults(this);
  }

  AdminDashboardDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _day = $v.day;
      _lastWeekDay = $v.lastWeekDay;
      _status = $v.status.toBuilder();
      _today = $v.today.toBuilder();
      _lastWeek = $v.lastWeek.toBuilder();
      _tasks = $v.tasks.toBuilder();
      _hours = $v.hours.toBuilder();
      _topRestaurants = $v.topRestaurants.toBuilder();
      _troubledRestaurants = $v.troubledRestaurants.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardDtoOutput other) {
    _$v = other as _$AdminDashboardDtoOutput;
  }

  @override
  void update(void Function(AdminDashboardDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardDtoOutput build() => _build();

  _$AdminDashboardDtoOutput _build() {
    _$AdminDashboardDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminDashboardDtoOutput._(
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminDashboardDtoOutput',
              'cityId',
            ),
            day: BuiltValueNullFieldError.checkNotNull(
              day,
              r'AdminDashboardDtoOutput',
              'day',
            ),
            lastWeekDay: BuiltValueNullFieldError.checkNotNull(
              lastWeekDay,
              r'AdminDashboardDtoOutput',
              'lastWeekDay',
            ),
            status: status.build(),
            today: today.build(),
            lastWeek: lastWeek.build(),
            tasks: tasks.build(),
            hours: hours.build(),
            topRestaurants: topRestaurants.build(),
            troubledRestaurants: troubledRestaurants.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'status';
        status.build();
        _$failedField = 'today';
        today.build();
        _$failedField = 'lastWeek';
        lastWeek.build();
        _$failedField = 'tasks';
        tasks.build();
        _$failedField = 'hours';
        hours.build();
        _$failedField = 'topRestaurants';
        topRestaurants.build();
        _$failedField = 'troubledRestaurants';
        troubledRestaurants.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminDashboardDtoOutput',
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
