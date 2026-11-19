// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_profile_dto_output_earnings_month.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainProfileDtoOutputEarningsMonth
    extends AdminCaptainProfileDtoOutputEarningsMonth {
  @override
  final DateTime from;
  @override
  final String earnings;
  @override
  final int orders;
  @override
  final int onlineMinutes;

  factory _$AdminCaptainProfileDtoOutputEarningsMonth([
    void Function(AdminCaptainProfileDtoOutputEarningsMonthBuilder)? updates,
  ]) => (AdminCaptainProfileDtoOutputEarningsMonthBuilder()..update(updates))
      ._build();

  _$AdminCaptainProfileDtoOutputEarningsMonth._({
    required this.from,
    required this.earnings,
    required this.orders,
    required this.onlineMinutes,
  }) : super._();
  @override
  AdminCaptainProfileDtoOutputEarningsMonth rebuild(
    void Function(AdminCaptainProfileDtoOutputEarningsMonthBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainProfileDtoOutputEarningsMonthBuilder toBuilder() =>
      AdminCaptainProfileDtoOutputEarningsMonthBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainProfileDtoOutputEarningsMonth &&
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
            r'AdminCaptainProfileDtoOutputEarningsMonth',
          )
          ..add('from', from)
          ..add('earnings', earnings)
          ..add('orders', orders)
          ..add('onlineMinutes', onlineMinutes))
        .toString();
  }
}

class AdminCaptainProfileDtoOutputEarningsMonthBuilder
    implements
        Builder<
          AdminCaptainProfileDtoOutputEarningsMonth,
          AdminCaptainProfileDtoOutputEarningsMonthBuilder
        > {
  _$AdminCaptainProfileDtoOutputEarningsMonth? _$v;

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

  AdminCaptainProfileDtoOutputEarningsMonthBuilder() {
    AdminCaptainProfileDtoOutputEarningsMonth._defaults(this);
  }

  AdminCaptainProfileDtoOutputEarningsMonthBuilder get _$this {
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
  void replace(AdminCaptainProfileDtoOutputEarningsMonth other) {
    _$v = other as _$AdminCaptainProfileDtoOutputEarningsMonth;
  }

  @override
  void update(
    void Function(AdminCaptainProfileDtoOutputEarningsMonthBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainProfileDtoOutputEarningsMonth build() => _build();

  _$AdminCaptainProfileDtoOutputEarningsMonth _build() {
    final _$result =
        _$v ??
        _$AdminCaptainProfileDtoOutputEarningsMonth._(
          from: BuiltValueNullFieldError.checkNotNull(
            from,
            r'AdminCaptainProfileDtoOutputEarningsMonth',
            'from',
          ),
          earnings: BuiltValueNullFieldError.checkNotNull(
            earnings,
            r'AdminCaptainProfileDtoOutputEarningsMonth',
            'earnings',
          ),
          orders: BuiltValueNullFieldError.checkNotNull(
            orders,
            r'AdminCaptainProfileDtoOutputEarningsMonth',
            'orders',
          ),
          onlineMinutes: BuiltValueNullFieldError.checkNotNull(
            onlineMinutes,
            r'AdminCaptainProfileDtoOutputEarningsMonth',
            'onlineMinutes',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
