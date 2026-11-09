//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_active_orders_dto_output_orders_inner_rejection.g.dart';

/// While rejected (CU §11.9).
///
/// Properties:
/// * [at] 
/// * [reason] - The code: item_unavailable, restaurant_closed or too_busy (RA §8.6).
/// * [text] - After «نعتذر، لم يقبل المطعم طلبك»: the reason's customer text (CU Appendix C) as it was at the rejection, with the items filled in.
/// * [unavailableItemIds] - «اطلب بدون الأصناف غير المتوفرة» rebuilds the cart without these items (CU §11.9, Q22); empty for the other reasons.
@BuiltValue()
abstract class CustomerActiveOrdersDtoOutputOrdersInnerRejection implements Built<CustomerActiveOrdersDtoOutputOrdersInnerRejection, CustomerActiveOrdersDtoOutputOrdersInnerRejectionBuilder> {
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  /// The code: item_unavailable, restaurant_closed or too_busy (RA §8.6).
  @BuiltValueField(wireName: r'reason')
  String get reason;

  /// After «نعتذر، لم يقبل المطعم طلبك»: the reason's customer text (CU Appendix C) as it was at the rejection, with the items filled in.
  @BuiltValueField(wireName: r'text')
  String get text;

  /// «اطلب بدون الأصناف غير المتوفرة» rebuilds the cart without these items (CU §11.9, Q22); empty for the other reasons.
  @BuiltValueField(wireName: r'unavailableItemIds')
  BuiltList<String> get unavailableItemIds;

  CustomerActiveOrdersDtoOutputOrdersInnerRejection._();

  factory CustomerActiveOrdersDtoOutputOrdersInnerRejection([void updates(CustomerActiveOrdersDtoOutputOrdersInnerRejectionBuilder b)]) = _$CustomerActiveOrdersDtoOutputOrdersInnerRejection;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerActiveOrdersDtoOutputOrdersInnerRejectionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerActiveOrdersDtoOutputOrdersInnerRejection> get serializer => _$CustomerActiveOrdersDtoOutputOrdersInnerRejectionSerializer();
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerRejectionSerializer implements PrimitiveSerializer<CustomerActiveOrdersDtoOutputOrdersInnerRejection> {
  @override
  final Iterable<Type> types = const [CustomerActiveOrdersDtoOutputOrdersInnerRejection, _$CustomerActiveOrdersDtoOutputOrdersInnerRejection];

  @override
  final String wireName = r'CustomerActiveOrdersDtoOutputOrdersInnerRejection';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerRejection object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'text';
    yield serializers.serialize(
      object.text,
      specifiedType: const FullType(String),
    );
    yield r'unavailableItemIds';
    yield serializers.serialize(
      object.unavailableItemIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerRejection object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerActiveOrdersDtoOutputOrdersInnerRejectionBuilder result,
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
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.text = valueDes;
          break;
        case r'unavailableItemIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.unavailableItemIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerRejection deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerActiveOrdersDtoOutputOrdersInnerRejectionBuilder();
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


