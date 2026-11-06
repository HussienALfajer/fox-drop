// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sender_pool_dto_output_alerts_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SenderPoolDtoOutputAlertsInnerTypeEnum
_$senderPoolDtoOutputAlertsInnerTypeEnum_numberStopped =
    const SenderPoolDtoOutputAlertsInnerTypeEnum._('numberStopped');
const SenderPoolDtoOutputAlertsInnerTypeEnum
_$senderPoolDtoOutputAlertsInnerTypeEnum_cannotSend =
    const SenderPoolDtoOutputAlertsInnerTypeEnum._('cannotSend');

SenderPoolDtoOutputAlertsInnerTypeEnum
_$senderPoolDtoOutputAlertsInnerTypeEnumValueOf(String name) {
  switch (name) {
    case 'numberStopped':
      return _$senderPoolDtoOutputAlertsInnerTypeEnum_numberStopped;
    case 'cannotSend':
      return _$senderPoolDtoOutputAlertsInnerTypeEnum_cannotSend;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SenderPoolDtoOutputAlertsInnerTypeEnum>
_$senderPoolDtoOutputAlertsInnerTypeEnumValues =
    BuiltSet<SenderPoolDtoOutputAlertsInnerTypeEnum>(
      const <SenderPoolDtoOutputAlertsInnerTypeEnum>[
        _$senderPoolDtoOutputAlertsInnerTypeEnum_numberStopped,
        _$senderPoolDtoOutputAlertsInnerTypeEnum_cannotSend,
      ],
    );

const SenderPoolDtoOutputAlertsInnerSeverityEnum
_$senderPoolDtoOutputAlertsInnerSeverityEnum_critical =
    const SenderPoolDtoOutputAlertsInnerSeverityEnum._('critical');

SenderPoolDtoOutputAlertsInnerSeverityEnum
_$senderPoolDtoOutputAlertsInnerSeverityEnumValueOf(String name) {
  switch (name) {
    case 'critical':
      return _$senderPoolDtoOutputAlertsInnerSeverityEnum_critical;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SenderPoolDtoOutputAlertsInnerSeverityEnum>
_$senderPoolDtoOutputAlertsInnerSeverityEnumValues =
    BuiltSet<SenderPoolDtoOutputAlertsInnerSeverityEnum>(
      const <SenderPoolDtoOutputAlertsInnerSeverityEnum>[
        _$senderPoolDtoOutputAlertsInnerSeverityEnum_critical,
      ],
    );

Serializer<SenderPoolDtoOutputAlertsInnerTypeEnum>
_$senderPoolDtoOutputAlertsInnerTypeEnumSerializer =
    _$SenderPoolDtoOutputAlertsInnerTypeEnumSerializer();
Serializer<SenderPoolDtoOutputAlertsInnerSeverityEnum>
_$senderPoolDtoOutputAlertsInnerSeverityEnumSerializer =
    _$SenderPoolDtoOutputAlertsInnerSeverityEnumSerializer();

class _$SenderPoolDtoOutputAlertsInnerTypeEnumSerializer
    implements PrimitiveSerializer<SenderPoolDtoOutputAlertsInnerTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'numberStopped': 'number_stopped',
    'cannotSend': 'cannot_send',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'number_stopped': 'numberStopped',
    'cannot_send': 'cannotSend',
  };

  @override
  final Iterable<Type> types = const <Type>[
    SenderPoolDtoOutputAlertsInnerTypeEnum,
  ];
  @override
  final String wireName = 'SenderPoolDtoOutputAlertsInnerTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    SenderPoolDtoOutputAlertsInnerTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  SenderPoolDtoOutputAlertsInnerTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => SenderPoolDtoOutputAlertsInnerTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$SenderPoolDtoOutputAlertsInnerSeverityEnumSerializer
    implements PrimitiveSerializer<SenderPoolDtoOutputAlertsInnerSeverityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'critical': 'critical',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'critical': 'critical',
  };

  @override
  final Iterable<Type> types = const <Type>[
    SenderPoolDtoOutputAlertsInnerSeverityEnum,
  ];
  @override
  final String wireName = 'SenderPoolDtoOutputAlertsInnerSeverityEnum';

  @override
  Object serialize(
    Serializers serializers,
    SenderPoolDtoOutputAlertsInnerSeverityEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  SenderPoolDtoOutputAlertsInnerSeverityEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => SenderPoolDtoOutputAlertsInnerSeverityEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$SenderPoolDtoOutputAlertsInner extends SenderPoolDtoOutputAlertsInner {
  @override
  final OneOf oneOf;

  factory _$SenderPoolDtoOutputAlertsInner([
    void Function(SenderPoolDtoOutputAlertsInnerBuilder)? updates,
  ]) => (SenderPoolDtoOutputAlertsInnerBuilder()..update(updates))._build();

  _$SenderPoolDtoOutputAlertsInner._({required this.oneOf}) : super._();
  @override
  SenderPoolDtoOutputAlertsInner rebuild(
    void Function(SenderPoolDtoOutputAlertsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SenderPoolDtoOutputAlertsInnerBuilder toBuilder() =>
      SenderPoolDtoOutputAlertsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SenderPoolDtoOutputAlertsInner && oneOf == other.oneOf;
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
      r'SenderPoolDtoOutputAlertsInner',
    )..add('oneOf', oneOf)).toString();
  }
}

class SenderPoolDtoOutputAlertsInnerBuilder
    implements
        Builder<
          SenderPoolDtoOutputAlertsInner,
          SenderPoolDtoOutputAlertsInnerBuilder
        > {
  _$SenderPoolDtoOutputAlertsInner? _$v;

  OneOf? _oneOf;
  OneOf? get oneOf => _$this._oneOf;
  set oneOf(OneOf? oneOf) => _$this._oneOf = oneOf;

  SenderPoolDtoOutputAlertsInnerBuilder() {
    SenderPoolDtoOutputAlertsInner._defaults(this);
  }

  SenderPoolDtoOutputAlertsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _oneOf = $v.oneOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SenderPoolDtoOutputAlertsInner other) {
    _$v = other as _$SenderPoolDtoOutputAlertsInner;
  }

  @override
  void update(void Function(SenderPoolDtoOutputAlertsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SenderPoolDtoOutputAlertsInner build() => _build();

  _$SenderPoolDtoOutputAlertsInner _build() {
    final _$result =
        _$v ??
        _$SenderPoolDtoOutputAlertsInner._(
          oneOf: BuiltValueNullFieldError.checkNotNull(
            oneOf,
            r'SenderPoolDtoOutputAlertsInner',
            'oneOf',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
