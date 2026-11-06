// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_availability_dto_output_availability_one_of2.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainAvailabilityDtoOutputAvailabilityOneOf2StateEnum
_$captainAvailabilityDtoOutputAvailabilityOneOf2StateEnum_notReceivingOffers =
    const CaptainAvailabilityDtoOutputAvailabilityOneOf2StateEnum._(
      'notReceivingOffers',
    );

CaptainAvailabilityDtoOutputAvailabilityOneOf2StateEnum
_$captainAvailabilityDtoOutputAvailabilityOneOf2StateEnumValueOf(String name) {
  switch (name) {
    case 'notReceivingOffers':
      return _$captainAvailabilityDtoOutputAvailabilityOneOf2StateEnum_notReceivingOffers;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainAvailabilityDtoOutputAvailabilityOneOf2StateEnum>
_$captainAvailabilityDtoOutputAvailabilityOneOf2StateEnumValues =
    BuiltSet<CaptainAvailabilityDtoOutputAvailabilityOneOf2StateEnum>(const <
      CaptainAvailabilityDtoOutputAvailabilityOneOf2StateEnum
    >[
      _$captainAvailabilityDtoOutputAvailabilityOneOf2StateEnum_notReceivingOffers,
    ]);

const CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum
_$captainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum_cashLimit =
    const CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum._(
      'cashLimit',
    );
const CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum
_$captainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum_closedDue =
    const CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum._(
      'closedDue',
    );
const CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum
_$captainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum_simulatedLocation =
    const CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum._(
      'simulatedLocation',
    );

CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum
_$captainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnumValueOf(
  String name,
) {
  switch (name) {
    case 'cashLimit':
      return _$captainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum_cashLimit;
    case 'closedDue':
      return _$captainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum_closedDue;
    case 'simulatedLocation':
      return _$captainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum_simulatedLocation;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum>
_$captainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnumValues =
    BuiltSet<CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum>(const <
      CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum
    >[
      _$captainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum_cashLimit,
      _$captainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum_closedDue,
      _$captainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum_simulatedLocation,
    ]);

Serializer<CaptainAvailabilityDtoOutputAvailabilityOneOf2StateEnum>
_$captainAvailabilityDtoOutputAvailabilityOneOf2StateEnumSerializer =
    _$CaptainAvailabilityDtoOutputAvailabilityOneOf2StateEnumSerializer();
Serializer<CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum>
_$captainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnumSerializer =
    _$CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnumSerializer();

class _$CaptainAvailabilityDtoOutputAvailabilityOneOf2StateEnumSerializer
    implements
        PrimitiveSerializer<
          CaptainAvailabilityDtoOutputAvailabilityOneOf2StateEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'notReceivingOffers': 'not_receiving_offers',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'not_receiving_offers': 'notReceivingOffers',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CaptainAvailabilityDtoOutputAvailabilityOneOf2StateEnum,
  ];
  @override
  final String wireName =
      'CaptainAvailabilityDtoOutputAvailabilityOneOf2StateEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainAvailabilityDtoOutputAvailabilityOneOf2StateEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainAvailabilityDtoOutputAvailabilityOneOf2StateEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainAvailabilityDtoOutputAvailabilityOneOf2StateEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnumSerializer
    implements
        PrimitiveSerializer<
          CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum
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
    CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum,
  ];
  @override
  final String wireName =
      'CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainAvailabilityDtoOutputAvailabilityOneOf2
    extends CaptainAvailabilityDtoOutputAvailabilityOneOf2 {
  @override
  final CaptainAvailabilityDtoOutputAvailabilityOneOf2StateEnum state;
  @override
  final DateTime since;
  @override
  final BuiltList<CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum>
  reasons;

  factory _$CaptainAvailabilityDtoOutputAvailabilityOneOf2([
    void Function(CaptainAvailabilityDtoOutputAvailabilityOneOf2Builder)?
    updates,
  ]) =>
      (CaptainAvailabilityDtoOutputAvailabilityOneOf2Builder()..update(updates))
          ._build();

  _$CaptainAvailabilityDtoOutputAvailabilityOneOf2._({
    required this.state,
    required this.since,
    required this.reasons,
  }) : super._();
  @override
  CaptainAvailabilityDtoOutputAvailabilityOneOf2 rebuild(
    void Function(CaptainAvailabilityDtoOutputAvailabilityOneOf2Builder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainAvailabilityDtoOutputAvailabilityOneOf2Builder toBuilder() =>
      CaptainAvailabilityDtoOutputAvailabilityOneOf2Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainAvailabilityDtoOutputAvailabilityOneOf2 &&
        state == other.state &&
        since == other.since &&
        reasons == other.reasons;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, since.hashCode);
    _$hash = $jc(_$hash, reasons.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainAvailabilityDtoOutputAvailabilityOneOf2',
          )
          ..add('state', state)
          ..add('since', since)
          ..add('reasons', reasons))
        .toString();
  }
}

class CaptainAvailabilityDtoOutputAvailabilityOneOf2Builder
    implements
        Builder<
          CaptainAvailabilityDtoOutputAvailabilityOneOf2,
          CaptainAvailabilityDtoOutputAvailabilityOneOf2Builder
        > {
  _$CaptainAvailabilityDtoOutputAvailabilityOneOf2? _$v;

  CaptainAvailabilityDtoOutputAvailabilityOneOf2StateEnum? _state;
  CaptainAvailabilityDtoOutputAvailabilityOneOf2StateEnum? get state =>
      _$this._state;
  set state(CaptainAvailabilityDtoOutputAvailabilityOneOf2StateEnum? state) =>
      _$this._state = state;

  DateTime? _since;
  DateTime? get since => _$this._since;
  set since(DateTime? since) => _$this._since = since;

  ListBuilder<CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum>?
  _reasons;
  ListBuilder<CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum>
  get reasons => _$this._reasons ??=
      ListBuilder<CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum>();
  set reasons(
    ListBuilder<CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum>?
    reasons,
  ) => _$this._reasons = reasons;

  CaptainAvailabilityDtoOutputAvailabilityOneOf2Builder() {
    CaptainAvailabilityDtoOutputAvailabilityOneOf2._defaults(this);
  }

  CaptainAvailabilityDtoOutputAvailabilityOneOf2Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _state = $v.state;
      _since = $v.since;
      _reasons = $v.reasons.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainAvailabilityDtoOutputAvailabilityOneOf2 other) {
    _$v = other as _$CaptainAvailabilityDtoOutputAvailabilityOneOf2;
  }

  @override
  void update(
    void Function(CaptainAvailabilityDtoOutputAvailabilityOneOf2Builder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainAvailabilityDtoOutputAvailabilityOneOf2 build() => _build();

  _$CaptainAvailabilityDtoOutputAvailabilityOneOf2 _build() {
    _$CaptainAvailabilityDtoOutputAvailabilityOneOf2 _$result;
    try {
      _$result =
          _$v ??
          _$CaptainAvailabilityDtoOutputAvailabilityOneOf2._(
            state: BuiltValueNullFieldError.checkNotNull(
              state,
              r'CaptainAvailabilityDtoOutputAvailabilityOneOf2',
              'state',
            ),
            since: BuiltValueNullFieldError.checkNotNull(
              since,
              r'CaptainAvailabilityDtoOutputAvailabilityOneOf2',
              'since',
            ),
            reasons: reasons.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'reasons';
        reasons.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainAvailabilityDtoOutputAvailabilityOneOf2',
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
