// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sender_pool_dto_output_alerts_inner_one_of.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SenderPoolDtoOutputAlertsInnerOneOfTypeEnum
_$senderPoolDtoOutputAlertsInnerOneOfTypeEnum_numberStopped =
    const SenderPoolDtoOutputAlertsInnerOneOfTypeEnum._('numberStopped');

SenderPoolDtoOutputAlertsInnerOneOfTypeEnum
_$senderPoolDtoOutputAlertsInnerOneOfTypeEnumValueOf(String name) {
  switch (name) {
    case 'numberStopped':
      return _$senderPoolDtoOutputAlertsInnerOneOfTypeEnum_numberStopped;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SenderPoolDtoOutputAlertsInnerOneOfTypeEnum>
_$senderPoolDtoOutputAlertsInnerOneOfTypeEnumValues =
    BuiltSet<SenderPoolDtoOutputAlertsInnerOneOfTypeEnum>(
      const <SenderPoolDtoOutputAlertsInnerOneOfTypeEnum>[
        _$senderPoolDtoOutputAlertsInnerOneOfTypeEnum_numberStopped,
      ],
    );

const SenderPoolDtoOutputAlertsInnerOneOfSeverityEnum
_$senderPoolDtoOutputAlertsInnerOneOfSeverityEnum_warning =
    const SenderPoolDtoOutputAlertsInnerOneOfSeverityEnum._('warning');

SenderPoolDtoOutputAlertsInnerOneOfSeverityEnum
_$senderPoolDtoOutputAlertsInnerOneOfSeverityEnumValueOf(String name) {
  switch (name) {
    case 'warning':
      return _$senderPoolDtoOutputAlertsInnerOneOfSeverityEnum_warning;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SenderPoolDtoOutputAlertsInnerOneOfSeverityEnum>
_$senderPoolDtoOutputAlertsInnerOneOfSeverityEnumValues =
    BuiltSet<SenderPoolDtoOutputAlertsInnerOneOfSeverityEnum>(
      const <SenderPoolDtoOutputAlertsInnerOneOfSeverityEnum>[
        _$senderPoolDtoOutputAlertsInnerOneOfSeverityEnum_warning,
      ],
    );

Serializer<SenderPoolDtoOutputAlertsInnerOneOfTypeEnum>
_$senderPoolDtoOutputAlertsInnerOneOfTypeEnumSerializer =
    _$SenderPoolDtoOutputAlertsInnerOneOfTypeEnumSerializer();
Serializer<SenderPoolDtoOutputAlertsInnerOneOfSeverityEnum>
_$senderPoolDtoOutputAlertsInnerOneOfSeverityEnumSerializer =
    _$SenderPoolDtoOutputAlertsInnerOneOfSeverityEnumSerializer();

class _$SenderPoolDtoOutputAlertsInnerOneOfTypeEnumSerializer
    implements
        PrimitiveSerializer<SenderPoolDtoOutputAlertsInnerOneOfTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'numberStopped': 'number_stopped',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'number_stopped': 'numberStopped',
  };

  @override
  final Iterable<Type> types = const <Type>[
    SenderPoolDtoOutputAlertsInnerOneOfTypeEnum,
  ];
  @override
  final String wireName = 'SenderPoolDtoOutputAlertsInnerOneOfTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    SenderPoolDtoOutputAlertsInnerOneOfTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  SenderPoolDtoOutputAlertsInnerOneOfTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => SenderPoolDtoOutputAlertsInnerOneOfTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$SenderPoolDtoOutputAlertsInnerOneOfSeverityEnumSerializer
    implements
        PrimitiveSerializer<SenderPoolDtoOutputAlertsInnerOneOfSeverityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'warning': 'warning',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'warning': 'warning',
  };

  @override
  final Iterable<Type> types = const <Type>[
    SenderPoolDtoOutputAlertsInnerOneOfSeverityEnum,
  ];
  @override
  final String wireName = 'SenderPoolDtoOutputAlertsInnerOneOfSeverityEnum';

  @override
  Object serialize(
    Serializers serializers,
    SenderPoolDtoOutputAlertsInnerOneOfSeverityEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  SenderPoolDtoOutputAlertsInnerOneOfSeverityEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => SenderPoolDtoOutputAlertsInnerOneOfSeverityEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$SenderPoolDtoOutputAlertsInnerOneOf
    extends SenderPoolDtoOutputAlertsInnerOneOf {
  @override
  final SenderPoolDtoOutputAlertsInnerOneOfTypeEnum type;
  @override
  final SenderPoolDtoOutputAlertsInnerOneOfSeverityEnum severity;
  @override
  final BuiltList<String> numberIds;

  factory _$SenderPoolDtoOutputAlertsInnerOneOf([
    void Function(SenderPoolDtoOutputAlertsInnerOneOfBuilder)? updates,
  ]) =>
      (SenderPoolDtoOutputAlertsInnerOneOfBuilder()..update(updates))._build();

  _$SenderPoolDtoOutputAlertsInnerOneOf._({
    required this.type,
    required this.severity,
    required this.numberIds,
  }) : super._();
  @override
  SenderPoolDtoOutputAlertsInnerOneOf rebuild(
    void Function(SenderPoolDtoOutputAlertsInnerOneOfBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SenderPoolDtoOutputAlertsInnerOneOfBuilder toBuilder() =>
      SenderPoolDtoOutputAlertsInnerOneOfBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SenderPoolDtoOutputAlertsInnerOneOf &&
        type == other.type &&
        severity == other.severity &&
        numberIds == other.numberIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, severity.hashCode);
    _$hash = $jc(_$hash, numberIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SenderPoolDtoOutputAlertsInnerOneOf')
          ..add('type', type)
          ..add('severity', severity)
          ..add('numberIds', numberIds))
        .toString();
  }
}

class SenderPoolDtoOutputAlertsInnerOneOfBuilder
    implements
        Builder<
          SenderPoolDtoOutputAlertsInnerOneOf,
          SenderPoolDtoOutputAlertsInnerOneOfBuilder
        > {
  _$SenderPoolDtoOutputAlertsInnerOneOf? _$v;

  SenderPoolDtoOutputAlertsInnerOneOfTypeEnum? _type;
  SenderPoolDtoOutputAlertsInnerOneOfTypeEnum? get type => _$this._type;
  set type(SenderPoolDtoOutputAlertsInnerOneOfTypeEnum? type) =>
      _$this._type = type;

  SenderPoolDtoOutputAlertsInnerOneOfSeverityEnum? _severity;
  SenderPoolDtoOutputAlertsInnerOneOfSeverityEnum? get severity =>
      _$this._severity;
  set severity(SenderPoolDtoOutputAlertsInnerOneOfSeverityEnum? severity) =>
      _$this._severity = severity;

  ListBuilder<String>? _numberIds;
  ListBuilder<String> get numberIds =>
      _$this._numberIds ??= ListBuilder<String>();
  set numberIds(ListBuilder<String>? numberIds) =>
      _$this._numberIds = numberIds;

  SenderPoolDtoOutputAlertsInnerOneOfBuilder() {
    SenderPoolDtoOutputAlertsInnerOneOf._defaults(this);
  }

  SenderPoolDtoOutputAlertsInnerOneOfBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _severity = $v.severity;
      _numberIds = $v.numberIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SenderPoolDtoOutputAlertsInnerOneOf other) {
    _$v = other as _$SenderPoolDtoOutputAlertsInnerOneOf;
  }

  @override
  void update(
    void Function(SenderPoolDtoOutputAlertsInnerOneOfBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  SenderPoolDtoOutputAlertsInnerOneOf build() => _build();

  _$SenderPoolDtoOutputAlertsInnerOneOf _build() {
    _$SenderPoolDtoOutputAlertsInnerOneOf _$result;
    try {
      _$result =
          _$v ??
          _$SenderPoolDtoOutputAlertsInnerOneOf._(
            type: BuiltValueNullFieldError.checkNotNull(
              type,
              r'SenderPoolDtoOutputAlertsInnerOneOf',
              'type',
            ),
            severity: BuiltValueNullFieldError.checkNotNull(
              severity,
              r'SenderPoolDtoOutputAlertsInnerOneOf',
              'severity',
            ),
            numberIds: numberIds.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'numberIds';
        numberIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'SenderPoolDtoOutputAlertsInnerOneOf',
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
