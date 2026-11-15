// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_earnings_dto_output_today.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainEarningsDtoOutputToday extends CaptainEarningsDtoOutputToday {
  @override
  final DateTime from;
  @override
  final String earnings;
  @override
  final int orders;
  @override
  final int onlineMinutes;

  factory _$CaptainEarningsDtoOutputToday([
    void Function(CaptainEarningsDtoOutputTodayBuilder)? updates,
  ]) => (CaptainEarningsDtoOutputTodayBuilder()..update(updates))._build();

  _$CaptainEarningsDtoOutputToday._({
    required this.from,
    required this.earnings,
    required this.orders,
    required this.onlineMinutes,
  }) : super._();
  @override
  CaptainEarningsDtoOutputToday rebuild(
    void Function(CaptainEarningsDtoOutputTodayBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainEarningsDtoOutputTodayBuilder toBuilder() =>
      CaptainEarningsDtoOutputTodayBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainEarningsDtoOutputToday &&
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
    return (newBuiltValueToStringHelper(r'CaptainEarningsDtoOutputToday')
          ..add('from', from)
          ..add('earnings', earnings)
          ..add('orders', orders)
          ..add('onlineMinutes', onlineMinutes))
        .toString();
  }
}

class CaptainEarningsDtoOutputTodayBuilder
    implements
        Builder<
          CaptainEarningsDtoOutputToday,
          CaptainEarningsDtoOutputTodayBuilder
        > {
  _$CaptainEarningsDtoOutputToday? _$v;

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

  CaptainEarningsDtoOutputTodayBuilder() {
    CaptainEarningsDtoOutputToday._defaults(this);
  }

  CaptainEarningsDtoOutputTodayBuilder get _$this {
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
  void replace(CaptainEarningsDtoOutputToday other) {
    _$v = other as _$CaptainEarningsDtoOutputToday;
  }

  @override
  void update(void Function(CaptainEarningsDtoOutputTodayBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainEarningsDtoOutputToday build() => _build();

  _$CaptainEarningsDtoOutputToday _build() {
    final _$result =
        _$v ??
        _$CaptainEarningsDtoOutputToday._(
          from: BuiltValueNullFieldError.checkNotNull(
            from,
            r'CaptainEarningsDtoOutputToday',
            'from',
          ),
          earnings: BuiltValueNullFieldError.checkNotNull(
            earnings,
            r'CaptainEarningsDtoOutputToday',
            'earnings',
          ),
          orders: BuiltValueNullFieldError.checkNotNull(
            orders,
            r'CaptainEarningsDtoOutputToday',
            'orders',
          ),
          onlineMinutes: BuiltValueNullFieldError.checkNotNull(
            onlineMinutes,
            r'CaptainEarningsDtoOutputToday',
            'onlineMinutes',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
