//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/customer_restaurant_page_dto_output_menu_inner_items_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/customer_restaurant_page_dto_output_menu_inner_window.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_restaurant_page_dto_output_menu_inner.g.dart';

/// CustomerRestaurantPageDtoOutputMenuInner
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [window] 
/// * [items] 
@BuiltValue()
abstract class CustomerRestaurantPageDtoOutputMenuInner implements Built<CustomerRestaurantPageDtoOutputMenuInner, CustomerRestaurantPageDtoOutputMenuInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'window')
  CustomerRestaurantPageDtoOutputMenuInnerWindow? get window;

  @BuiltValueField(wireName: r'items')
  BuiltList<CustomerRestaurantPageDtoOutputMenuInnerItemsInner> get items;

  CustomerRestaurantPageDtoOutputMenuInner._();

  factory CustomerRestaurantPageDtoOutputMenuInner([void updates(CustomerRestaurantPageDtoOutputMenuInnerBuilder b)]) = _$CustomerRestaurantPageDtoOutputMenuInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerRestaurantPageDtoOutputMenuInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerRestaurantPageDtoOutputMenuInner> get serializer => _$CustomerRestaurantPageDtoOutputMenuInnerSerializer();
}

class _$CustomerRestaurantPageDtoOutputMenuInnerSerializer implements PrimitiveSerializer<CustomerRestaurantPageDtoOutputMenuInner> {
  @override
  final Iterable<Type> types = const [CustomerRestaurantPageDtoOutputMenuInner, _$CustomerRestaurantPageDtoOutputMenuInner];

  @override
  final String wireName = r'CustomerRestaurantPageDtoOutputMenuInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerRestaurantPageDtoOutputMenuInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'window';
    yield object.window == null ? null : serializers.serialize(
      object.window,
      specifiedType: const FullType.nullable(CustomerRestaurantPageDtoOutputMenuInnerWindow),
    );
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(CustomerRestaurantPageDtoOutputMenuInnerItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerRestaurantPageDtoOutputMenuInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerRestaurantPageDtoOutputMenuInnerBuilder result,
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'window':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CustomerRestaurantPageDtoOutputMenuInnerWindow),
          ) as CustomerRestaurantPageDtoOutputMenuInnerWindow?;
          if (valueDes == null) continue;
          result.window.replace(valueDes);
          break;
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CustomerRestaurantPageDtoOutputMenuInnerItemsInner)]),
          ) as BuiltList<CustomerRestaurantPageDtoOutputMenuInnerItemsInner>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerRestaurantPageDtoOutputMenuInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerRestaurantPageDtoOutputMenuInnerBuilder();
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


