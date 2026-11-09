//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_code_request_dto.g.dart';

/// MerchantCodeRequestDto
///
/// Properties:
/// * [phone] - The mobile number in E.164: +9639xxxxxxxx or +905xxxxxxxxx.
/// * [deviceId] - The app installation, generated once by the app and kept until it is removed.
/// * [platform] - Windows sends no App Check token (owner decision 2026-11-07).
@BuiltValue()
abstract class MerchantCodeRequestDto implements Built<MerchantCodeRequestDto, MerchantCodeRequestDtoBuilder> {
  /// The mobile number in E.164: +9639xxxxxxxx or +905xxxxxxxxx.
  @BuiltValueField(wireName: r'phone')
  String get phone;

  /// The app installation, generated once by the app and kept until it is removed.
  @BuiltValueField(wireName: r'deviceId')
  String get deviceId;

  /// Windows sends no App Check token (owner decision 2026-11-07).
  @BuiltValueField(wireName: r'platform')
  MerchantCodeRequestDtoPlatformEnum? get platform;
  // enum platformEnum {  android,  ios,  windows,  };

  MerchantCodeRequestDto._();

  factory MerchantCodeRequestDto([void updates(MerchantCodeRequestDtoBuilder b)]) = _$MerchantCodeRequestDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantCodeRequestDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantCodeRequestDto> get serializer => _$MerchantCodeRequestDtoSerializer();
}

class _$MerchantCodeRequestDtoSerializer implements PrimitiveSerializer<MerchantCodeRequestDto> {
  @override
  final Iterable<Type> types = const [MerchantCodeRequestDto, _$MerchantCodeRequestDto];

  @override
  final String wireName = r'MerchantCodeRequestDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantCodeRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(String),
    );
    yield r'deviceId';
    yield serializers.serialize(
      object.deviceId,
      specifiedType: const FullType(String),
    );
    if (object.platform != null) {
      yield r'platform';
      yield serializers.serialize(
        object.platform,
        specifiedType: const FullType(MerchantCodeRequestDtoPlatformEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantCodeRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantCodeRequestDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.phone = valueDes;
          break;
        case r'deviceId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.deviceId = valueDes;
          break;
        case r'platform':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(MerchantCodeRequestDtoPlatformEnum),
          ) as MerchantCodeRequestDtoPlatformEnum?;
          if (valueDes == null) continue;
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
  MerchantCodeRequestDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantCodeRequestDtoBuilder();
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


/// Windows sends no App Check token (owner decision 2026-11-07).
class MerchantCodeRequestDtoPlatformEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'android')
  static const MerchantCodeRequestDtoPlatformEnum android = _$merchantCodeRequestDtoPlatformEnum_android;
  @BuiltValueEnumConst(wireName: r'ios')
  static const MerchantCodeRequestDtoPlatformEnum ios = _$merchantCodeRequestDtoPlatformEnum_ios;
  @BuiltValueEnumConst(wireName: r'windows')
  static const MerchantCodeRequestDtoPlatformEnum windows = _$merchantCodeRequestDtoPlatformEnum_windows;

  static Serializer<MerchantCodeRequestDtoPlatformEnum> get serializer => _$merchantCodeRequestDtoPlatformEnumSerializer;

  const MerchantCodeRequestDtoPlatformEnum._(String name): super(name);

  static BuiltSet<MerchantCodeRequestDtoPlatformEnum> get values => _$merchantCodeRequestDtoPlatformEnumValues;
  static MerchantCodeRequestDtoPlatformEnum valueOf(String name) => _$merchantCodeRequestDtoPlatformEnumValueOf(name);
}

