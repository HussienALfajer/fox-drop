//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_went_offline_dto_output_hand_in.dart';
import 'package:core_api/src/model/customer_search_dto_output_items_inner_from_price.dart';
import 'package:core_api/src/model/customer_search_dto_output_items_inner_option_groups_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/customer_restaurant_list_dto_output_restaurants_inner_state.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_search_dto_output_items_inner.g.dart';

/// CustomerSearchDtoOutputItemsInner
///
/// Properties:
/// * [id]
/// * [name]
/// * [description]
/// * [photoKey] - Its key in public-media, shown through imgproxy (architecture §5.8); null without one.
/// * [price]
/// * [fromPrice]
/// * [available]
/// * [unavailableReason] - «يتوفر غداً», «متوفر من {الساعة}» (its category window) or «غير متوفر حالياً».
/// * [optionGroups]
/// * [restaurantId]
/// * [restaurantName]
/// * [restaurantState]
@BuiltValue()
abstract class CustomerSearchDtoOutputItemsInner
    implements
        Built<
          CustomerSearchDtoOutputItemsInner,
          CustomerSearchDtoOutputItemsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'description')
  String? get description;

  /// Its key in public-media, shown through imgproxy (architecture §5.8); null without one.
  @BuiltValueField(wireName: r'photoKey')
  String? get photoKey;

  @BuiltValueField(wireName: r'price')
  CaptainWentOfflineDtoOutputHandIn? get price;

  @BuiltValueField(wireName: r'fromPrice')
  CustomerSearchDtoOutputItemsInnerFromPrice? get fromPrice;

  @BuiltValueField(wireName: r'available')
  bool get available;

  /// «يتوفر غداً», «متوفر من {الساعة}» (its category window) or «غير متوفر حالياً».
  @BuiltValueField(wireName: r'unavailableReason')
  CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum? get unavailableReason;
  // enum unavailableReasonEnum {  tomorrow,  window,  unavailable,  };

  @BuiltValueField(wireName: r'optionGroups')
  BuiltList<CustomerSearchDtoOutputItemsInnerOptionGroupsInner>
  get optionGroups;

  @BuiltValueField(wireName: r'restaurantId')
  String get restaurantId;

  @BuiltValueField(wireName: r'restaurantName')
  String get restaurantName;

  @BuiltValueField(wireName: r'restaurantState')
  CustomerRestaurantListDtoOutputRestaurantsInnerState get restaurantState;

  CustomerSearchDtoOutputItemsInner._();

  factory CustomerSearchDtoOutputItemsInner([
    void updates(CustomerSearchDtoOutputItemsInnerBuilder b),
  ]) = _$CustomerSearchDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerSearchDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerSearchDtoOutputItemsInner> get serializer =>
      _$CustomerSearchDtoOutputItemsInnerSerializer();
}

class _$CustomerSearchDtoOutputItemsInnerSerializer
    implements PrimitiveSerializer<CustomerSearchDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [
    CustomerSearchDtoOutputItemsInner,
    _$CustomerSearchDtoOutputItemsInner,
  ];

  @override
  final String wireName = r'CustomerSearchDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerSearchDtoOutputItemsInner object, {
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
    yield r'description';
    yield object.description == null
        ? null
        : serializers.serialize(
            object.description,
            specifiedType: const FullType.nullable(String),
          );
    yield r'photoKey';
    yield object.photoKey == null
        ? null
        : serializers.serialize(
            object.photoKey,
            specifiedType: const FullType.nullable(String),
          );
    yield r'price';
    yield object.price == null
        ? null
        : serializers.serialize(
            object.price,
            specifiedType: const FullType.nullable(
              CaptainWentOfflineDtoOutputHandIn,
            ),
          );
    yield r'fromPrice';
    yield object.fromPrice == null
        ? null
        : serializers.serialize(
            object.fromPrice,
            specifiedType: const FullType.nullable(
              CustomerSearchDtoOutputItemsInnerFromPrice,
            ),
          );
    yield r'available';
    yield serializers.serialize(
      object.available,
      specifiedType: const FullType(bool),
    );
    yield r'unavailableReason';
    yield object.unavailableReason == null
        ? null
        : serializers.serialize(
            object.unavailableReason,
            specifiedType: const FullType.nullable(
              CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum,
            ),
          );
    yield r'optionGroups';
    yield serializers.serialize(
      object.optionGroups,
      specifiedType: const FullType(BuiltList, [
        FullType(CustomerSearchDtoOutputItemsInnerOptionGroupsInner),
      ]),
    );
    yield r'restaurantId';
    yield serializers.serialize(
      object.restaurantId,
      specifiedType: const FullType(String),
    );
    yield r'restaurantName';
    yield serializers.serialize(
      object.restaurantName,
      specifiedType: const FullType(String),
    );
    yield r'restaurantState';
    yield serializers.serialize(
      object.restaurantState,
      specifiedType: const FullType(
        CustomerRestaurantListDtoOutputRestaurantsInnerState,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerSearchDtoOutputItemsInner object, {
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
    required CustomerSearchDtoOutputItemsInnerBuilder result,
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
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'description':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'photoKey':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.photoKey = valueDes;
          break;
        case r'price':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainWentOfflineDtoOutputHandIn,
                    ),
                  )
                  as CaptainWentOfflineDtoOutputHandIn?;
          if (valueDes == null) continue;
          result.price.replace(valueDes);
          break;
        case r'fromPrice':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CustomerSearchDtoOutputItemsInnerFromPrice,
                    ),
                  )
                  as CustomerSearchDtoOutputItemsInnerFromPrice?;
          if (valueDes == null) continue;
          result.fromPrice.replace(valueDes);
          break;
        case r'available':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.available = valueDes;
          break;
        case r'unavailableReason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum,
                    ),
                  )
                  as CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum?;
          if (valueDes == null) continue;
          result.unavailableReason = valueDes;
          break;
        case r'optionGroups':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        CustomerSearchDtoOutputItemsInnerOptionGroupsInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    CustomerSearchDtoOutputItemsInnerOptionGroupsInner
                  >;
          result.optionGroups.replace(valueDes);
          break;
        case r'restaurantId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.restaurantId = valueDes;
          break;
        case r'restaurantName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.restaurantName = valueDes;
          break;
        case r'restaurantState':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerRestaurantListDtoOutputRestaurantsInnerState,
                    ),
                  )
                  as CustomerRestaurantListDtoOutputRestaurantsInnerState;
          result.restaurantState.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerSearchDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerSearchDtoOutputItemsInnerBuilder();
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

/// «يتوفر غداً», «متوفر من {الساعة}» (its category window) or «غير متوفر حالياً».
class CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'tomorrow')
  static const CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum tomorrow =
      _$customerSearchDtoOutputItemsInnerUnavailableReasonEnum_tomorrow;
  @BuiltValueEnumConst(wireName: r'window')
  static const CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum window =
      _$customerSearchDtoOutputItemsInnerUnavailableReasonEnum_window;
  @BuiltValueEnumConst(wireName: r'unavailable')
  static const CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum
  unavailable =
      _$customerSearchDtoOutputItemsInnerUnavailableReasonEnum_unavailable;

  static Serializer<CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum>
  get serializer =>
      _$customerSearchDtoOutputItemsInnerUnavailableReasonEnumSerializer;

  const CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum._(String name)
    : super(name);

  static BuiltSet<CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum>
  get values => _$customerSearchDtoOutputItemsInnerUnavailableReasonEnumValues;
  static CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum valueOf(
    String name,
  ) => _$customerSearchDtoOutputItemsInnerUnavailableReasonEnumValueOf(name);
}
