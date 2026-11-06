//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_code_sent_dto_output.g.dart';

/// MerchantCodeSentDtoOutput
///
/// Properties:
/// * [channel] - Where the code went (architecture §8.3.4).
/// * [resendAfterSec] - When the app may offer «إعادة الإرسال».
/// * [expiresAt]
@BuiltValue()
abstract class MerchantCodeSentDtoOutput
    implements
        Built<MerchantCodeSentDtoOutput, MerchantCodeSentDtoOutputBuilder> {
  /// Where the code went (architecture §8.3.4).
  @BuiltValueField(wireName: r'channel')
  MerchantCodeSentDtoOutputChannelEnum get channel;
  // enum channelEnum {  whatsapp,  };

  /// When the app may offer «إعادة الإرسال».
  @BuiltValueField(wireName: r'resendAfterSec')
  int get resendAfterSec;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  MerchantCodeSentDtoOutput._();

  factory MerchantCodeSentDtoOutput([
    void updates(MerchantCodeSentDtoOutputBuilder b),
  ]) = _$MerchantCodeSentDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantCodeSentDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantCodeSentDtoOutput> get serializer =>
      _$MerchantCodeSentDtoOutputSerializer();
}

class _$MerchantCodeSentDtoOutputSerializer
    implements PrimitiveSerializer<MerchantCodeSentDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantCodeSentDtoOutput,
    _$MerchantCodeSentDtoOutput,
  ];

  @override
  final String wireName = r'MerchantCodeSentDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantCodeSentDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'channel';
    yield serializers.serialize(
      object.channel,
      specifiedType: const FullType(MerchantCodeSentDtoOutputChannelEnum),
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
    MerchantCodeSentDtoOutput object, {
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
    required MerchantCodeSentDtoOutputBuilder result,
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
                      MerchantCodeSentDtoOutputChannelEnum,
                    ),
                  )
                  as MerchantCodeSentDtoOutputChannelEnum;
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
  MerchantCodeSentDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantCodeSentDtoOutputBuilder();
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
class MerchantCodeSentDtoOutputChannelEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'whatsapp')
  static const MerchantCodeSentDtoOutputChannelEnum whatsapp =
      _$merchantCodeSentDtoOutputChannelEnum_whatsapp;

  static Serializer<MerchantCodeSentDtoOutputChannelEnum> get serializer =>
      _$merchantCodeSentDtoOutputChannelEnumSerializer;

  const MerchantCodeSentDtoOutputChannelEnum._(String name) : super(name);

  static BuiltSet<MerchantCodeSentDtoOutputChannelEnum> get values =>
      _$merchantCodeSentDtoOutputChannelEnumValues;
  static MerchantCodeSentDtoOutputChannelEnum valueOf(String name) =>
      _$merchantCodeSentDtoOutputChannelEnumValueOf(name);
}
