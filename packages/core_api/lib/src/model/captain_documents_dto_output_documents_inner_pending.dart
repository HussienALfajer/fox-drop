//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_documents_dto_output_documents_inner_pending.g.dart';

/// «رفع نسخة جديدة» waiting for OPS.
///
/// Properties:
/// * [issueDate]
/// * [expiresOn]
/// * [uploadedAt]
@BuiltValue()
abstract class CaptainDocumentsDtoOutputDocumentsInnerPending
    implements
        Built<
          CaptainDocumentsDtoOutputDocumentsInnerPending,
          CaptainDocumentsDtoOutputDocumentsInnerPendingBuilder
        > {
  @BuiltValueField(wireName: r'issueDate')
  Date? get issueDate;

  @BuiltValueField(wireName: r'expiresOn')
  Date? get expiresOn;

  @BuiltValueField(wireName: r'uploadedAt')
  DateTime get uploadedAt;

  CaptainDocumentsDtoOutputDocumentsInnerPending._();

  factory CaptainDocumentsDtoOutputDocumentsInnerPending([
    void updates(CaptainDocumentsDtoOutputDocumentsInnerPendingBuilder b),
  ]) = _$CaptainDocumentsDtoOutputDocumentsInnerPending;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainDocumentsDtoOutputDocumentsInnerPendingBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainDocumentsDtoOutputDocumentsInnerPending>
  get serializer =>
      _$CaptainDocumentsDtoOutputDocumentsInnerPendingSerializer();
}

class _$CaptainDocumentsDtoOutputDocumentsInnerPendingSerializer
    implements
        PrimitiveSerializer<CaptainDocumentsDtoOutputDocumentsInnerPending> {
  @override
  final Iterable<Type> types = const [
    CaptainDocumentsDtoOutputDocumentsInnerPending,
    _$CaptainDocumentsDtoOutputDocumentsInnerPending,
  ];

  @override
  final String wireName = r'CaptainDocumentsDtoOutputDocumentsInnerPending';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainDocumentsDtoOutputDocumentsInnerPending object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'issueDate';
    yield object.issueDate == null
        ? null
        : serializers.serialize(
            object.issueDate,
            specifiedType: const FullType.nullable(Date),
          );
    yield r'expiresOn';
    yield object.expiresOn == null
        ? null
        : serializers.serialize(
            object.expiresOn,
            specifiedType: const FullType.nullable(Date),
          );
    yield r'uploadedAt';
    yield serializers.serialize(
      object.uploadedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainDocumentsDtoOutputDocumentsInnerPending object, {
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
    required CaptainDocumentsDtoOutputDocumentsInnerPendingBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'issueDate':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(Date),
                  )
                  as Date?;
          if (valueDes == null) continue;
          result.issueDate = valueDes;
          break;
        case r'expiresOn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(Date),
                  )
                  as Date?;
          if (valueDes == null) continue;
          result.expiresOn = valueDes;
          break;
        case r'uploadedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.uploadedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainDocumentsDtoOutputDocumentsInnerPending deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainDocumentsDtoOutputDocumentsInnerPendingBuilder();
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
