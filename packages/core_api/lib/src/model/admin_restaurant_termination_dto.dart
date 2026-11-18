//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_termination_dto.g.dart';

/// AdminRestaurantTerminationDto
///
/// Properties:
/// * [reason] - Why the contract ends (AP §9.6.5).
@BuiltValue()
abstract class AdminRestaurantTerminationDto
    implements
        Built<
          AdminRestaurantTerminationDto,
          AdminRestaurantTerminationDtoBuilder
        > {
  /// Why the contract ends (AP §9.6.5).
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminRestaurantTerminationDto._();

  factory AdminRestaurantTerminationDto([
    void updates(AdminRestaurantTerminationDtoBuilder b),
  ]) = _$AdminRestaurantTerminationDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantTerminationDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantTerminationDto> get serializer =>
      _$AdminRestaurantTerminationDtoSerializer();
}

class _$AdminRestaurantTerminationDtoSerializer
    implements PrimitiveSerializer<AdminRestaurantTerminationDto> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantTerminationDto,
    _$AdminRestaurantTerminationDto,
  ];

  @override
  final String wireName = r'AdminRestaurantTerminationDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantTerminationDto object, {
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
    AdminRestaurantTerminationDto object, {
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
    required AdminRestaurantTerminationDtoBuilder result,
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
  AdminRestaurantTerminationDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantTerminationDtoBuilder();
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
