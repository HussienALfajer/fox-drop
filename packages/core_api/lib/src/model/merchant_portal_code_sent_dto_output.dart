//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_portal_code_sent_dto_output.g.dart';

/// MerchantPortalCodeSentDtoOutput
///
/// Properties:
/// * [channel] - Where the code went (architecture §8.3.4).
/// * [resendAfterSec] - When the app may offer «إعادة الإرسال».
/// * [expiresAt]
@BuiltValue()
abstract class MerchantPortalCodeSentDtoOutput
    implements
        Built<
          MerchantPortalCodeSentDtoOutput,
          MerchantPortalCodeSentDtoOutputBuilder
        > {
  /// Where the code went (architecture §8.3.4).
  @BuiltValueField(wireName: r'channel')
  MerchantPortalCodeSentDtoOutputChannelEnum get channel;
  // enum channelEnum {  whatsapp,  };

  /// When the app may offer «إعادة الإرسال».
  @BuiltValueField(wireName: r'resendAfterSec')
  int get resendAfterSec;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  MerchantPortalCodeSentDtoOutput._();

  factory MerchantPortalCodeSentDtoOutput([
    void updates(MerchantPortalCodeSentDtoOutputBuilder b),
  ]) = _$MerchantPortalCodeSentDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantPortalCodeSentDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantPortalCodeSentDtoOutput> get serializer =>
      _$MerchantPortalCodeSentDtoOutputSerializer();
}

class _$MerchantPortalCodeSentDtoOutputSerializer
    implements PrimitiveSerializer<MerchantPortalCodeSentDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantPortalCodeSentDtoOutput,
    _$MerchantPortalCodeSentDtoOutput,
  ];

  @override
  final String wireName = r'MerchantPortalCodeSentDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantPortalCodeSentDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'channel';
    yield serializers.serialize(
      object.channel,
      specifiedType: const FullType(MerchantPortalCodeSentDtoOutputChannelEnum),
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
    MerchantPortalCodeSentDtoOutput object, {
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
    required MerchantPortalCodeSentDtoOutputBuilder result,
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
                      MerchantPortalCodeSentDtoOutputChannelEnum,
                    ),
                  )
                  as MerchantPortalCodeSentDtoOutputChannelEnum;
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
  MerchantPortalCodeSentDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantPortalCodeSentDtoOutputBuilder();
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
class MerchantPortalCodeSentDtoOutputChannelEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'whatsapp')
  static const MerchantPortalCodeSentDtoOutputChannelEnum whatsapp =
      _$merchantPortalCodeSentDtoOutputChannelEnum_whatsapp;

  static Serializer<MerchantPortalCodeSentDtoOutputChannelEnum>
  get serializer => _$merchantPortalCodeSentDtoOutputChannelEnumSerializer;

  const MerchantPortalCodeSentDtoOutputChannelEnum._(String name) : super(name);

  static BuiltSet<MerchantPortalCodeSentDtoOutputChannelEnum> get values =>
      _$merchantPortalCodeSentDtoOutputChannelEnumValues;
  static MerchantPortalCodeSentDtoOutputChannelEnum valueOf(String name) =>
      _$merchantPortalCodeSentDtoOutputChannelEnumValueOf(name);
}
