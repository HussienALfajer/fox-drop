//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_device_dto.g.dart';

/// MerchantDeviceDto
///
/// Properties:
/// * [name] - Such as «كاشير 1» or «تابلت المطبخ».
/// * [platform] 
/// * [appVersion] 
@BuiltValue()
abstract class MerchantDeviceDto implements Built<MerchantDeviceDto, MerchantDeviceDtoBuilder> {
  /// Such as «كاشير 1» or «تابلت المطبخ».
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'platform')
  MerchantDeviceDtoPlatformEnum get platform;
  // enum platformEnum {  android,  ios,  windows,  };

  @BuiltValueField(wireName: r'appVersion')
  String get appVersion;

  MerchantDeviceDto._();

  factory MerchantDeviceDto([void updates(MerchantDeviceDtoBuilder b)]) = _$MerchantDeviceDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantDeviceDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantDeviceDto> get serializer => _$MerchantDeviceDtoSerializer();
}

class _$MerchantDeviceDtoSerializer implements PrimitiveSerializer<MerchantDeviceDto> {
  @override
  final Iterable<Type> types = const [MerchantDeviceDto, _$MerchantDeviceDto];

  @override
  final String wireName = r'MerchantDeviceDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantDeviceDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'platform';
    yield serializers.serialize(
      object.platform,
      specifiedType: const FullType(MerchantDeviceDtoPlatformEnum),
    );
    yield r'appVersion';
    yield serializers.serialize(
      object.appVersion,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantDeviceDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantDeviceDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'platform':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MerchantDeviceDtoPlatformEnum),
          ) as MerchantDeviceDtoPlatformEnum;
          result.platform = valueDes;
          break;
        case r'appVersion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.appVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantDeviceDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantDeviceDtoBuilder();
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


class MerchantDeviceDtoPlatformEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'android')
  static const MerchantDeviceDtoPlatformEnum android = _$merchantDeviceDtoPlatformEnum_android;
  @BuiltValueEnumConst(wireName: r'ios')
  static const MerchantDeviceDtoPlatformEnum ios = _$merchantDeviceDtoPlatformEnum_ios;
  @BuiltValueEnumConst(wireName: r'windows')
  static const MerchantDeviceDtoPlatformEnum windows = _$merchantDeviceDtoPlatformEnum_windows;

  static Serializer<MerchantDeviceDtoPlatformEnum> get serializer => _$merchantDeviceDtoPlatformEnumSerializer;

  const MerchantDeviceDtoPlatformEnum._(String name): super(name);

  static BuiltSet<MerchantDeviceDtoPlatformEnum> get values => _$merchantDeviceDtoPlatformEnumValues;
  static MerchantDeviceDtoPlatformEnum valueOf(String name) => _$merchantDeviceDtoPlatformEnumValueOf(name);
}

