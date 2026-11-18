//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_visibility_dto.g.dart';

/// AdminRestaurantVisibilityDto
///
/// Properties:
/// * [visible]
@BuiltValue()
abstract class AdminRestaurantVisibilityDto
    implements
        Built<
          AdminRestaurantVisibilityDto,
          AdminRestaurantVisibilityDtoBuilder
        > {
  @BuiltValueField(wireName: r'visible')
  bool get visible;

  AdminRestaurantVisibilityDto._();

  factory AdminRestaurantVisibilityDto([
    void updates(AdminRestaurantVisibilityDtoBuilder b),
  ]) = _$AdminRestaurantVisibilityDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantVisibilityDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantVisibilityDto> get serializer =>
      _$AdminRestaurantVisibilityDtoSerializer();
}

class _$AdminRestaurantVisibilityDtoSerializer
    implements PrimitiveSerializer<AdminRestaurantVisibilityDto> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantVisibilityDto,
    _$AdminRestaurantVisibilityDto,
  ];

  @override
  final String wireName = r'AdminRestaurantVisibilityDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantVisibilityDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'visible';
    yield serializers.serialize(
      object.visible,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantVisibilityDto object, {
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
    required AdminRestaurantVisibilityDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'visible':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.visible = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantVisibilityDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantVisibilityDtoBuilder();
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
