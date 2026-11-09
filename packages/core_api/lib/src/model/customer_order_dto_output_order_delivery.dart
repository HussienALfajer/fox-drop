//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_availability_dto_output_custody_limit.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_order_dto_output_order_delivery.g.dart';

/// Once delivered; the order screen opens the rating sheet (CU §12.1).
///
/// Properties:
/// * [at] - «تم التسليم».
/// * [received] - «استلم الكابتن: {المبالغ}» (CU §11.8, Q23).
/// * [change] - «أعاد لك: {المبالغ}».
@BuiltValue()
abstract class CustomerOrderDtoOutputOrderDelivery implements Built<CustomerOrderDtoOutputOrderDelivery, CustomerOrderDtoOutputOrderDeliveryBuilder> {
  /// «تم التسليم».
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  /// «استلم الكابتن: {المبالغ}» (CU §11.8, Q23).
  @BuiltValueField(wireName: r'received')
  BuiltList<CaptainAvailabilityDtoOutputCustodyLimit> get received;

  /// «أعاد لك: {المبالغ}».
  @BuiltValueField(wireName: r'change')
  BuiltList<CaptainAvailabilityDtoOutputCustodyLimit> get change;

  CustomerOrderDtoOutputOrderDelivery._();

  factory CustomerOrderDtoOutputOrderDelivery([void updates(CustomerOrderDtoOutputOrderDeliveryBuilder b)]) = _$CustomerOrderDtoOutputOrderDelivery;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerOrderDtoOutputOrderDeliveryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerOrderDtoOutputOrderDelivery> get serializer => _$CustomerOrderDtoOutputOrderDeliverySerializer();
}

class _$CustomerOrderDtoOutputOrderDeliverySerializer implements PrimitiveSerializer<CustomerOrderDtoOutputOrderDelivery> {
  @override
  final Iterable<Type> types = const [CustomerOrderDtoOutputOrderDelivery, _$CustomerOrderDtoOutputOrderDelivery];

  @override
  final String wireName = r'CustomerOrderDtoOutputOrderDelivery';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerOrderDtoOutputOrderDelivery object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'received';
    yield serializers.serialize(
      object.received,
      specifiedType: const FullType(BuiltList, [FullType(CaptainAvailabilityDtoOutputCustodyLimit)]),
    );
    yield r'change';
    yield serializers.serialize(
      object.change,
      specifiedType: const FullType(BuiltList, [FullType(CaptainAvailabilityDtoOutputCustodyLimit)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerOrderDtoOutputOrderDelivery object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerOrderDtoOutputOrderDeliveryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.at = valueDes;
          break;
        case r'received':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CaptainAvailabilityDtoOutputCustodyLimit)]),
          ) as BuiltList<CaptainAvailabilityDtoOutputCustodyLimit>;
          result.received.replace(valueDes);
          break;
        case r'change':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CaptainAvailabilityDtoOutputCustodyLimit)]),
          ) as BuiltList<CaptainAvailabilityDtoOutputCustodyLimit>;
          result.change.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerOrderDtoOutputOrderDelivery deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerOrderDtoOutputOrderDeliveryBuilder();
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


