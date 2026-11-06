//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_current_offer_dto_output_offer_collect.dart';
import 'package:core_api/src/model/admin_picker_dto_output_captains_inner_custody_limit.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_current_offer_dto_output_offer_customer.dart';
import 'package:core_api/src/model/captain_current_offer_dto_output_offer_restaurant.dart';
import 'package:core_api/src/model/captain_current_offer_dto_output_offer_pickup_payment.dart';
import 'package:core_api/src/model/captain_current_offer_dto_output_offer_preparation.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_current_offer_dto_output_offer.g.dart';

/// An offer (CA §8.2).
///
/// Properties:
/// * [id]
/// * [status]
/// * [orderId]
/// * [number]
/// * [fromOperations] - «تعيين من العمليات» (CA §8.4).
/// * [offeredAt]
/// * [expiresAt] - The countdown ring runs to it (CA §8.2).
/// * [pay]
/// * [restaurant]
/// * [customer]
/// * [pickupPayment]
/// * [collect]
/// * [preparation]
@BuiltValue()
abstract class CaptainCurrentOfferDtoOutputOffer
    implements
        Built<
          CaptainCurrentOfferDtoOutputOffer,
          CaptainCurrentOfferDtoOutputOfferBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'status')
  CaptainCurrentOfferDtoOutputOfferStatusEnum get status;
  // enum statusEnum {  open,  accepted,  declined,  expired,  withdrawn,  };

  @BuiltValueField(wireName: r'orderId')
  String get orderId;

  @BuiltValueField(wireName: r'number')
  String get number;

  /// «تعيين من العمليات» (CA §8.4).
  @BuiltValueField(wireName: r'fromOperations')
  bool get fromOperations;

  @BuiltValueField(wireName: r'offeredAt')
  DateTime get offeredAt;

  /// The countdown ring runs to it (CA §8.2).
  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  @BuiltValueField(wireName: r'pay')
  AdminPickerDtoOutputCaptainsInnerCustodyLimit? get pay;

  @BuiltValueField(wireName: r'restaurant')
  CaptainCurrentOfferDtoOutputOfferRestaurant get restaurant;

  @BuiltValueField(wireName: r'customer')
  CaptainCurrentOfferDtoOutputOfferCustomer get customer;

  @BuiltValueField(wireName: r'pickupPayment')
  CaptainCurrentOfferDtoOutputOfferPickupPayment get pickupPayment;

  @BuiltValueField(wireName: r'collect')
  CaptainCurrentOfferDtoOutputOfferCollect get collect;

  @BuiltValueField(wireName: r'preparation')
  CaptainCurrentOfferDtoOutputOfferPreparation get preparation;

  CaptainCurrentOfferDtoOutputOffer._();

  factory CaptainCurrentOfferDtoOutputOffer([
    void updates(CaptainCurrentOfferDtoOutputOfferBuilder b),
  ]) = _$CaptainCurrentOfferDtoOutputOffer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainCurrentOfferDtoOutputOfferBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainCurrentOfferDtoOutputOffer> get serializer =>
      _$CaptainCurrentOfferDtoOutputOfferSerializer();
}

class _$CaptainCurrentOfferDtoOutputOfferSerializer
    implements PrimitiveSerializer<CaptainCurrentOfferDtoOutputOffer> {
  @override
  final Iterable<Type> types = const [
    CaptainCurrentOfferDtoOutputOffer,
    _$CaptainCurrentOfferDtoOutputOffer,
  ];

  @override
  final String wireName = r'CaptainCurrentOfferDtoOutputOffer';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainCurrentOfferDtoOutputOffer object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
        CaptainCurrentOfferDtoOutputOfferStatusEnum,
      ),
    );
    yield r'orderId';
    yield serializers.serialize(
      object.orderId,
      specifiedType: const FullType(String),
    );
    yield r'number';
    yield serializers.serialize(
      object.number,
      specifiedType: const FullType(String),
    );
    yield r'fromOperations';
    yield serializers.serialize(
      object.fromOperations,
      specifiedType: const FullType(bool),
    );
    yield r'offeredAt';
    yield serializers.serialize(
      object.offeredAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'pay';
    yield object.pay == null
        ? null
        : serializers.serialize(
            object.pay,
            specifiedType: const FullType.nullable(
              AdminPickerDtoOutputCaptainsInnerCustodyLimit,
            ),
          );
    yield r'restaurant';
    yield serializers.serialize(
      object.restaurant,
      specifiedType: const FullType(
        CaptainCurrentOfferDtoOutputOfferRestaurant,
      ),
    );
    yield r'customer';
    yield serializers.serialize(
      object.customer,
      specifiedType: const FullType(CaptainCurrentOfferDtoOutputOfferCustomer),
    );
    yield r'pickupPayment';
    yield serializers.serialize(
      object.pickupPayment,
      specifiedType: const FullType(
        CaptainCurrentOfferDtoOutputOfferPickupPayment,
      ),
    );
    yield r'collect';
    yield serializers.serialize(
      object.collect,
      specifiedType: const FullType(CaptainCurrentOfferDtoOutputOfferCollect),
    );
    yield r'preparation';
    yield serializers.serialize(
      object.preparation,
      specifiedType: const FullType(
        CaptainCurrentOfferDtoOutputOfferPreparation,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainCurrentOfferDtoOutputOffer object, {
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
    required CaptainCurrentOfferDtoOutputOfferBuilder result,
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
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainCurrentOfferDtoOutputOfferStatusEnum,
                    ),
                  )
                  as CaptainCurrentOfferDtoOutputOfferStatusEnum;
          result.status = valueDes;
          break;
        case r'orderId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.orderId = valueDes;
          break;
        case r'number':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.number = valueDes;
          break;
        case r'fromOperations':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.fromOperations = valueDes;
          break;
        case r'offeredAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.offeredAt = valueDes;
          break;
        case r'expiresAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.expiresAt = valueDes;
          break;
        case r'pay':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminPickerDtoOutputCaptainsInnerCustodyLimit,
                    ),
                  )
                  as AdminPickerDtoOutputCaptainsInnerCustodyLimit?;
          if (valueDes == null) continue;
          result.pay.replace(valueDes);
          break;
        case r'restaurant':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainCurrentOfferDtoOutputOfferRestaurant,
                    ),
                  )
                  as CaptainCurrentOfferDtoOutputOfferRestaurant;
          result.restaurant.replace(valueDes);
          break;
        case r'customer':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainCurrentOfferDtoOutputOfferCustomer,
                    ),
                  )
                  as CaptainCurrentOfferDtoOutputOfferCustomer;
          result.customer.replace(valueDes);
          break;
        case r'pickupPayment':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainCurrentOfferDtoOutputOfferPickupPayment,
                    ),
                  )
                  as CaptainCurrentOfferDtoOutputOfferPickupPayment;
          result.pickupPayment.replace(valueDes);
          break;
        case r'collect':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainCurrentOfferDtoOutputOfferCollect,
                    ),
                  )
                  as CaptainCurrentOfferDtoOutputOfferCollect;
          result.collect.replace(valueDes);
          break;
        case r'preparation':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainCurrentOfferDtoOutputOfferPreparation,
                    ),
                  )
                  as CaptainCurrentOfferDtoOutputOfferPreparation;
          result.preparation.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainCurrentOfferDtoOutputOffer deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainCurrentOfferDtoOutputOfferBuilder();
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

class CaptainCurrentOfferDtoOutputOfferStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'open')
  static const CaptainCurrentOfferDtoOutputOfferStatusEnum open =
      _$captainCurrentOfferDtoOutputOfferStatusEnum_open;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const CaptainCurrentOfferDtoOutputOfferStatusEnum accepted =
      _$captainCurrentOfferDtoOutputOfferStatusEnum_accepted;
  @BuiltValueEnumConst(wireName: r'declined')
  static const CaptainCurrentOfferDtoOutputOfferStatusEnum declined =
      _$captainCurrentOfferDtoOutputOfferStatusEnum_declined;
  @BuiltValueEnumConst(wireName: r'expired')
  static const CaptainCurrentOfferDtoOutputOfferStatusEnum expired =
      _$captainCurrentOfferDtoOutputOfferStatusEnum_expired;
  @BuiltValueEnumConst(wireName: r'withdrawn')
  static const CaptainCurrentOfferDtoOutputOfferStatusEnum withdrawn =
      _$captainCurrentOfferDtoOutputOfferStatusEnum_withdrawn;

  static Serializer<CaptainCurrentOfferDtoOutputOfferStatusEnum>
  get serializer => _$captainCurrentOfferDtoOutputOfferStatusEnumSerializer;

  const CaptainCurrentOfferDtoOutputOfferStatusEnum._(String name)
    : super(name);

  static BuiltSet<CaptainCurrentOfferDtoOutputOfferStatusEnum> get values =>
      _$captainCurrentOfferDtoOutputOfferStatusEnumValues;
  static CaptainCurrentOfferDtoOutputOfferStatusEnum valueOf(String name) =>
      _$captainCurrentOfferDtoOutputOfferStatusEnumValueOf(name);
}
