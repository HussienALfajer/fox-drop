//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_report_ticket_dto_output_ticket.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_report_ticket_dto_output.g.dart';

/// CaptainReportTicketDtoOutput
///
/// Properties:
/// * [ticket]
@BuiltValue()
abstract class CaptainReportTicketDtoOutput
    implements
        Built<
          CaptainReportTicketDtoOutput,
          CaptainReportTicketDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'ticket')
  CaptainReportTicketDtoOutputTicket get ticket;

  CaptainReportTicketDtoOutput._();

  factory CaptainReportTicketDtoOutput([
    void updates(CaptainReportTicketDtoOutputBuilder b),
  ]) = _$CaptainReportTicketDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainReportTicketDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainReportTicketDtoOutput> get serializer =>
      _$CaptainReportTicketDtoOutputSerializer();
}

class _$CaptainReportTicketDtoOutputSerializer
    implements PrimitiveSerializer<CaptainReportTicketDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CaptainReportTicketDtoOutput,
    _$CaptainReportTicketDtoOutput,
  ];

  @override
  final String wireName = r'CaptainReportTicketDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainReportTicketDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ticket';
    yield serializers.serialize(
      object.ticket,
      specifiedType: const FullType(CaptainReportTicketDtoOutputTicket),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainReportTicketDtoOutput object, {
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
    required CaptainReportTicketDtoOutputBuilder result,
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
                      CaptainReportTicketDtoOutputTicket,
                    ),
                  )
                  as CaptainReportTicketDtoOutputTicket;
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
  CaptainReportTicketDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainReportTicketDtoOutputBuilder();
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
