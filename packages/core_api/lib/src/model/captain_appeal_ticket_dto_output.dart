//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_report_ticket_dto_output_ticket.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_appeal_ticket_dto_output.g.dart';

/// CaptainAppealTicketDtoOutput
///
/// Properties:
/// * [ticket]
@BuiltValue()
abstract class CaptainAppealTicketDtoOutput
    implements
        Built<
          CaptainAppealTicketDtoOutput,
          CaptainAppealTicketDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'ticket')
  CaptainReportTicketDtoOutputTicket get ticket;

  CaptainAppealTicketDtoOutput._();

  factory CaptainAppealTicketDtoOutput([
    void updates(CaptainAppealTicketDtoOutputBuilder b),
  ]) = _$CaptainAppealTicketDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainAppealTicketDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainAppealTicketDtoOutput> get serializer =>
      _$CaptainAppealTicketDtoOutputSerializer();
}

class _$CaptainAppealTicketDtoOutputSerializer
    implements PrimitiveSerializer<CaptainAppealTicketDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CaptainAppealTicketDtoOutput,
    _$CaptainAppealTicketDtoOutput,
  ];

  @override
  final String wireName = r'CaptainAppealTicketDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainAppealTicketDtoOutput object, {
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
    CaptainAppealTicketDtoOutput object, {
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
    required CaptainAppealTicketDtoOutputBuilder result,
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
  CaptainAppealTicketDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainAppealTicketDtoOutputBuilder();
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
