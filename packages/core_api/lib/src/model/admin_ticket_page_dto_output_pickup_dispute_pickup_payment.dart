//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ticket_page_dto_output_pickup_dispute_pickup_payment.g.dart';

/// «أبلغ عن سعر مختلف»: the shop's price, in the base.
///
/// Properties:
/// * [amount]
/// * [currency]
@BuiltValue()
abstract class AdminTicketPageDtoOutputPickupDisputePickupPayment
    implements
        Built<
          AdminTicketPageDtoOutputPickupDisputePickupPayment,
          AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder
        > {
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  AdminTicketPageDtoOutputPickupDisputePickupPayment._();

  factory AdminTicketPageDtoOutputPickupDisputePickupPayment([
    void updates(AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder b),
  ]) = _$AdminTicketPageDtoOutputPickupDisputePickupPayment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTicketPageDtoOutputPickupDisputePickupPayment>
  get serializer =>
      _$AdminTicketPageDtoOutputPickupDisputePickupPaymentSerializer();
}

class _$AdminTicketPageDtoOutputPickupDisputePickupPaymentSerializer
    implements
        PrimitiveSerializer<
          AdminTicketPageDtoOutputPickupDisputePickupPayment
        > {
  @override
  final Iterable<Type> types = const [
    AdminTicketPageDtoOutputPickupDisputePickupPayment,
    _$AdminTicketPageDtoOutputPickupDisputePickupPayment,
  ];

  @override
  final String wireName = r'AdminTicketPageDtoOutputPickupDisputePickupPayment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTicketPageDtoOutputPickupDisputePickupPayment object, {
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
    AdminTicketPageDtoOutputPickupDisputePickupPayment object, {
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
    required AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder result,
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
  AdminTicketPageDtoOutputPickupDisputePickupPayment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder();
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
