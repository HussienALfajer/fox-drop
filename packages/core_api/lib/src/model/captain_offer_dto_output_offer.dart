//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_current_offer_dto_output_offer_collect.dart';
import 'package:core_api/src/model/admin_picker_dto_output_captains_inner_custody_limit.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_current_offer_dto_output_offer_customer.dart';
import 'package:core_api/src/model/captain_current_offer_dto_output_offer_restaurant.dart';
import 'package:core_api/src/model/captain_current_offer_dto_output_offer_handover.dart';
import 'package:core_api/src/model/captain_current_offer_dto_output_offer_pickup_payment.dart';
import 'package:core_api/src/model/captain_current_offer_dto_output_offer_preparation.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_offer_dto_output_offer.g.dart';

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
/// * [handover]
/// * [aboveMaxPickup] - CA §8.4, K2: sent by operations above the captain’s «أقصى مبلغ أحمله»: «المبلغ أكبر من الحد الذي حددته — اقبل فقط إذا كان معك ما يكفي».
@BuiltValue()
abstract class CaptainOfferDtoOutputOffer
    implements
        Built<CaptainOfferDtoOutputOffer, CaptainOfferDtoOutputOfferBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'status')
  CaptainOfferDtoOutputOfferStatusEnum get status;
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

  @BuiltValueField(wireName: r'handover')
  CaptainCurrentOfferDtoOutputOfferHandover? get handover;

  /// CA §8.4, K2: sent by operations above the captain’s «أقصى مبلغ أحمله»: «المبلغ أكبر من الحد الذي حددته — اقبل فقط إذا كان معك ما يكفي».
  @BuiltValueField(wireName: r'aboveMaxPickup')
  bool get aboveMaxPickup;

  CaptainOfferDtoOutputOffer._();

  factory CaptainOfferDtoOutputOffer([
    void updates(CaptainOfferDtoOutputOfferBuilder b),
  ]) = _$CaptainOfferDtoOutputOffer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainOfferDtoOutputOfferBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainOfferDtoOutputOffer> get serializer =>
      _$CaptainOfferDtoOutputOfferSerializer();
}

class _$CaptainOfferDtoOutputOfferSerializer
    implements PrimitiveSerializer<CaptainOfferDtoOutputOffer> {
  @override
  final Iterable<Type> types = const [
    CaptainOfferDtoOutputOffer,
    _$CaptainOfferDtoOutputOffer,
  ];

  @override
  final String wireName = r'CaptainOfferDtoOutputOffer';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainOfferDtoOutputOffer object, {
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
      specifiedType: const FullType(CaptainOfferDtoOutputOfferStatusEnum),
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
    yield r'handover';
    yield object.handover == null
        ? null
        : serializers.serialize(
            object.handover,
            specifiedType: const FullType.nullable(
              CaptainCurrentOfferDtoOutputOfferHandover,
            ),
          );
    yield r'aboveMaxPickup';
    yield serializers.serialize(
      object.aboveMaxPickup,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainOfferDtoOutputOffer object, {
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
    required CaptainOfferDtoOutputOfferBuilder result,
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
                      CaptainOfferDtoOutputOfferStatusEnum,
                    ),
                  )
                  as CaptainOfferDtoOutputOfferStatusEnum;
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
        case r'handover':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainCurrentOfferDtoOutputOfferHandover,
                    ),
                  )
                  as CaptainCurrentOfferDtoOutputOfferHandover?;
          if (valueDes == null) continue;
          result.handover.replace(valueDes);
          break;
        case r'aboveMaxPickup':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.aboveMaxPickup = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainOfferDtoOutputOffer deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainOfferDtoOutputOfferBuilder();
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

class CaptainOfferDtoOutputOfferStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'open')
  static const CaptainOfferDtoOutputOfferStatusEnum open =
      _$captainOfferDtoOutputOfferStatusEnum_open;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const CaptainOfferDtoOutputOfferStatusEnum accepted =
      _$captainOfferDtoOutputOfferStatusEnum_accepted;
  @BuiltValueEnumConst(wireName: r'declined')
  static const CaptainOfferDtoOutputOfferStatusEnum declined =
      _$captainOfferDtoOutputOfferStatusEnum_declined;
  @BuiltValueEnumConst(wireName: r'expired')
  static const CaptainOfferDtoOutputOfferStatusEnum expired =
      _$captainOfferDtoOutputOfferStatusEnum_expired;
  @BuiltValueEnumConst(wireName: r'withdrawn')
  static const CaptainOfferDtoOutputOfferStatusEnum withdrawn =
      _$captainOfferDtoOutputOfferStatusEnum_withdrawn;

  static Serializer<CaptainOfferDtoOutputOfferStatusEnum> get serializer =>
      _$captainOfferDtoOutputOfferStatusEnumSerializer;

  const CaptainOfferDtoOutputOfferStatusEnum._(String name) : super(name);

  static BuiltSet<CaptainOfferDtoOutputOfferStatusEnum> get values =>
      _$captainOfferDtoOutputOfferStatusEnumValues;
  static CaptainOfferDtoOutputOfferStatusEnum valueOf(String name) =>
      _$captainOfferDtoOutputOfferStatusEnumValueOf(name);
}
