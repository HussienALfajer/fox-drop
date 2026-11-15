// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_settlements_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminSettlementsDtoOutputPayoutWeekdayEnum
_$adminSettlementsDtoOutputPayoutWeekdayEnum_saturday =
    const AdminSettlementsDtoOutputPayoutWeekdayEnum._('saturday');
const AdminSettlementsDtoOutputPayoutWeekdayEnum
_$adminSettlementsDtoOutputPayoutWeekdayEnum_sunday =
    const AdminSettlementsDtoOutputPayoutWeekdayEnum._('sunday');
const AdminSettlementsDtoOutputPayoutWeekdayEnum
_$adminSettlementsDtoOutputPayoutWeekdayEnum_monday =
    const AdminSettlementsDtoOutputPayoutWeekdayEnum._('monday');
const AdminSettlementsDtoOutputPayoutWeekdayEnum
_$adminSettlementsDtoOutputPayoutWeekdayEnum_tuesday =
    const AdminSettlementsDtoOutputPayoutWeekdayEnum._('tuesday');
const AdminSettlementsDtoOutputPayoutWeekdayEnum
_$adminSettlementsDtoOutputPayoutWeekdayEnum_wednesday =
    const AdminSettlementsDtoOutputPayoutWeekdayEnum._('wednesday');
const AdminSettlementsDtoOutputPayoutWeekdayEnum
_$adminSettlementsDtoOutputPayoutWeekdayEnum_thursday =
    const AdminSettlementsDtoOutputPayoutWeekdayEnum._('thursday');
const AdminSettlementsDtoOutputPayoutWeekdayEnum
_$adminSettlementsDtoOutputPayoutWeekdayEnum_friday =
    const AdminSettlementsDtoOutputPayoutWeekdayEnum._('friday');

AdminSettlementsDtoOutputPayoutWeekdayEnum
_$adminSettlementsDtoOutputPayoutWeekdayEnumValueOf(String name) {
  switch (name) {
    case 'saturday':
      return _$adminSettlementsDtoOutputPayoutWeekdayEnum_saturday;
    case 'sunday':
      return _$adminSettlementsDtoOutputPayoutWeekdayEnum_sunday;
    case 'monday':
      return _$adminSettlementsDtoOutputPayoutWeekdayEnum_monday;
    case 'tuesday':
      return _$adminSettlementsDtoOutputPayoutWeekdayEnum_tuesday;
    case 'wednesday':
      return _$adminSettlementsDtoOutputPayoutWeekdayEnum_wednesday;
    case 'thursday':
      return _$adminSettlementsDtoOutputPayoutWeekdayEnum_thursday;
    case 'friday':
      return _$adminSettlementsDtoOutputPayoutWeekdayEnum_friday;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSettlementsDtoOutputPayoutWeekdayEnum>
_$adminSettlementsDtoOutputPayoutWeekdayEnumValues =
    BuiltSet<AdminSettlementsDtoOutputPayoutWeekdayEnum>(
      const <AdminSettlementsDtoOutputPayoutWeekdayEnum>[
        _$adminSettlementsDtoOutputPayoutWeekdayEnum_saturday,
        _$adminSettlementsDtoOutputPayoutWeekdayEnum_sunday,
        _$adminSettlementsDtoOutputPayoutWeekdayEnum_monday,
        _$adminSettlementsDtoOutputPayoutWeekdayEnum_tuesday,
        _$adminSettlementsDtoOutputPayoutWeekdayEnum_wednesday,
        _$adminSettlementsDtoOutputPayoutWeekdayEnum_thursday,
        _$adminSettlementsDtoOutputPayoutWeekdayEnum_friday,
      ],
    );

const AdminSettlementsDtoOutputPolicyEnum
_$adminSettlementsDtoOutputPolicyEnum_carryForward =
    const AdminSettlementsDtoOutputPolicyEnum._('carryForward');
const AdminSettlementsDtoOutputPolicyEnum
_$adminSettlementsDtoOutputPolicyEnum_collectAtDesk =
    const AdminSettlementsDtoOutputPolicyEnum._('collectAtDesk');

AdminSettlementsDtoOutputPolicyEnum
_$adminSettlementsDtoOutputPolicyEnumValueOf(String name) {
  switch (name) {
    case 'carryForward':
      return _$adminSettlementsDtoOutputPolicyEnum_carryForward;
    case 'collectAtDesk':
      return _$adminSettlementsDtoOutputPolicyEnum_collectAtDesk;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSettlementsDtoOutputPolicyEnum>
_$adminSettlementsDtoOutputPolicyEnumValues =
    BuiltSet<AdminSettlementsDtoOutputPolicyEnum>(
      const <AdminSettlementsDtoOutputPolicyEnum>[
        _$adminSettlementsDtoOutputPolicyEnum_carryForward,
        _$adminSettlementsDtoOutputPolicyEnum_collectAtDesk,
      ],
    );

Serializer<AdminSettlementsDtoOutputPayoutWeekdayEnum>
_$adminSettlementsDtoOutputPayoutWeekdayEnumSerializer =
    _$AdminSettlementsDtoOutputPayoutWeekdayEnumSerializer();
Serializer<AdminSettlementsDtoOutputPolicyEnum>
_$adminSettlementsDtoOutputPolicyEnumSerializer =
    _$AdminSettlementsDtoOutputPolicyEnumSerializer();

class _$AdminSettlementsDtoOutputPayoutWeekdayEnumSerializer
    implements PrimitiveSerializer<AdminSettlementsDtoOutputPayoutWeekdayEnum> {
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
    AdminSettlementsDtoOutputPayoutWeekdayEnum,
  ];
  @override
  final String wireName = 'AdminSettlementsDtoOutputPayoutWeekdayEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminSettlementsDtoOutputPayoutWeekdayEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminSettlementsDtoOutputPayoutWeekdayEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminSettlementsDtoOutputPayoutWeekdayEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminSettlementsDtoOutputPolicyEnumSerializer
    implements PrimitiveSerializer<AdminSettlementsDtoOutputPolicyEnum> {
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
    AdminSettlementsDtoOutputPolicyEnum,
  ];
  @override
  final String wireName = 'AdminSettlementsDtoOutputPolicyEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminSettlementsDtoOutputPolicyEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminSettlementsDtoOutputPolicyEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminSettlementsDtoOutputPolicyEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminSettlementsDtoOutput extends AdminSettlementsDtoOutput {
  @override
  final bool payoutDay;
  @override
  final AdminSettlementsDtoOutputPayoutWeekdayEnum payoutWeekday;
  @override
  final AdminSettlementsDtoOutputPolicyEnum policy;
  @override
  final BuiltList<AdminCaptainBalancesDtoOutputCaptainsInner> captains;

  factory _$AdminSettlementsDtoOutput([
    void Function(AdminSettlementsDtoOutputBuilder)? updates,
  ]) => (AdminSettlementsDtoOutputBuilder()..update(updates))._build();

  _$AdminSettlementsDtoOutput._({
    required this.payoutDay,
    required this.payoutWeekday,
    required this.policy,
    required this.captains,
  }) : super._();
  @override
  AdminSettlementsDtoOutput rebuild(
    void Function(AdminSettlementsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSettlementsDtoOutputBuilder toBuilder() =>
      AdminSettlementsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSettlementsDtoOutput &&
        payoutDay == other.payoutDay &&
        payoutWeekday == other.payoutWeekday &&
        policy == other.policy &&
        captains == other.captains;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, payoutDay.hashCode);
    _$hash = $jc(_$hash, payoutWeekday.hashCode);
    _$hash = $jc(_$hash, policy.hashCode);
    _$hash = $jc(_$hash, captains.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSettlementsDtoOutput')
          ..add('payoutDay', payoutDay)
          ..add('payoutWeekday', payoutWeekday)
          ..add('policy', policy)
          ..add('captains', captains))
        .toString();
  }
}

class AdminSettlementsDtoOutputBuilder
    implements
        Builder<AdminSettlementsDtoOutput, AdminSettlementsDtoOutputBuilder> {
  _$AdminSettlementsDtoOutput? _$v;

  bool? _payoutDay;
  bool? get payoutDay => _$this._payoutDay;
  set payoutDay(bool? payoutDay) => _$this._payoutDay = payoutDay;

  AdminSettlementsDtoOutputPayoutWeekdayEnum? _payoutWeekday;
  AdminSettlementsDtoOutputPayoutWeekdayEnum? get payoutWeekday =>
      _$this._payoutWeekday;
  set payoutWeekday(
    AdminSettlementsDtoOutputPayoutWeekdayEnum? payoutWeekday,
  ) => _$this._payoutWeekday = payoutWeekday;

  AdminSettlementsDtoOutputPolicyEnum? _policy;
  AdminSettlementsDtoOutputPolicyEnum? get policy => _$this._policy;
  set policy(AdminSettlementsDtoOutputPolicyEnum? policy) =>
      _$this._policy = policy;

  ListBuilder<AdminCaptainBalancesDtoOutputCaptainsInner>? _captains;
  ListBuilder<AdminCaptainBalancesDtoOutputCaptainsInner> get captains =>
      _$this._captains ??=
          ListBuilder<AdminCaptainBalancesDtoOutputCaptainsInner>();
  set captains(
    ListBuilder<AdminCaptainBalancesDtoOutputCaptainsInner>? captains,
  ) => _$this._captains = captains;

  AdminSettlementsDtoOutputBuilder() {
    AdminSettlementsDtoOutput._defaults(this);
  }

  AdminSettlementsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _payoutDay = $v.payoutDay;
      _payoutWeekday = $v.payoutWeekday;
      _policy = $v.policy;
      _captains = $v.captains.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSettlementsDtoOutput other) {
    _$v = other as _$AdminSettlementsDtoOutput;
  }

  @override
  void update(void Function(AdminSettlementsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSettlementsDtoOutput build() => _build();

  _$AdminSettlementsDtoOutput _build() {
    _$AdminSettlementsDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminSettlementsDtoOutput._(
            payoutDay: BuiltValueNullFieldError.checkNotNull(
              payoutDay,
              r'AdminSettlementsDtoOutput',
              'payoutDay',
            ),
            payoutWeekday: BuiltValueNullFieldError.checkNotNull(
              payoutWeekday,
              r'AdminSettlementsDtoOutput',
              'payoutWeekday',
            ),
            policy: BuiltValueNullFieldError.checkNotNull(
              policy,
              r'AdminSettlementsDtoOutput',
              'policy',
            ),
            captains: captains.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'captains';
        captains.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminSettlementsDtoOutput',
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
