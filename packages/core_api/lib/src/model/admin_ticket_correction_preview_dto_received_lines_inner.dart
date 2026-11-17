//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ticket_correction_preview_dto_received_lines_inner.g.dart';

/// AdminTicketCorrectionPreviewDtoReceivedLinesInner
///
/// Properties:
/// * [amount]
/// * [currency]
@BuiltValue()
abstract class AdminTicketCorrectionPreviewDtoReceivedLinesInner
    implements
        Built<
          AdminTicketCorrectionPreviewDtoReceivedLinesInner,
          AdminTicketCorrectionPreviewDtoReceivedLinesInnerBuilder
        > {
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  AdminTicketCorrectionPreviewDtoReceivedLinesInner._();

  factory AdminTicketCorrectionPreviewDtoReceivedLinesInner([
    void updates(AdminTicketCorrectionPreviewDtoReceivedLinesInnerBuilder b),
  ]) = _$AdminTicketCorrectionPreviewDtoReceivedLinesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminTicketCorrectionPreviewDtoReceivedLinesInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTicketCorrectionPreviewDtoReceivedLinesInner>
  get serializer =>
      _$AdminTicketCorrectionPreviewDtoReceivedLinesInnerSerializer();
}

class _$AdminTicketCorrectionPreviewDtoReceivedLinesInnerSerializer
    implements
        PrimitiveSerializer<AdminTicketCorrectionPreviewDtoReceivedLinesInner> {
  @override
  final Iterable<Type> types = const [
    AdminTicketCorrectionPreviewDtoReceivedLinesInner,
    _$AdminTicketCorrectionPreviewDtoReceivedLinesInner,
  ];

  @override
  final String wireName = r'AdminTicketCorrectionPreviewDtoReceivedLinesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTicketCorrectionPreviewDtoReceivedLinesInner object, {
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
    AdminTicketCorrectionPreviewDtoReceivedLinesInner object, {
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
    required AdminTicketCorrectionPreviewDtoReceivedLinesInnerBuilder result,
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
  AdminTicketCorrectionPreviewDtoReceivedLinesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTicketCorrectionPreviewDtoReceivedLinesInnerBuilder();
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
