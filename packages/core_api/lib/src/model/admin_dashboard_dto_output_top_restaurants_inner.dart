//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_dto_output_top_restaurants_inner.g.dart';

/// AdminDashboardDtoOutputTopRestaurantsInner
///
/// Properties:
/// * [restaurantId]
/// * [name]
/// * [orders]
@BuiltValue()
abstract class AdminDashboardDtoOutputTopRestaurantsInner
    implements
        Built<
          AdminDashboardDtoOutputTopRestaurantsInner,
          AdminDashboardDtoOutputTopRestaurantsInnerBuilder
        > {
  @BuiltValueField(wireName: r'restaurantId')
  String get restaurantId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'orders')
  int get orders;

  AdminDashboardDtoOutputTopRestaurantsInner._();

  factory AdminDashboardDtoOutputTopRestaurantsInner([
    void updates(AdminDashboardDtoOutputTopRestaurantsInnerBuilder b),
  ]) = _$AdminDashboardDtoOutputTopRestaurantsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardDtoOutputTopRestaurantsInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardDtoOutputTopRestaurantsInner>
  get serializer => _$AdminDashboardDtoOutputTopRestaurantsInnerSerializer();
}

class _$AdminDashboardDtoOutputTopRestaurantsInnerSerializer
    implements PrimitiveSerializer<AdminDashboardDtoOutputTopRestaurantsInner> {
  @override
  final Iterable<Type> types = const [
    AdminDashboardDtoOutputTopRestaurantsInner,
    _$AdminDashboardDtoOutputTopRestaurantsInner,
  ];

  @override
  final String wireName = r'AdminDashboardDtoOutputTopRestaurantsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardDtoOutputTopRestaurantsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'restaurantId';
    yield serializers.serialize(
      object.restaurantId,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardDtoOutputTopRestaurantsInner object, {
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
    required AdminDashboardDtoOutputTopRestaurantsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'restaurantId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.restaurantId = valueDes;
          break;
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'orders':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.orders = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboardDtoOutputTopRestaurantsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardDtoOutputTopRestaurantsInnerBuilder();
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
