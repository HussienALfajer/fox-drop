//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/customer_active_orders_dto_output_orders_inner_rating_captain.dart';
import 'package:core_api/src/model/customer_active_orders_dto_output_orders_inner_rating_restaurant.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_active_orders_dto_output_orders_inner_rating.g.dart';

/// CU §12.1 (slice 2.26a): the order's ratings; the app opens the sheet once after the delivery, then offers it on the detail until `until`. Null in the list of active orders.
///
/// Properties:
/// * [until] - «قيّم طلبك» until then (CU §12.1: customer.rating_window_days after the delivery), while a part is left to send; null once both are sent, past the window, or for an order that cannot be rated (not delivered, or a free re-delivery).
/// * [captainRatable] - «قيّم الكابتن» is offered: a captain delivered the order (after a handover, the second).
/// * [restaurant]
/// * [captain]
@BuiltValue()
abstract class CustomerActiveOrdersDtoOutputOrdersInnerRating
    implements
        Built<
          CustomerActiveOrdersDtoOutputOrdersInnerRating,
          CustomerActiveOrdersDtoOutputOrdersInnerRatingBuilder
        > {
  /// «قيّم طلبك» until then (CU §12.1: customer.rating_window_days after the delivery), while a part is left to send; null once both are sent, past the window, or for an order that cannot be rated (not delivered, or a free re-delivery).
  @BuiltValueField(wireName: r'until')
  DateTime? get until;

  /// «قيّم الكابتن» is offered: a captain delivered the order (after a handover, the second).
  @BuiltValueField(wireName: r'captainRatable')
  bool get captainRatable;

  @BuiltValueField(wireName: r'restaurant')
  CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurant? get restaurant;

  @BuiltValueField(wireName: r'captain')
  CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain? get captain;

  CustomerActiveOrdersDtoOutputOrdersInnerRating._();

  factory CustomerActiveOrdersDtoOutputOrdersInnerRating([
    void updates(CustomerActiveOrdersDtoOutputOrdersInnerRatingBuilder b),
  ]) = _$CustomerActiveOrdersDtoOutputOrdersInnerRating;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CustomerActiveOrdersDtoOutputOrdersInnerRatingBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerActiveOrdersDtoOutputOrdersInnerRating>
  get serializer =>
      _$CustomerActiveOrdersDtoOutputOrdersInnerRatingSerializer();
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerRatingSerializer
    implements
        PrimitiveSerializer<CustomerActiveOrdersDtoOutputOrdersInnerRating> {
  @override
  final Iterable<Type> types = const [
    CustomerActiveOrdersDtoOutputOrdersInnerRating,
    _$CustomerActiveOrdersDtoOutputOrdersInnerRating,
  ];

  @override
  final String wireName = r'CustomerActiveOrdersDtoOutputOrdersInnerRating';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerRating object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'until';
    yield object.until == null
        ? null
        : serializers.serialize(
            object.until,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'captainRatable';
    yield serializers.serialize(
      object.captainRatable,
      specifiedType: const FullType(bool),
    );
    yield r'restaurant';
    yield object.restaurant == null
        ? null
        : serializers.serialize(
            object.restaurant,
            specifiedType: const FullType.nullable(
              CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurant,
            ),
          );
    yield r'captain';
    yield object.captain == null
        ? null
        : serializers.serialize(
            object.captain,
            specifiedType: const FullType.nullable(
              CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerRating object, {
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
    required CustomerActiveOrdersDtoOutputOrdersInnerRatingBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'until':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.until = valueDes;
          break;
        case r'captainRatable':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.captainRatable = valueDes;
          break;
        case r'restaurant':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurant,
                    ),
                  )
                  as CustomerActiveOrdersDtoOutputOrdersInnerRatingRestaurant?;
          if (valueDes == null) continue;
          result.restaurant.replace(valueDes);
          break;
        case r'captain':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain,
                    ),
                  )
                  as CustomerActiveOrdersDtoOutputOrdersInnerRatingCaptain?;
          if (valueDes == null) continue;
          result.captain.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerRating deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerActiveOrdersDtoOutputOrdersInnerRatingBuilder();
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
