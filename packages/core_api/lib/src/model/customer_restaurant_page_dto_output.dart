//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_went_offline_dto_output_hand_in.dart';
import 'package:core_api/src/model/customer_restaurant_list_dto_output_restaurants_inner_estimate.dart';
import 'package:core_api/src/model/customer_restaurant_page_dto_output_delivery_fee.dart';
import 'package:core_api/src/model/customer_restaurant_page_dto_output_schedule_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/customer_restaurant_list_dto_output_restaurants_inner_state.dart';
import 'package:core_api/src/model/customer_restaurant_page_dto_output_menu_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_restaurant_page_dto_output.g.dart';

/// CustomerRestaurantPageDtoOutput
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
/// * [description]
/// * [minimumOrder]
/// * [freeDeliveryFrom]
/// * [schedule] - «أوقات العمل» (RA §10).
/// * [deliversHere] - Whether the restaurant covers the point; when false, the fee and estimate are no offer and nothing can be added.
/// * [menu]
@BuiltValue()
abstract class CustomerRestaurantPageDtoOutput
    implements
        Built<
          CustomerRestaurantPageDtoOutput,
          CustomerRestaurantPageDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'nameAr')
  String get nameAr;

  @BuiltValueField(wireName: r'nameEn')
  BuiltList<String> get nameEn;

  @BuiltValueField(wireName: r'category')
  BuiltList<String> get category;

  @BuiltValueField(wireName: r'logoKey')
  BuiltList<String> get logoKey;

  @BuiltValueField(wireName: r'coverKey')
  BuiltList<String> get coverKey;

  /// The average rating; null is «جديد» (Q16). Ratings arrive with their slice.
  @BuiltValueField(wireName: r'rating')
  BuiltList<num> get rating;

  /// The number of ratings on the page (CU §9.1).
  @BuiltValueField(wireName: r'ratingCount')
  int? get ratingCount;

  @BuiltValueField(wireName: r'estimate')
  CustomerRestaurantListDtoOutputRestaurantsInnerEstimate get estimate;

  @BuiltValueField(wireName: r'deliveryFee')
  CustomerRestaurantPageDtoOutputDeliveryFee? get deliveryFee;

  @BuiltValueField(wireName: r'state')
  CustomerRestaurantListDtoOutputRestaurantsInnerState get state;

  @BuiltValueField(wireName: r'description')
  BuiltList<String> get description;

  @BuiltValueField(wireName: r'minimumOrder')
  CaptainWentOfflineDtoOutputHandIn? get minimumOrder;

  @BuiltValueField(wireName: r'freeDeliveryFrom')
  CaptainWentOfflineDtoOutputHandIn? get freeDeliveryFrom;

  /// «أوقات العمل» (RA §10).
  @BuiltValueField(wireName: r'schedule')
  BuiltList<CustomerRestaurantPageDtoOutputScheduleInner> get schedule;

  /// Whether the restaurant covers the point; when false, the fee and estimate are no offer and nothing can be added.
  @BuiltValueField(wireName: r'deliversHere')
  bool get deliversHere;

  @BuiltValueField(wireName: r'menu')
  BuiltList<CustomerRestaurantPageDtoOutputMenuInner> get menu;

  CustomerRestaurantPageDtoOutput._();

  factory CustomerRestaurantPageDtoOutput([
    void updates(CustomerRestaurantPageDtoOutputBuilder b),
  ]) = _$CustomerRestaurantPageDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerRestaurantPageDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerRestaurantPageDtoOutput> get serializer =>
      _$CustomerRestaurantPageDtoOutputSerializer();
}

class _$CustomerRestaurantPageDtoOutputSerializer
    implements PrimitiveSerializer<CustomerRestaurantPageDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CustomerRestaurantPageDtoOutput,
    _$CustomerRestaurantPageDtoOutput,
  ];

  @override
  final String wireName = r'CustomerRestaurantPageDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerRestaurantPageDtoOutput object, {
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
    yield serializers.serialize(
      object.nameEn,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'logoKey';
    yield serializers.serialize(
      object.logoKey,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'coverKey';
    yield serializers.serialize(
      object.coverKey,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'rating';
    yield serializers.serialize(
      object.rating,
      specifiedType: const FullType(BuiltList, [FullType(num)]),
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
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'minimumOrder';
    yield object.minimumOrder == null
        ? null
        : serializers.serialize(
            object.minimumOrder,
            specifiedType: const FullType.nullable(
              CaptainWentOfflineDtoOutputHandIn,
            ),
          );
    yield r'freeDeliveryFrom';
    yield object.freeDeliveryFrom == null
        ? null
        : serializers.serialize(
            object.freeDeliveryFrom,
            specifiedType: const FullType.nullable(
              CaptainWentOfflineDtoOutputHandIn,
            ),
          );
    yield r'schedule';
    yield serializers.serialize(
      object.schedule,
      specifiedType: const FullType(BuiltList, [
        FullType(CustomerRestaurantPageDtoOutputScheduleInner),
      ]),
    );
    yield r'deliversHere';
    yield serializers.serialize(
      object.deliversHere,
      specifiedType: const FullType(bool),
    );
    yield r'menu';
    yield serializers.serialize(
      object.menu,
      specifiedType: const FullType(BuiltList, [
        FullType(CustomerRestaurantPageDtoOutputMenuInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerRestaurantPageDtoOutput object, {
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
    required CustomerRestaurantPageDtoOutputBuilder result,
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
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.nameEn.replace(valueDes);
          break;
        case r'category':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.category.replace(valueDes);
          break;
        case r'logoKey':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.logoKey.replace(valueDes);
          break;
        case r'coverKey':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.coverKey.replace(valueDes);
          break;
        case r'rating':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [FullType(num)]),
                  )
                  as BuiltList<num>;
          result.rating.replace(valueDes);
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
        case r'description':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.description.replace(valueDes);
          break;
        case r'minimumOrder':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainWentOfflineDtoOutputHandIn,
                    ),
                  )
                  as CaptainWentOfflineDtoOutputHandIn?;
          if (valueDes == null) continue;
          result.minimumOrder.replace(valueDes);
          break;
        case r'freeDeliveryFrom':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainWentOfflineDtoOutputHandIn,
                    ),
                  )
                  as CaptainWentOfflineDtoOutputHandIn?;
          if (valueDes == null) continue;
          result.freeDeliveryFrom.replace(valueDes);
          break;
        case r'schedule':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CustomerRestaurantPageDtoOutputScheduleInner),
                    ]),
                  )
                  as BuiltList<CustomerRestaurantPageDtoOutputScheduleInner>;
          result.schedule.replace(valueDes);
          break;
        case r'deliversHere':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.deliversHere = valueDes;
          break;
        case r'menu':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CustomerRestaurantPageDtoOutputMenuInner),
                    ]),
                  )
                  as BuiltList<CustomerRestaurantPageDtoOutputMenuInner>;
          result.menu.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerRestaurantPageDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerRestaurantPageDtoOutputBuilder();
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
