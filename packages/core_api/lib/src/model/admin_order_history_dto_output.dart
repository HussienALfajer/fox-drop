//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_order_history_dto_output_orders_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_history_dto_output.g.dart';

/// AdminOrderHistoryDtoOutput
///
/// Properties:
/// * [orders] - Newest first.
/// * [next] - The cursor of the next 50 orders; null at the end.
@BuiltValue()
abstract class AdminOrderHistoryDtoOutput
    implements
        Built<AdminOrderHistoryDtoOutput, AdminOrderHistoryDtoOutputBuilder> {
  /// Newest first.
  @BuiltValueField(wireName: r'orders')
  BuiltList<AdminOrderHistoryDtoOutputOrdersInner> get orders;

  /// The cursor of the next 50 orders; null at the end.
  @BuiltValueField(wireName: r'next')
  String? get next;

  AdminOrderHistoryDtoOutput._();

  factory AdminOrderHistoryDtoOutput([
    void updates(AdminOrderHistoryDtoOutputBuilder b),
  ]) = _$AdminOrderHistoryDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderHistoryDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderHistoryDtoOutput> get serializer =>
      _$AdminOrderHistoryDtoOutputSerializer();
}

class _$AdminOrderHistoryDtoOutputSerializer
    implements PrimitiveSerializer<AdminOrderHistoryDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminOrderHistoryDtoOutput,
    _$AdminOrderHistoryDtoOutput,
  ];

  @override
  final String wireName = r'AdminOrderHistoryDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderHistoryDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminOrderHistoryDtoOutputOrdersInner),
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
    AdminOrderHistoryDtoOutput object, {
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
    required AdminOrderHistoryDtoOutputBuilder result,
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
                      FullType(AdminOrderHistoryDtoOutputOrdersInner),
                    ]),
                  )
                  as BuiltList<AdminOrderHistoryDtoOutputOrdersInner>;
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
  AdminOrderHistoryDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderHistoryDtoOutputBuilder();
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
