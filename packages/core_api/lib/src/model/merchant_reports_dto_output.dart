//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_report_ticket_dto_output_ticket.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_reports_dto_output.g.dart';

/// MerchantReportsDtoOutput
///
/// Properties:
/// * [tickets] - Newest first, the latest 100: an owner's every ticket of the restaurant, a cashier's own.
@BuiltValue()
abstract class MerchantReportsDtoOutput
    implements
        Built<MerchantReportsDtoOutput, MerchantReportsDtoOutputBuilder> {
  /// Newest first, the latest 100: an owner's every ticket of the restaurant, a cashier's own.
  @BuiltValueField(wireName: r'tickets')
  BuiltList<MerchantReportTicketDtoOutputTicket> get tickets;

  MerchantReportsDtoOutput._();

  factory MerchantReportsDtoOutput([
    void updates(MerchantReportsDtoOutputBuilder b),
  ]) = _$MerchantReportsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantReportsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantReportsDtoOutput> get serializer =>
      _$MerchantReportsDtoOutputSerializer();
}

class _$MerchantReportsDtoOutputSerializer
    implements PrimitiveSerializer<MerchantReportsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantReportsDtoOutput,
    _$MerchantReportsDtoOutput,
  ];

  @override
  final String wireName = r'MerchantReportsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantReportsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tickets';
    yield serializers.serialize(
      object.tickets,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantReportTicketDtoOutputTicket),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantReportsDtoOutput object, {
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
    required MerchantReportsDtoOutputBuilder result,
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
                      FullType(MerchantReportTicketDtoOutputTicket),
                    ]),
                  )
                  as BuiltList<MerchantReportTicketDtoOutputTicket>;
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
  MerchantReportsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantReportsDtoOutputBuilder();
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
