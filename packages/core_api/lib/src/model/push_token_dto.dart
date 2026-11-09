//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'push_token_dto.g.dart';

/// PushTokenDto
///
/// Properties:
/// * [token] - The app installation's Firebase Installation ID (FID), FCM's target for this device.
/// * [platform] 
@BuiltValue()
abstract class PushTokenDto implements Built<PushTokenDto, PushTokenDtoBuilder> {
  /// The app installation's Firebase Installation ID (FID), FCM's target for this device.
  @BuiltValueField(wireName: r'token')
  String get token;

  @BuiltValueField(wireName: r'platform')
  PushTokenDtoPlatformEnum get platform;
  // enum platformEnum {  android,  };

  PushTokenDto._();

  factory PushTokenDto([void updates(PushTokenDtoBuilder b)]) = _$PushTokenDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PushTokenDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PushTokenDto> get serializer => _$PushTokenDtoSerializer();
}

class _$PushTokenDtoSerializer implements PrimitiveSerializer<PushTokenDto> {
  @override
  final Iterable<Type> types = const [PushTokenDto, _$PushTokenDto];

  @override
  final String wireName = r'PushTokenDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PushTokenDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'token';
    yield serializers.serialize(
      object.token,
      specifiedType: const FullType(String),
    );
    yield r'platform';
    yield serializers.serialize(
      object.platform,
      specifiedType: const FullType(PushTokenDtoPlatformEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PushTokenDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PushTokenDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.token = valueDes;
          break;
        case r'platform':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PushTokenDtoPlatformEnum),
          ) as PushTokenDtoPlatformEnum;
          result.platform = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PushTokenDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PushTokenDtoBuilder();
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


class PushTokenDtoPlatformEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'android')
  static const PushTokenDtoPlatformEnum android = _$pushTokenDtoPlatformEnum_android;

  static Serializer<PushTokenDtoPlatformEnum> get serializer => _$pushTokenDtoPlatformEnumSerializer;

  const PushTokenDtoPlatformEnum._(String name): super(name);

  static BuiltSet<PushTokenDtoPlatformEnum> get values => _$pushTokenDtoPlatformEnumValues;
  static PushTokenDtoPlatformEnum valueOf(String name) => _$pushTokenDtoPlatformEnumValueOf(name);
}

