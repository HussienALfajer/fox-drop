// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_dto_output_status_captains.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDashboardDtoOutputStatusCaptains
    extends AdminDashboardDtoOutputStatusCaptains {
  @override
  final int online;
  @override
  final int available;
  @override
  final int busy;
  @override
  final int cashBlocked;

  factory _$AdminDashboardDtoOutputStatusCaptains([
    void Function(AdminDashboardDtoOutputStatusCaptainsBuilder)? updates,
  ]) => (AdminDashboardDtoOutputStatusCaptainsBuilder()..update(updates))
      ._build();

  _$AdminDashboardDtoOutputStatusCaptains._({
    required this.online,
    required this.available,
    required this.busy,
    required this.cashBlocked,
  }) : super._();
  @override
  AdminDashboardDtoOutputStatusCaptains rebuild(
    void Function(AdminDashboardDtoOutputStatusCaptainsBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDashboardDtoOutputStatusCaptainsBuilder toBuilder() =>
      AdminDashboardDtoOutputStatusCaptainsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardDtoOutputStatusCaptains &&
        online == other.online &&
        available == other.available &&
        busy == other.busy &&
        cashBlocked == other.cashBlocked;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, online.hashCode);
    _$hash = $jc(_$hash, available.hashCode);
    _$hash = $jc(_$hash, busy.hashCode);
    _$hash = $jc(_$hash, cashBlocked.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminDashboardDtoOutputStatusCaptains',
          )
          ..add('online', online)
          ..add('available', available)
          ..add('busy', busy)
          ..add('cashBlocked', cashBlocked))
        .toString();
  }
}

class AdminDashboardDtoOutputStatusCaptainsBuilder
    implements
        Builder<
          AdminDashboardDtoOutputStatusCaptains,
          AdminDashboardDtoOutputStatusCaptainsBuilder
        > {
  _$AdminDashboardDtoOutputStatusCaptains? _$v;

  int? _online;
  int? get online => _$this._online;
  set online(int? online) => _$this._online = online;

  int? _available;
  int? get available => _$this._available;
  set available(int? available) => _$this._available = available;

  int? _busy;
  int? get busy => _$this._busy;
  set busy(int? busy) => _$this._busy = busy;

  int? _cashBlocked;
  int? get cashBlocked => _$this._cashBlocked;
  set cashBlocked(int? cashBlocked) => _$this._cashBlocked = cashBlocked;

  AdminDashboardDtoOutputStatusCaptainsBuilder() {
    AdminDashboardDtoOutputStatusCaptains._defaults(this);
  }

  AdminDashboardDtoOutputStatusCaptainsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _online = $v.online;
      _available = $v.available;
      _busy = $v.busy;
      _cashBlocked = $v.cashBlocked;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardDtoOutputStatusCaptains other) {
    _$v = other as _$AdminDashboardDtoOutputStatusCaptains;
  }

  @override
  void update(
    void Function(AdminDashboardDtoOutputStatusCaptainsBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardDtoOutputStatusCaptains build() => _build();

  _$AdminDashboardDtoOutputStatusCaptains _build() {
    final _$result =
        _$v ??
        _$AdminDashboardDtoOutputStatusCaptains._(
          online: BuiltValueNullFieldError.checkNotNull(
            online,
            r'AdminDashboardDtoOutputStatusCaptains',
            'online',
          ),
          available: BuiltValueNullFieldError.checkNotNull(
            available,
            r'AdminDashboardDtoOutputStatusCaptains',
            'available',
          ),
          busy: BuiltValueNullFieldError.checkNotNull(
            busy,
            r'AdminDashboardDtoOutputStatusCaptains',
            'busy',
          ),
          cashBlocked: BuiltValueNullFieldError.checkNotNull(
            cashBlocked,
            r'AdminDashboardDtoOutputStatusCaptains',
            'cashBlocked',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
