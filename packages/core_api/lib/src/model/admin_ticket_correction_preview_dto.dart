//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_ticket_correction_preview_dto_received_lines_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ticket_correction_preview_dto.g.dart';

/// AdminTicketCorrectionPreviewDto
///
/// Properties:
/// * [cityId]
/// * [receivedLines] - The lines the restaurant received, one per currency.
@BuiltValue()
abstract class AdminTicketCorrectionPreviewDto
    implements
        Built<
          AdminTicketCorrectionPreviewDto,
          AdminTicketCorrectionPreviewDtoBuilder
        > {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// The lines the restaurant received, one per currency.
  @BuiltValueField(wireName: r'receivedLines')
  BuiltList<AdminTicketCorrectionPreviewDtoReceivedLinesInner>
  get receivedLines;

  AdminTicketCorrectionPreviewDto._();

  factory AdminTicketCorrectionPreviewDto([
    void updates(AdminTicketCorrectionPreviewDtoBuilder b),
  ]) = _$AdminTicketCorrectionPreviewDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTicketCorrectionPreviewDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTicketCorrectionPreviewDto> get serializer =>
      _$AdminTicketCorrectionPreviewDtoSerializer();
}

class _$AdminTicketCorrectionPreviewDtoSerializer
    implements PrimitiveSerializer<AdminTicketCorrectionPreviewDto> {
  @override
  final Iterable<Type> types = const [
    AdminTicketCorrectionPreviewDto,
    _$AdminTicketCorrectionPreviewDto,
  ];

  @override
  final String wireName = r'AdminTicketCorrectionPreviewDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTicketCorrectionPreviewDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'receivedLines';
    yield serializers.serialize(
      object.receivedLines,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminTicketCorrectionPreviewDtoReceivedLinesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketCorrectionPreviewDto object, {
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
    required AdminTicketCorrectionPreviewDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
          break;
        case r'receivedLines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminTicketCorrectionPreviewDtoReceivedLinesInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminTicketCorrectionPreviewDtoReceivedLinesInner
                  >;
          result.receivedLines.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminTicketCorrectionPreviewDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTicketCorrectionPreviewDtoBuilder();
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
