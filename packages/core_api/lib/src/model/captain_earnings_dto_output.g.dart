// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_earnings_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainEarningsDtoOutputPayoutWeekdayEnum
_$captainEarningsDtoOutputPayoutWeekdayEnum_saturday =
    const CaptainEarningsDtoOutputPayoutWeekdayEnum._('saturday');
const CaptainEarningsDtoOutputPayoutWeekdayEnum
_$captainEarningsDtoOutputPayoutWeekdayEnum_sunday =
    const CaptainEarningsDtoOutputPayoutWeekdayEnum._('sunday');
const CaptainEarningsDtoOutputPayoutWeekdayEnum
_$captainEarningsDtoOutputPayoutWeekdayEnum_monday =
    const CaptainEarningsDtoOutputPayoutWeekdayEnum._('monday');
const CaptainEarningsDtoOutputPayoutWeekdayEnum
_$captainEarningsDtoOutputPayoutWeekdayEnum_tuesday =
    const CaptainEarningsDtoOutputPayoutWeekdayEnum._('tuesday');
const CaptainEarningsDtoOutputPayoutWeekdayEnum
_$captainEarningsDtoOutputPayoutWeekdayEnum_wednesday =
    const CaptainEarningsDtoOutputPayoutWeekdayEnum._('wednesday');
const CaptainEarningsDtoOutputPayoutWeekdayEnum
_$captainEarningsDtoOutputPayoutWeekdayEnum_thursday =
    const CaptainEarningsDtoOutputPayoutWeekdayEnum._('thursday');
const CaptainEarningsDtoOutputPayoutWeekdayEnum
_$captainEarningsDtoOutputPayoutWeekdayEnum_friday =
    const CaptainEarningsDtoOutputPayoutWeekdayEnum._('friday');

CaptainEarningsDtoOutputPayoutWeekdayEnum
_$captainEarningsDtoOutputPayoutWeekdayEnumValueOf(String name) {
  switch (name) {
    case 'saturday':
      return _$captainEarningsDtoOutputPayoutWeekdayEnum_saturday;
    case 'sunday':
      return _$captainEarningsDtoOutputPayoutWeekdayEnum_sunday;
    case 'monday':
      return _$captainEarningsDtoOutputPayoutWeekdayEnum_monday;
    case 'tuesday':
      return _$captainEarningsDtoOutputPayoutWeekdayEnum_tuesday;
    case 'wednesday':
      return _$captainEarningsDtoOutputPayoutWeekdayEnum_wednesday;
    case 'thursday':
      return _$captainEarningsDtoOutputPayoutWeekdayEnum_thursday;
    case 'friday':
      return _$captainEarningsDtoOutputPayoutWeekdayEnum_friday;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainEarningsDtoOutputPayoutWeekdayEnum>
_$captainEarningsDtoOutputPayoutWeekdayEnumValues =
    BuiltSet<CaptainEarningsDtoOutputPayoutWeekdayEnum>(
      const <CaptainEarningsDtoOutputPayoutWeekdayEnum>[
        _$captainEarningsDtoOutputPayoutWeekdayEnum_saturday,
        _$captainEarningsDtoOutputPayoutWeekdayEnum_sunday,
        _$captainEarningsDtoOutputPayoutWeekdayEnum_monday,
        _$captainEarningsDtoOutputPayoutWeekdayEnum_tuesday,
        _$captainEarningsDtoOutputPayoutWeekdayEnum_wednesday,
        _$captainEarningsDtoOutputPayoutWeekdayEnum_thursday,
        _$captainEarningsDtoOutputPayoutWeekdayEnum_friday,
      ],
    );

const CaptainEarningsDtoOutputNegativePolicyEnum
_$captainEarningsDtoOutputNegativePolicyEnum_carryForward =
    const CaptainEarningsDtoOutputNegativePolicyEnum._('carryForward');
const CaptainEarningsDtoOutputNegativePolicyEnum
_$captainEarningsDtoOutputNegativePolicyEnum_collectAtDesk =
    const CaptainEarningsDtoOutputNegativePolicyEnum._('collectAtDesk');

CaptainEarningsDtoOutputNegativePolicyEnum
_$captainEarningsDtoOutputNegativePolicyEnumValueOf(String name) {
  switch (name) {
    case 'carryForward':
      return _$captainEarningsDtoOutputNegativePolicyEnum_carryForward;
    case 'collectAtDesk':
      return _$captainEarningsDtoOutputNegativePolicyEnum_collectAtDesk;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainEarningsDtoOutputNegativePolicyEnum>
_$captainEarningsDtoOutputNegativePolicyEnumValues =
    BuiltSet<CaptainEarningsDtoOutputNegativePolicyEnum>(
      const <CaptainEarningsDtoOutputNegativePolicyEnum>[
        _$captainEarningsDtoOutputNegativePolicyEnum_carryForward,
        _$captainEarningsDtoOutputNegativePolicyEnum_collectAtDesk,
      ],
    );

Serializer<CaptainEarningsDtoOutputPayoutWeekdayEnum>
_$captainEarningsDtoOutputPayoutWeekdayEnumSerializer =
    _$CaptainEarningsDtoOutputPayoutWeekdayEnumSerializer();
Serializer<CaptainEarningsDtoOutputNegativePolicyEnum>
_$captainEarningsDtoOutputNegativePolicyEnumSerializer =
    _$CaptainEarningsDtoOutputNegativePolicyEnumSerializer();

class _$CaptainEarningsDtoOutputPayoutWeekdayEnumSerializer
    implements PrimitiveSerializer<CaptainEarningsDtoOutputPayoutWeekdayEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'saturday': 'saturday',
    'sunday': 'sunday',
    'monday': 'monday',
    'tuesday': 'tuesday',
    'wednesday': 'wednesday',
    'thursday': 'thursday',
    'friday': 'friday',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'saturday': 'saturday',
    'sunday': 'sunday',
    'monday': 'monday',
    'tuesday': 'tuesday',
    'wednesday': 'wednesday',
    'thursday': 'thursday',
    'friday': 'friday',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CaptainEarningsDtoOutputPayoutWeekdayEnum,
  ];
  @override
  final String wireName = 'CaptainEarningsDtoOutputPayoutWeekdayEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainEarningsDtoOutputPayoutWeekdayEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainEarningsDtoOutputPayoutWeekdayEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainEarningsDtoOutputPayoutWeekdayEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainEarningsDtoOutputNegativePolicyEnumSerializer
    implements PrimitiveSerializer<CaptainEarningsDtoOutputNegativePolicyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'carryForward': 'carry_forward',
    'collectAtDesk': 'collect_at_desk',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'carry_forward': 'carryForward',
    'collect_at_desk': 'collectAtDesk',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CaptainEarningsDtoOutputNegativePolicyEnum,
  ];
  @override
  final String wireName = 'CaptainEarningsDtoOutputNegativePolicyEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainEarningsDtoOutputNegativePolicyEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainEarningsDtoOutputNegativePolicyEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainEarningsDtoOutputNegativePolicyEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainEarningsDtoOutput extends CaptainEarningsDtoOutput {
  @override
  final String currency;
  @override
  final CaptainEarningsDtoOutputToday today;
  @override
  final CaptainEarningsDtoOutputWeek week;
  @override
  final BuiltList<CaptainEarningsDtoOutputOrdersInner> orders;
  @override
  final BuiltList<CaptainEarningsDtoOutputLinesInner> lines;
  @override
  final String balance;
  @override
  final CaptainEarningsDtoOutputPayoutWeekdayEnum payoutWeekday;
  @override
  final Date nextPayout;
  @override
  final CaptainEarningsDtoOutputNegativePolicyEnum negativePolicy;

  factory _$CaptainEarningsDtoOutput([
    void Function(CaptainEarningsDtoOutputBuilder)? updates,
  ]) => (CaptainEarningsDtoOutputBuilder()..update(updates))._build();

  _$CaptainEarningsDtoOutput._({
    required this.currency,
    required this.today,
    required this.week,
    required this.orders,
    required this.lines,
    required this.balance,
    required this.payoutWeekday,
    required this.nextPayout,
    required this.negativePolicy,
  }) : super._();
  @override
  CaptainEarningsDtoOutput rebuild(
    void Function(CaptainEarningsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainEarningsDtoOutputBuilder toBuilder() =>
      CaptainEarningsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainEarningsDtoOutput &&
        currency == other.currency &&
        today == other.today &&
        week == other.week &&
        orders == other.orders &&
        lines == other.lines &&
        balance == other.balance &&
        payoutWeekday == other.payoutWeekday &&
        nextPayout == other.nextPayout &&
        negativePolicy == other.negativePolicy;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, today.hashCode);
    _$hash = $jc(_$hash, week.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, balance.hashCode);
    _$hash = $jc(_$hash, payoutWeekday.hashCode);
    _$hash = $jc(_$hash, nextPayout.hashCode);
    _$hash = $jc(_$hash, negativePolicy.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainEarningsDtoOutput')
          ..add('currency', currency)
          ..add('today', today)
          ..add('week', week)
          ..add('orders', orders)
          ..add('lines', lines)
          ..add('balance', balance)
          ..add('payoutWeekday', payoutWeekday)
          ..add('nextPayout', nextPayout)
          ..add('negativePolicy', negativePolicy))
        .toString();
  }
}

class CaptainEarningsDtoOutputBuilder
    implements
        Builder<CaptainEarningsDtoOutput, CaptainEarningsDtoOutputBuilder> {
  _$CaptainEarningsDtoOutput? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CaptainEarningsDtoOutputTodayBuilder? _today;
  CaptainEarningsDtoOutputTodayBuilder get today =>
      _$this._today ??= CaptainEarningsDtoOutputTodayBuilder();
  set today(CaptainEarningsDtoOutputTodayBuilder? today) =>
      _$this._today = today;

  CaptainEarningsDtoOutputWeekBuilder? _week;
  CaptainEarningsDtoOutputWeekBuilder get week =>
      _$this._week ??= CaptainEarningsDtoOutputWeekBuilder();
  set week(CaptainEarningsDtoOutputWeekBuilder? week) => _$this._week = week;

  ListBuilder<CaptainEarningsDtoOutputOrdersInner>? _orders;
  ListBuilder<CaptainEarningsDtoOutputOrdersInner> get orders =>
      _$this._orders ??= ListBuilder<CaptainEarningsDtoOutputOrdersInner>();
  set orders(ListBuilder<CaptainEarningsDtoOutputOrdersInner>? orders) =>
      _$this._orders = orders;

  ListBuilder<CaptainEarningsDtoOutputLinesInner>? _lines;
  ListBuilder<CaptainEarningsDtoOutputLinesInner> get lines =>
      _$this._lines ??= ListBuilder<CaptainEarningsDtoOutputLinesInner>();
  set lines(ListBuilder<CaptainEarningsDtoOutputLinesInner>? lines) =>
      _$this._lines = lines;

  String? _balance;
  String? get balance => _$this._balance;
  set balance(String? balance) => _$this._balance = balance;

  CaptainEarningsDtoOutputPayoutWeekdayEnum? _payoutWeekday;
  CaptainEarningsDtoOutputPayoutWeekdayEnum? get payoutWeekday =>
      _$this._payoutWeekday;
  set payoutWeekday(CaptainEarningsDtoOutputPayoutWeekdayEnum? payoutWeekday) =>
      _$this._payoutWeekday = payoutWeekday;

  Date? _nextPayout;
  Date? get nextPayout => _$this._nextPayout;
  set nextPayout(Date? nextPayout) => _$this._nextPayout = nextPayout;

  CaptainEarningsDtoOutputNegativePolicyEnum? _negativePolicy;
  CaptainEarningsDtoOutputNegativePolicyEnum? get negativePolicy =>
      _$this._negativePolicy;
  set negativePolicy(
    CaptainEarningsDtoOutputNegativePolicyEnum? negativePolicy,
  ) => _$this._negativePolicy = negativePolicy;

  CaptainEarningsDtoOutputBuilder() {
    CaptainEarningsDtoOutput._defaults(this);
  }

  CaptainEarningsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _today = $v.today.toBuilder();
      _week = $v.week.toBuilder();
      _orders = $v.orders.toBuilder();
      _lines = $v.lines.toBuilder();
      _balance = $v.balance;
      _payoutWeekday = $v.payoutWeekday;
      _nextPayout = $v.nextPayout;
      _negativePolicy = $v.negativePolicy;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainEarningsDtoOutput other) {
    _$v = other as _$CaptainEarningsDtoOutput;
  }

  @override
  void update(void Function(CaptainEarningsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainEarningsDtoOutput build() => _build();

  _$CaptainEarningsDtoOutput _build() {
    _$CaptainEarningsDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$CaptainEarningsDtoOutput._(
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'CaptainEarningsDtoOutput',
              'currency',
            ),
            today: today.build(),
            week: week.build(),
            orders: orders.build(),
            lines: lines.build(),
            balance: BuiltValueNullFieldError.checkNotNull(
              balance,
              r'CaptainEarningsDtoOutput',
              'balance',
            ),
            payoutWeekday: BuiltValueNullFieldError.checkNotNull(
              payoutWeekday,
              r'CaptainEarningsDtoOutput',
              'payoutWeekday',
            ),
            nextPayout: BuiltValueNullFieldError.checkNotNull(
              nextPayout,
              r'CaptainEarningsDtoOutput',
              'nextPayout',
            ),
            negativePolicy: BuiltValueNullFieldError.checkNotNull(
              negativePolicy,
              r'CaptainEarningsDtoOutput',
              'negativePolicy',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'today';
        today.build();
        _$failedField = 'week';
        week.build();
        _$failedField = 'orders';
        orders.build();
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainEarningsDtoOutput',
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
