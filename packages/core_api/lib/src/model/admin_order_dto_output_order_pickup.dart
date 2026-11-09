//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_order_dto_output_order_pickup_requests_inner.dart';
import 'package:core_api/src/model/admin_order_dto_output_order_pickup_dispute.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_pickup.g.dart';

/// AdminOrderDtoOutputOrderPickup
///
/// Properties:
/// * [at] 
/// * [readyNotPressed] - «لم يُضغط جاهز».
/// * [requests] - Newest first; the last one's lines prefill «تأكيد الاستلام نيابة عن المطعم».
/// * [dispute] 
@BuiltValue()
abstract class AdminOrderDtoOutputOrderPickup implements Built<AdminOrderDtoOutputOrderPickup, AdminOrderDtoOutputOrderPickupBuilder> {
  @BuiltValueField(wireName: r'at')
  DateTime? get at;

  /// «لم يُضغط جاهز».
  @BuiltValueField(wireName: r'readyNotPressed')
  bool get readyNotPressed;

  /// Newest first; the last one's lines prefill «تأكيد الاستلام نيابة عن المطعم».
  @BuiltValueField(wireName: r'requests')
  BuiltList<AdminOrderDtoOutputOrderPickupRequestsInner> get requests;

  @BuiltValueField(wireName: r'dispute')
  AdminOrderDtoOutputOrderPickupDispute? get dispute;

  AdminOrderDtoOutputOrderPickup._();

  factory AdminOrderDtoOutputOrderPickup([void updates(AdminOrderDtoOutputOrderPickupBuilder b)]) = _$AdminOrderDtoOutputOrderPickup;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderPickupBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderPickup> get serializer => _$AdminOrderDtoOutputOrderPickupSerializer();
}

class _$AdminOrderDtoOutputOrderPickupSerializer implements PrimitiveSerializer<AdminOrderDtoOutputOrderPickup> {
  @override
  final Iterable<Type> types = const [AdminOrderDtoOutputOrderPickup, _$AdminOrderDtoOutputOrderPickup];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderPickup';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderPickup object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield object.at == null ? null : serializers.serialize(
      object.at,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'readyNotPressed';
    yield serializers.serialize(
      object.readyNotPressed,
      specifiedType: const FullType(bool),
    );
    yield r'requests';
    yield serializers.serialize(
      object.requests,
      specifiedType: const FullType(BuiltList, [FullType(AdminOrderDtoOutputOrderPickupRequestsInner)]),
    );
    yield r'dispute';
    yield object.dispute == null ? null : serializers.serialize(
      object.dispute,
      specifiedType: const FullType.nullable(AdminOrderDtoOutputOrderPickupDispute),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderPickup object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOrderDtoOutputOrderPickupBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.at = valueDes;
          break;
        case r'readyNotPressed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.readyNotPressed = valueDes;
          break;
        case r'requests':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminOrderDtoOutputOrderPickupRequestsInner)]),
          ) as BuiltList<AdminOrderDtoOutputOrderPickupRequestsInner>;
          result.requests.replace(valueDes);
          break;
        case r'dispute':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AdminOrderDtoOutputOrderPickupDispute),
          ) as AdminOrderDtoOutputOrderPickupDispute?;
          if (valueDes == null) continue;
          result.dispute.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderPickup deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderPickupBuilder();
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


