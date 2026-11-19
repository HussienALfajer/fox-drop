// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_profile_dto_output_earnings.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainProfileDtoOutputEarnings
    extends AdminCaptainProfileDtoOutputEarnings {
  @override
  final String currency;
  @override
  final String balance;
  @override
  final AdminCaptainProfileDtoOutputEarningsToday today;
  @override
  final AdminCaptainProfileDtoOutputEarningsWeek week;
  @override
  final AdminCaptainProfileDtoOutputEarningsMonth month;

  factory _$AdminCaptainProfileDtoOutputEarnings([
    void Function(AdminCaptainProfileDtoOutputEarningsBuilder)? updates,
  ]) =>
      (AdminCaptainProfileDtoOutputEarningsBuilder()..update(updates))._build();

  _$AdminCaptainProfileDtoOutputEarnings._({
    required this.currency,
    required this.balance,
    required this.today,
    required this.week,
    required this.month,
  }) : super._();
  @override
  AdminCaptainProfileDtoOutputEarnings rebuild(
    void Function(AdminCaptainProfileDtoOutputEarningsBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainProfileDtoOutputEarningsBuilder toBuilder() =>
      AdminCaptainProfileDtoOutputEarningsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainProfileDtoOutputEarnings &&
        currency == other.currency &&
        balance == other.balance &&
        today == other.today &&
        week == other.week &&
        month == other.month;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, balance.hashCode);
    _$hash = $jc(_$hash, today.hashCode);
    _$hash = $jc(_$hash, week.hashCode);
    _$hash = $jc(_$hash, month.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCaptainProfileDtoOutputEarnings')
          ..add('currency', currency)
          ..add('balance', balance)
          ..add('today', today)
          ..add('week', week)
          ..add('month', month))
        .toString();
  }
}

class AdminCaptainProfileDtoOutputEarningsBuilder
    implements
        Builder<
          AdminCaptainProfileDtoOutputEarnings,
          AdminCaptainProfileDtoOutputEarningsBuilder
        > {
  _$AdminCaptainProfileDtoOutputEarnings? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _balance;
  String? get balance => _$this._balance;
  set balance(String? balance) => _$this._balance = balance;

  AdminCaptainProfileDtoOutputEarningsTodayBuilder? _today;
  AdminCaptainProfileDtoOutputEarningsTodayBuilder get today =>
      _$this._today ??= AdminCaptainProfileDtoOutputEarningsTodayBuilder();
  set today(AdminCaptainProfileDtoOutputEarningsTodayBuilder? today) =>
      _$this._today = today;

  AdminCaptainProfileDtoOutputEarningsWeekBuilder? _week;
  AdminCaptainProfileDtoOutputEarningsWeekBuilder get week =>
      _$this._week ??= AdminCaptainProfileDtoOutputEarningsWeekBuilder();
  set week(AdminCaptainProfileDtoOutputEarningsWeekBuilder? week) =>
      _$this._week = week;

  AdminCaptainProfileDtoOutputEarningsMonthBuilder? _month;
  AdminCaptainProfileDtoOutputEarningsMonthBuilder get month =>
      _$this._month ??= AdminCaptainProfileDtoOutputEarningsMonthBuilder();
  set month(AdminCaptainProfileDtoOutputEarningsMonthBuilder? month) =>
      _$this._month = month;

  AdminCaptainProfileDtoOutputEarningsBuilder() {
    AdminCaptainProfileDtoOutputEarnings._defaults(this);
  }

  AdminCaptainProfileDtoOutputEarningsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _balance = $v.balance;
      _today = $v.today.toBuilder();
      _week = $v.week.toBuilder();
      _month = $v.month.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainProfileDtoOutputEarnings other) {
    _$v = other as _$AdminCaptainProfileDtoOutputEarnings;
  }

  @override
  void update(
    void Function(AdminCaptainProfileDtoOutputEarningsBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainProfileDtoOutputEarnings build() => _build();

  _$AdminCaptainProfileDtoOutputEarnings _build() {
    _$AdminCaptainProfileDtoOutputEarnings _$result;
    try {
      _$result =
          _$v ??
          _$AdminCaptainProfileDtoOutputEarnings._(
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminCaptainProfileDtoOutputEarnings',
              'currency',
            ),
            balance: BuiltValueNullFieldError.checkNotNull(
              balance,
              r'AdminCaptainProfileDtoOutputEarnings',
              'balance',
            ),
            today: today.build(),
            week: week.build(),
            month: month.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'today';
        today.build();
        _$failedField = 'week';
        week.build();
        _$failedField = 'month';
        month.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCaptainProfileDtoOutputEarnings',
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
