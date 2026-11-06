// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_availability_dto_output_availability.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainAvailabilityDtoOutputAvailabilityStateEnum
_$captainAvailabilityDtoOutputAvailabilityStateEnum_suspended =
    const CaptainAvailabilityDtoOutputAvailabilityStateEnum._('suspended');

CaptainAvailabilityDtoOutputAvailabilityStateEnum
_$captainAvailabilityDtoOutputAvailabilityStateEnumValueOf(String name) {
  switch (name) {
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
    'suspended': 'suspended',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
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
  final OneOf oneOf;

  factory _$CaptainAvailabilityDtoOutputAvailability([
    void Function(CaptainAvailabilityDtoOutputAvailabilityBuilder)? updates,
  ]) => (CaptainAvailabilityDtoOutputAvailabilityBuilder()..update(updates))
      ._build();

  _$CaptainAvailabilityDtoOutputAvailability._({required this.oneOf})
    : super._();
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
        oneOf == other.oneOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, oneOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CaptainAvailabilityDtoOutputAvailability',
    )..add('oneOf', oneOf)).toString();
  }
}

class CaptainAvailabilityDtoOutputAvailabilityBuilder
    implements
        Builder<
          CaptainAvailabilityDtoOutputAvailability,
          CaptainAvailabilityDtoOutputAvailabilityBuilder
        > {
  _$CaptainAvailabilityDtoOutputAvailability? _$v;

  OneOf? _oneOf;
  OneOf? get oneOf => _$this._oneOf;
  set oneOf(OneOf? oneOf) => _$this._oneOf = oneOf;

  CaptainAvailabilityDtoOutputAvailabilityBuilder() {
    CaptainAvailabilityDtoOutputAvailability._defaults(this);
  }

  CaptainAvailabilityDtoOutputAvailabilityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _oneOf = $v.oneOf;
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
    final _$result =
        _$v ??
        _$CaptainAvailabilityDtoOutputAvailability._(
          oneOf: BuiltValueNullFieldError.checkNotNull(
            oneOf,
            r'CaptainAvailabilityDtoOutputAvailability',
            'oneOf',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
