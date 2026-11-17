//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_ticket_correction_dto_output_entries_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ticket_money_preview_dto_output.g.dart';

/// AdminTicketMoneyPreviewDtoOutput
///
/// Properties:
/// * [currency]
/// * [affectedValue] - V.
/// * [merchantDebit] - What the restaurant ends up owing: V less the commission reversed.
/// * [captainCharge]
/// * [entries]
@BuiltValue()
abstract class AdminTicketMoneyPreviewDtoOutput
    implements
        Built<
          AdminTicketMoneyPreviewDtoOutput,
          AdminTicketMoneyPreviewDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'currency')
  String? get currency;

  /// V.
  @BuiltValueField(wireName: r'affectedValue')
  String get affectedValue;

  /// What the restaurant ends up owing: V less the commission reversed.
  @BuiltValueField(wireName: r'merchantDebit')
  String get merchantDebit;

  @BuiltValueField(wireName: r'captainCharge')
  String get captainCharge;

  @BuiltValueField(wireName: r'entries')
  BuiltList<AdminTicketCorrectionDtoOutputEntriesInner> get entries;

  AdminTicketMoneyPreviewDtoOutput._();

  factory AdminTicketMoneyPreviewDtoOutput([
    void updates(AdminTicketMoneyPreviewDtoOutputBuilder b),
  ]) = _$AdminTicketMoneyPreviewDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTicketMoneyPreviewDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTicketMoneyPreviewDtoOutput> get serializer =>
      _$AdminTicketMoneyPreviewDtoOutputSerializer();
}

class _$AdminTicketMoneyPreviewDtoOutputSerializer
    implements PrimitiveSerializer<AdminTicketMoneyPreviewDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminTicketMoneyPreviewDtoOutput,
    _$AdminTicketMoneyPreviewDtoOutput,
  ];

  @override
  final String wireName = r'AdminTicketMoneyPreviewDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTicketMoneyPreviewDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currency';
    yield object.currency == null
        ? null
        : serializers.serialize(
            object.currency,
            specifiedType: const FullType.nullable(String),
          );
    yield r'affectedValue';
    yield serializers.serialize(
      object.affectedValue,
      specifiedType: const FullType(String),
    );
    yield r'merchantDebit';
    yield serializers.serialize(
      object.merchantDebit,
      specifiedType: const FullType(String),
    );
    yield r'captainCharge';
    yield serializers.serialize(
      object.captainCharge,
      specifiedType: const FullType(String),
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
    AdminTicketMoneyPreviewDtoOutput object, {
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
    required AdminTicketMoneyPreviewDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.currency = valueDes;
          break;
        case r'affectedValue':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.affectedValue = valueDes;
          break;
        case r'merchantDebit':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.merchantDebit = valueDes;
          break;
        case r'captainCharge':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.captainCharge = valueDes;
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
  AdminTicketMoneyPreviewDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTicketMoneyPreviewDtoOutputBuilder();
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
