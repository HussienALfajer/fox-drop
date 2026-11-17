//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ticket_correction_dto_output_merchant.g.dart';

/// + a credit to the restaurant, − a debit.
///
/// Properties:
/// * [amount]
/// * [currency]
@BuiltValue()
abstract class AdminTicketCorrectionDtoOutputMerchant
    implements
        Built<
          AdminTicketCorrectionDtoOutputMerchant,
          AdminTicketCorrectionDtoOutputMerchantBuilder
        > {
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  AdminTicketCorrectionDtoOutputMerchant._();

  factory AdminTicketCorrectionDtoOutputMerchant([
    void updates(AdminTicketCorrectionDtoOutputMerchantBuilder b),
  ]) = _$AdminTicketCorrectionDtoOutputMerchant;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTicketCorrectionDtoOutputMerchantBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTicketCorrectionDtoOutputMerchant> get serializer =>
      _$AdminTicketCorrectionDtoOutputMerchantSerializer();
}

class _$AdminTicketCorrectionDtoOutputMerchantSerializer
    implements PrimitiveSerializer<AdminTicketCorrectionDtoOutputMerchant> {
  @override
  final Iterable<Type> types = const [
    AdminTicketCorrectionDtoOutputMerchant,
    _$AdminTicketCorrectionDtoOutputMerchant,
  ];

  @override
  final String wireName = r'AdminTicketCorrectionDtoOutputMerchant';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTicketCorrectionDtoOutputMerchant object, {
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
    AdminTicketCorrectionDtoOutputMerchant object, {
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
    required AdminTicketCorrectionDtoOutputMerchantBuilder result,
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
  AdminTicketCorrectionDtoOutputMerchant deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTicketCorrectionDtoOutputMerchantBuilder();
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
