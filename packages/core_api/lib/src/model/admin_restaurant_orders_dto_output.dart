//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_restaurant_orders_dto_output_orders_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_orders_dto_output.g.dart';

/// AdminRestaurantOrdersDtoOutput
///
/// Properties:
/// * [orders] - The latest 50, newest first.
@BuiltValue()
abstract class AdminRestaurantOrdersDtoOutput
    implements
        Built<
          AdminRestaurantOrdersDtoOutput,
          AdminRestaurantOrdersDtoOutputBuilder
        > {
  /// The latest 50, newest first.
  @BuiltValueField(wireName: r'orders')
  BuiltList<AdminRestaurantOrdersDtoOutputOrdersInner> get orders;

  AdminRestaurantOrdersDtoOutput._();

  factory AdminRestaurantOrdersDtoOutput([
    void updates(AdminRestaurantOrdersDtoOutputBuilder b),
  ]) = _$AdminRestaurantOrdersDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantOrdersDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantOrdersDtoOutput> get serializer =>
      _$AdminRestaurantOrdersDtoOutputSerializer();
}

class _$AdminRestaurantOrdersDtoOutputSerializer
    implements PrimitiveSerializer<AdminRestaurantOrdersDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantOrdersDtoOutput,
    _$AdminRestaurantOrdersDtoOutput,
  ];

  @override
  final String wireName = r'AdminRestaurantOrdersDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantOrdersDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminRestaurantOrdersDtoOutputOrdersInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantOrdersDtoOutput object, {
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
    required AdminRestaurantOrdersDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'orders':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminRestaurantOrdersDtoOutputOrdersInner),
                    ]),
                  )
                  as BuiltList<AdminRestaurantOrdersDtoOutputOrdersInner>;
          result.orders.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantOrdersDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantOrdersDtoOutputBuilder();
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
