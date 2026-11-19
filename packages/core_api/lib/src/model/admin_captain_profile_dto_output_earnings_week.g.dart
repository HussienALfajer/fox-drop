// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_profile_dto_output_earnings_week.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainProfileDtoOutputEarningsWeek
    extends AdminCaptainProfileDtoOutputEarningsWeek {
  @override
  final DateTime from;
  @override
  final String earnings;
  @override
  final int orders;
  @override
  final int onlineMinutes;

  factory _$AdminCaptainProfileDtoOutputEarningsWeek([
    void Function(AdminCaptainProfileDtoOutputEarningsWeekBuilder)? updates,
  ]) => (AdminCaptainProfileDtoOutputEarningsWeekBuilder()..update(updates))
      ._build();

  _$AdminCaptainProfileDtoOutputEarningsWeek._({
    required this.from,
    required this.earnings,
    required this.orders,
    required this.onlineMinutes,
  }) : super._();
  @override
  AdminCaptainProfileDtoOutputEarningsWeek rebuild(
    void Function(AdminCaptainProfileDtoOutputEarningsWeekBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainProfileDtoOutputEarningsWeekBuilder toBuilder() =>
      AdminCaptainProfileDtoOutputEarningsWeekBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainProfileDtoOutputEarningsWeek &&
        from == other.from &&
        earnings == other.earnings &&
        orders == other.orders &&
        onlineMinutes == other.onlineMinutes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, earnings.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, onlineMinutes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCaptainProfileDtoOutputEarningsWeek',
          )
          ..add('from', from)
          ..add('earnings', earnings)
          ..add('orders', orders)
          ..add('onlineMinutes', onlineMinutes))
        .toString();
  }
}

class AdminCaptainProfileDtoOutputEarningsWeekBuilder
    implements
        Builder<
          AdminCaptainProfileDtoOutputEarningsWeek,
          AdminCaptainProfileDtoOutputEarningsWeekBuilder
        > {
  _$AdminCaptainProfileDtoOutputEarningsWeek? _$v;

  DateTime? _from;
  DateTime? get from => _$this._from;
  set from(DateTime? from) => _$this._from = from;

  String? _earnings;
  String? get earnings => _$this._earnings;
  set earnings(String? earnings) => _$this._earnings = earnings;

  int? _orders;
  int? get orders => _$this._orders;
  set orders(int? orders) => _$this._orders = orders;

  int? _onlineMinutes;
  int? get onlineMinutes => _$this._onlineMinutes;
  set onlineMinutes(int? onlineMinutes) =>
      _$this._onlineMinutes = onlineMinutes;

  AdminCaptainProfileDtoOutputEarningsWeekBuilder() {
    AdminCaptainProfileDtoOutputEarningsWeek._defaults(this);
  }

  AdminCaptainProfileDtoOutputEarningsWeekBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _from = $v.from;
      _earnings = $v.earnings;
      _orders = $v.orders;
      _onlineMinutes = $v.onlineMinutes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainProfileDtoOutputEarningsWeek other) {
    _$v = other as _$AdminCaptainProfileDtoOutputEarningsWeek;
  }

  @override
  void update(
    void Function(AdminCaptainProfileDtoOutputEarningsWeekBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainProfileDtoOutputEarningsWeek build() => _build();

  _$AdminCaptainProfileDtoOutputEarningsWeek _build() {
    final _$result =
        _$v ??
        _$AdminCaptainProfileDtoOutputEarningsWeek._(
          from: BuiltValueNullFieldError.checkNotNull(
            from,
            r'AdminCaptainProfileDtoOutputEarningsWeek',
            'from',
          ),
          earnings: BuiltValueNullFieldError.checkNotNull(
            earnings,
            r'AdminCaptainProfileDtoOutputEarningsWeek',
            'earnings',
          ),
          orders: BuiltValueNullFieldError.checkNotNull(
            orders,
            r'AdminCaptainProfileDtoOutputEarningsWeek',
            'orders',
          ),
          onlineMinutes: BuiltValueNullFieldError.checkNotNull(
            onlineMinutes,
            r'AdminCaptainProfileDtoOutputEarningsWeek',
            'onlineMinutes',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
