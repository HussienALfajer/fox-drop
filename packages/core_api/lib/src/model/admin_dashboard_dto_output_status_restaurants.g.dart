// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_dto_output_status_restaurants.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDashboardDtoOutputStatusRestaurants
    extends AdminDashboardDtoOutputStatusRestaurants {
  @override
  final int open;
  @override
  final int busy;
  @override
  final int paused;
  @override
  final int closed;
  @override
  final int holiday;
  @override
  final int suspended;

  factory _$AdminDashboardDtoOutputStatusRestaurants([
    void Function(AdminDashboardDtoOutputStatusRestaurantsBuilder)? updates,
  ]) => (AdminDashboardDtoOutputStatusRestaurantsBuilder()..update(updates))
      ._build();

  _$AdminDashboardDtoOutputStatusRestaurants._({
    required this.open,
    required this.busy,
    required this.paused,
    required this.closed,
    required this.holiday,
    required this.suspended,
  }) : super._();
  @override
  AdminDashboardDtoOutputStatusRestaurants rebuild(
    void Function(AdminDashboardDtoOutputStatusRestaurantsBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDashboardDtoOutputStatusRestaurantsBuilder toBuilder() =>
      AdminDashboardDtoOutputStatusRestaurantsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardDtoOutputStatusRestaurants &&
        open == other.open &&
        busy == other.busy &&
        paused == other.paused &&
        closed == other.closed &&
        holiday == other.holiday &&
        suspended == other.suspended;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, open.hashCode);
    _$hash = $jc(_$hash, busy.hashCode);
    _$hash = $jc(_$hash, paused.hashCode);
    _$hash = $jc(_$hash, closed.hashCode);
    _$hash = $jc(_$hash, holiday.hashCode);
    _$hash = $jc(_$hash, suspended.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminDashboardDtoOutputStatusRestaurants',
          )
          ..add('open', open)
          ..add('busy', busy)
          ..add('paused', paused)
          ..add('closed', closed)
          ..add('holiday', holiday)
          ..add('suspended', suspended))
        .toString();
  }
}

class AdminDashboardDtoOutputStatusRestaurantsBuilder
    implements
        Builder<
          AdminDashboardDtoOutputStatusRestaurants,
          AdminDashboardDtoOutputStatusRestaurantsBuilder
        > {
  _$AdminDashboardDtoOutputStatusRestaurants? _$v;

  int? _open;
  int? get open => _$this._open;
  set open(int? open) => _$this._open = open;

  int? _busy;
  int? get busy => _$this._busy;
  set busy(int? busy) => _$this._busy = busy;

  int? _paused;
  int? get paused => _$this._paused;
  set paused(int? paused) => _$this._paused = paused;

  int? _closed;
  int? get closed => _$this._closed;
  set closed(int? closed) => _$this._closed = closed;

  int? _holiday;
  int? get holiday => _$this._holiday;
  set holiday(int? holiday) => _$this._holiday = holiday;

  int? _suspended;
  int? get suspended => _$this._suspended;
  set suspended(int? suspended) => _$this._suspended = suspended;

  AdminDashboardDtoOutputStatusRestaurantsBuilder() {
    AdminDashboardDtoOutputStatusRestaurants._defaults(this);
  }

  AdminDashboardDtoOutputStatusRestaurantsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _open = $v.open;
      _busy = $v.busy;
      _paused = $v.paused;
      _closed = $v.closed;
      _holiday = $v.holiday;
      _suspended = $v.suspended;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardDtoOutputStatusRestaurants other) {
    _$v = other as _$AdminDashboardDtoOutputStatusRestaurants;
  }

  @override
  void update(
    void Function(AdminDashboardDtoOutputStatusRestaurantsBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardDtoOutputStatusRestaurants build() => _build();

  _$AdminDashboardDtoOutputStatusRestaurants _build() {
    final _$result =
        _$v ??
        _$AdminDashboardDtoOutputStatusRestaurants._(
          open: BuiltValueNullFieldError.checkNotNull(
            open,
            r'AdminDashboardDtoOutputStatusRestaurants',
            'open',
          ),
          busy: BuiltValueNullFieldError.checkNotNull(
            busy,
            r'AdminDashboardDtoOutputStatusRestaurants',
            'busy',
          ),
          paused: BuiltValueNullFieldError.checkNotNull(
            paused,
            r'AdminDashboardDtoOutputStatusRestaurants',
            'paused',
          ),
          closed: BuiltValueNullFieldError.checkNotNull(
            closed,
            r'AdminDashboardDtoOutputStatusRestaurants',
            'closed',
          ),
          holiday: BuiltValueNullFieldError.checkNotNull(
            holiday,
            r'AdminDashboardDtoOutputStatusRestaurants',
            'holiday',
          ),
          suspended: BuiltValueNullFieldError.checkNotNull(
            suspended,
            r'AdminDashboardDtoOutputStatusRestaurants',
            'suspended',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
