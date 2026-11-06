// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_availability_dto_output_availability.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainAvailabilityDtoOutputAvailabilityStateEnum
_$captainAvailabilityDtoOutputAvailabilityStateEnum_offline =
    const CaptainAvailabilityDtoOutputAvailabilityStateEnum._('offline');
const CaptainAvailabilityDtoOutputAvailabilityStateEnum
_$captainAvailabilityDtoOutputAvailabilityStateEnum_onlineAvailable =
    const CaptainAvailabilityDtoOutputAvailabilityStateEnum._(
      'onlineAvailable',
    );
const CaptainAvailabilityDtoOutputAvailabilityStateEnum
_$captainAvailabilityDtoOutputAvailabilityStateEnum_notReceivingOffers =
    const CaptainAvailabilityDtoOutputAvailabilityStateEnum._(
      'notReceivingOffers',
    );
const CaptainAvailabilityDtoOutputAvailabilityStateEnum
_$captainAvailabilityDtoOutputAvailabilityStateEnum_suspended =
    const CaptainAvailabilityDtoOutputAvailabilityStateEnum._('suspended');

CaptainAvailabilityDtoOutputAvailabilityStateEnum
_$captainAvailabilityDtoOutputAvailabilityStateEnumValueOf(String name) {
  switch (name) {
    case 'offline':
      return _$captainAvailabilityDtoOutputAvailabilityStateEnum_offline;
    case 'onlineAvailable':
      return _$captainAvailabilityDtoOutputAvailabilityStateEnum_onlineAvailable;
    case 'notReceivingOffers':
      return _$captainAvailabilityDtoOutputAvailabilityStateEnum_notReceivingOffers;
    case 'suspended':
      return _$captainAvailabilityDtoOutputAvailabilityStateEnum_suspended;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainAvailabilityDtoOutputAvailabilityStateEnum>
_$captainAvailabilityDtoOutputAvailabilityStateEnumValues =
    BuiltSet<CaptainAvailabilityDtoOutputAvailabilityStateEnum>(
      const <CaptainAvailabilityDtoOutputAvailabilityStateEnum>[
        _$captainAvailabilityDtoOutputAvailabilityStateEnum_offline,
        _$captainAvailabilityDtoOutputAvailabilityStateEnum_onlineAvailable,
        _$captainAvailabilityDtoOutputAvailabilityStateEnum_notReceivingOffers,
        _$captainAvailabilityDtoOutputAvailabilityStateEnum_suspended,
      ],
    );

const CaptainAvailabilityDtoOutputAvailabilityReasonsEnum
_$captainAvailabilityDtoOutputAvailabilityReasonsEnum_cashLimit =
    const CaptainAvailabilityDtoOutputAvailabilityReasonsEnum._('cashLimit');
const CaptainAvailabilityDtoOutputAvailabilityReasonsEnum
_$captainAvailabilityDtoOutputAvailabilityReasonsEnum_closedDue =
    const CaptainAvailabilityDtoOutputAvailabilityReasonsEnum._('closedDue');
const CaptainAvailabilityDtoOutputAvailabilityReasonsEnum
_$captainAvailabilityDtoOutputAvailabilityReasonsEnum_simulatedLocation =
    const CaptainAvailabilityDtoOutputAvailabilityReasonsEnum._(
      'simulatedLocation',
    );

CaptainAvailabilityDtoOutputAvailabilityReasonsEnum
_$captainAvailabilityDtoOutputAvailabilityReasonsEnumValueOf(String name) {
  switch (name) {
    case 'cashLimit':
      return _$captainAvailabilityDtoOutputAvailabilityReasonsEnum_cashLimit;
    case 'closedDue':
      return _$captainAvailabilityDtoOutputAvailabilityReasonsEnum_closedDue;
    case 'simulatedLocation':
      return _$captainAvailabilityDtoOutputAvailabilityReasonsEnum_simulatedLocation;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainAvailabilityDtoOutputAvailabilityReasonsEnum>
_$captainAvailabilityDtoOutputAvailabilityReasonsEnumValues =
    BuiltSet<CaptainAvailabilityDtoOutputAvailabilityReasonsEnum>(
      const <CaptainAvailabilityDtoOutputAvailabilityReasonsEnum>[
        _$captainAvailabilityDtoOutputAvailabilityReasonsEnum_cashLimit,
        _$captainAvailabilityDtoOutputAvailabilityReasonsEnum_closedDue,
        _$captainAvailabilityDtoOutputAvailabilityReasonsEnum_simulatedLocation,
      ],
    );

Serializer<CaptainAvailabilityDtoOutputAvailabilityStateEnum>
_$captainAvailabilityDtoOutputAvailabilityStateEnumSerializer =
    _$CaptainAvailabilityDtoOutputAvailabilityStateEnumSerializer();
Serializer<CaptainAvailabilityDtoOutputAvailabilityReasonsEnum>
_$captainAvailabilityDtoOutputAvailabilityReasonsEnumSerializer =
    _$CaptainAvailabilityDtoOutputAvailabilityReasonsEnumSerializer();

class _$CaptainAvailabilityDtoOutputAvailabilityStateEnumSerializer
    implements
        PrimitiveSerializer<CaptainAvailabilityDtoOutputAvailabilityStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'offline': 'offline',
    'onlineAvailable': 'online_available',
    'notReceivingOffers': 'not_receiving_offers',
    'suspended': 'suspended',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'offline': 'offline',
    'online_available': 'onlineAvailable',
    'not_receiving_offers': 'notReceivingOffers',
    'suspended': 'suspended',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CaptainAvailabilityDtoOutputAvailabilityStateEnum,
  ];
  @override
  final String wireName = 'CaptainAvailabilityDtoOutputAvailabilityStateEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainAvailabilityDtoOutputAvailabilityStateEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainAvailabilityDtoOutputAvailabilityStateEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainAvailabilityDtoOutputAvailabilityStateEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainAvailabilityDtoOutputAvailabilityReasonsEnumSerializer
    implements
        PrimitiveSerializer<
          CaptainAvailabilityDtoOutputAvailabilityReasonsEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'cashLimit': 'cash_limit',
    'closedDue': 'closed_due',
    'simulatedLocation': 'simulated_location',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'cash_limit': 'cashLimit',
    'closed_due': 'closedDue',
    'simulated_location': 'simulatedLocation',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CaptainAvailabilityDtoOutputAvailabilityReasonsEnum,
  ];
  @override
  final String wireName = 'CaptainAvailabilityDtoOutputAvailabilityReasonsEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainAvailabilityDtoOutputAvailabilityReasonsEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainAvailabilityDtoOutputAvailabilityReasonsEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainAvailabilityDtoOutputAvailabilityReasonsEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainAvailabilityDtoOutputAvailability
    extends CaptainAvailabilityDtoOutputAvailability {
  @override
  final CaptainAvailabilityDtoOutputAvailabilityStateEnum state;
  @override
  final DateTime? since;
  @override
  final BuiltList<CaptainAvailabilityDtoOutputAvailabilityReasonsEnum> reasons;
  @override
  final String? suspensionReason;
  @override
  final DateTime? suspendedUntil;

  factory _$CaptainAvailabilityDtoOutputAvailability([
    void Function(CaptainAvailabilityDtoOutputAvailabilityBuilder)? updates,
  ]) => (CaptainAvailabilityDtoOutputAvailabilityBuilder()..update(updates))
      ._build();

  _$CaptainAvailabilityDtoOutputAvailability._({
    required this.state,
    this.since,
    required this.reasons,
    this.suspensionReason,
    this.suspendedUntil,
  }) : super._();
  @override
  CaptainAvailabilityDtoOutputAvailability rebuild(
    void Function(CaptainAvailabilityDtoOutputAvailabilityBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainAvailabilityDtoOutputAvailabilityBuilder toBuilder() =>
      CaptainAvailabilityDtoOutputAvailabilityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainAvailabilityDtoOutputAvailability &&
        state == other.state &&
        since == other.since &&
        reasons == other.reasons &&
        suspensionReason == other.suspensionReason &&
        suspendedUntil == other.suspendedUntil;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, since.hashCode);
    _$hash = $jc(_$hash, reasons.hashCode);
    _$hash = $jc(_$hash, suspensionReason.hashCode);
    _$hash = $jc(_$hash, suspendedUntil.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainAvailabilityDtoOutputAvailability',
          )
          ..add('state', state)
          ..add('since', since)
          ..add('reasons', reasons)
          ..add('suspensionReason', suspensionReason)
          ..add('suspendedUntil', suspendedUntil))
        .toString();
  }
}

class CaptainAvailabilityDtoOutputAvailabilityBuilder
    implements
        Builder<
          CaptainAvailabilityDtoOutputAvailability,
          CaptainAvailabilityDtoOutputAvailabilityBuilder
        > {
  _$CaptainAvailabilityDtoOutputAvailability? _$v;

  CaptainAvailabilityDtoOutputAvailabilityStateEnum? _state;
  CaptainAvailabilityDtoOutputAvailabilityStateEnum? get state => _$this._state;
  set state(CaptainAvailabilityDtoOutputAvailabilityStateEnum? state) =>
      _$this._state = state;

  DateTime? _since;
  DateTime? get since => _$this._since;
  set since(DateTime? since) => _$this._since = since;

  ListBuilder<CaptainAvailabilityDtoOutputAvailabilityReasonsEnum>? _reasons;
  ListBuilder<CaptainAvailabilityDtoOutputAvailabilityReasonsEnum>
  get reasons => _$this._reasons ??=
      ListBuilder<CaptainAvailabilityDtoOutputAvailabilityReasonsEnum>();
  set reasons(
    ListBuilder<CaptainAvailabilityDtoOutputAvailabilityReasonsEnum>? reasons,
  ) => _$this._reasons = reasons;

  String? _suspensionReason;
  String? get suspensionReason => _$this._suspensionReason;
  set suspensionReason(String? suspensionReason) =>
      _$this._suspensionReason = suspensionReason;

  DateTime? _suspendedUntil;
  DateTime? get suspendedUntil => _$this._suspendedUntil;
  set suspendedUntil(DateTime? suspendedUntil) =>
      _$this._suspendedUntil = suspendedUntil;

  CaptainAvailabilityDtoOutputAvailabilityBuilder() {
    CaptainAvailabilityDtoOutputAvailability._defaults(this);
  }

  CaptainAvailabilityDtoOutputAvailabilityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _state = $v.state;
      _since = $v.since;
      _reasons = $v.reasons.toBuilder();
      _suspensionReason = $v.suspensionReason;
      _suspendedUntil = $v.suspendedUntil;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainAvailabilityDtoOutputAvailability other) {
    _$v = other as _$CaptainAvailabilityDtoOutputAvailability;
  }

  @override
  void update(
    void Function(CaptainAvailabilityDtoOutputAvailabilityBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainAvailabilityDtoOutputAvailability build() => _build();

  _$CaptainAvailabilityDtoOutputAvailability _build() {
    _$CaptainAvailabilityDtoOutputAvailability _$result;
    try {
      _$result =
          _$v ??
          _$CaptainAvailabilityDtoOutputAvailability._(
            state: BuiltValueNullFieldError.checkNotNull(
              state,
              r'CaptainAvailabilityDtoOutputAvailability',
              'state',
            ),
            since: since,
            reasons: reasons.build(),
            suspensionReason: suspensionReason,
            suspendedUntil: suspendedUntil,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'reasons';
        reasons.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainAvailabilityDtoOutputAvailability',
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
