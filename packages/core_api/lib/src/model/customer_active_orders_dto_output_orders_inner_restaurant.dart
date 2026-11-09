//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_active_orders_dto_output_orders_inner_restaurant.g.dart';

/// CustomerActiveOrdersDtoOutputOrdersInnerRestaurant
///
/// Properties:
/// * [id] 
/// * [nameAr] 
/// * [nameEn] 
@BuiltValue()
abstract class CustomerActiveOrdersDtoOutputOrdersInnerRestaurant implements Built<CustomerActiveOrdersDtoOutputOrdersInnerRestaurant, CustomerActiveOrdersDtoOutputOrdersInnerRestaurantBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'nameAr')
  String get nameAr;

  @BuiltValueField(wireName: r'nameEn')
  String? get nameEn;

  CustomerActiveOrdersDtoOutputOrdersInnerRestaurant._();

  factory CustomerActiveOrdersDtoOutputOrdersInnerRestaurant([void updates(CustomerActiveOrdersDtoOutputOrdersInnerRestaurantBuilder b)]) = _$CustomerActiveOrdersDtoOutputOrdersInnerRestaurant;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerActiveOrdersDtoOutputOrdersInnerRestaurantBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerActiveOrdersDtoOutputOrdersInnerRestaurant> get serializer => _$CustomerActiveOrdersDtoOutputOrdersInnerRestaurantSerializer();
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerRestaurantSerializer implements PrimitiveSerializer<CustomerActiveOrdersDtoOutputOrdersInnerRestaurant> {
  @override
  final Iterable<Type> types = const [CustomerActiveOrdersDtoOutputOrdersInnerRestaurant, _$CustomerActiveOrdersDtoOutputOrdersInnerRestaurant];

  @override
  final String wireName = r'CustomerActiveOrdersDtoOutputOrdersInnerRestaurant';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerRestaurant object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'nameAr';
    yield serializers.serialize(
      object.nameAr,
      specifiedType: const FullType(String),
    );
    yield r'nameEn';
    yield object.nameEn == null ? null : serializers.serialize(
      object.nameEn,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerRestaurant object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerActiveOrdersDtoOutputOrdersInnerRestaurantBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'nameAr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nameAr = valueDes;
          break;
        case r'nameEn':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nameEn = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerRestaurant deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerActiveOrdersDtoOutputOrdersInnerRestaurantBuilder();
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


