//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sender_pool_dto_output_alerts_inner_one_of1.g.dart';

/// SenderPoolDtoOutputAlertsInnerOneOf1
///
/// Properties:
/// * [type] - «لا يمكن إرسال رموز الدخول»
/// * [severity]
@BuiltValue()
abstract class SenderPoolDtoOutputAlertsInnerOneOf1
    implements
        Built<
          SenderPoolDtoOutputAlertsInnerOneOf1,
          SenderPoolDtoOutputAlertsInnerOneOf1Builder
        > {
  /// «لا يمكن إرسال رموز الدخول»
  @BuiltValueField(wireName: r'type')
  SenderPoolDtoOutputAlertsInnerOneOf1TypeEnum get type;
  // enum typeEnum {  cannot_send,  };

  @BuiltValueField(wireName: r'severity')
  SenderPoolDtoOutputAlertsInnerOneOf1SeverityEnum get severity;
  // enum severityEnum {  critical,  };

  SenderPoolDtoOutputAlertsInnerOneOf1._();

  factory SenderPoolDtoOutputAlertsInnerOneOf1([
    void updates(SenderPoolDtoOutputAlertsInnerOneOf1Builder b),
  ]) = _$SenderPoolDtoOutputAlertsInnerOneOf1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SenderPoolDtoOutputAlertsInnerOneOf1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SenderPoolDtoOutputAlertsInnerOneOf1> get serializer =>
      _$SenderPoolDtoOutputAlertsInnerOneOf1Serializer();
}

class _$SenderPoolDtoOutputAlertsInnerOneOf1Serializer
    implements PrimitiveSerializer<SenderPoolDtoOutputAlertsInnerOneOf1> {
  @override
  final Iterable<Type> types = const [
    SenderPoolDtoOutputAlertsInnerOneOf1,
    _$SenderPoolDtoOutputAlertsInnerOneOf1,
  ];

  @override
  final String wireName = r'SenderPoolDtoOutputAlertsInnerOneOf1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SenderPoolDtoOutputAlertsInnerOneOf1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(
        SenderPoolDtoOutputAlertsInnerOneOf1TypeEnum,
      ),
    );
    yield r'severity';
    yield serializers.serialize(
      object.severity,
      specifiedType: const FullType(
        SenderPoolDtoOutputAlertsInnerOneOf1SeverityEnum,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SenderPoolDtoOutputAlertsInnerOneOf1 object, {
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
    required SenderPoolDtoOutputAlertsInnerOneOf1Builder result,
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
                      SenderPoolDtoOutputAlertsInnerOneOf1TypeEnum,
                    ),
                  )
                  as SenderPoolDtoOutputAlertsInnerOneOf1TypeEnum;
          result.type = valueDes;
          break;
        case r'severity':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      SenderPoolDtoOutputAlertsInnerOneOf1SeverityEnum,
                    ),
                  )
                  as SenderPoolDtoOutputAlertsInnerOneOf1SeverityEnum;
          result.severity = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SenderPoolDtoOutputAlertsInnerOneOf1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SenderPoolDtoOutputAlertsInnerOneOf1Builder();
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

/// «لا يمكن إرسال رموز الدخول»
class SenderPoolDtoOutputAlertsInnerOneOf1TypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'cannot_send')
  static const SenderPoolDtoOutputAlertsInnerOneOf1TypeEnum cannotSend =
      _$senderPoolDtoOutputAlertsInnerOneOf1TypeEnum_cannotSend;

  static Serializer<SenderPoolDtoOutputAlertsInnerOneOf1TypeEnum>
  get serializer => _$senderPoolDtoOutputAlertsInnerOneOf1TypeEnumSerializer;

  const SenderPoolDtoOutputAlertsInnerOneOf1TypeEnum._(String name)
    : super(name);

  static BuiltSet<SenderPoolDtoOutputAlertsInnerOneOf1TypeEnum> get values =>
      _$senderPoolDtoOutputAlertsInnerOneOf1TypeEnumValues;
  static SenderPoolDtoOutputAlertsInnerOneOf1TypeEnum valueOf(String name) =>
      _$senderPoolDtoOutputAlertsInnerOneOf1TypeEnumValueOf(name);
}

class SenderPoolDtoOutputAlertsInnerOneOf1SeverityEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'critical')
  static const SenderPoolDtoOutputAlertsInnerOneOf1SeverityEnum critical =
      _$senderPoolDtoOutputAlertsInnerOneOf1SeverityEnum_critical;

  static Serializer<SenderPoolDtoOutputAlertsInnerOneOf1SeverityEnum>
  get serializer =>
      _$senderPoolDtoOutputAlertsInnerOneOf1SeverityEnumSerializer;

  const SenderPoolDtoOutputAlertsInnerOneOf1SeverityEnum._(String name)
    : super(name);

  static BuiltSet<SenderPoolDtoOutputAlertsInnerOneOf1SeverityEnum>
  get values => _$senderPoolDtoOutputAlertsInnerOneOf1SeverityEnumValues;
  static SenderPoolDtoOutputAlertsInnerOneOf1SeverityEnum valueOf(
    String name,
  ) => _$senderPoolDtoOutputAlertsInnerOneOf1SeverityEnumValueOf(name);
}
