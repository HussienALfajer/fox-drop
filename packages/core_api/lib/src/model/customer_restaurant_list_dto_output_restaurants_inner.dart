//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/customer_restaurant_list_dto_output_restaurants_inner_estimate.dart';
import 'package:core_api/src/model/customer_restaurant_list_dto_output_restaurants_inner_state.dart';
import 'package:core_api/src/model/customer_restaurant_list_dto_output_restaurants_inner_delivery_fee.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_restaurant_list_dto_output_restaurants_inner.g.dart';

/// CustomerRestaurantListDtoOutputRestaurantsInner
///
/// Properties:
/// * [id]
/// * [nameAr]
/// * [nameEn]
/// * [category]
/// * [logoKey]
/// * [coverKey]
/// * [rating] - The average rating; null is «جديد» (Q16). Ratings arrive with their slice.
/// * [ratingCount] - The number of ratings on the page (CU §9.1).
/// * [estimate]
/// * [deliveryFee]
/// * [state]
@BuiltValue()
abstract class CustomerRestaurantListDtoOutputRestaurantsInner
    implements
        Built<
          CustomerRestaurantListDtoOutputRestaurantsInner,
          CustomerRestaurantListDtoOutputRestaurantsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'nameAr')
  String get nameAr;

  @BuiltValueField(wireName: r'nameEn')
  String? get nameEn;

  @BuiltValueField(wireName: r'category')
  String? get category;

  @BuiltValueField(wireName: r'logoKey')
  String? get logoKey;

  @BuiltValueField(wireName: r'coverKey')
  String? get coverKey;

  /// The average rating; null is «جديد» (Q16). Ratings arrive with their slice.
  @BuiltValueField(wireName: r'rating')
  num? get rating;

  /// The number of ratings on the page (CU §9.1).
  @BuiltValueField(wireName: r'ratingCount')
  int? get ratingCount;

  @BuiltValueField(wireName: r'estimate')
  CustomerRestaurantListDtoOutputRestaurantsInnerEstimate get estimate;

  @BuiltValueField(wireName: r'deliveryFee')
  CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee? get deliveryFee;

  @BuiltValueField(wireName: r'state')
  CustomerRestaurantListDtoOutputRestaurantsInnerState get state;

  CustomerRestaurantListDtoOutputRestaurantsInner._();

  factory CustomerRestaurantListDtoOutputRestaurantsInner([
    void updates(CustomerRestaurantListDtoOutputRestaurantsInnerBuilder b),
  ]) = _$CustomerRestaurantListDtoOutputRestaurantsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CustomerRestaurantListDtoOutputRestaurantsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerRestaurantListDtoOutputRestaurantsInner>
  get serializer =>
      _$CustomerRestaurantListDtoOutputRestaurantsInnerSerializer();
}

class _$CustomerRestaurantListDtoOutputRestaurantsInnerSerializer
    implements
        PrimitiveSerializer<CustomerRestaurantListDtoOutputRestaurantsInner> {
  @override
  final Iterable<Type> types = const [
    CustomerRestaurantListDtoOutputRestaurantsInner,
    _$CustomerRestaurantListDtoOutputRestaurantsInner,
  ];

  @override
  final String wireName = r'CustomerRestaurantListDtoOutputRestaurantsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerRestaurantListDtoOutputRestaurantsInner object, {
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
              CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee,
            ),
          );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(
        CustomerRestaurantListDtoOutputRestaurantsInnerState,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerRestaurantListDtoOutputRestaurantsInner object, {
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
    required CustomerRestaurantListDtoOutputRestaurantsInnerBuilder result,
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
                      CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee,
                    ),
                  )
                  as CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee?;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerRestaurantListDtoOutputRestaurantsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerRestaurantListDtoOutputRestaurantsInnerBuilder();
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
