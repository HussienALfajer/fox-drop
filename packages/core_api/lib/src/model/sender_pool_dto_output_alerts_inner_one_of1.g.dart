// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sender_pool_dto_output_alerts_inner_one_of1.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SenderPoolDtoOutputAlertsInnerOneOf1TypeEnum
_$senderPoolDtoOutputAlertsInnerOneOf1TypeEnum_cannotSend =
    const SenderPoolDtoOutputAlertsInnerOneOf1TypeEnum._('cannotSend');

SenderPoolDtoOutputAlertsInnerOneOf1TypeEnum
_$senderPoolDtoOutputAlertsInnerOneOf1TypeEnumValueOf(String name) {
  switch (name) {
    case 'cannotSend':
      return _$senderPoolDtoOutputAlertsInnerOneOf1TypeEnum_cannotSend;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SenderPoolDtoOutputAlertsInnerOneOf1TypeEnum>
_$senderPoolDtoOutputAlertsInnerOneOf1TypeEnumValues =
    BuiltSet<SenderPoolDtoOutputAlertsInnerOneOf1TypeEnum>(
      const <SenderPoolDtoOutputAlertsInnerOneOf1TypeEnum>[
        _$senderPoolDtoOutputAlertsInnerOneOf1TypeEnum_cannotSend,
      ],
    );

const SenderPoolDtoOutputAlertsInnerOneOf1SeverityEnum
_$senderPoolDtoOutputAlertsInnerOneOf1SeverityEnum_critical =
    const SenderPoolDtoOutputAlertsInnerOneOf1SeverityEnum._('critical');

SenderPoolDtoOutputAlertsInnerOneOf1SeverityEnum
_$senderPoolDtoOutputAlertsInnerOneOf1SeverityEnumValueOf(String name) {
  switch (name) {
    case 'critical':
      return _$senderPoolDtoOutputAlertsInnerOneOf1SeverityEnum_critical;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SenderPoolDtoOutputAlertsInnerOneOf1SeverityEnum>
_$senderPoolDtoOutputAlertsInnerOneOf1SeverityEnumValues =
    BuiltSet<SenderPoolDtoOutputAlertsInnerOneOf1SeverityEnum>(
      const <SenderPoolDtoOutputAlertsInnerOneOf1SeverityEnum>[
        _$senderPoolDtoOutputAlertsInnerOneOf1SeverityEnum_critical,
      ],
    );

Serializer<SenderPoolDtoOutputAlertsInnerOneOf1TypeEnum>
_$senderPoolDtoOutputAlertsInnerOneOf1TypeEnumSerializer =
    _$SenderPoolDtoOutputAlertsInnerOneOf1TypeEnumSerializer();
Serializer<SenderPoolDtoOutputAlertsInnerOneOf1SeverityEnum>
_$senderPoolDtoOutputAlertsInnerOneOf1SeverityEnumSerializer =
    _$SenderPoolDtoOutputAlertsInnerOneOf1SeverityEnumSerializer();

class _$SenderPoolDtoOutputAlertsInnerOneOf1TypeEnumSerializer
    implements
        PrimitiveSerializer<SenderPoolDtoOutputAlertsInnerOneOf1TypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'cannotSend': 'cannot_send',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'cannot_send': 'cannotSend',
  };

  @override
  final Iterable<Type> types = const <Type>[
    SenderPoolDtoOutputAlertsInnerOneOf1TypeEnum,
  ];
  @override
  final String wireName = 'SenderPoolDtoOutputAlertsInnerOneOf1TypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    SenderPoolDtoOutputAlertsInnerOneOf1TypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  SenderPoolDtoOutputAlertsInnerOneOf1TypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => SenderPoolDtoOutputAlertsInnerOneOf1TypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$SenderPoolDtoOutputAlertsInnerOneOf1SeverityEnumSerializer
    implements
        PrimitiveSerializer<SenderPoolDtoOutputAlertsInnerOneOf1SeverityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'critical': 'critical',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'critical': 'critical',
  };

  @override
  final Iterable<Type> types = const <Type>[
    SenderPoolDtoOutputAlertsInnerOneOf1SeverityEnum,
  ];
  @override
  final String wireName = 'SenderPoolDtoOutputAlertsInnerOneOf1SeverityEnum';

  @override
  Object serialize(
    Serializers serializers,
    SenderPoolDtoOutputAlertsInnerOneOf1SeverityEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  SenderPoolDtoOutputAlertsInnerOneOf1SeverityEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => SenderPoolDtoOutputAlertsInnerOneOf1SeverityEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$SenderPoolDtoOutputAlertsInnerOneOf1
    extends SenderPoolDtoOutputAlertsInnerOneOf1 {
  @override
  final SenderPoolDtoOutputAlertsInnerOneOf1TypeEnum type;
  @override
  final SenderPoolDtoOutputAlertsInnerOneOf1SeverityEnum severity;

  factory _$SenderPoolDtoOutputAlertsInnerOneOf1([
    void Function(SenderPoolDtoOutputAlertsInnerOneOf1Builder)? updates,
  ]) =>
      (SenderPoolDtoOutputAlertsInnerOneOf1Builder()..update(updates))._build();

  _$SenderPoolDtoOutputAlertsInnerOneOf1._({
    required this.type,
    required this.severity,
  }) : super._();
  @override
  SenderPoolDtoOutputAlertsInnerOneOf1 rebuild(
    void Function(SenderPoolDtoOutputAlertsInnerOneOf1Builder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SenderPoolDtoOutputAlertsInnerOneOf1Builder toBuilder() =>
      SenderPoolDtoOutputAlertsInnerOneOf1Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SenderPoolDtoOutputAlertsInnerOneOf1 &&
        type == other.type &&
        severity == other.severity;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, severity.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SenderPoolDtoOutputAlertsInnerOneOf1')
          ..add('type', type)
          ..add('severity', severity))
        .toString();
  }
}

class SenderPoolDtoOutputAlertsInnerOneOf1Builder
    implements
        Builder<
          SenderPoolDtoOutputAlertsInnerOneOf1,
          SenderPoolDtoOutputAlertsInnerOneOf1Builder
        > {
  _$SenderPoolDtoOutputAlertsInnerOneOf1? _$v;

  SenderPoolDtoOutputAlertsInnerOneOf1TypeEnum? _type;
  SenderPoolDtoOutputAlertsInnerOneOf1TypeEnum? get type => _$this._type;
  set type(SenderPoolDtoOutputAlertsInnerOneOf1TypeEnum? type) =>
      _$this._type = type;

  SenderPoolDtoOutputAlertsInnerOneOf1SeverityEnum? _severity;
  SenderPoolDtoOutputAlertsInnerOneOf1SeverityEnum? get severity =>
      _$this._severity;
  set severity(SenderPoolDtoOutputAlertsInnerOneOf1SeverityEnum? severity) =>
      _$this._severity = severity;

  SenderPoolDtoOutputAlertsInnerOneOf1Builder() {
    SenderPoolDtoOutputAlertsInnerOneOf1._defaults(this);
  }

  SenderPoolDtoOutputAlertsInnerOneOf1Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _severity = $v.severity;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SenderPoolDtoOutputAlertsInnerOneOf1 other) {
    _$v = other as _$SenderPoolDtoOutputAlertsInnerOneOf1;
  }

  @override
  void update(
    void Function(SenderPoolDtoOutputAlertsInnerOneOf1Builder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  SenderPoolDtoOutputAlertsInnerOneOf1 build() => _build();

  _$SenderPoolDtoOutputAlertsInnerOneOf1 _build() {
    final _$result =
        _$v ??
        _$SenderPoolDtoOutputAlertsInnerOneOf1._(
          type: BuiltValueNullFieldError.checkNotNull(
            type,
            r'SenderPoolDtoOutputAlertsInnerOneOf1',
            'type',
          ),
          severity: BuiltValueNullFieldError.checkNotNull(
            severity,
            r'SenderPoolDtoOutputAlertsInnerOneOf1',
            'severity',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
