//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/sender_pool_dto_output_alerts_inner_one_of.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/sender_pool_dto_output_alerts_inner_one_of1.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/one_of.dart';

part 'sender_pool_dto_output_alerts_inner.g.dart';

/// SenderPoolDtoOutputAlertsInner
///
/// Properties:
/// * [type] - «رقم إرسال الرموز متوقف»
/// * [severity]
/// * [numberIds]
@BuiltValue()
abstract class SenderPoolDtoOutputAlertsInner
    implements
        Built<
          SenderPoolDtoOutputAlertsInner,
          SenderPoolDtoOutputAlertsInnerBuilder
        > {
  /// One Of [SenderPoolDtoOutputAlertsInnerOneOf], [SenderPoolDtoOutputAlertsInnerOneOf1]
  OneOf get oneOf;

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
  }) sync* {}

  @override
  Object serialize(
    Serializers serializers,
    SenderPoolDtoOutputAlertsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final oneOf = object.oneOf;
    return serializers.serialize(
      oneOf.value,
      specifiedType: FullType(oneOf.valueType),
    )!;
  }

  @override
  SenderPoolDtoOutputAlertsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SenderPoolDtoOutputAlertsInnerBuilder();
    Object? oneOfDataSrc;
    final targetType = const FullType(OneOf, [
      FullType(SenderPoolDtoOutputAlertsInnerOneOf),
      FullType(SenderPoolDtoOutputAlertsInnerOneOf1),
    ]);
    oneOfDataSrc = serialized;
    result.oneOf =
        serializers.deserialize(oneOfDataSrc, specifiedType: targetType)
            as OneOf;
    return result.build();
  }
}

/// «رقم إرسال الرموز متوقف»
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
