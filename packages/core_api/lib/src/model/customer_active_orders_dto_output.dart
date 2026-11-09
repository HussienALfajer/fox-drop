//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/customer_active_orders_dto_output_orders_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_active_orders_dto_output.g.dart';

/// CustomerActiveOrdersDtoOutput
///
/// Properties:
/// * [orders] - Until each ends, newest first: the active-order bar (CU §6).
@BuiltValue()
abstract class CustomerActiveOrdersDtoOutput implements Built<CustomerActiveOrdersDtoOutput, CustomerActiveOrdersDtoOutputBuilder> {
  /// Until each ends, newest first: the active-order bar (CU §6).
  @BuiltValueField(wireName: r'orders')
  BuiltList<CustomerActiveOrdersDtoOutputOrdersInner> get orders;

  CustomerActiveOrdersDtoOutput._();

  factory CustomerActiveOrdersDtoOutput([void updates(CustomerActiveOrdersDtoOutputBuilder b)]) = _$CustomerActiveOrdersDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerActiveOrdersDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerActiveOrdersDtoOutput> get serializer => _$CustomerActiveOrdersDtoOutputSerializer();
}

class _$CustomerActiveOrdersDtoOutputSerializer implements PrimitiveSerializer<CustomerActiveOrdersDtoOutput> {
  @override
  final Iterable<Type> types = const [CustomerActiveOrdersDtoOutput, _$CustomerActiveOrdersDtoOutput];

  @override
  final String wireName = r'CustomerActiveOrdersDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerActiveOrdersDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(BuiltList, [FullType(CustomerActiveOrdersDtoOutputOrdersInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerActiveOrdersDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerActiveOrdersDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CustomerActiveOrdersDtoOutputOrdersInner)]),
          ) as BuiltList<CustomerActiveOrdersDtoOutputOrdersInner>;
          result.orders.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerActiveOrdersDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerActiveOrdersDtoOutputBuilder();
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


