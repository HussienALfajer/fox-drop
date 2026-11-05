//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_code_sent_dto_output.g.dart';

/// CustomerCodeSentDtoOutput
///
/// Properties:
/// * [channel] - Where the code went (architecture §8.3.4).
/// * [resendAfterSec] - When the app may offer «إعادة الإرسال».
/// * [expiresAt]
@BuiltValue()
abstract class CustomerCodeSentDtoOutput
    implements
        Built<CustomerCodeSentDtoOutput, CustomerCodeSentDtoOutputBuilder> {
  /// Where the code went (architecture §8.3.4).
  @BuiltValueField(wireName: r'channel')
  CustomerCodeSentDtoOutputChannelEnum get channel;
  // enum channelEnum {  whatsapp,  };

  /// When the app may offer «إعادة الإرسال».
  @BuiltValueField(wireName: r'resendAfterSec')
  int get resendAfterSec;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  CustomerCodeSentDtoOutput._();

  factory CustomerCodeSentDtoOutput([
    void updates(CustomerCodeSentDtoOutputBuilder b),
  ]) = _$CustomerCodeSentDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerCodeSentDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerCodeSentDtoOutput> get serializer =>
      _$CustomerCodeSentDtoOutputSerializer();
}

class _$CustomerCodeSentDtoOutputSerializer
    implements PrimitiveSerializer<CustomerCodeSentDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CustomerCodeSentDtoOutput,
    _$CustomerCodeSentDtoOutput,
  ];

  @override
  final String wireName = r'CustomerCodeSentDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerCodeSentDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'channel';
    yield serializers.serialize(
      object.channel,
      specifiedType: const FullType(CustomerCodeSentDtoOutputChannelEnum),
    );
    yield r'resendAfterSec';
    yield serializers.serialize(
      object.resendAfterSec,
      specifiedType: const FullType(int),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerCodeSentDtoOutput object, {
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
    required CustomerCodeSentDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'channel':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerCodeSentDtoOutputChannelEnum,
                    ),
                  )
                  as CustomerCodeSentDtoOutputChannelEnum;
          result.channel = valueDes;
          break;
        case r'resendAfterSec':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.resendAfterSec = valueDes;
          break;
        case r'expiresAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.expiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerCodeSentDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerCodeSentDtoOutputBuilder();
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

/// Where the code went (architecture §8.3.4).
class CustomerCodeSentDtoOutputChannelEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'whatsapp')
  static const CustomerCodeSentDtoOutputChannelEnum whatsapp =
      _$customerCodeSentDtoOutputChannelEnum_whatsapp;

  static Serializer<CustomerCodeSentDtoOutputChannelEnum> get serializer =>
      _$customerCodeSentDtoOutputChannelEnumSerializer;

  const CustomerCodeSentDtoOutputChannelEnum._(String name) : super(name);

  static BuiltSet<CustomerCodeSentDtoOutputChannelEnum> get values =>
      _$customerCodeSentDtoOutputChannelEnumValues;
  static CustomerCodeSentDtoOutputChannelEnum valueOf(String name) =>
      _$customerCodeSentDtoOutputChannelEnumValueOf(name);
}
