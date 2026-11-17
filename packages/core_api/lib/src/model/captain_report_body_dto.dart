//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_report_body_dto.g.dart';

/// CaptainReportBodyDto
///
/// Properties:
/// * [typeCode] - A code of Content's captain_ticket_type list (CA Appendix C).
/// * [orderId] - Optional: one of the captain's orders.
/// * [note] - Optional, up to 300 characters; the text of «أخرى».
/// * [photoUploadId] - One photo at most, from POST /v1/captain/uploads/report-photo once uploaded.
@BuiltValue()
abstract class CaptainReportBodyDto
    implements Built<CaptainReportBodyDto, CaptainReportBodyDtoBuilder> {
  /// A code of Content's captain_ticket_type list (CA Appendix C).
  @BuiltValueField(wireName: r'typeCode')
  String get typeCode;

  /// Optional: one of the captain's orders.
  @BuiltValueField(wireName: r'orderId')
  String? get orderId;

  /// Optional, up to 300 characters; the text of «أخرى».
  @BuiltValueField(wireName: r'note')
  String? get note;

  /// One photo at most, from POST /v1/captain/uploads/report-photo once uploaded.
  @BuiltValueField(wireName: r'photoUploadId')
  String? get photoUploadId;

  CaptainReportBodyDto._();

  factory CaptainReportBodyDto([void updates(CaptainReportBodyDtoBuilder b)]) =
      _$CaptainReportBodyDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainReportBodyDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainReportBodyDto> get serializer =>
      _$CaptainReportBodyDtoSerializer();
}

class _$CaptainReportBodyDtoSerializer
    implements PrimitiveSerializer<CaptainReportBodyDto> {
  @override
  final Iterable<Type> types = const [
    CaptainReportBodyDto,
    _$CaptainReportBodyDto,
  ];

  @override
  final String wireName = r'CaptainReportBodyDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainReportBodyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'typeCode';
    yield serializers.serialize(
      object.typeCode,
      specifiedType: const FullType(String),
    );
    yield r'orderId';
    yield object.orderId == null
        ? null
        : serializers.serialize(
            object.orderId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
    yield r'photoUploadId';
    yield object.photoUploadId == null
        ? null
        : serializers.serialize(
            object.photoUploadId,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainReportBodyDto object, {
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
    required CaptainReportBodyDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'typeCode':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.typeCode = valueDes;
          break;
        case r'orderId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.orderId = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'photoUploadId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.photoUploadId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainReportBodyDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainReportBodyDtoBuilder();
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
