//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_promo_code_city_dto.g.dart';

/// AdminPromoCodeCityDto
///
/// Properties:
/// * [cityId]
@BuiltValue()
abstract class AdminPromoCodeCityDto
    implements Built<AdminPromoCodeCityDto, AdminPromoCodeCityDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  AdminPromoCodeCityDto._();

  factory AdminPromoCodeCityDto([
    void updates(AdminPromoCodeCityDtoBuilder b),
  ]) = _$AdminPromoCodeCityDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPromoCodeCityDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPromoCodeCityDto> get serializer =>
      _$AdminPromoCodeCityDtoSerializer();
}

class _$AdminPromoCodeCityDtoSerializer
    implements PrimitiveSerializer<AdminPromoCodeCityDto> {
  @override
  final Iterable<Type> types = const [
    AdminPromoCodeCityDto,
    _$AdminPromoCodeCityDto,
  ];

  @override
  final String wireName = r'AdminPromoCodeCityDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPromoCodeCityDto object, {
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
    AdminPromoCodeCityDto object, {
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
    required AdminPromoCodeCityDtoBuilder result,
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
  AdminPromoCodeCityDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPromoCodeCityDtoBuilder();
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
