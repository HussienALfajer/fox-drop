//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_max_active_orders_dto.g.dart';

/// AdminRestaurantMaxActiveOrdersDto
///
/// Properties:
/// * [maxActiveOrders] - Off (null) or 1 to 50 (RA §7.4).
@BuiltValue()
abstract class AdminRestaurantMaxActiveOrdersDto
    implements
        Built<
          AdminRestaurantMaxActiveOrdersDto,
          AdminRestaurantMaxActiveOrdersDtoBuilder
        > {
  /// Off (null) or 1 to 50 (RA §7.4).
  @BuiltValueField(wireName: r'maxActiveOrders')
  int? get maxActiveOrders;

  AdminRestaurantMaxActiveOrdersDto._();

  factory AdminRestaurantMaxActiveOrdersDto([
    void updates(AdminRestaurantMaxActiveOrdersDtoBuilder b),
  ]) = _$AdminRestaurantMaxActiveOrdersDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantMaxActiveOrdersDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantMaxActiveOrdersDto> get serializer =>
      _$AdminRestaurantMaxActiveOrdersDtoSerializer();
}

class _$AdminRestaurantMaxActiveOrdersDtoSerializer
    implements PrimitiveSerializer<AdminRestaurantMaxActiveOrdersDto> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantMaxActiveOrdersDto,
    _$AdminRestaurantMaxActiveOrdersDto,
  ];

  @override
  final String wireName = r'AdminRestaurantMaxActiveOrdersDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantMaxActiveOrdersDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'maxActiveOrders';
    yield object.maxActiveOrders == null
        ? null
        : serializers.serialize(
            object.maxActiveOrders,
            specifiedType: const FullType.nullable(int),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantMaxActiveOrdersDto object, {
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
    required AdminRestaurantMaxActiveOrdersDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'maxActiveOrders':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.maxActiveOrders = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantMaxActiveOrdersDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantMaxActiveOrdersDtoBuilder();
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
