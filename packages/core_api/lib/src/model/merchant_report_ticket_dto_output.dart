//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_report_ticket_dto_output_ticket.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_report_ticket_dto_output.g.dart';

/// MerchantReportTicketDtoOutput
///
/// Properties:
/// * [ticket]
@BuiltValue()
abstract class MerchantReportTicketDtoOutput
    implements
        Built<
          MerchantReportTicketDtoOutput,
          MerchantReportTicketDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'ticket')
  MerchantReportTicketDtoOutputTicket get ticket;

  MerchantReportTicketDtoOutput._();

  factory MerchantReportTicketDtoOutput([
    void updates(MerchantReportTicketDtoOutputBuilder b),
  ]) = _$MerchantReportTicketDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantReportTicketDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantReportTicketDtoOutput> get serializer =>
      _$MerchantReportTicketDtoOutputSerializer();
}

class _$MerchantReportTicketDtoOutputSerializer
    implements PrimitiveSerializer<MerchantReportTicketDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantReportTicketDtoOutput,
    _$MerchantReportTicketDtoOutput,
  ];

  @override
  final String wireName = r'MerchantReportTicketDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantReportTicketDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ticket';
    yield serializers.serialize(
      object.ticket,
      specifiedType: const FullType(MerchantReportTicketDtoOutputTicket),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantReportTicketDtoOutput object, {
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
    required MerchantReportTicketDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ticket':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantReportTicketDtoOutputTicket,
                    ),
                  )
                  as MerchantReportTicketDtoOutputTicket;
          result.ticket.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantReportTicketDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantReportTicketDtoOutputBuilder();
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
