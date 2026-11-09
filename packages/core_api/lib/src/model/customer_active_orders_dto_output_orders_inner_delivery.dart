//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_went_offline_dto_output_hand_in.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_active_orders_dto_output_orders_inner_delivery.g.dart';

/// Once delivered; the order screen opens the rating sheet (CU §12.1).
///
/// Properties:
/// * [at] - «تم التسليم».
/// * [received] - «استلم الكابتن: {المبالغ}» (CU §11.8, Q23).
/// * [change] - «أعاد لك: {المبالغ}».
@BuiltValue()
abstract class CustomerActiveOrdersDtoOutputOrdersInnerDelivery implements Built<CustomerActiveOrdersDtoOutputOrdersInnerDelivery, CustomerActiveOrdersDtoOutputOrdersInnerDeliveryBuilder> {
  /// «تم التسليم».
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  /// «استلم الكابتن: {المبالغ}» (CU §11.8, Q23).
  @BuiltValueField(wireName: r'received')
  BuiltList<CaptainWentOfflineDtoOutputHandIn?> get received;

  /// «أعاد لك: {المبالغ}».
  @BuiltValueField(wireName: r'change')
  BuiltList<CaptainWentOfflineDtoOutputHandIn?> get change;

  CustomerActiveOrdersDtoOutputOrdersInnerDelivery._();

  factory CustomerActiveOrdersDtoOutputOrdersInnerDelivery([void updates(CustomerActiveOrdersDtoOutputOrdersInnerDeliveryBuilder b)]) = _$CustomerActiveOrdersDtoOutputOrdersInnerDelivery;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerActiveOrdersDtoOutputOrdersInnerDeliveryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerActiveOrdersDtoOutputOrdersInnerDelivery> get serializer => _$CustomerActiveOrdersDtoOutputOrdersInnerDeliverySerializer();
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerDeliverySerializer implements PrimitiveSerializer<CustomerActiveOrdersDtoOutputOrdersInnerDelivery> {
  @override
  final Iterable<Type> types = const [CustomerActiveOrdersDtoOutputOrdersInnerDelivery, _$CustomerActiveOrdersDtoOutputOrdersInnerDelivery];

  @override
  final String wireName = r'CustomerActiveOrdersDtoOutputOrdersInnerDelivery';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerDelivery object, {
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
      specifiedType: const FullType(BuiltList, [FullType.nullable(CaptainWentOfflineDtoOutputHandIn)]),
    );
    yield r'change';
    yield serializers.serialize(
      object.change,
      specifiedType: const FullType(BuiltList, [FullType.nullable(CaptainWentOfflineDtoOutputHandIn)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerDelivery object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerActiveOrdersDtoOutputOrdersInnerDeliveryBuilder result,
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
            specifiedType: const FullType(BuiltList, [FullType.nullable(CaptainWentOfflineDtoOutputHandIn)]),
          ) as BuiltList<CaptainWentOfflineDtoOutputHandIn?>;
          result.received.replace(valueDes);
          break;
        case r'change':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType.nullable(CaptainWentOfflineDtoOutputHandIn)]),
          ) as BuiltList<CaptainWentOfflineDtoOutputHandIn?>;
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
  CustomerActiveOrdersDtoOutputOrdersInnerDelivery deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerActiveOrdersDtoOutputOrdersInnerDeliveryBuilder();
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


