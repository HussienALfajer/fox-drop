// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_settlement_preview_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminSettlementPreviewDtoOutputPayoutWeekdayEnum
_$adminSettlementPreviewDtoOutputPayoutWeekdayEnum_saturday =
    const AdminSettlementPreviewDtoOutputPayoutWeekdayEnum._('saturday');
const AdminSettlementPreviewDtoOutputPayoutWeekdayEnum
_$adminSettlementPreviewDtoOutputPayoutWeekdayEnum_sunday =
    const AdminSettlementPreviewDtoOutputPayoutWeekdayEnum._('sunday');
const AdminSettlementPreviewDtoOutputPayoutWeekdayEnum
_$adminSettlementPreviewDtoOutputPayoutWeekdayEnum_monday =
    const AdminSettlementPreviewDtoOutputPayoutWeekdayEnum._('monday');
const AdminSettlementPreviewDtoOutputPayoutWeekdayEnum
_$adminSettlementPreviewDtoOutputPayoutWeekdayEnum_tuesday =
    const AdminSettlementPreviewDtoOutputPayoutWeekdayEnum._('tuesday');
const AdminSettlementPreviewDtoOutputPayoutWeekdayEnum
_$adminSettlementPreviewDtoOutputPayoutWeekdayEnum_wednesday =
    const AdminSettlementPreviewDtoOutputPayoutWeekdayEnum._('wednesday');
const AdminSettlementPreviewDtoOutputPayoutWeekdayEnum
_$adminSettlementPreviewDtoOutputPayoutWeekdayEnum_thursday =
    const AdminSettlementPreviewDtoOutputPayoutWeekdayEnum._('thursday');
const AdminSettlementPreviewDtoOutputPayoutWeekdayEnum
_$adminSettlementPreviewDtoOutputPayoutWeekdayEnum_friday =
    const AdminSettlementPreviewDtoOutputPayoutWeekdayEnum._('friday');

AdminSettlementPreviewDtoOutputPayoutWeekdayEnum
_$adminSettlementPreviewDtoOutputPayoutWeekdayEnumValueOf(String name) {
  switch (name) {
    case 'saturday':
      return _$adminSettlementPreviewDtoOutputPayoutWeekdayEnum_saturday;
    case 'sunday':
      return _$adminSettlementPreviewDtoOutputPayoutWeekdayEnum_sunday;
    case 'monday':
      return _$adminSettlementPreviewDtoOutputPayoutWeekdayEnum_monday;
    case 'tuesday':
      return _$adminSettlementPreviewDtoOutputPayoutWeekdayEnum_tuesday;
    case 'wednesday':
      return _$adminSettlementPreviewDtoOutputPayoutWeekdayEnum_wednesday;
    case 'thursday':
      return _$adminSettlementPreviewDtoOutputPayoutWeekdayEnum_thursday;
    case 'friday':
      return _$adminSettlementPreviewDtoOutputPayoutWeekdayEnum_friday;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSettlementPreviewDtoOutputPayoutWeekdayEnum>
_$adminSettlementPreviewDtoOutputPayoutWeekdayEnumValues =
    BuiltSet<AdminSettlementPreviewDtoOutputPayoutWeekdayEnum>(
      const <AdminSettlementPreviewDtoOutputPayoutWeekdayEnum>[
        _$adminSettlementPreviewDtoOutputPayoutWeekdayEnum_saturday,
        _$adminSettlementPreviewDtoOutputPayoutWeekdayEnum_sunday,
        _$adminSettlementPreviewDtoOutputPayoutWeekdayEnum_monday,
        _$adminSettlementPreviewDtoOutputPayoutWeekdayEnum_tuesday,
        _$adminSettlementPreviewDtoOutputPayoutWeekdayEnum_wednesday,
        _$adminSettlementPreviewDtoOutputPayoutWeekdayEnum_thursday,
        _$adminSettlementPreviewDtoOutputPayoutWeekdayEnum_friday,
      ],
    );

const AdminSettlementPreviewDtoOutputPolicyEnum
_$adminSettlementPreviewDtoOutputPolicyEnum_carryForward =
    const AdminSettlementPreviewDtoOutputPolicyEnum._('carryForward');
const AdminSettlementPreviewDtoOutputPolicyEnum
_$adminSettlementPreviewDtoOutputPolicyEnum_collectAtDesk =
    const AdminSettlementPreviewDtoOutputPolicyEnum._('collectAtDesk');

AdminSettlementPreviewDtoOutputPolicyEnum
_$adminSettlementPreviewDtoOutputPolicyEnumValueOf(String name) {
  switch (name) {
    case 'carryForward':
      return _$adminSettlementPreviewDtoOutputPolicyEnum_carryForward;
    case 'collectAtDesk':
      return _$adminSettlementPreviewDtoOutputPolicyEnum_collectAtDesk;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSettlementPreviewDtoOutputPolicyEnum>
_$adminSettlementPreviewDtoOutputPolicyEnumValues =
    BuiltSet<AdminSettlementPreviewDtoOutputPolicyEnum>(
      const <AdminSettlementPreviewDtoOutputPolicyEnum>[
        _$adminSettlementPreviewDtoOutputPolicyEnum_carryForward,
        _$adminSettlementPreviewDtoOutputPolicyEnum_collectAtDesk,
      ],
    );

Serializer<AdminSettlementPreviewDtoOutputPayoutWeekdayEnum>
_$adminSettlementPreviewDtoOutputPayoutWeekdayEnumSerializer =
    _$AdminSettlementPreviewDtoOutputPayoutWeekdayEnumSerializer();
Serializer<AdminSettlementPreviewDtoOutputPolicyEnum>
_$adminSettlementPreviewDtoOutputPolicyEnumSerializer =
    _$AdminSettlementPreviewDtoOutputPolicyEnumSerializer();

class _$AdminSettlementPreviewDtoOutputPayoutWeekdayEnumSerializer
    implements
        PrimitiveSerializer<AdminSettlementPreviewDtoOutputPayoutWeekdayEnum> {
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
    AdminSettlementPreviewDtoOutputPayoutWeekdayEnum,
  ];
  @override
  final String wireName = 'AdminSettlementPreviewDtoOutputPayoutWeekdayEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminSettlementPreviewDtoOutputPayoutWeekdayEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminSettlementPreviewDtoOutputPayoutWeekdayEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminSettlementPreviewDtoOutputPayoutWeekdayEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminSettlementPreviewDtoOutputPolicyEnumSerializer
    implements PrimitiveSerializer<AdminSettlementPreviewDtoOutputPolicyEnum> {
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
    AdminSettlementPreviewDtoOutputPolicyEnum,
  ];
  @override
  final String wireName = 'AdminSettlementPreviewDtoOutputPolicyEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminSettlementPreviewDtoOutputPolicyEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminSettlementPreviewDtoOutputPolicyEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminSettlementPreviewDtoOutputPolicyEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminSettlementPreviewDtoOutput
    extends AdminSettlementPreviewDtoOutput {
  @override
  final String captainId;
  @override
  final String name;
  @override
  final String cityId;
  @override
  final bool payoutDay;
  @override
  final AdminSettlementPreviewDtoOutputPayoutWeekdayEnum payoutWeekday;
  @override
  final AdminSettlementPreviewDtoOutputPolicyEnum policy;
  @override
  final BuiltList<AdminSettlementPreviewDtoOutputCustodyInner> custody;
  @override
  final AdminCaptainBalancesDtoOutputCaptainsInnerEarnings earnings;
  @override
  final AdminSettlementPreviewDtoOutputPayout? payout;
  @override
  final String? collect;
  @override
  final BuiltList<AdminTicketPageDtoOutputPickupDisputePickupPayment?> net;

  factory _$AdminSettlementPreviewDtoOutput([
    void Function(AdminSettlementPreviewDtoOutputBuilder)? updates,
  ]) => (AdminSettlementPreviewDtoOutputBuilder()..update(updates))._build();

  _$AdminSettlementPreviewDtoOutput._({
    required this.captainId,
    required this.name,
    required this.cityId,
    required this.payoutDay,
    required this.payoutWeekday,
    required this.policy,
    required this.custody,
    required this.earnings,
    this.payout,
    this.collect,
    required this.net,
  }) : super._();
  @override
  AdminSettlementPreviewDtoOutput rebuild(
    void Function(AdminSettlementPreviewDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSettlementPreviewDtoOutputBuilder toBuilder() =>
      AdminSettlementPreviewDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSettlementPreviewDtoOutput &&
        captainId == other.captainId &&
        name == other.name &&
        cityId == other.cityId &&
        payoutDay == other.payoutDay &&
        payoutWeekday == other.payoutWeekday &&
        policy == other.policy &&
        custody == other.custody &&
        earnings == other.earnings &&
        payout == other.payout &&
        collect == other.collect &&
        net == other.net;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, captainId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, payoutDay.hashCode);
    _$hash = $jc(_$hash, payoutWeekday.hashCode);
    _$hash = $jc(_$hash, policy.hashCode);
    _$hash = $jc(_$hash, custody.hashCode);
    _$hash = $jc(_$hash, earnings.hashCode);
    _$hash = $jc(_$hash, payout.hashCode);
    _$hash = $jc(_$hash, collect.hashCode);
    _$hash = $jc(_$hash, net.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSettlementPreviewDtoOutput')
          ..add('captainId', captainId)
          ..add('name', name)
          ..add('cityId', cityId)
          ..add('payoutDay', payoutDay)
          ..add('payoutWeekday', payoutWeekday)
          ..add('policy', policy)
          ..add('custody', custody)
          ..add('earnings', earnings)
          ..add('payout', payout)
          ..add('collect', collect)
          ..add('net', net))
        .toString();
  }
}

class AdminSettlementPreviewDtoOutputBuilder
    implements
        Builder<
          AdminSettlementPreviewDtoOutput,
          AdminSettlementPreviewDtoOutputBuilder
        > {
  _$AdminSettlementPreviewDtoOutput? _$v;

  String? _captainId;
  String? get captainId => _$this._captainId;
  set captainId(String? captainId) => _$this._captainId = captainId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  bool? _payoutDay;
  bool? get payoutDay => _$this._payoutDay;
  set payoutDay(bool? payoutDay) => _$this._payoutDay = payoutDay;

  AdminSettlementPreviewDtoOutputPayoutWeekdayEnum? _payoutWeekday;
  AdminSettlementPreviewDtoOutputPayoutWeekdayEnum? get payoutWeekday =>
      _$this._payoutWeekday;
  set payoutWeekday(
    AdminSettlementPreviewDtoOutputPayoutWeekdayEnum? payoutWeekday,
  ) => _$this._payoutWeekday = payoutWeekday;

  AdminSettlementPreviewDtoOutputPolicyEnum? _policy;
  AdminSettlementPreviewDtoOutputPolicyEnum? get policy => _$this._policy;
  set policy(AdminSettlementPreviewDtoOutputPolicyEnum? policy) =>
      _$this._policy = policy;

  ListBuilder<AdminSettlementPreviewDtoOutputCustodyInner>? _custody;
  ListBuilder<AdminSettlementPreviewDtoOutputCustodyInner> get custody =>
      _$this._custody ??=
          ListBuilder<AdminSettlementPreviewDtoOutputCustodyInner>();
  set custody(
    ListBuilder<AdminSettlementPreviewDtoOutputCustodyInner>? custody,
  ) => _$this._custody = custody;

  AdminCaptainBalancesDtoOutputCaptainsInnerEarningsBuilder? _earnings;
  AdminCaptainBalancesDtoOutputCaptainsInnerEarningsBuilder get earnings =>
      _$this._earnings ??=
          AdminCaptainBalancesDtoOutputCaptainsInnerEarningsBuilder();
  set earnings(
    AdminCaptainBalancesDtoOutputCaptainsInnerEarningsBuilder? earnings,
  ) => _$this._earnings = earnings;

  AdminSettlementPreviewDtoOutputPayoutBuilder? _payout;
  AdminSettlementPreviewDtoOutputPayoutBuilder get payout =>
      _$this._payout ??= AdminSettlementPreviewDtoOutputPayoutBuilder();
  set payout(AdminSettlementPreviewDtoOutputPayoutBuilder? payout) =>
      _$this._payout = payout;

  String? _collect;
  String? get collect => _$this._collect;
  set collect(String? collect) => _$this._collect = collect;

  ListBuilder<AdminTicketPageDtoOutputPickupDisputePickupPayment?>? _net;
  ListBuilder<AdminTicketPageDtoOutputPickupDisputePickupPayment?> get net =>
      _$this._net ??=
          ListBuilder<AdminTicketPageDtoOutputPickupDisputePickupPayment?>();
  set net(
    ListBuilder<AdminTicketPageDtoOutputPickupDisputePickupPayment?>? net,
  ) => _$this._net = net;

  AdminSettlementPreviewDtoOutputBuilder() {
    AdminSettlementPreviewDtoOutput._defaults(this);
  }

  AdminSettlementPreviewDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _captainId = $v.captainId;
      _name = $v.name;
      _cityId = $v.cityId;
      _payoutDay = $v.payoutDay;
      _payoutWeekday = $v.payoutWeekday;
      _policy = $v.policy;
      _custody = $v.custody.toBuilder();
      _earnings = $v.earnings.toBuilder();
      _payout = $v.payout?.toBuilder();
      _collect = $v.collect;
      _net = $v.net.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSettlementPreviewDtoOutput other) {
    _$v = other as _$AdminSettlementPreviewDtoOutput;
  }

  @override
  void update(void Function(AdminSettlementPreviewDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSettlementPreviewDtoOutput build() => _build();

  _$AdminSettlementPreviewDtoOutput _build() {
    _$AdminSettlementPreviewDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminSettlementPreviewDtoOutput._(
            captainId: BuiltValueNullFieldError.checkNotNull(
              captainId,
              r'AdminSettlementPreviewDtoOutput',
              'captainId',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AdminSettlementPreviewDtoOutput',
              'name',
            ),
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminSettlementPreviewDtoOutput',
              'cityId',
            ),
            payoutDay: BuiltValueNullFieldError.checkNotNull(
              payoutDay,
              r'AdminSettlementPreviewDtoOutput',
              'payoutDay',
            ),
            payoutWeekday: BuiltValueNullFieldError.checkNotNull(
              payoutWeekday,
              r'AdminSettlementPreviewDtoOutput',
              'payoutWeekday',
            ),
            policy: BuiltValueNullFieldError.checkNotNull(
              policy,
              r'AdminSettlementPreviewDtoOutput',
              'policy',
            ),
            custody: custody.build(),
            earnings: earnings.build(),
            payout: _payout?.build(),
            collect: collect,
            net: net.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'custody';
        custody.build();
        _$failedField = 'earnings';
        earnings.build();
        _$failedField = 'payout';
        _payout?.build();

        _$failedField = 'net';
        net.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminSettlementPreviewDtoOutput',
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
