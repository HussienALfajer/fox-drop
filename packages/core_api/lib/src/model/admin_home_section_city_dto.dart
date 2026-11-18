//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_home_section_city_dto.g.dart';

/// AdminHomeSectionCityDto
///
/// Properties:
/// * [cityId]
@BuiltValue()
abstract class AdminHomeSectionCityDto
    implements Built<AdminHomeSectionCityDto, AdminHomeSectionCityDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  AdminHomeSectionCityDto._();

  factory AdminHomeSectionCityDto([
    void updates(AdminHomeSectionCityDtoBuilder b),
  ]) = _$AdminHomeSectionCityDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminHomeSectionCityDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminHomeSectionCityDto> get serializer =>
      _$AdminHomeSectionCityDtoSerializer();
}

class _$AdminHomeSectionCityDtoSerializer
    implements PrimitiveSerializer<AdminHomeSectionCityDto> {
  @override
  final Iterable<Type> types = const [
    AdminHomeSectionCityDto,
    _$AdminHomeSectionCityDto,
  ];

  @override
  final String wireName = r'AdminHomeSectionCityDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminHomeSectionCityDto object, {
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
    AdminHomeSectionCityDto object, {
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
    required AdminHomeSectionCityDtoBuilder result,
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
  AdminHomeSectionCityDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminHomeSectionCityDtoBuilder();
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
