//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_report_ticket_dto_output_ticket.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_reports_dto_output.g.dart';

/// CaptainReportsDtoOutput
///
/// Properties:
/// * [tickets] - Newest first, the latest 100: the captain's tickets, the panel's included.
@BuiltValue()
abstract class CaptainReportsDtoOutput
    implements Built<CaptainReportsDtoOutput, CaptainReportsDtoOutputBuilder> {
  /// Newest first, the latest 100: the captain's tickets, the panel's included.
  @BuiltValueField(wireName: r'tickets')
  BuiltList<CaptainReportTicketDtoOutputTicket> get tickets;

  CaptainReportsDtoOutput._();

  factory CaptainReportsDtoOutput([
    void updates(CaptainReportsDtoOutputBuilder b),
  ]) = _$CaptainReportsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainReportsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainReportsDtoOutput> get serializer =>
      _$CaptainReportsDtoOutputSerializer();
}

class _$CaptainReportsDtoOutputSerializer
    implements PrimitiveSerializer<CaptainReportsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CaptainReportsDtoOutput,
    _$CaptainReportsDtoOutput,
  ];

  @override
  final String wireName = r'CaptainReportsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainReportsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tickets';
    yield serializers.serialize(
      object.tickets,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainReportTicketDtoOutputTicket),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainReportsDtoOutput object, {
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
    required CaptainReportsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tickets':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CaptainReportTicketDtoOutputTicket),
                    ]),
                  )
                  as BuiltList<CaptainReportTicketDtoOutputTicket>;
          result.tickets.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainReportsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainReportsDtoOutputBuilder();
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
