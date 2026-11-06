// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_availability_dto_output_availability_one_of.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainAvailabilityDtoOutputAvailabilityOneOfStateEnum
_$captainAvailabilityDtoOutputAvailabilityOneOfStateEnum_offline =
    const CaptainAvailabilityDtoOutputAvailabilityOneOfStateEnum._('offline');

CaptainAvailabilityDtoOutputAvailabilityOneOfStateEnum
_$captainAvailabilityDtoOutputAvailabilityOneOfStateEnumValueOf(String name) {
  switch (name) {
    case 'offline':
      return _$captainAvailabilityDtoOutputAvailabilityOneOfStateEnum_offline;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainAvailabilityDtoOutputAvailabilityOneOfStateEnum>
_$captainAvailabilityDtoOutputAvailabilityOneOfStateEnumValues =
    BuiltSet<CaptainAvailabilityDtoOutputAvailabilityOneOfStateEnum>(
      const <CaptainAvailabilityDtoOutputAvailabilityOneOfStateEnum>[
        _$captainAvailabilityDtoOutputAvailabilityOneOfStateEnum_offline,
      ],
    );

Serializer<CaptainAvailabilityDtoOutputAvailabilityOneOfStateEnum>
_$captainAvailabilityDtoOutputAvailabilityOneOfStateEnumSerializer =
    _$CaptainAvailabilityDtoOutputAvailabilityOneOfStateEnumSerializer();

class _$CaptainAvailabilityDtoOutputAvailabilityOneOfStateEnumSerializer
    implements
        PrimitiveSerializer<
          CaptainAvailabilityDtoOutputAvailabilityOneOfStateEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'offline': 'offline',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'offline': 'offline',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CaptainAvailabilityDtoOutputAvailabilityOneOfStateEnum,
  ];
  @override
  final String wireName =
      'CaptainAvailabilityDtoOutputAvailabilityOneOfStateEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainAvailabilityDtoOutputAvailabilityOneOfStateEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainAvailabilityDtoOutputAvailabilityOneOfStateEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainAvailabilityDtoOutputAvailabilityOneOfStateEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainAvailabilityDtoOutputAvailabilityOneOf
    extends CaptainAvailabilityDtoOutputAvailabilityOneOf {
  @override
  final CaptainAvailabilityDtoOutputAvailabilityOneOfStateEnum state;

  factory _$CaptainAvailabilityDtoOutputAvailabilityOneOf([
    void Function(CaptainAvailabilityDtoOutputAvailabilityOneOfBuilder)?
    updates,
  ]) =>
      (CaptainAvailabilityDtoOutputAvailabilityOneOfBuilder()..update(updates))
          ._build();

  _$CaptainAvailabilityDtoOutputAvailabilityOneOf._({required this.state})
    : super._();
  @override
  CaptainAvailabilityDtoOutputAvailabilityOneOf rebuild(
    void Function(CaptainAvailabilityDtoOutputAvailabilityOneOfBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainAvailabilityDtoOutputAvailabilityOneOfBuilder toBuilder() =>
      CaptainAvailabilityDtoOutputAvailabilityOneOfBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainAvailabilityDtoOutputAvailabilityOneOf &&
        state == other.state;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CaptainAvailabilityDtoOutputAvailabilityOneOf',
    )..add('state', state)).toString();
  }
}

class CaptainAvailabilityDtoOutputAvailabilityOneOfBuilder
    implements
        Builder<
          CaptainAvailabilityDtoOutputAvailabilityOneOf,
          CaptainAvailabilityDtoOutputAvailabilityOneOfBuilder
        > {
  _$CaptainAvailabilityDtoOutputAvailabilityOneOf? _$v;

  CaptainAvailabilityDtoOutputAvailabilityOneOfStateEnum? _state;
  CaptainAvailabilityDtoOutputAvailabilityOneOfStateEnum? get state =>
      _$this._state;
  set state(CaptainAvailabilityDtoOutputAvailabilityOneOfStateEnum? state) =>
      _$this._state = state;

  CaptainAvailabilityDtoOutputAvailabilityOneOfBuilder() {
    CaptainAvailabilityDtoOutputAvailabilityOneOf._defaults(this);
  }

  CaptainAvailabilityDtoOutputAvailabilityOneOfBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _state = $v.state;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainAvailabilityDtoOutputAvailabilityOneOf other) {
    _$v = other as _$CaptainAvailabilityDtoOutputAvailabilityOneOf;
  }

  @override
  void update(
    void Function(CaptainAvailabilityDtoOutputAvailabilityOneOfBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainAvailabilityDtoOutputAvailabilityOneOf build() => _build();

  _$CaptainAvailabilityDtoOutputAvailabilityOneOf _build() {
    final _$result =
        _$v ??
        _$CaptainAvailabilityDtoOutputAvailabilityOneOf._(
          state: BuiltValueNullFieldError.checkNotNull(
            state,
            r'CaptainAvailabilityDtoOutputAvailabilityOneOf',
            'state',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
