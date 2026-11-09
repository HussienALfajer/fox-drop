//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_delivery_net_received.g.dart';

/// Received minus change, by the order's rates.
///
/// Properties:
/// * [amount] - Integer minor units (AP §8.6).
/// * [currency]
@BuiltValue()
abstract class AdminOrderDtoOutputOrderDeliveryNetReceived
    implements
        Built<
          AdminOrderDtoOutputOrderDeliveryNetReceived,
          AdminOrderDtoOutputOrderDeliveryNetReceivedBuilder
        > {
  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  AdminOrderDtoOutputOrderDeliveryNetReceived._();

  factory AdminOrderDtoOutputOrderDeliveryNetReceived([
    void updates(AdminOrderDtoOutputOrderDeliveryNetReceivedBuilder b),
  ]) = _$AdminOrderDtoOutputOrderDeliveryNetReceived;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderDeliveryNetReceivedBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderDeliveryNetReceived>
  get serializer => _$AdminOrderDtoOutputOrderDeliveryNetReceivedSerializer();
}

class _$AdminOrderDtoOutputOrderDeliveryNetReceivedSerializer
    implements
        PrimitiveSerializer<AdminOrderDtoOutputOrderDeliveryNetReceived> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderDeliveryNetReceived,
    _$AdminOrderDtoOutputOrderDeliveryNetReceived,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderDeliveryNetReceived';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderDeliveryNetReceived object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderDeliveryNetReceived object, {
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
    required AdminOrderDtoOutputOrderDeliveryNetReceivedBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.amount = valueDes;
          break;
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.currency = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderDeliveryNetReceived deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderDeliveryNetReceivedBuilder();
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
