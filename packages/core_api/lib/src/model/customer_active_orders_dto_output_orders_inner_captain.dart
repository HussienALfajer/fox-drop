//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_active_orders_dto_output_orders_inner_captain.g.dart';

/// The captain card from assignment (CU §11.3, Q14): «الكابتن {الاسم} في طريقه إلى المطعم»; never the phone number or the captain track (CU §11.2). The photo comes with the object storage.
///
/// Properties:
/// * [firstName] 
/// * [vehicle] - «سيراً على الأقدام», «دراجة», «دراجة نارية» or «سيارة» (CU §11.3).
/// * [atRestaurant] - Before the pickup: «الكابتن {الاسم} وصل إلى المطعم», or «الكابتن يستلم طلبك الآن» once ready (CU §11.2).
@BuiltValue()
abstract class CustomerActiveOrdersDtoOutputOrdersInnerCaptain implements Built<CustomerActiveOrdersDtoOutputOrdersInnerCaptain, CustomerActiveOrdersDtoOutputOrdersInnerCaptainBuilder> {
  @BuiltValueField(wireName: r'firstName')
  String get firstName;

  /// «سيراً على الأقدام», «دراجة», «دراجة نارية» or «سيارة» (CU §11.3).
  @BuiltValueField(wireName: r'vehicle')
  CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum get vehicle;
  // enum vehicleEnum {  walking,  bicycle,  motorbike,  car,  };

  /// Before the pickup: «الكابتن {الاسم} وصل إلى المطعم», or «الكابتن يستلم طلبك الآن» once ready (CU §11.2).
  @BuiltValueField(wireName: r'atRestaurant')
  bool get atRestaurant;

  CustomerActiveOrdersDtoOutputOrdersInnerCaptain._();

  factory CustomerActiveOrdersDtoOutputOrdersInnerCaptain([void updates(CustomerActiveOrdersDtoOutputOrdersInnerCaptainBuilder b)]) = _$CustomerActiveOrdersDtoOutputOrdersInnerCaptain;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerActiveOrdersDtoOutputOrdersInnerCaptainBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerActiveOrdersDtoOutputOrdersInnerCaptain> get serializer => _$CustomerActiveOrdersDtoOutputOrdersInnerCaptainSerializer();
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerCaptainSerializer implements PrimitiveSerializer<CustomerActiveOrdersDtoOutputOrdersInnerCaptain> {
  @override
  final Iterable<Type> types = const [CustomerActiveOrdersDtoOutputOrdersInnerCaptain, _$CustomerActiveOrdersDtoOutputOrdersInnerCaptain];

  @override
  final String wireName = r'CustomerActiveOrdersDtoOutputOrdersInnerCaptain';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerCaptain object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'firstName';
    yield serializers.serialize(
      object.firstName,
      specifiedType: const FullType(String),
    );
    yield r'vehicle';
    yield serializers.serialize(
      object.vehicle,
      specifiedType: const FullType(CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum),
    );
    yield r'atRestaurant';
    yield serializers.serialize(
      object.atRestaurant,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerCaptain object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerActiveOrdersDtoOutputOrdersInnerCaptainBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'firstName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.firstName = valueDes;
          break;
        case r'vehicle':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum),
          ) as CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum;
          result.vehicle = valueDes;
          break;
        case r'atRestaurant':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.atRestaurant = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerCaptain deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerActiveOrdersDtoOutputOrdersInnerCaptainBuilder();
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


/// «سيراً على الأقدام», «دراجة», «دراجة نارية» or «سيارة» (CU §11.3).
class CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'walking')
  static const CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum walking = _$customerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum_walking;
  @BuiltValueEnumConst(wireName: r'bicycle')
  static const CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum bicycle = _$customerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum_bicycle;
  @BuiltValueEnumConst(wireName: r'motorbike')
  static const CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum motorbike = _$customerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum_motorbike;
  @BuiltValueEnumConst(wireName: r'car')
  static const CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum car = _$customerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum_car;

  static Serializer<CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum> get serializer => _$customerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnumSerializer;

  const CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum._(String name): super(name);

  static BuiltSet<CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum> get values => _$customerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnumValues;
  static CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum valueOf(String name) => _$customerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnumValueOf(name);
}

