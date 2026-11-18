//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_restaurant_list_dto_output_banners_inner.g.dart';

/// CustomerRestaurantListDtoOutputBannersInner
///
/// Properties:
/// * [id]
/// * [title]
/// * [imageKey] - In public-media, 1200×500 (architecture §5.8).
/// * [target] - The tap opens the restaurant’s page (restaurantIds holds it), the category’s page, the banner’s list under its title (restaurantIds), or «أكوادي» on its code.
/// * [restaurantIds] - Cards of `restaurants`, open first and closed last; empty otherwise.
/// * [categoryId]
/// * [code]
@BuiltValue()
abstract class CustomerRestaurantListDtoOutputBannersInner
    implements
        Built<
          CustomerRestaurantListDtoOutputBannersInner,
          CustomerRestaurantListDtoOutputBannersInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'title')
  String get title;

  /// In public-media, 1200×500 (architecture §5.8).
  @BuiltValueField(wireName: r'imageKey')
  String get imageKey;

  /// The tap opens the restaurant’s page (restaurantIds holds it), the category’s page, the banner’s list under its title (restaurantIds), or «أكوادي» on its code.
  @BuiltValueField(wireName: r'target')
  CustomerRestaurantListDtoOutputBannersInnerTargetEnum get target;
  // enum targetEnum {  restaurant,  category,  restaurants,  code,  };

  /// Cards of `restaurants`, open first and closed last; empty otherwise.
  @BuiltValueField(wireName: r'restaurantIds')
  BuiltList<String> get restaurantIds;

  @BuiltValueField(wireName: r'categoryId')
  String? get categoryId;

  @BuiltValueField(wireName: r'code')
  String? get code;

  CustomerRestaurantListDtoOutputBannersInner._();

  factory CustomerRestaurantListDtoOutputBannersInner([
    void updates(CustomerRestaurantListDtoOutputBannersInnerBuilder b),
  ]) = _$CustomerRestaurantListDtoOutputBannersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerRestaurantListDtoOutputBannersInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerRestaurantListDtoOutputBannersInner>
  get serializer => _$CustomerRestaurantListDtoOutputBannersInnerSerializer();
}

class _$CustomerRestaurantListDtoOutputBannersInnerSerializer
    implements
        PrimitiveSerializer<CustomerRestaurantListDtoOutputBannersInner> {
  @override
  final Iterable<Type> types = const [
    CustomerRestaurantListDtoOutputBannersInner,
    _$CustomerRestaurantListDtoOutputBannersInner,
  ];

  @override
  final String wireName = r'CustomerRestaurantListDtoOutputBannersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerRestaurantListDtoOutputBannersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'imageKey';
    yield serializers.serialize(
      object.imageKey,
      specifiedType: const FullType(String),
    );
    yield r'target';
    yield serializers.serialize(
      object.target,
      specifiedType: const FullType(
        CustomerRestaurantListDtoOutputBannersInnerTargetEnum,
      ),
    );
    yield r'restaurantIds';
    yield serializers.serialize(
      object.restaurantIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'categoryId';
    yield object.categoryId == null
        ? null
        : serializers.serialize(
            object.categoryId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'code';
    yield object.code == null
        ? null
        : serializers.serialize(
            object.code,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerRestaurantListDtoOutputBannersInner object, {
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
    required CustomerRestaurantListDtoOutputBannersInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
        case r'title':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.title = valueDes;
          break;
        case r'imageKey':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.imageKey = valueDes;
          break;
        case r'target':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerRestaurantListDtoOutputBannersInnerTargetEnum,
                    ),
                  )
                  as CustomerRestaurantListDtoOutputBannersInnerTargetEnum;
          result.target = valueDes;
          break;
        case r'restaurantIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.restaurantIds.replace(valueDes);
          break;
        case r'categoryId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.categoryId = valueDes;
          break;
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.code = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerRestaurantListDtoOutputBannersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerRestaurantListDtoOutputBannersInnerBuilder();
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

/// The tap opens the restaurant’s page (restaurantIds holds it), the category’s page, the banner’s list under its title (restaurantIds), or «أكوادي» on its code.
class CustomerRestaurantListDtoOutputBannersInnerTargetEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const CustomerRestaurantListDtoOutputBannersInnerTargetEnum
  restaurant =
      _$customerRestaurantListDtoOutputBannersInnerTargetEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'category')
  static const CustomerRestaurantListDtoOutputBannersInnerTargetEnum category =
      _$customerRestaurantListDtoOutputBannersInnerTargetEnum_category;
  @BuiltValueEnumConst(wireName: r'restaurants')
  static const CustomerRestaurantListDtoOutputBannersInnerTargetEnum
  restaurants =
      _$customerRestaurantListDtoOutputBannersInnerTargetEnum_restaurants;
  @BuiltValueEnumConst(wireName: r'code')
  static const CustomerRestaurantListDtoOutputBannersInnerTargetEnum code =
      _$customerRestaurantListDtoOutputBannersInnerTargetEnum_code;

  static Serializer<CustomerRestaurantListDtoOutputBannersInnerTargetEnum>
  get serializer =>
      _$customerRestaurantListDtoOutputBannersInnerTargetEnumSerializer;

  const CustomerRestaurantListDtoOutputBannersInnerTargetEnum._(String name)
    : super(name);

  static BuiltSet<CustomerRestaurantListDtoOutputBannersInnerTargetEnum>
  get values => _$customerRestaurantListDtoOutputBannersInnerTargetEnumValues;
  static CustomerRestaurantListDtoOutputBannersInnerTargetEnum valueOf(
    String name,
  ) => _$customerRestaurantListDtoOutputBannersInnerTargetEnumValueOf(name);
}
