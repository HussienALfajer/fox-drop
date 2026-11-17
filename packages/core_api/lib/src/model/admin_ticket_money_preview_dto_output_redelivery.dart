//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ticket_money_preview_dto_output_redelivery.g.dart';

/// «إعادة توصيل مجانية» (AP §9.9.3): posted at its delivery, not now.
///
/// Properties:
/// * [pickupPayment] - What its pickup pays the restaurant: 0 when it is responsible.
/// * [commission]
/// * [merchantNet] - What the responsible party bears at its delivery.
@BuiltValue()
abstract class AdminTicketMoneyPreviewDtoOutputRedelivery
    implements
        Built<
          AdminTicketMoneyPreviewDtoOutputRedelivery,
          AdminTicketMoneyPreviewDtoOutputRedeliveryBuilder
        > {
  /// What its pickup pays the restaurant: 0 when it is responsible.
  @BuiltValueField(wireName: r'pickupPayment')
  String get pickupPayment;

  @BuiltValueField(wireName: r'commission')
  String get commission;

  /// What the responsible party bears at its delivery.
  @BuiltValueField(wireName: r'merchantNet')
  String get merchantNet;

  AdminTicketMoneyPreviewDtoOutputRedelivery._();

  factory AdminTicketMoneyPreviewDtoOutputRedelivery([
    void updates(AdminTicketMoneyPreviewDtoOutputRedeliveryBuilder b),
  ]) = _$AdminTicketMoneyPreviewDtoOutputRedelivery;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTicketMoneyPreviewDtoOutputRedeliveryBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTicketMoneyPreviewDtoOutputRedelivery>
  get serializer => _$AdminTicketMoneyPreviewDtoOutputRedeliverySerializer();
}

class _$AdminTicketMoneyPreviewDtoOutputRedeliverySerializer
    implements PrimitiveSerializer<AdminTicketMoneyPreviewDtoOutputRedelivery> {
  @override
  final Iterable<Type> types = const [
    AdminTicketMoneyPreviewDtoOutputRedelivery,
    _$AdminTicketMoneyPreviewDtoOutputRedelivery,
  ];

  @override
  final String wireName = r'AdminTicketMoneyPreviewDtoOutputRedelivery';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTicketMoneyPreviewDtoOutputRedelivery object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'pickupPayment';
    yield serializers.serialize(
      object.pickupPayment,
      specifiedType: const FullType(String),
    );
    yield r'commission';
    yield serializers.serialize(
      object.commission,
      specifiedType: const FullType(String),
    );
    yield r'merchantNet';
    yield serializers.serialize(
      object.merchantNet,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketMoneyPreviewDtoOutputRedelivery object, {
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
    required AdminTicketMoneyPreviewDtoOutputRedeliveryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'pickupPayment':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.pickupPayment = valueDes;
          break;
        case r'commission':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.commission = valueDes;
          break;
        case r'merchantNet':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.merchantNet = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminTicketMoneyPreviewDtoOutputRedelivery deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTicketMoneyPreviewDtoOutputRedeliveryBuilder();
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
