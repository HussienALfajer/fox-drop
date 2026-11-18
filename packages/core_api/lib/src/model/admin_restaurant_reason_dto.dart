//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_reason_dto.g.dart';

/// AdminRestaurantReasonDto
///
/// Properties:
/// * [reason] - Why, for the change log (AP §9.6.5).
@BuiltValue()
abstract class AdminRestaurantReasonDto
    implements
        Built<AdminRestaurantReasonDto, AdminRestaurantReasonDtoBuilder> {
  /// Why, for the change log (AP §9.6.5).
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminRestaurantReasonDto._();

  factory AdminRestaurantReasonDto([
    void updates(AdminRestaurantReasonDtoBuilder b),
  ]) = _$AdminRestaurantReasonDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantReasonDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantReasonDto> get serializer =>
      _$AdminRestaurantReasonDtoSerializer();
}

class _$AdminRestaurantReasonDtoSerializer
    implements PrimitiveSerializer<AdminRestaurantReasonDto> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantReasonDto,
    _$AdminRestaurantReasonDto,
  ];

  @override
  final String wireName = r'AdminRestaurantReasonDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantReasonDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantReasonDto object, {
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
    required AdminRestaurantReasonDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantReasonDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantReasonDtoBuilder();
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
