//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_content_dto_output_reasons_merchant_rejection_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_content_dto_output_reasons.g.dart';

/// order_note: «الملاحظات الجاهزة» at checkout; the rating lists by stars (1–2, 3, 4–5).
///
/// Properties:
/// * [customerCancel]
/// * [customerProblem]
/// * [orderNote]
/// * [restaurantRatingLow]
/// * [restaurantRatingMid]
/// * [restaurantRatingHigh]
/// * [captainRatingLow]
/// * [captainRatingMid]
/// * [captainRatingHigh]
@BuiltValue()
abstract class CustomerContentDtoOutputReasons
    implements
        Built<
          CustomerContentDtoOutputReasons,
          CustomerContentDtoOutputReasonsBuilder
        > {
  @BuiltValueField(wireName: r'customer_cancel')
  BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  get customerCancel;

  @BuiltValueField(wireName: r'customer_problem')
  BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  get customerProblem;

  @BuiltValueField(wireName: r'order_note')
  BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  get orderNote;

  @BuiltValueField(wireName: r'restaurant_rating_low')
  BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  get restaurantRatingLow;

  @BuiltValueField(wireName: r'restaurant_rating_mid')
  BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  get restaurantRatingMid;

  @BuiltValueField(wireName: r'restaurant_rating_high')
  BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  get restaurantRatingHigh;

  @BuiltValueField(wireName: r'captain_rating_low')
  BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  get captainRatingLow;

  @BuiltValueField(wireName: r'captain_rating_mid')
  BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  get captainRatingMid;

  @BuiltValueField(wireName: r'captain_rating_high')
  BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  get captainRatingHigh;

  CustomerContentDtoOutputReasons._();

  factory CustomerContentDtoOutputReasons([
    void updates(CustomerContentDtoOutputReasonsBuilder b),
  ]) = _$CustomerContentDtoOutputReasons;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerContentDtoOutputReasonsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerContentDtoOutputReasons> get serializer =>
      _$CustomerContentDtoOutputReasonsSerializer();
}

class _$CustomerContentDtoOutputReasonsSerializer
    implements PrimitiveSerializer<CustomerContentDtoOutputReasons> {
  @override
  final Iterable<Type> types = const [
    CustomerContentDtoOutputReasons,
    _$CustomerContentDtoOutputReasons,
  ];

  @override
  final String wireName = r'CustomerContentDtoOutputReasons';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerContentDtoOutputReasons object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'customer_cancel';
    yield serializers.serialize(
      object.customerCancel,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantContentDtoOutputReasonsMerchantRejectionInner),
      ]),
    );
    yield r'customer_problem';
    yield serializers.serialize(
      object.customerProblem,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantContentDtoOutputReasonsMerchantRejectionInner),
      ]),
    );
    yield r'order_note';
    yield serializers.serialize(
      object.orderNote,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantContentDtoOutputReasonsMerchantRejectionInner),
      ]),
    );
    yield r'restaurant_rating_low';
    yield serializers.serialize(
      object.restaurantRatingLow,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantContentDtoOutputReasonsMerchantRejectionInner),
      ]),
    );
    yield r'restaurant_rating_mid';
    yield serializers.serialize(
      object.restaurantRatingMid,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantContentDtoOutputReasonsMerchantRejectionInner),
      ]),
    );
    yield r'restaurant_rating_high';
    yield serializers.serialize(
      object.restaurantRatingHigh,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantContentDtoOutputReasonsMerchantRejectionInner),
      ]),
    );
    yield r'captain_rating_low';
    yield serializers.serialize(
      object.captainRatingLow,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantContentDtoOutputReasonsMerchantRejectionInner),
      ]),
    );
    yield r'captain_rating_mid';
    yield serializers.serialize(
      object.captainRatingMid,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantContentDtoOutputReasonsMerchantRejectionInner),
      ]),
    );
    yield r'captain_rating_high';
    yield serializers.serialize(
      object.captainRatingHigh,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantContentDtoOutputReasonsMerchantRejectionInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerContentDtoOutputReasons object, {
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
    required CustomerContentDtoOutputReasonsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'customer_cancel':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        MerchantContentDtoOutputReasonsMerchantRejectionInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    MerchantContentDtoOutputReasonsMerchantRejectionInner
                  >;
          result.customerCancel.replace(valueDes);
          break;
        case r'customer_problem':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        MerchantContentDtoOutputReasonsMerchantRejectionInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    MerchantContentDtoOutputReasonsMerchantRejectionInner
                  >;
          result.customerProblem.replace(valueDes);
          break;
        case r'order_note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        MerchantContentDtoOutputReasonsMerchantRejectionInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    MerchantContentDtoOutputReasonsMerchantRejectionInner
                  >;
          result.orderNote.replace(valueDes);
          break;
        case r'restaurant_rating_low':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        MerchantContentDtoOutputReasonsMerchantRejectionInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    MerchantContentDtoOutputReasonsMerchantRejectionInner
                  >;
          result.restaurantRatingLow.replace(valueDes);
          break;
        case r'restaurant_rating_mid':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        MerchantContentDtoOutputReasonsMerchantRejectionInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    MerchantContentDtoOutputReasonsMerchantRejectionInner
                  >;
          result.restaurantRatingMid.replace(valueDes);
          break;
        case r'restaurant_rating_high':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        MerchantContentDtoOutputReasonsMerchantRejectionInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    MerchantContentDtoOutputReasonsMerchantRejectionInner
                  >;
          result.restaurantRatingHigh.replace(valueDes);
          break;
        case r'captain_rating_low':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        MerchantContentDtoOutputReasonsMerchantRejectionInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    MerchantContentDtoOutputReasonsMerchantRejectionInner
                  >;
          result.captainRatingLow.replace(valueDes);
          break;
        case r'captain_rating_mid':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        MerchantContentDtoOutputReasonsMerchantRejectionInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    MerchantContentDtoOutputReasonsMerchantRejectionInner
                  >;
          result.captainRatingMid.replace(valueDes);
          break;
        case r'captain_rating_high':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        MerchantContentDtoOutputReasonsMerchantRejectionInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    MerchantContentDtoOutputReasonsMerchantRejectionInner
                  >;
          result.captainRatingHigh.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerContentDtoOutputReasons deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerContentDtoOutputReasonsBuilder();
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
