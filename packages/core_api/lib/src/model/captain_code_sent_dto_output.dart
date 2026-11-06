//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_code_sent_dto_output.g.dart';

/// CaptainCodeSentDtoOutput
///
/// Properties:
/// * [channel] - Where the code went (architecture §8.3.4).
/// * [resendAfterSec] - When the app may offer «إعادة الإرسال».
/// * [expiresAt] 
@BuiltValue()
abstract class CaptainCodeSentDtoOutput implements Built<CaptainCodeSentDtoOutput, CaptainCodeSentDtoOutputBuilder> {
  /// Where the code went (architecture §8.3.4).
  @BuiltValueField(wireName: r'channel')
  CaptainCodeSentDtoOutputChannelEnum get channel;
  // enum channelEnum {  whatsapp,  };

  /// When the app may offer «إعادة الإرسال».
  @BuiltValueField(wireName: r'resendAfterSec')
  int get resendAfterSec;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  CaptainCodeSentDtoOutput._();

  factory CaptainCodeSentDtoOutput([void updates(CaptainCodeSentDtoOutputBuilder b)]) = _$CaptainCodeSentDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainCodeSentDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainCodeSentDtoOutput> get serializer => _$CaptainCodeSentDtoOutputSerializer();
}

class _$CaptainCodeSentDtoOutputSerializer implements PrimitiveSerializer<CaptainCodeSentDtoOutput> {
  @override
  final Iterable<Type> types = const [CaptainCodeSentDtoOutput, _$CaptainCodeSentDtoOutput];

  @override
  final String wireName = r'CaptainCodeSentDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainCodeSentDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'channel';
    yield serializers.serialize(
      object.channel,
      specifiedType: const FullType(CaptainCodeSentDtoOutputChannelEnum),
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
    CaptainCodeSentDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CaptainCodeSentDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'channel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CaptainCodeSentDtoOutputChannelEnum),
          ) as CaptainCodeSentDtoOutputChannelEnum;
          result.channel = valueDes;
          break;
        case r'resendAfterSec':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.resendAfterSec = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
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
  CaptainCodeSentDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainCodeSentDtoOutputBuilder();
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
class CaptainCodeSentDtoOutputChannelEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'whatsapp')
  static const CaptainCodeSentDtoOutputChannelEnum whatsapp = _$captainCodeSentDtoOutputChannelEnum_whatsapp;

  static Serializer<CaptainCodeSentDtoOutputChannelEnum> get serializer => _$captainCodeSentDtoOutputChannelEnumSerializer;

  const CaptainCodeSentDtoOutputChannelEnum._(String name): super(name);

  static BuiltSet<CaptainCodeSentDtoOutputChannelEnum> get values => _$captainCodeSentDtoOutputChannelEnumValues;
  static CaptainCodeSentDtoOutputChannelEnum valueOf(String name) => _$captainCodeSentDtoOutputChannelEnumValueOf(name);
}

