//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_mass_push_city_dto.g.dart';

/// AdminMassPushCityDto
///
/// Properties:
/// * [cityId]
@BuiltValue()
abstract class AdminMassPushCityDto
    implements Built<AdminMassPushCityDto, AdminMassPushCityDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  AdminMassPushCityDto._();

  factory AdminMassPushCityDto([void updates(AdminMassPushCityDtoBuilder b)]) =
      _$AdminMassPushCityDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMassPushCityDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMassPushCityDto> get serializer =>
      _$AdminMassPushCityDtoSerializer();
}

class _$AdminMassPushCityDtoSerializer
    implements PrimitiveSerializer<AdminMassPushCityDto> {
  @override
  final Iterable<Type> types = const [
    AdminMassPushCityDto,
    _$AdminMassPushCityDto,
  ];

  @override
  final String wireName = r'AdminMassPushCityDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMassPushCityDto object, {
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
    AdminMassPushCityDto object, {
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
    required AdminMassPushCityDtoBuilder result,
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
  AdminMassPushCityDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMassPushCityDtoBuilder();
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
