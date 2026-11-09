//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_orders_dto_output_orders_inner_pickup_request.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_orders_dto_output_orders_inner_pickup.g.dart';

/// The pickup confirmation (RA §8.10).
///
/// Properties:
/// * [request] 
/// * [pickedUpAt] - «تم الاستلام».
/// * [readyNotPressed] - «لم يُضغط جاهز» (S8).
/// * [disputeUntil] - «المبلغ غير صحيح» stays on the order until then after the pickup (RA §8.10 item 8); null once disputed or before the pickup.
/// * [disputedAt] 
@BuiltValue()
abstract class MerchantOrdersDtoOutputOrdersInnerPickup implements Built<MerchantOrdersDtoOutputOrdersInnerPickup, MerchantOrdersDtoOutputOrdersInnerPickupBuilder> {
  @BuiltValueField(wireName: r'request')
  MerchantOrdersDtoOutputOrdersInnerPickupRequest? get request;

  /// «تم الاستلام».
  @BuiltValueField(wireName: r'pickedUpAt')
  DateTime? get pickedUpAt;

  /// «لم يُضغط جاهز» (S8).
  @BuiltValueField(wireName: r'readyNotPressed')
  bool get readyNotPressed;

  /// «المبلغ غير صحيح» stays on the order until then after the pickup (RA §8.10 item 8); null once disputed or before the pickup.
  @BuiltValueField(wireName: r'disputeUntil')
  DateTime? get disputeUntil;

  @BuiltValueField(wireName: r'disputedAt')
  DateTime? get disputedAt;

  MerchantOrdersDtoOutputOrdersInnerPickup._();

  factory MerchantOrdersDtoOutputOrdersInnerPickup([void updates(MerchantOrdersDtoOutputOrdersInnerPickupBuilder b)]) = _$MerchantOrdersDtoOutputOrdersInnerPickup;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantOrdersDtoOutputOrdersInnerPickupBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantOrdersDtoOutputOrdersInnerPickup> get serializer => _$MerchantOrdersDtoOutputOrdersInnerPickupSerializer();
}

class _$MerchantOrdersDtoOutputOrdersInnerPickupSerializer implements PrimitiveSerializer<MerchantOrdersDtoOutputOrdersInnerPickup> {
  @override
  final Iterable<Type> types = const [MerchantOrdersDtoOutputOrdersInnerPickup, _$MerchantOrdersDtoOutputOrdersInnerPickup];

  @override
  final String wireName = r'MerchantOrdersDtoOutputOrdersInnerPickup';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerPickup object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'request';
    yield object.request == null ? null : serializers.serialize(
      object.request,
      specifiedType: const FullType.nullable(MerchantOrdersDtoOutputOrdersInnerPickupRequest),
    );
    yield r'pickedUpAt';
    yield object.pickedUpAt == null ? null : serializers.serialize(
      object.pickedUpAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'readyNotPressed';
    yield serializers.serialize(
      object.readyNotPressed,
      specifiedType: const FullType(bool),
    );
    yield r'disputeUntil';
    yield object.disputeUntil == null ? null : serializers.serialize(
      object.disputeUntil,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'disputedAt';
    yield object.disputedAt == null ? null : serializers.serialize(
      object.disputedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerPickup object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantOrdersDtoOutputOrdersInnerPickupBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'request':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(MerchantOrdersDtoOutputOrdersInnerPickupRequest),
          ) as MerchantOrdersDtoOutputOrdersInnerPickupRequest?;
          if (valueDes == null) continue;
          result.request.replace(valueDes);
          break;
        case r'pickedUpAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.pickedUpAt = valueDes;
          break;
        case r'readyNotPressed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.readyNotPressed = valueDes;
          break;
        case r'disputeUntil':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.disputeUntil = valueDes;
          break;
        case r'disputedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.disputedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantOrdersDtoOutputOrdersInnerPickup deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantOrdersDtoOutputOrdersInnerPickupBuilder();
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


