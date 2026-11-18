//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_banner_city_dto.g.dart';

/// AdminBannerCityDto
///
/// Properties:
/// * [cityId]
@BuiltValue()
abstract class AdminBannerCityDto
    implements Built<AdminBannerCityDto, AdminBannerCityDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  AdminBannerCityDto._();

  factory AdminBannerCityDto([void updates(AdminBannerCityDtoBuilder b)]) =
      _$AdminBannerCityDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminBannerCityDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminBannerCityDto> get serializer =>
      _$AdminBannerCityDtoSerializer();
}

class _$AdminBannerCityDtoSerializer
    implements PrimitiveSerializer<AdminBannerCityDto> {
  @override
  final Iterable<Type> types = const [AdminBannerCityDto, _$AdminBannerCityDto];

  @override
  final String wireName = r'AdminBannerCityDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminBannerCityDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminBannerCityDto object, {
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
    required AdminBannerCityDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminBannerCityDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminBannerCityDtoBuilder();
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
