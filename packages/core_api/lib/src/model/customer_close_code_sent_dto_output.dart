//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_close_code_sent_dto_output.g.dart';

/// CustomerCloseCodeSentDtoOutput
///
/// Properties:
/// * [channel] - Where the code went (architecture §8.3.4).
/// * [resendAfterSec] - When the app may offer «إعادة الإرسال».
/// * [expiresAt]
@BuiltValue()
abstract class CustomerCloseCodeSentDtoOutput
    implements
        Built<
          CustomerCloseCodeSentDtoOutput,
          CustomerCloseCodeSentDtoOutputBuilder
        > {
  /// Where the code went (architecture §8.3.4).
  @BuiltValueField(wireName: r'channel')
  CustomerCloseCodeSentDtoOutputChannelEnum get channel;
  // enum channelEnum {  whatsapp,  };

  /// When the app may offer «إعادة الإرسال».
  @BuiltValueField(wireName: r'resendAfterSec')
  int get resendAfterSec;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  CustomerCloseCodeSentDtoOutput._();

  factory CustomerCloseCodeSentDtoOutput([
    void updates(CustomerCloseCodeSentDtoOutputBuilder b),
  ]) = _$CustomerCloseCodeSentDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerCloseCodeSentDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerCloseCodeSentDtoOutput> get serializer =>
      _$CustomerCloseCodeSentDtoOutputSerializer();
}

class _$CustomerCloseCodeSentDtoOutputSerializer
    implements PrimitiveSerializer<CustomerCloseCodeSentDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CustomerCloseCodeSentDtoOutput,
    _$CustomerCloseCodeSentDtoOutput,
  ];

  @override
  final String wireName = r'CustomerCloseCodeSentDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerCloseCodeSentDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'channel';
    yield serializers.serialize(
      object.channel,
      specifiedType: const FullType(CustomerCloseCodeSentDtoOutputChannelEnum),
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
    CustomerCloseCodeSentDtoOutput object, {
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
    required CustomerCloseCodeSentDtoOutputBuilder result,
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
                      CustomerCloseCodeSentDtoOutputChannelEnum,
                    ),
                  )
                  as CustomerCloseCodeSentDtoOutputChannelEnum;
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
  CustomerCloseCodeSentDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerCloseCodeSentDtoOutputBuilder();
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
class CustomerCloseCodeSentDtoOutputChannelEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'whatsapp')
  static const CustomerCloseCodeSentDtoOutputChannelEnum whatsapp =
      _$customerCloseCodeSentDtoOutputChannelEnum_whatsapp;

  static Serializer<CustomerCloseCodeSentDtoOutputChannelEnum> get serializer =>
      _$customerCloseCodeSentDtoOutputChannelEnumSerializer;

  const CustomerCloseCodeSentDtoOutputChannelEnum._(String name) : super(name);

  static BuiltSet<CustomerCloseCodeSentDtoOutputChannelEnum> get values =>
      _$customerCloseCodeSentDtoOutputChannelEnumValues;
  static CustomerCloseCodeSentDtoOutputChannelEnum valueOf(String name) =>
      _$customerCloseCodeSentDtoOutputChannelEnumValueOf(name);
}
