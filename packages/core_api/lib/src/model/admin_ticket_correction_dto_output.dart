//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_order_tickets_dto_output_tickets_inner_resolution_corrected_lines_inner.dart';
import 'package:core_api/src/model/admin_ticket_correction_dto_output_merchant.dart';
import 'package:core_api/src/model/admin_ticket_correction_dto_output_entries_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ticket_correction_dto_output.g.dart';

/// AdminTicketCorrectionDtoOutput
///
/// Properties:
/// * [captainChanges] - Per currency: + the captain hands it in, − the desk reimburses them.
/// * [merchant]
/// * [entries]
@BuiltValue()
abstract class AdminTicketCorrectionDtoOutput
    implements
        Built<
          AdminTicketCorrectionDtoOutput,
          AdminTicketCorrectionDtoOutputBuilder
        > {
  /// Per currency: + the captain hands it in, − the desk reimburses them.
  @BuiltValueField(wireName: r'captainChanges')
  BuiltList<AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner>
  get captainChanges;

  @BuiltValueField(wireName: r'merchant')
  AdminTicketCorrectionDtoOutputMerchant get merchant;

  @BuiltValueField(wireName: r'entries')
  BuiltList<AdminTicketCorrectionDtoOutputEntriesInner> get entries;

  AdminTicketCorrectionDtoOutput._();

  factory AdminTicketCorrectionDtoOutput([
    void updates(AdminTicketCorrectionDtoOutputBuilder b),
  ]) = _$AdminTicketCorrectionDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTicketCorrectionDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTicketCorrectionDtoOutput> get serializer =>
      _$AdminTicketCorrectionDtoOutputSerializer();
}

class _$AdminTicketCorrectionDtoOutputSerializer
    implements PrimitiveSerializer<AdminTicketCorrectionDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminTicketCorrectionDtoOutput,
    _$AdminTicketCorrectionDtoOutput,
  ];

  @override
  final String wireName = r'AdminTicketCorrectionDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTicketCorrectionDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'captainChanges';
    yield serializers.serialize(
      object.captainChanges,
      specifiedType: const FullType(BuiltList, [
        FullType(
          AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner,
        ),
      ]),
    );
    yield r'merchant';
    yield serializers.serialize(
      object.merchant,
      specifiedType: const FullType(AdminTicketCorrectionDtoOutputMerchant),
    );
    yield r'entries';
    yield serializers.serialize(
      object.entries,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminTicketCorrectionDtoOutputEntriesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketCorrectionDtoOutput object, {
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
    required AdminTicketCorrectionDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'captainChanges':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner
                  >;
          result.captainChanges.replace(valueDes);
          break;
        case r'merchant':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminTicketCorrectionDtoOutputMerchant,
                    ),
                  )
                  as AdminTicketCorrectionDtoOutputMerchant;
          result.merchant.replace(valueDes);
          break;
        case r'entries':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminTicketCorrectionDtoOutputEntriesInner),
                    ]),
                  )
                  as BuiltList<AdminTicketCorrectionDtoOutputEntriesInner>;
          result.entries.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminTicketCorrectionDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTicketCorrectionDtoOutputBuilder();
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
