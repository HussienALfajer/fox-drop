//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/customer_restaurant_list_dto_output_restaurants_inner_estimate.dart';
import 'package:core_api/src/model/customer_restaurant_page_dto_output_delivery_fee.dart';
import 'package:core_api/src/model/admin_restaurant_draft_choices_dto_output_categories_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/customer_restaurant_list_dto_output_restaurants_inner_state.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_search_dto_output_restaurants_inner.g.dart';

/// CustomerSearchDtoOutputRestaurantsInner
///
/// Properties:
/// * [id]
/// * [nameAr]
/// * [nameEn]
/// * [category] - Deprecated (slice 2.27a): the first of `categories`, for older apps.
/// * [categories] - Its active categories (AP §9.13), in the restaurant’s order.
/// * [logoKey] - Its key in public-media, shown through imgproxy (architecture §5.8); null without one.
/// * [coverKey] - Its key in public-media, shown through imgproxy (architecture §5.8); null without one.
/// * [rating] - The restaurant's average stars to one decimal; null is «جديد», below 5 ratings (CU §12.1, Q16).
/// * [ratingCount] - The number of ratings beside the average (CU §8.2, §9.1); null with «جديد».
/// * [testMode] - «تجريبي»: in test mode, seen only by an admin test account (CU §8.2, AP §9.8).
/// * [estimate]
/// * [deliveryFee]
/// * [state]
/// * [favourite] - The heart (CU §9.6): a favourite of the signed-in customer; false for a guest.
@BuiltValue()
abstract class CustomerSearchDtoOutputRestaurantsInner
    implements
        Built<
          CustomerSearchDtoOutputRestaurantsInner,
          CustomerSearchDtoOutputRestaurantsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'nameAr')
  String get nameAr;

  @BuiltValueField(wireName: r'nameEn')
  String? get nameEn;

  /// Deprecated (slice 2.27a): the first of `categories`, for older apps.
  @BuiltValueField(wireName: r'category')
  String? get category;

  /// Its active categories (AP §9.13), in the restaurant’s order.
  @BuiltValueField(wireName: r'categories')
  BuiltList<AdminRestaurantDraftChoicesDtoOutputCategoriesInner> get categories;

  /// Its key in public-media, shown through imgproxy (architecture §5.8); null without one.
  @BuiltValueField(wireName: r'logoKey')
  String? get logoKey;

  /// Its key in public-media, shown through imgproxy (architecture §5.8); null without one.
  @BuiltValueField(wireName: r'coverKey')
  String? get coverKey;

  /// The restaurant's average stars to one decimal; null is «جديد», below 5 ratings (CU §12.1, Q16).
  @BuiltValueField(wireName: r'rating')
  num? get rating;

  /// The number of ratings beside the average (CU §8.2, §9.1); null with «جديد».
  @BuiltValueField(wireName: r'ratingCount')
  int? get ratingCount;

  /// «تجريبي»: in test mode, seen only by an admin test account (CU §8.2, AP §9.8).
  @BuiltValueField(wireName: r'testMode')
  bool get testMode;

  @BuiltValueField(wireName: r'estimate')
  CustomerRestaurantListDtoOutputRestaurantsInnerEstimate get estimate;

  @BuiltValueField(wireName: r'deliveryFee')
  CustomerRestaurantPageDtoOutputDeliveryFee? get deliveryFee;

  @BuiltValueField(wireName: r'state')
  CustomerRestaurantListDtoOutputRestaurantsInnerState get state;

  /// The heart (CU §9.6): a favourite of the signed-in customer; false for a guest.
  @BuiltValueField(wireName: r'favourite')
  bool get favourite;

  CustomerSearchDtoOutputRestaurantsInner._();

  factory CustomerSearchDtoOutputRestaurantsInner([
    void updates(CustomerSearchDtoOutputRestaurantsInnerBuilder b),
  ]) = _$CustomerSearchDtoOutputRestaurantsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerSearchDtoOutputRestaurantsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerSearchDtoOutputRestaurantsInner> get serializer =>
      _$CustomerSearchDtoOutputRestaurantsInnerSerializer();
}

class _$CustomerSearchDtoOutputRestaurantsInnerSerializer
    implements PrimitiveSerializer<CustomerSearchDtoOutputRestaurantsInner> {
  @override
  final Iterable<Type> types = const [
    CustomerSearchDtoOutputRestaurantsInner,
    _$CustomerSearchDtoOutputRestaurantsInner,
  ];

  @override
  final String wireName = r'CustomerSearchDtoOutputRestaurantsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerSearchDtoOutputRestaurantsInner object, {
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
    yield object.nameEn == null
        ? null
        : serializers.serialize(
            object.nameEn,
            specifiedType: const FullType.nullable(String),
          );
    yield r'category';
    yield object.category == null
        ? null
        : serializers.serialize(
            object.category,
            specifiedType: const FullType.nullable(String),
          );
    yield r'categories';
    yield serializers.serialize(
      object.categories,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminRestaurantDraftChoicesDtoOutputCategoriesInner),
      ]),
    );
    yield r'logoKey';
    yield object.logoKey == null
        ? null
        : serializers.serialize(
            object.logoKey,
            specifiedType: const FullType.nullable(String),
          );
    yield r'coverKey';
    yield object.coverKey == null
        ? null
        : serializers.serialize(
            object.coverKey,
            specifiedType: const FullType.nullable(String),
          );
    yield r'rating';
    yield object.rating == null
        ? null
        : serializers.serialize(
            object.rating,
            specifiedType: const FullType.nullable(num),
          );
    yield r'ratingCount';
    yield object.ratingCount == null
        ? null
        : serializers.serialize(
            object.ratingCount,
            specifiedType: const FullType.nullable(int),
          );
    yield r'testMode';
    yield serializers.serialize(
      object.testMode,
      specifiedType: const FullType(bool),
    );
    yield r'estimate';
    yield serializers.serialize(
      object.estimate,
      specifiedType: const FullType(
        CustomerRestaurantListDtoOutputRestaurantsInnerEstimate,
      ),
    );
    yield r'deliveryFee';
    yield object.deliveryFee == null
        ? null
        : serializers.serialize(
            object.deliveryFee,
            specifiedType: const FullType.nullable(
              CustomerRestaurantPageDtoOutputDeliveryFee,
            ),
          );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(
        CustomerRestaurantListDtoOutputRestaurantsInnerState,
      ),
    );
    yield r'favourite';
    yield serializers.serialize(
      object.favourite,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerSearchDtoOutputRestaurantsInner object, {
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
    required CustomerSearchDtoOutputRestaurantsInnerBuilder result,
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
        case r'nameAr':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.nameAr = valueDes;
          break;
        case r'nameEn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.nameEn = valueDes;
          break;
        case r'category':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.category = valueDes;
          break;
        case r'categories':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminRestaurantDraftChoicesDtoOutputCategoriesInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminRestaurantDraftChoicesDtoOutputCategoriesInner
                  >;
          result.categories.replace(valueDes);
          break;
        case r'logoKey':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.logoKey = valueDes;
          break;
        case r'coverKey':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.coverKey = valueDes;
          break;
        case r'rating':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(num),
                  )
                  as num?;
          if (valueDes == null) continue;
          result.rating = valueDes;
          break;
        case r'ratingCount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.ratingCount = valueDes;
          break;
        case r'testMode':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.testMode = valueDes;
          break;
        case r'estimate':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerRestaurantListDtoOutputRestaurantsInnerEstimate,
                    ),
                  )
                  as CustomerRestaurantListDtoOutputRestaurantsInnerEstimate;
          result.estimate.replace(valueDes);
          break;
        case r'deliveryFee':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CustomerRestaurantPageDtoOutputDeliveryFee,
                    ),
                  )
                  as CustomerRestaurantPageDtoOutputDeliveryFee?;
          if (valueDes == null) continue;
          result.deliveryFee.replace(valueDes);
          break;
        case r'state':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerRestaurantListDtoOutputRestaurantsInnerState,
                    ),
                  )
                  as CustomerRestaurantListDtoOutputRestaurantsInnerState;
          result.state.replace(valueDes);
          break;
        case r'favourite':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.favourite = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerSearchDtoOutputRestaurantsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerSearchDtoOutputRestaurantsInnerBuilder();
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
