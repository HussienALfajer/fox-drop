// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_availability_dto_output_availability_one_of1.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainAvailabilityDtoOutputAvailabilityOneOf1StateEnum
_$captainAvailabilityDtoOutputAvailabilityOneOf1StateEnum_onlineAvailable =
    const CaptainAvailabilityDtoOutputAvailabilityOneOf1StateEnum._(
      'onlineAvailable',
    );

CaptainAvailabilityDtoOutputAvailabilityOneOf1StateEnum
_$captainAvailabilityDtoOutputAvailabilityOneOf1StateEnumValueOf(String name) {
  switch (name) {
    case 'onlineAvailable':
      return _$captainAvailabilityDtoOutputAvailabilityOneOf1StateEnum_onlineAvailable;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainAvailabilityDtoOutputAvailabilityOneOf1StateEnum>
_$captainAvailabilityDtoOutputAvailabilityOneOf1StateEnumValues =
    BuiltSet<CaptainAvailabilityDtoOutputAvailabilityOneOf1StateEnum>(const <
      CaptainAvailabilityDtoOutputAvailabilityOneOf1StateEnum
    >[
      _$captainAvailabilityDtoOutputAvailabilityOneOf1StateEnum_onlineAvailable,
    ]);

Serializer<CaptainAvailabilityDtoOutputAvailabilityOneOf1StateEnum>
_$captainAvailabilityDtoOutputAvailabilityOneOf1StateEnumSerializer =
    _$CaptainAvailabilityDtoOutputAvailabilityOneOf1StateEnumSerializer();

class _$CaptainAvailabilityDtoOutputAvailabilityOneOf1StateEnumSerializer
    implements
        PrimitiveSerializer<
          CaptainAvailabilityDtoOutputAvailabilityOneOf1StateEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'onlineAvailable': 'online_available',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'online_available': 'onlineAvailable',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CaptainAvailabilityDtoOutputAvailabilityOneOf1StateEnum,
  ];
  @override
  final String wireName =
      'CaptainAvailabilityDtoOutputAvailabilityOneOf1StateEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainAvailabilityDtoOutputAvailabilityOneOf1StateEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainAvailabilityDtoOutputAvailabilityOneOf1StateEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainAvailabilityDtoOutputAvailabilityOneOf1StateEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainAvailabilityDtoOutputAvailabilityOneOf1
    extends CaptainAvailabilityDtoOutputAvailabilityOneOf1 {
  @override
  final CaptainAvailabilityDtoOutputAvailabilityOneOf1StateEnum state;
  @override
  final DateTime since;

  factory _$CaptainAvailabilityDtoOutputAvailabilityOneOf1([
    void Function(CaptainAvailabilityDtoOutputAvailabilityOneOf1Builder)?
    updates,
  ]) =>
      (CaptainAvailabilityDtoOutputAvailabilityOneOf1Builder()..update(updates))
          ._build();

  _$CaptainAvailabilityDtoOutputAvailabilityOneOf1._({
    required this.state,
    required this.since,
  }) : super._();
  @override
  CaptainAvailabilityDtoOutputAvailabilityOneOf1 rebuild(
    void Function(CaptainAvailabilityDtoOutputAvailabilityOneOf1Builder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainAvailabilityDtoOutputAvailabilityOneOf1Builder toBuilder() =>
      CaptainAvailabilityDtoOutputAvailabilityOneOf1Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainAvailabilityDtoOutputAvailabilityOneOf1 &&
        state == other.state &&
        since == other.since;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, since.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainAvailabilityDtoOutputAvailabilityOneOf1',
          )
          ..add('state', state)
          ..add('since', since))
        .toString();
  }
}

class CaptainAvailabilityDtoOutputAvailabilityOneOf1Builder
    implements
        Builder<
          CaptainAvailabilityDtoOutputAvailabilityOneOf1,
          CaptainAvailabilityDtoOutputAvailabilityOneOf1Builder
        > {
  _$CaptainAvailabilityDtoOutputAvailabilityOneOf1? _$v;

  CaptainAvailabilityDtoOutputAvailabilityOneOf1StateEnum? _state;
  CaptainAvailabilityDtoOutputAvailabilityOneOf1StateEnum? get state =>
      _$this._state;
  set state(CaptainAvailabilityDtoOutputAvailabilityOneOf1StateEnum? state) =>
      _$this._state = state;

  DateTime? _since;
  DateTime? get since => _$this._since;
  set since(DateTime? since) => _$this._since = since;

  CaptainAvailabilityDtoOutputAvailabilityOneOf1Builder() {
    CaptainAvailabilityDtoOutputAvailabilityOneOf1._defaults(this);
  }

  CaptainAvailabilityDtoOutputAvailabilityOneOf1Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _state = $v.state;
      _since = $v.since;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainAvailabilityDtoOutputAvailabilityOneOf1 other) {
    _$v = other as _$CaptainAvailabilityDtoOutputAvailabilityOneOf1;
  }

  @override
  void update(
    void Function(CaptainAvailabilityDtoOutputAvailabilityOneOf1Builder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainAvailabilityDtoOutputAvailabilityOneOf1 build() => _build();

  _$CaptainAvailabilityDtoOutputAvailabilityOneOf1 _build() {
    final _$result =
        _$v ??
        _$CaptainAvailabilityDtoOutputAvailabilityOneOf1._(
          state: BuiltValueNullFieldError.checkNotNull(
            state,
            r'CaptainAvailabilityDtoOutputAvailabilityOneOf1',
            'state',
          ),
          since: BuiltValueNullFieldError.checkNotNull(
            since,
            r'CaptainAvailabilityDtoOutputAvailabilityOneOf1',
            'since',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
