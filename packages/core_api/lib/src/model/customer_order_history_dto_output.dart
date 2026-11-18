//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/customer_order_history_dto_output_orders_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_order_history_dto_output.g.dart';

/// CustomerOrderHistoryDtoOutput
///
/// Properties:
/// * [orders] - CU §12.3 «طلباتي»: the first page holds every active order, then the past ones; each group newest first.
/// * [next] - The cursor of the next page of 20 past orders; null at the end.
@BuiltValue()
abstract class CustomerOrderHistoryDtoOutput
    implements
        Built<
          CustomerOrderHistoryDtoOutput,
          CustomerOrderHistoryDtoOutputBuilder
        > {
  /// CU §12.3 «طلباتي»: the first page holds every active order, then the past ones; each group newest first.
  @BuiltValueField(wireName: r'orders')
  BuiltList<CustomerOrderHistoryDtoOutputOrdersInner> get orders;

  /// The cursor of the next page of 20 past orders; null at the end.
  @BuiltValueField(wireName: r'next')
  String? get next;

  CustomerOrderHistoryDtoOutput._();

  factory CustomerOrderHistoryDtoOutput([
    void updates(CustomerOrderHistoryDtoOutputBuilder b),
  ]) = _$CustomerOrderHistoryDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerOrderHistoryDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerOrderHistoryDtoOutput> get serializer =>
      _$CustomerOrderHistoryDtoOutputSerializer();
}

class _$CustomerOrderHistoryDtoOutputSerializer
    implements PrimitiveSerializer<CustomerOrderHistoryDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CustomerOrderHistoryDtoOutput,
    _$CustomerOrderHistoryDtoOutput,
  ];

  @override
  final String wireName = r'CustomerOrderHistoryDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerOrderHistoryDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(BuiltList, [
        FullType(CustomerOrderHistoryDtoOutputOrdersInner),
      ]),
    );
    yield r'next';
    yield object.next == null
        ? null
        : serializers.serialize(
            object.next,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerOrderHistoryDtoOutput object, {
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
    required CustomerOrderHistoryDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'orders':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CustomerOrderHistoryDtoOutputOrdersInner),
                    ]),
                  )
                  as BuiltList<CustomerOrderHistoryDtoOutputOrdersInner>;
          result.orders.replace(valueDes);
          break;
        case r'next':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.next = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerOrderHistoryDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerOrderHistoryDtoOutputBuilder();
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
