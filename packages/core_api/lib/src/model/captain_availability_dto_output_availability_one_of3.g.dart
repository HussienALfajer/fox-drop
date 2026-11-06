// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_availability_dto_output_availability_one_of3.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainAvailabilityDtoOutputAvailabilityOneOf3StateEnum
_$captainAvailabilityDtoOutputAvailabilityOneOf3StateEnum_suspended =
    const CaptainAvailabilityDtoOutputAvailabilityOneOf3StateEnum._(
      'suspended',
    );

CaptainAvailabilityDtoOutputAvailabilityOneOf3StateEnum
_$captainAvailabilityDtoOutputAvailabilityOneOf3StateEnumValueOf(String name) {
  switch (name) {
    case 'suspended':
      return _$captainAvailabilityDtoOutputAvailabilityOneOf3StateEnum_suspended;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainAvailabilityDtoOutputAvailabilityOneOf3StateEnum>
_$captainAvailabilityDtoOutputAvailabilityOneOf3StateEnumValues =
    BuiltSet<CaptainAvailabilityDtoOutputAvailabilityOneOf3StateEnum>(
      const <CaptainAvailabilityDtoOutputAvailabilityOneOf3StateEnum>[
        _$captainAvailabilityDtoOutputAvailabilityOneOf3StateEnum_suspended,
      ],
    );

Serializer<CaptainAvailabilityDtoOutputAvailabilityOneOf3StateEnum>
_$captainAvailabilityDtoOutputAvailabilityOneOf3StateEnumSerializer =
    _$CaptainAvailabilityDtoOutputAvailabilityOneOf3StateEnumSerializer();

class _$CaptainAvailabilityDtoOutputAvailabilityOneOf3StateEnumSerializer
    implements
        PrimitiveSerializer<
          CaptainAvailabilityDtoOutputAvailabilityOneOf3StateEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'suspended': 'suspended',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'suspended': 'suspended',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CaptainAvailabilityDtoOutputAvailabilityOneOf3StateEnum,
  ];
  @override
  final String wireName =
      'CaptainAvailabilityDtoOutputAvailabilityOneOf3StateEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainAvailabilityDtoOutputAvailabilityOneOf3StateEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainAvailabilityDtoOutputAvailabilityOneOf3StateEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainAvailabilityDtoOutputAvailabilityOneOf3StateEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainAvailabilityDtoOutputAvailabilityOneOf3
    extends CaptainAvailabilityDtoOutputAvailabilityOneOf3 {
  @override
  final CaptainAvailabilityDtoOutputAvailabilityOneOf3StateEnum state;
  @override
  final String reason;
  @override
  final DateTime? until;

  factory _$CaptainAvailabilityDtoOutputAvailabilityOneOf3([
    void Function(CaptainAvailabilityDtoOutputAvailabilityOneOf3Builder)?
    updates,
  ]) =>
      (CaptainAvailabilityDtoOutputAvailabilityOneOf3Builder()..update(updates))
          ._build();

  _$CaptainAvailabilityDtoOutputAvailabilityOneOf3._({
    required this.state,
    required this.reason,
    this.until,
  }) : super._();
  @override
  CaptainAvailabilityDtoOutputAvailabilityOneOf3 rebuild(
    void Function(CaptainAvailabilityDtoOutputAvailabilityOneOf3Builder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainAvailabilityDtoOutputAvailabilityOneOf3Builder toBuilder() =>
      CaptainAvailabilityDtoOutputAvailabilityOneOf3Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainAvailabilityDtoOutputAvailabilityOneOf3 &&
        state == other.state &&
        reason == other.reason &&
        until == other.until;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, until.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainAvailabilityDtoOutputAvailabilityOneOf3',
          )
          ..add('state', state)
          ..add('reason', reason)
          ..add('until', until))
        .toString();
  }
}

class CaptainAvailabilityDtoOutputAvailabilityOneOf3Builder
    implements
        Builder<
          CaptainAvailabilityDtoOutputAvailabilityOneOf3,
          CaptainAvailabilityDtoOutputAvailabilityOneOf3Builder
        > {
  _$CaptainAvailabilityDtoOutputAvailabilityOneOf3? _$v;

  CaptainAvailabilityDtoOutputAvailabilityOneOf3StateEnum? _state;
  CaptainAvailabilityDtoOutputAvailabilityOneOf3StateEnum? get state =>
      _$this._state;
  set state(CaptainAvailabilityDtoOutputAvailabilityOneOf3StateEnum? state) =>
      _$this._state = state;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DateTime? _until;
  DateTime? get until => _$this._until;
  set until(DateTime? until) => _$this._until = until;

  CaptainAvailabilityDtoOutputAvailabilityOneOf3Builder() {
    CaptainAvailabilityDtoOutputAvailabilityOneOf3._defaults(this);
  }

  CaptainAvailabilityDtoOutputAvailabilityOneOf3Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _state = $v.state;
      _reason = $v.reason;
      _until = $v.until;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainAvailabilityDtoOutputAvailabilityOneOf3 other) {
    _$v = other as _$CaptainAvailabilityDtoOutputAvailabilityOneOf3;
  }

  @override
  void update(
    void Function(CaptainAvailabilityDtoOutputAvailabilityOneOf3Builder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainAvailabilityDtoOutputAvailabilityOneOf3 build() => _build();

  _$CaptainAvailabilityDtoOutputAvailabilityOneOf3 _build() {
    final _$result =
        _$v ??
        _$CaptainAvailabilityDtoOutputAvailabilityOneOf3._(
          state: BuiltValueNullFieldError.checkNotNull(
            state,
            r'CaptainAvailabilityDtoOutputAvailabilityOneOf3',
            'state',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'CaptainAvailabilityDtoOutputAvailabilityOneOf3',
            'reason',
          ),
          until: until,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
