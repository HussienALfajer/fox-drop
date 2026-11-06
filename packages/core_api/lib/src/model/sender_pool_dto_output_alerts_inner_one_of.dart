//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sender_pool_dto_output_alerts_inner_one_of.g.dart';

/// SenderPoolDtoOutputAlertsInnerOneOf
///
/// Properties:
/// * [type] - «رقم إرسال الرموز متوقف»
/// * [severity]
/// * [numberIds]
@BuiltValue()
abstract class SenderPoolDtoOutputAlertsInnerOneOf
    implements
        Built<
          SenderPoolDtoOutputAlertsInnerOneOf,
          SenderPoolDtoOutputAlertsInnerOneOfBuilder
        > {
  /// «رقم إرسال الرموز متوقف»
  @BuiltValueField(wireName: r'type')
  SenderPoolDtoOutputAlertsInnerOneOfTypeEnum get type;
  // enum typeEnum {  number_stopped,  };

  @BuiltValueField(wireName: r'severity')
  SenderPoolDtoOutputAlertsInnerOneOfSeverityEnum get severity;
  // enum severityEnum {  warning,  };

  @BuiltValueField(wireName: r'numberIds')
  BuiltList<String> get numberIds;

  SenderPoolDtoOutputAlertsInnerOneOf._();

  factory SenderPoolDtoOutputAlertsInnerOneOf([
    void updates(SenderPoolDtoOutputAlertsInnerOneOfBuilder b),
  ]) = _$SenderPoolDtoOutputAlertsInnerOneOf;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SenderPoolDtoOutputAlertsInnerOneOfBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SenderPoolDtoOutputAlertsInnerOneOf> get serializer =>
      _$SenderPoolDtoOutputAlertsInnerOneOfSerializer();
}

class _$SenderPoolDtoOutputAlertsInnerOneOfSerializer
    implements PrimitiveSerializer<SenderPoolDtoOutputAlertsInnerOneOf> {
  @override
  final Iterable<Type> types = const [
    SenderPoolDtoOutputAlertsInnerOneOf,
    _$SenderPoolDtoOutputAlertsInnerOneOf,
  ];

  @override
  final String wireName = r'SenderPoolDtoOutputAlertsInnerOneOf';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SenderPoolDtoOutputAlertsInnerOneOf object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(
        SenderPoolDtoOutputAlertsInnerOneOfTypeEnum,
      ),
    );
    yield r'severity';
    yield serializers.serialize(
      object.severity,
      specifiedType: const FullType(
        SenderPoolDtoOutputAlertsInnerOneOfSeverityEnum,
      ),
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
    SenderPoolDtoOutputAlertsInnerOneOf object, {
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
    required SenderPoolDtoOutputAlertsInnerOneOfBuilder result,
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
                      SenderPoolDtoOutputAlertsInnerOneOfTypeEnum,
                    ),
                  )
                  as SenderPoolDtoOutputAlertsInnerOneOfTypeEnum;
          result.type = valueDes;
          break;
        case r'severity':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      SenderPoolDtoOutputAlertsInnerOneOfSeverityEnum,
                    ),
                  )
                  as SenderPoolDtoOutputAlertsInnerOneOfSeverityEnum;
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
  SenderPoolDtoOutputAlertsInnerOneOf deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SenderPoolDtoOutputAlertsInnerOneOfBuilder();
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

/// «رقم إرسال الرموز متوقف»
class SenderPoolDtoOutputAlertsInnerOneOfTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'number_stopped')
  static const SenderPoolDtoOutputAlertsInnerOneOfTypeEnum numberStopped =
      _$senderPoolDtoOutputAlertsInnerOneOfTypeEnum_numberStopped;

  static Serializer<SenderPoolDtoOutputAlertsInnerOneOfTypeEnum>
  get serializer => _$senderPoolDtoOutputAlertsInnerOneOfTypeEnumSerializer;

  const SenderPoolDtoOutputAlertsInnerOneOfTypeEnum._(String name)
    : super(name);

  static BuiltSet<SenderPoolDtoOutputAlertsInnerOneOfTypeEnum> get values =>
      _$senderPoolDtoOutputAlertsInnerOneOfTypeEnumValues;
  static SenderPoolDtoOutputAlertsInnerOneOfTypeEnum valueOf(String name) =>
      _$senderPoolDtoOutputAlertsInnerOneOfTypeEnumValueOf(name);
}

class SenderPoolDtoOutputAlertsInnerOneOfSeverityEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'warning')
  static const SenderPoolDtoOutputAlertsInnerOneOfSeverityEnum warning =
      _$senderPoolDtoOutputAlertsInnerOneOfSeverityEnum_warning;

  static Serializer<SenderPoolDtoOutputAlertsInnerOneOfSeverityEnum>
  get serializer => _$senderPoolDtoOutputAlertsInnerOneOfSeverityEnumSerializer;

  const SenderPoolDtoOutputAlertsInnerOneOfSeverityEnum._(String name)
    : super(name);

  static BuiltSet<SenderPoolDtoOutputAlertsInnerOneOfSeverityEnum> get values =>
      _$senderPoolDtoOutputAlertsInnerOneOfSeverityEnumValues;
  static SenderPoolDtoOutputAlertsInnerOneOfSeverityEnum valueOf(String name) =>
      _$senderPoolDtoOutputAlertsInnerOneOfSeverityEnumValueOf(name);
}
