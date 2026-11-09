//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sender_pool_dto_output_alerts_inner.g.dart';

/// SenderPoolDtoOutputAlertsInner
///
/// Properties:
/// * [type] - number_stopped: «رقم إرسال الرموز متوقف» (warning); cannot_send: «لا يمكن إرسال رموز الدخول» (critical).
/// * [severity]
/// * [numberIds] - The stopped numbers; empty for cannot_send.
@BuiltValue()
abstract class SenderPoolDtoOutputAlertsInner
    implements
        Built<
          SenderPoolDtoOutputAlertsInner,
          SenderPoolDtoOutputAlertsInnerBuilder
        > {
  /// number_stopped: «رقم إرسال الرموز متوقف» (warning); cannot_send: «لا يمكن إرسال رموز الدخول» (critical).
  @BuiltValueField(wireName: r'type')
  SenderPoolDtoOutputAlertsInnerTypeEnum get type;
  // enum typeEnum {  number_stopped,  cannot_send,  };

  @BuiltValueField(wireName: r'severity')
  SenderPoolDtoOutputAlertsInnerSeverityEnum get severity;
  // enum severityEnum {  warning,  critical,  };

  /// The stopped numbers; empty for cannot_send.
  @BuiltValueField(wireName: r'numberIds')
  BuiltList<String> get numberIds;

  SenderPoolDtoOutputAlertsInner._();

  factory SenderPoolDtoOutputAlertsInner([
    void updates(SenderPoolDtoOutputAlertsInnerBuilder b),
  ]) = _$SenderPoolDtoOutputAlertsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SenderPoolDtoOutputAlertsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SenderPoolDtoOutputAlertsInner> get serializer =>
      _$SenderPoolDtoOutputAlertsInnerSerializer();
}

class _$SenderPoolDtoOutputAlertsInnerSerializer
    implements PrimitiveSerializer<SenderPoolDtoOutputAlertsInner> {
  @override
  final Iterable<Type> types = const [
    SenderPoolDtoOutputAlertsInner,
    _$SenderPoolDtoOutputAlertsInner,
  ];

  @override
  final String wireName = r'SenderPoolDtoOutputAlertsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SenderPoolDtoOutputAlertsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(SenderPoolDtoOutputAlertsInnerTypeEnum),
    );
    yield r'severity';
    yield serializers.serialize(
      object.severity,
      specifiedType: const FullType(SenderPoolDtoOutputAlertsInnerSeverityEnum),
    );
    yield r'numberIds';
    yield serializers.serialize(
      object.numberIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SenderPoolDtoOutputAlertsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(
      serializers,
      object,
      specifiedType: specifiedType,
    ).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SenderPoolDtoOutputAlertsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      SenderPoolDtoOutputAlertsInnerTypeEnum,
                    ),
                  )
                  as SenderPoolDtoOutputAlertsInnerTypeEnum;
          result.type = valueDes;
          break;
        case r'severity':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      SenderPoolDtoOutputAlertsInnerSeverityEnum,
                    ),
                  )
                  as SenderPoolDtoOutputAlertsInnerSeverityEnum;
          result.severity = valueDes;
          break;
        case r'numberIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.numberIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SenderPoolDtoOutputAlertsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SenderPoolDtoOutputAlertsInnerBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

/// number_stopped: «رقم إرسال الرموز متوقف» (warning); cannot_send: «لا يمكن إرسال رموز الدخول» (critical).
class SenderPoolDtoOutputAlertsInnerTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'number_stopped')
  static const SenderPoolDtoOutputAlertsInnerTypeEnum numberStopped =
      _$senderPoolDtoOutputAlertsInnerTypeEnum_numberStopped;
  @BuiltValueEnumConst(wireName: r'cannot_send')
  static const SenderPoolDtoOutputAlertsInnerTypeEnum cannotSend =
      _$senderPoolDtoOutputAlertsInnerTypeEnum_cannotSend;

  static Serializer<SenderPoolDtoOutputAlertsInnerTypeEnum> get serializer =>
      _$senderPoolDtoOutputAlertsInnerTypeEnumSerializer;

  const SenderPoolDtoOutputAlertsInnerTypeEnum._(String name) : super(name);

  static BuiltSet<SenderPoolDtoOutputAlertsInnerTypeEnum> get values =>
      _$senderPoolDtoOutputAlertsInnerTypeEnumValues;
  static SenderPoolDtoOutputAlertsInnerTypeEnum valueOf(String name) =>
      _$senderPoolDtoOutputAlertsInnerTypeEnumValueOf(name);
}

class SenderPoolDtoOutputAlertsInnerSeverityEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'warning')
  static const SenderPoolDtoOutputAlertsInnerSeverityEnum warning =
      _$senderPoolDtoOutputAlertsInnerSeverityEnum_warning;
  @BuiltValueEnumConst(wireName: r'critical')
  static const SenderPoolDtoOutputAlertsInnerSeverityEnum critical =
      _$senderPoolDtoOutputAlertsInnerSeverityEnum_critical;

  static Serializer<SenderPoolDtoOutputAlertsInnerSeverityEnum>
  get serializer => _$senderPoolDtoOutputAlertsInnerSeverityEnumSerializer;

  const SenderPoolDtoOutputAlertsInnerSeverityEnum._(String name) : super(name);

  static BuiltSet<SenderPoolDtoOutputAlertsInnerSeverityEnum> get values =>
      _$senderPoolDtoOutputAlertsInnerSeverityEnumValues;
  static SenderPoolDtoOutputAlertsInnerSeverityEnum valueOf(String name) =>
      _$senderPoolDtoOutputAlertsInnerSeverityEnumValueOf(name);
}
