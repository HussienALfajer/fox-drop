//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_restaurant_page_dto_output_menu_inner_window.g.dart';

/// Minutes after midnight on the city clock; «متوفر من {الساعة}» outside it.
///
/// Properties:
/// * [startsAt] 
/// * [endsAt] 
@BuiltValue()
abstract class CustomerRestaurantPageDtoOutputMenuInnerWindow implements Built<CustomerRestaurantPageDtoOutputMenuInnerWindow, CustomerRestaurantPageDtoOutputMenuInnerWindowBuilder> {
  @BuiltValueField(wireName: r'startsAt')
  int get startsAt;

  @BuiltValueField(wireName: r'endsAt')
  int get endsAt;

  CustomerRestaurantPageDtoOutputMenuInnerWindow._();

  factory CustomerRestaurantPageDtoOutputMenuInnerWindow([void updates(CustomerRestaurantPageDtoOutputMenuInnerWindowBuilder b)]) = _$CustomerRestaurantPageDtoOutputMenuInnerWindow;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerRestaurantPageDtoOutputMenuInnerWindowBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerRestaurantPageDtoOutputMenuInnerWindow> get serializer => _$CustomerRestaurantPageDtoOutputMenuInnerWindowSerializer();
}

class _$CustomerRestaurantPageDtoOutputMenuInnerWindowSerializer implements PrimitiveSerializer<CustomerRestaurantPageDtoOutputMenuInnerWindow> {
  @override
  final Iterable<Type> types = const [CustomerRestaurantPageDtoOutputMenuInnerWindow, _$CustomerRestaurantPageDtoOutputMenuInnerWindow];

  @override
  final String wireName = r'CustomerRestaurantPageDtoOutputMenuInnerWindow';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerRestaurantPageDtoOutputMenuInnerWindow object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'startsAt';
    yield serializers.serialize(
      object.startsAt,
      specifiedType: const FullType(int),
    );
    yield r'endsAt';
    yield serializers.serialize(
      object.endsAt,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerRestaurantPageDtoOutputMenuInnerWindow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerRestaurantPageDtoOutputMenuInnerWindowBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'startsAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.startsAt = valueDes;
          break;
        case r'endsAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.endsAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerRestaurantPageDtoOutputMenuInnerWindow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerRestaurantPageDtoOutputMenuInnerWindowBuilder();
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


