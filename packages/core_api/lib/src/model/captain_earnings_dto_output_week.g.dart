// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_earnings_dto_output_week.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainEarningsDtoOutputWeek extends CaptainEarningsDtoOutputWeek {
  @override
  final DateTime from;
  @override
  final String earnings;
  @override
  final int orders;
  @override
  final int onlineMinutes;

  factory _$CaptainEarningsDtoOutputWeek([
    void Function(CaptainEarningsDtoOutputWeekBuilder)? updates,
  ]) => (CaptainEarningsDtoOutputWeekBuilder()..update(updates))._build();

  _$CaptainEarningsDtoOutputWeek._({
    required this.from,
    required this.earnings,
    required this.orders,
    required this.onlineMinutes,
  }) : super._();
  @override
  CaptainEarningsDtoOutputWeek rebuild(
    void Function(CaptainEarningsDtoOutputWeekBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainEarningsDtoOutputWeekBuilder toBuilder() =>
      CaptainEarningsDtoOutputWeekBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainEarningsDtoOutputWeek &&
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
    return (newBuiltValueToStringHelper(r'CaptainEarningsDtoOutputWeek')
          ..add('from', from)
          ..add('earnings', earnings)
          ..add('orders', orders)
          ..add('onlineMinutes', onlineMinutes))
        .toString();
  }
}

class CaptainEarningsDtoOutputWeekBuilder
    implements
        Builder<
          CaptainEarningsDtoOutputWeek,
          CaptainEarningsDtoOutputWeekBuilder
        > {
  _$CaptainEarningsDtoOutputWeek? _$v;

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

  CaptainEarningsDtoOutputWeekBuilder() {
    CaptainEarningsDtoOutputWeek._defaults(this);
  }

  CaptainEarningsDtoOutputWeekBuilder get _$this {
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
  void replace(CaptainEarningsDtoOutputWeek other) {
    _$v = other as _$CaptainEarningsDtoOutputWeek;
  }

  @override
  void update(void Function(CaptainEarningsDtoOutputWeekBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainEarningsDtoOutputWeek build() => _build();

  _$CaptainEarningsDtoOutputWeek _build() {
    final _$result =
        _$v ??
        _$CaptainEarningsDtoOutputWeek._(
          from: BuiltValueNullFieldError.checkNotNull(
            from,
            r'CaptainEarningsDtoOutputWeek',
            'from',
          ),
          earnings: BuiltValueNullFieldError.checkNotNull(
            earnings,
            r'CaptainEarningsDtoOutputWeek',
            'earnings',
          ),
          orders: BuiltValueNullFieldError.checkNotNull(
            orders,
            r'CaptainEarningsDtoOutputWeek',
            'orders',
          ),
          onlineMinutes: BuiltValueNullFieldError.checkNotNull(
            onlineMinutes,
            r'CaptainEarningsDtoOutputWeek',
            'onlineMinutes',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
